#Requires -Version 5.1
<#
.SYNOPSIS
    Installs Neovim and sets up configuration on Windows.
.DESCRIPTION
    This script installs Neovim and creates a symlink from this dotfiles
    repository's config/nvim to the Windows nvim config location.
    Lazy.nvim will automatically install plugins on first launch.

    This is a wrapper for backward compatibility. The actual implementation
    is in bin/windows/modules/Install-Neovim.ps1.
.PARAMETER NoSymlink
    If specified, copies configuration files instead of creating symbolic links.
    Useful when not running as Administrator.
.PARAMETER Force
    If specified, overwrites existing configuration.
.NOTES
    Run this script from an elevated (Administrator) PowerShell prompt for
    symlink creation, or use the -NoSymlink flag to copy files instead.
.EXAMPLE
    .\install-nvim-windows.ps1
    # Installs neovim with symlink (requires admin)
.EXAMPLE
    .\install-nvim-windows.ps1 -NoSymlink
    # Installs neovim by copying config (no admin required)
.EXAMPLE
    .\install-nvim-windows.ps1 -Force
    # Reinstalls, overwriting existing config
#>

param(
    [switch]$NoSymlink,
    [switch]$Force
)

# Determine paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ModulePath = Join-Path $ScriptDir "windows\modules\Install-Neovim.ps1"

# Check if the module exists
if (Test-Path $ModulePath) {
    # Call the modular implementation
    $args = @()
    if ($NoSymlink) { $args += "-NoSymlink" }
    if ($Force) { $args += "-Force" }

    & $ModulePath @args
    exit $LASTEXITCODE
}
else {
    Write-Host "[-] Module not found: $ModulePath" -ForegroundColor Red
    Write-Host "[*] Please run from the dotfiles repository root or check your installation" -ForegroundColor Cyan
    exit 1
}
