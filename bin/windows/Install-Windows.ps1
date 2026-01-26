#Requires -Version 5.1
<#
.SYNOPSIS
    Main entry point for Windows dotfiles installation.
.DESCRIPTION
    Orchestrates the installation of all Windows components from the dotfiles
    repository. By default, runs all components in order:
    1. packages - CLI tools via winget
    2. neovim - Neovim editor and configuration
    3. configs - Application configuration files (lazygit, etc.)
    4. profile - PowerShell profile

    Components can be selectively installed using the -Components parameter.
.PARAMETER Components
    Array of components to install. Valid values: packages, neovim, configs, profile.
    If not specified, all components are installed.
.PARAMETER NoSymlink
    If specified, copies configuration files instead of creating symbolic links.
    Useful when not running as Administrator.
.PARAMETER Force
    If specified, overwrites existing configurations.
.EXAMPLE
    .\Install-Windows.ps1
    # Installs all components
.EXAMPLE
    .\Install-Windows.ps1 -Components packages,neovim
    # Installs only packages and neovim
.EXAMPLE
    .\Install-Windows.ps1 -Components configs -Force
    # Reinstalls configs, overwriting existing files
.EXAMPLE
    .\Install-Windows.ps1 -NoSymlink
    # Installs all components using copies instead of symlinks
.NOTES
    Author: Dotfiles automation
    Requires: PowerShell 5.1+
    Run as Administrator for best results (symlinks require admin on Windows)
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string[]]$Components,

    [switch]$NoSymlink,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Import common utilities
. "$PSScriptRoot\lib\Common.ps1"

# Valid component names
$ValidComponents = @("packages", "neovim", "configs", "profile")

# Default to all components if none specified
if (-not $Components -or $Components.Count -eq 0) {
    $Components = $ValidComponents
}

# Validate components
$invalidComponents = $Components | Where-Object { $_ -notin $ValidComponents }
if ($invalidComponents) {
    Write-Status "Invalid component(s): $($invalidComponents -join ', ')" "Error"
    Write-Status "Valid components are: $($ValidComponents -join ', ')" "Info"
    exit 1
}

# Normalize component names to lowercase for consistent comparison
$Components = $Components | ForEach-Object { $_.ToLower() }

# ==============================================================================
# Banner
# ==============================================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "  Windows Dotfiles Installation" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

Write-Status "Components to install: $($Components -join ', ')"
if ($NoSymlink) {
    Write-Status "Mode: Copy (symlinks disabled)" "Info"
} else {
    Write-Status "Mode: Symlink (with fallback to copy)" "Info"
}
if ($Force) {
    Write-Status "Force: Enabled (will overwrite existing)" "Warning"
}
Write-Host ""

# ==============================================================================
# Track Results
# ==============================================================================

$results = @{}

# ==============================================================================
# Install Packages
# ==============================================================================

if ("packages" -in $Components) {
    Write-Host ""
    Write-Host "--- Installing Packages ---" -ForegroundColor Cyan
    Write-Host ""

    try {
        # Dot-source the packages script to run its main logic
        # The script runs directly when sourced, so we capture any errors
        & "$PSScriptRoot\modules\Install-Packages.ps1"
        $results["packages"] = $true
    }
    catch {
        Write-Status "Package installation failed: $($_.Exception.Message)" "Error"
        $results["packages"] = $false
    }
}

# ==============================================================================
# Install Neovim
# ==============================================================================

if ("neovim" -in $Components) {
    Write-Host ""
    Write-Host "--- Installing Neovim ---" -ForegroundColor Cyan
    Write-Host ""

    try {
        # Call the neovim script with parameters
        $nvimArgs = @()
        if ($NoSymlink) { $nvimArgs += "-NoSymlink" }
        if ($Force) { $nvimArgs += "-Force" }

        & "$PSScriptRoot\modules\Install-Neovim.ps1" @nvimArgs
        $results["neovim"] = $LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq $null
    }
    catch {
        Write-Status "Neovim installation failed: $($_.Exception.Message)" "Error"
        $results["neovim"] = $false
    }
}

# ==============================================================================
# Install Configs
# ==============================================================================

if ("configs" -in $Components) {
    Write-Host ""
    Write-Host "--- Installing Configs ---" -ForegroundColor Cyan
    Write-Host ""

    try {
        # Call the configs script with parameters
        $configArgs = @()
        if ($NoSymlink) { $configArgs += "-NoSymlink" }
        if ($Force) { $configArgs += "-Force" }

        & "$PSScriptRoot\modules\Install-Configs.ps1" @configArgs
        $results["configs"] = $LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq $null
    }
    catch {
        Write-Status "Config installation failed: $($_.Exception.Message)" "Error"
        $results["configs"] = $false
    }
}

# ==============================================================================
# Install PowerShell Profile
# ==============================================================================

if ("profile" -in $Components) {
    Write-Host ""
    Write-Host "--- Installing PowerShell Profile ---" -ForegroundColor Cyan
    Write-Host ""

    try {
        # Call the profile script with parameters
        $profileArgs = @()
        if ($NoSymlink) { $profileArgs += "-NoSymlink" }
        if ($Force) { $profileArgs += "-Force" }

        & "$PSScriptRoot\modules\Install-PowerShellProfile.ps1" @profileArgs
        $results["profile"] = $LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq $null
    }
    catch {
        Write-Status "Profile installation failed: $($_.Exception.Message)" "Error"
        $results["profile"] = $false
    }
}

# ==============================================================================
# Summary
# ==============================================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "  Installation Summary" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

$successCount = 0
$failCount = 0

foreach ($component in $Components) {
    if ($results.ContainsKey($component)) {
        if ($results[$component]) {
            Write-Status "$component`: Success" "Success"
            $successCount++
        } else {
            Write-Status "$component`: Failed" "Error"
            $failCount++
        }
    }
}

Write-Host ""

if ($failCount -eq 0) {
    Write-Status "All components installed successfully!" "Success"
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Restart your terminal to apply changes"
    Write-Host "  2. Run 'nvim' to start Neovim (plugins will auto-install)"
    Write-Host ""
    exit 0
} else {
    Write-Status "$failCount component(s) failed to install" "Error"
    Write-Status "Review the errors above and try again" "Info"
    Write-Host ""
    exit 1
}
