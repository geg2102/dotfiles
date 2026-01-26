#Requires -Version 5.1
<#
.SYNOPSIS
    Install the PowerShell profile from dotfiles.
.DESCRIPTION
    Creates a symbolic link (or copies) the PowerShell profile template from
    this dotfiles repository to the user's $PROFILE location.

    The profile includes:
    - Aliases (vim -> nvim, lg -> lazygit)
    - Environment variables (EDITOR, GIT_EDITOR)
    - zoxide initialization
    - vf function for fuzzy file finding
.PARAMETER NoSymlink
    If specified, copies the profile instead of creating a symbolic link.
    Use this if not running as Administrator.
.PARAMETER Force
    If specified, overwrites any existing profile at the destination.
.EXAMPLE
    .\Install-PowerShellProfile.ps1
    # Creates a symlink to the profile (requires Administrator)
.EXAMPLE
    .\Install-PowerShellProfile.ps1 -NoSymlink
    # Copies the profile instead of creating a symlink
.EXAMPLE
    .\Install-PowerShellProfile.ps1 -Force
    # Overwrites existing profile with a symlink
.NOTES
    Run as Administrator for symlink creation, or use -NoSymlink to copy.
#>

param(
    [switch]$NoSymlink,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Import common utilities
. "$PSScriptRoot\..\lib\Common.ps1"

# ==============================================================================
# Configuration
# ==============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DotfilesRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))
$ProfileSource = Join-Path $DotfilesRoot "config\windows\Microsoft.PowerShell_profile.ps1"
$ProfileTarget = $PROFILE

# ==============================================================================
# Main
# ==============================================================================

Write-Host ""
Write-Host "=== PowerShell Profile Installation ===" -ForegroundColor Magenta
Write-Host ""

Write-Status "Source: $ProfileSource"
Write-Status "Target: $ProfileTarget"
Write-Host ""

# Verify source exists
if (-not (Test-Path $ProfileSource)) {
    Write-Status "Profile template not found: $ProfileSource" "Error"
    exit 1
}

# Handle NoSymlink mode - use copy instead
if ($NoSymlink) {
    Write-Status "NoSymlink mode: will copy instead of symlink" "Info"

    # Handle existing profile
    if (Test-Path $ProfileTarget) {
        if ($Force) {
            try {
                Remove-Item -Path $ProfileTarget -Force -ErrorAction Stop
                Write-Status "Removed existing profile" "Info"
            }
            catch {
                Write-Status "Failed to remove existing profile: $($_.Exception.Message)" "Error"
                exit 1
            }
        }
        else {
            Write-Status "Profile already exists at: $ProfileTarget" "Error"
            Write-Status "Use -Force to overwrite" "Info"
            exit 1
        }
    }

    # Ensure parent directory exists
    $parentDir = Split-Path -Parent $ProfileTarget
    if ($parentDir -and -not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        Write-Status "Created directory: $parentDir" "Info"
    }

    # Copy the profile
    try {
        Copy-Item -Path $ProfileSource -Destination $ProfileTarget -Force
        Write-Status "Profile copied successfully" "Success"
        Write-Status "Note: Changes to source won't auto-sync. Re-run to update." "Warning"
    }
    catch {
        Write-Status "Failed to copy profile: $($_.Exception.Message)" "Error"
        exit 1
    }
}
else {
    # Use New-SymlinkOrCopy for automatic handling
    $result = New-SymlinkOrCopy -Path $ProfileTarget -Target $ProfileSource -Force:$Force

    if (-not $result.Success) {
        Write-Status "Failed to install profile" "Error"
        if (-not (Test-Administrator)) {
            Write-Status "Tip: Run as Administrator for symlinks, or use -NoSymlink" "Info"
        }
        exit 1
    }
}

Write-Host ""
Write-Status "Profile installation complete!" "Success"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Restart PowerShell to load the new profile"
Write-Host "  2. Install recommended tools (if not already installed):"
Write-Host "     winget install sharkdp.fd"
Write-Host "     winget install junegunn.fzf"
Write-Host "     winget install sharkdp.bat"
Write-Host "     winget install ajeetdsouza.zoxide"
Write-Host "     winget install jesseduffield.lazygit"
Write-Host ""
