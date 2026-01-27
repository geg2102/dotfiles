#Requires -Version 5.1
<#
.SYNOPSIS
    Install CLI tools via winget.
.DESCRIPTION
    Installs essential CLI tools using Windows Package Manager (winget).
    The script is idempotent - it skips packages that are already installed.

    Packages installed:
    - BurntSushi.ripgrep.MSVC (rg) - Fast grep alternative
    - sharkdp.fd (fd) - Fast find alternative
    - junegunn.fzf (fzf) - Fuzzy finder
    - sharkdp.bat (bat) - Cat clone with syntax highlighting
    - jqlang.jq (jq) - JSON processor
    - JesseDuffield.lazygit (lazygit) - Terminal UI for git
    - ajeetdsouza.zoxide (zoxide) - Smarter cd command
    - Git.Git (git) - Version control

.NOTES
    Author: Dotfiles automation
    Requires: PowerShell 5.1+, winget
.EXAMPLE
    .\Install-Packages.ps1
#>

# Import common utilities
. "$PSScriptRoot\..\lib\Common.ps1"

# Define packages to install
# Format: @{ Id = "winget.package.id"; Name = "friendly name" }
$Packages = @(
    @{ Id = "BurntSushi.ripgrep.MSVC"; Name = "ripgrep (rg)" }
    @{ Id = "sharkdp.fd"; Name = "fd" }
    @{ Id = "junegunn.fzf"; Name = "fzf" }
    @{ Id = "sharkdp.bat"; Name = "bat" }
    @{ Id = "jqlang.jq"; Name = "jq" }
    @{ Id = "JesseDuffield.lazygit"; Name = "lazygit" }
    @{ Id = "ajeetdsouza.zoxide"; Name = "zoxide" }
    @{ Id = "Git.Git"; Name = "Git" }
)

function Test-WingetInstalled {
    <#
    .SYNOPSIS
        Check if winget is available.
    #>
    return Test-Command "winget"
}

function Test-PackageInstalled {
    <#
    .SYNOPSIS
        Check if a package is already installed via winget.
    .PARAMETER PackageId
        The winget package ID to check.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageId
    )

    $result = winget list --id $PackageId --exact 2>$null --accept-source-agreements --accept-package-agreements
    # winget list returns the package info if found, check if the ID appears in output
    return ($result -match [regex]::Escape($PackageId))
}

function Install-Package {
    <#
    .SYNOPSIS
        Install a package via winget.
    .PARAMETER PackageId
        The winget package ID to install.
    .PARAMETER Name
        Friendly name for status messages.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageId,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    Write-Status "Installing $Name ($PackageId)..." "Info"

    $installArgs = @(
        "install"
        "--id", $PackageId
        "--exact"
        "--silent"
        "--accept-source-agreements"
        "--accept-package-agreements"
    )

    $process = Start-Process -FilePath "winget" -ArgumentList $installArgs -Wait -PassThru -NoNewWindow

    if ($process.ExitCode -eq 0) {
        Write-Status "$Name installed successfully" "Success"
        return $true
    }
    else {
        Write-Status "Failed to install $Name (exit code: $($process.ExitCode))" "Error"
        return $false
    }
}

# Main execution
Write-Status "Starting package installation..." "Info"

# Check for winget
if (-not (Test-WingetInstalled)) {
    Write-Status "winget is not installed. Please install App Installer from the Microsoft Store." "Error"
    exit 1
}

Write-Status "Found winget, checking packages..." "Success"

$installed = 0
$skipped = 0
$failed = 0

foreach ($package in $Packages) {
    $packageId = $package.Id
    $packageName = $package.Name

    if (Test-PackageInstalled -PackageId $packageId) {
        Write-Status "$packageName is already installed, skipping" "Success"
        $skipped++
    }
    else {
        if (Install-Package -PackageId $packageId -Name $packageName) {
            $installed++
        }
        else {
            $failed++
        }
    }
}

# Summary
Write-Status "Package installation complete" "Info"
Write-Status "  Installed: $installed" "Info"
Write-Status "  Skipped (already installed): $skipped" "Info"
if ($failed -gt 0) {
    Write-Status "  Failed: $failed" "Warning"
}
