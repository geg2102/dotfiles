#Requires -Version 5.1
<#
.SYNOPSIS
    Install configuration files via symlinks or copies.
.DESCRIPTION
    Creates symlinks (or copies if not running as Administrator) for various
    configuration files from the dotfiles repository to their expected locations.

    Supported configurations:
    - lazygit: config/lazygit_config.yml -> %APPDATA%\lazygit\config.yml

    Note: Neovim configuration is handled by Install-Neovim.ps1
.PARAMETER NoSymlink
    Force copy mode instead of attempting symlinks, even when running as Administrator.
.PARAMETER Force
    Overwrite existing files/symlinks at target locations.
.EXAMPLE
    .\Install-Configs.ps1
    # Creates symlinks (if admin) or copies for all configs
.EXAMPLE
    .\Install-Configs.ps1 -Force
    # Overwrites existing configurations
.EXAMPLE
    .\Install-Configs.ps1 -NoSymlink
    # Forces copy mode even when running as admin
.NOTES
    Author: Dotfiles automation
    Requires: PowerShell 5.1+
#>
[CmdletBinding()]
param(
    [switch]$NoSymlink,
    [switch]$Force
)

# Import common utilities
. "$PSScriptRoot\..\lib\Common.ps1"

# Get the dotfiles root directory (two levels up from this script)
$DotfilesRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))

# Define configuration mappings: Source (relative to dotfiles) -> Target (absolute path)
$ConfigMappings = @(
    @{
        Name   = "lazygit"
        Source = "config\lazygit_config.yml"
        Target = "$env:APPDATA\lazygit\config.yml"
    }
)

function Install-Configs {
    <#
    .SYNOPSIS
        Install all configuration files.
    .DESCRIPTION
        Iterates through all defined config mappings and creates symlinks or copies.
    #>
    [CmdletBinding()]
    param(
        [switch]$NoSymlink,
        [switch]$Force
    )

    Write-Status "Installing configuration files..." "Info"

    $successCount = 0
    $failCount = 0

    foreach ($config in $ConfigMappings) {
        $sourcePath = Join-Path $DotfilesRoot $config.Source
        $targetPath = $config.Target

        Write-Status "Processing $($config.Name) configuration..." "Info"
        Write-Status "  Source: $sourcePath" "Info"
        Write-Status "  Target: $targetPath" "Info"

        # Verify source exists
        if (-not (Test-Path $sourcePath)) {
            Write-Status "Source file not found: $sourcePath" "Error"
            $failCount++
            continue
        }

        # If NoSymlink is specified, we need to handle it differently
        # Since New-SymlinkOrCopy doesn't have a NoSymlink parameter,
        # we'll copy directly when NoSymlink is set
        if ($NoSymlink) {
            # Ensure parent directory exists
            $parentDir = Split-Path -Parent $targetPath
            if ($parentDir -and -not (Test-Path $parentDir)) {
                try {
                    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
                    Write-Status "Created parent directory: $parentDir" "Info"
                }
                catch {
                    Write-Status "Failed to create parent directory: $($_.Exception.Message)" "Error"
                    $failCount++
                    continue
                }
            }

            # Handle existing item
            if (Test-Path $targetPath) {
                if ($Force) {
                    try {
                        Remove-Item -Path $targetPath -Recurse -Force -ErrorAction Stop
                        Write-Status "Removed existing item at: $targetPath" "Info"
                    }
                    catch {
                        Write-Status "Failed to remove existing item: $($_.Exception.Message)" "Error"
                        $failCount++
                        continue
                    }
                }
                else {
                    Write-Status "Target already exists: $targetPath (use -Force to overwrite)" "Warning"
                    $failCount++
                    continue
                }
            }

            # Copy the file
            try {
                Copy-Item -Path $sourcePath -Destination $targetPath -Force -ErrorAction Stop
                Write-Status "Copied $($config.Name) config successfully" "Success"
                Write-Status "Note: Changes to source won't auto-sync. Re-run to update." "Warning"
                $successCount++
            }
            catch {
                Write-Status "Failed to copy $($config.Name) config: $($_.Exception.Message)" "Error"
                $failCount++
            }
        }
        else {
            # Use New-SymlinkOrCopy for automatic symlink/copy handling
            $result = New-SymlinkOrCopy -Path $targetPath -Target $sourcePath -Force:$Force

            if ($result.Success) {
                Write-Status "$($config.Name) config installed via $($result.Method)" "Success"
                $successCount++
            }
            else {
                Write-Status "Failed to install $($config.Name) config" "Error"
                $failCount++
            }
        }
    }

    # Summary
    Write-Host ""
    Write-Status "Configuration installation complete" "Info"
    Write-Status "  Successful: $successCount" "Success"
    if ($failCount -gt 0) {
        Write-Status "  Failed: $failCount" "Error"
    }

    return $failCount -eq 0
}

# Run if executed directly (not dot-sourced)
if ($MyInvocation.InvocationName -ne '.') {
    $success = Install-Configs -NoSymlink:$NoSymlink -Force:$Force
    if (-not $success) {
        exit 1
    }
}
