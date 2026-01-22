#Requires -Version 5.1
<#
.SYNOPSIS
    Installs Neovim and sets up configuration on Windows.
.DESCRIPTION
    This script installs Neovim via winget and creates a symlink from this
    dotfiles repository's config/nvim to the Windows nvim config location.
    Lazy.nvim will automatically install plugins on first launch.
.NOTES
    Run this script from an elevated (Administrator) PowerShell prompt for
    symlink creation, or use the -NoSymlink flag to copy files instead.
#>

param(
    [switch]$NoSymlink,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DotfilesRoot = Split-Path -Parent $ScriptDir
$NvimConfigSource = Join-Path $DotfilesRoot "config\nvim"
$NvimConfigTarget = Join-Path $env:LOCALAPPDATA "nvim"

function Write-Status {
    param([string]$Message, [string]$Type = "Info")
    switch ($Type) {
        "Info"    { Write-Host "[*] $Message" -ForegroundColor Cyan }
        "Success" { Write-Host "[+] $Message" -ForegroundColor Green }
        "Warning" { Write-Host "[!] $Message" -ForegroundColor Yellow }
        "Error"   { Write-Host "[-] $Message" -ForegroundColor Red }
    }
}

# Check if running as Administrator (needed for symlinks)
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Install Neovim from GitHub releases (latest version)
function Install-Neovim {
    Write-Status "Fetching latest Neovim release from GitHub..."

    $releasesUrl = "https://api.github.com/repos/neovim/neovim/releases/latest"
    $release = Invoke-RestMethod -Uri $releasesUrl -Headers @{ "User-Agent" = "PowerShell" }
    $releaseVersion = $release.tag_name

    Write-Status "Latest release: $releaseVersion"

    $asset = $release.assets | Where-Object { $_.name -eq "nvim-win64.zip" }
    if (-not $asset) {
        Write-Status "Could not find nvim-win64.zip in latest release" "Error"
        exit 1
    }

    $downloadUrl = $asset.browser_download_url
    $tempZip = Join-Path $env:TEMP "nvim-win64.zip"
    $installDir = Join-Path $env:LOCALAPPDATA "nvim-install"

    Write-Status "Downloading from: $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip

    # Remove old installation if exists
    if (Test-Path $installDir) {
        Write-Status "Removing previous installation..."
        Remove-Item -Path $installDir -Recurse -Force
    }

    Write-Status "Extracting to: $installDir"
    Expand-Archive -Path $tempZip -DestinationPath $installDir -Force
    Remove-Item -Path $tempZip -Force

    # The zip extracts to nvim-win64 subfolder
    $nvimBinDir = Join-Path $installDir "nvim-win64\bin"

    # Add to user PATH if not already there
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($userPath -notlike "*$nvimBinDir*") {
        Write-Status "Adding Neovim to user PATH..."
        [Environment]::SetEnvironmentVariable("Path", "$userPath;$nvimBinDir", "User")
        $env:Path = "$env:Path;$nvimBinDir"
    }

    Write-Status "Neovim $releaseVersion installed successfully" "Success"
    Write-Status "Restart your terminal to use nvim" "Warning"
}

# Setup nvim config symlink or copy
function Setup-NvimConfig {
    Write-Status "Setting up Neovim configuration..."
    Write-Status "Source: $NvimConfigSource"
    Write-Status "Target: $NvimConfigTarget"

    # Verify source exists
    if (-not (Test-Path $NvimConfigSource)) {
        Write-Status "Source config not found: $NvimConfigSource" "Error"
        exit 1
    }

    # Handle existing target
    if (Test-Path $NvimConfigTarget) {
        $item = Get-Item $NvimConfigTarget -Force
        $isSymlink = $item.Attributes -band [IO.FileAttributes]::ReparsePoint

        if ($isSymlink) {
            $linkTarget = (Get-Item $NvimConfigTarget).Target
            if ($linkTarget -eq $NvimConfigSource) {
                Write-Status "Symlink already correctly configured" "Success"
                return
            }
        }

        if ($Force) {
            Write-Status "Removing existing config at $NvimConfigTarget" "Warning"
            Remove-Item -Path $NvimConfigTarget -Recurse -Force
        } else {
            Write-Status "Config already exists at $NvimConfigTarget" "Error"
            Write-Status "Use -Force to overwrite, or manually backup/remove it" "Info"
            exit 1
        }
    }

    # Create parent directory if needed
    $parentDir = Split-Path -Parent $NvimConfigTarget
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    if ($NoSymlink) {
        Write-Status "Copying config files (symlinks disabled)..."
        Copy-Item -Path $NvimConfigSource -Destination $NvimConfigTarget -Recurse
        Write-Status "Config files copied" "Success"
        Write-Status "Note: Changes to dotfiles won't auto-sync. Re-run script to update." "Warning"
    } else {
        if (-not (Test-Administrator)) {
            Write-Status "Administrator privileges required for symlinks" "Error"
            Write-Status "Either:" "Info"
            Write-Status "  1. Run this script as Administrator" "Info"
            Write-Status "  2. Use -NoSymlink flag to copy files instead" "Info"
            exit 1
        }

        Write-Status "Creating symlink..."
        New-Item -ItemType SymbolicLink -Path $NvimConfigTarget -Target $NvimConfigSource | Out-Null
        Write-Status "Symlink created successfully" "Success"
    }
}

# Main
Write-Host ""
Write-Host "=== Neovim Windows Setup ===" -ForegroundColor Magenta
Write-Host ""

Install-Neovim
Write-Host ""
Setup-NvimConfig

Write-Host ""
Write-Status "Setup complete!" "Success"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open a new terminal (to refresh PATH)"
Write-Host "  2. Run 'nvim' to start Neovim"
Write-Host "  3. Lazy.nvim will automatically install plugins on first launch"
Write-Host "  4. Wait for plugin installation to complete, then restart nvim"
Write-Host ""
