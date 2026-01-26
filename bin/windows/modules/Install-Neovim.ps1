#Requires -Version 5.1
<#
.SYNOPSIS
    Installs Neovim and sets up configuration on Windows.
.DESCRIPTION
    This module installs Neovim from GitHub releases and creates a symlink
    from this dotfiles repository's config/nvim to the Windows nvim config
    location. Lazy.nvim will automatically install plugins on first launch.

    Can be run standalone or imported by an orchestrator script.
.PARAMETER NoSymlink
    If specified, copies config files instead of creating symlinks.
    Useful when not running as Administrator.
.PARAMETER Force
    If specified, overwrites existing configuration.
.EXAMPLE
    .\Install-Neovim.ps1
    # Installs Neovim and creates config symlink (requires Administrator)
.EXAMPLE
    .\Install-Neovim.ps1 -NoSymlink
    # Installs Neovim and copies config (no admin required)
.EXAMPLE
    .\Install-Neovim.ps1 -Force
    # Installs Neovim and overwrites existing config
.NOTES
    Author: Dotfiles automation
    Requires: PowerShell 5.1+, Administrator for symlinks
#>

param(
    [switch]$NoSymlink,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Import common functions
. "$PSScriptRoot\..\lib\Common.ps1"

# Calculate paths
$script:ModuleDir = $PSScriptRoot
$script:WindowsDir = Split-Path -Parent $ModuleDir
$script:BinDir = Split-Path -Parent $WindowsDir
$script:DotfilesRoot = Split-Path -Parent $BinDir
$script:NvimConfigSource = Join-Path $DotfilesRoot "config\nvim"
$script:NvimConfigTarget = Join-Path $env:LOCALAPPDATA "nvim"

function Install-Neovim {
    <#
    .SYNOPSIS
        Download and install the latest Neovim from GitHub releases.
    .DESCRIPTION
        Fetches the latest Neovim release from GitHub, downloads nvim-win64.zip,
        extracts it to LocalAppData, and adds the bin directory to the user PATH.
    .EXAMPLE
        Install-Neovim
    #>
    [CmdletBinding()]
    param()

    Write-Status "Fetching latest Neovim release from GitHub..."

    $releasesUrl = "https://api.github.com/repos/neovim/neovim/releases/latest"
    try {
        $release = Invoke-RestMethod -Uri $releasesUrl -Headers @{ "User-Agent" = "PowerShell" }
    }
    catch {
        Write-Status "Failed to fetch release info: $($_.Exception.Message)" "Error"
        return $false
    }

    $releaseVersion = $release.tag_name
    Write-Status "Latest release: $releaseVersion"

    $asset = $release.assets | Where-Object { $_.name -eq "nvim-win64.zip" }
    if (-not $asset) {
        Write-Status "Could not find nvim-win64.zip in latest release" "Error"
        return $false
    }

    $downloadUrl = $asset.browser_download_url
    $tempZip = Join-Path $env:TEMP "nvim-win64.zip"
    $installDir = Join-Path $env:LOCALAPPDATA "nvim-install"

    Write-Status "Downloading from: $downloadUrl"
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip
    }
    catch {
        Write-Status "Failed to download Neovim: $($_.Exception.Message)" "Error"
        return $false
    }

    # Remove old installation if exists
    if (Test-Path $installDir) {
        Write-Status "Removing previous installation..."
        Remove-Item -Path $installDir -Recurse -Force
    }

    Write-Status "Extracting to: $installDir"
    try {
        Expand-Archive -Path $tempZip -DestinationPath $installDir -Force
    }
    catch {
        Write-Status "Failed to extract archive: $($_.Exception.Message)" "Error"
        return $false
    }

    # Clean up temp file (non-critical, ignore errors)
    if (Test-Path $tempZip) {
        Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue
    }

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
    return $true
}

function Setup-NvimConfig {
    <#
    .SYNOPSIS
        Setup Neovim configuration by linking or copying from dotfiles.
    .DESCRIPTION
        Creates a symlink (or copy if -NoSymlink) from the dotfiles config/nvim
        directory to the Windows nvim config location at LocalAppData\nvim.
    .PARAMETER NoSymlink
        If specified, copies files instead of creating a symlink.
    .PARAMETER Force
        If specified, removes existing config before setup.
    .EXAMPLE
        Setup-NvimConfig
        # Creates symlink (requires Administrator)
    .EXAMPLE
        Setup-NvimConfig -NoSymlink -Force
        # Copies config, overwrites existing
    #>
    [CmdletBinding()]
    param(
        [switch]$NoSymlink,
        [switch]$Force
    )

    Write-Status "Setting up Neovim configuration..."
    Write-Status "Source: $script:NvimConfigSource"
    Write-Status "Target: $script:NvimConfigTarget"

    # Verify source exists
    if (-not (Test-Path $script:NvimConfigSource)) {
        Write-Status "Source config not found: $script:NvimConfigSource" "Error"
        return $false
    }

    if ($NoSymlink) {
        # Manual copy mode - skip symlink entirely
        if (Test-Path $script:NvimConfigTarget) {
            if ($Force) {
                Write-Status "Removing existing config at $script:NvimConfigTarget" "Warning"
                Remove-Item -Path $script:NvimConfigTarget -Recurse -Force
            }
            else {
                # Check if it's already the same (basic check)
                Write-Status "Config already exists at $script:NvimConfigTarget" "Error"
                Write-Status "Use -Force to overwrite, or manually backup/remove it" "Info"
                return $false
            }
        }

        # Ensure parent directory exists
        $parentDir = Split-Path -Parent $script:NvimConfigTarget
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }

        Write-Status "Copying config files (symlinks disabled)..."
        try {
            Copy-Item -Path $script:NvimConfigSource -Destination $script:NvimConfigTarget -Recurse
            Write-Status "Config files copied" "Success"
            Write-Status "Note: Changes to dotfiles won't auto-sync. Re-run script to update." "Warning"
            return $true
        }
        catch {
            Write-Status "Failed to copy config: $($_.Exception.Message)" "Error"
            return $false
        }
    }
    else {
        # Use New-SymlinkOrCopy for symlink with automatic fallback
        $result = New-SymlinkOrCopy -Path $script:NvimConfigTarget -Target $script:NvimConfigSource -Force:$Force

        if (-not $result.Success) {
            Write-Status "Failed to setup Neovim config" "Error"
            return $false
        }

        return $true
    }
}

# Main execution - only run when script is executed directly, not when dot-sourced
if ($MyInvocation.InvocationName -ne '.') {
    Write-Host ""
    Write-Host "=== Neovim Windows Setup ===" -ForegroundColor Magenta
    Write-Host ""

    $installSuccess = Install-Neovim
    if (-not $installSuccess) {
        Write-Status "Neovim installation failed" "Error"
        exit 1
    }

    Write-Host ""

    $configSuccess = Setup-NvimConfig -NoSymlink:$NoSymlink -Force:$Force
    if (-not $configSuccess) {
        Write-Status "Config setup failed" "Error"
        exit 1
    }

    Write-Host ""
    Write-Status "Setup complete!" "Success"
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Open a new terminal (to refresh PATH)"
    Write-Host "  2. Run 'nvim' to start Neovim"
    Write-Host "  3. Lazy.nvim will automatically install plugins on first launch"
    Write-Host "  4. Wait for plugin installation to complete, then restart nvim"
    Write-Host ""
}
