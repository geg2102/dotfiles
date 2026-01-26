#Requires -Version 5.1
<#
.SYNOPSIS
    Common utility functions for Windows automation scripts.
.DESCRIPTION
    This module provides shared utility functions used across the Windows
    automation system. Import via dot-sourcing:

    . "$PSScriptRoot\lib\Common.ps1"

    Available functions:
    - Write-Status: Colored console output with message types
    - Test-Administrator: Check if running with elevated privileges
    - Test-Command: Check if a command exists in PATH
    - New-SymlinkOrCopy: Create symlink with fallback to copy
.NOTES
    Author: Dotfiles automation
    Requires: PowerShell 5.1+
#>

function Write-Status {
    <#
    .SYNOPSIS
        Write a status message with colored output.
    .DESCRIPTION
        Outputs a formatted message to the console with a prefix and color
        based on the message type.
    .PARAMETER Message
        The message text to display.
    .PARAMETER Type
        The type of message: Info, Success, Warning, or Error.
        Defaults to Info.
    .EXAMPLE
        Write-Status "Installing package..."
        Write-Status "Installation complete" "Success"
        Write-Status "File not found" "Error"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,

        [Parameter(Position = 1)]
        [ValidateSet("Info", "Success", "Warning", "Error")]
        [string]$Type = "Info"
    )

    switch ($Type) {
        "Info"    { Write-Host "[*] $Message" -ForegroundColor Cyan }
        "Success" { Write-Host "[+] $Message" -ForegroundColor Green }
        "Warning" { Write-Host "[!] $Message" -ForegroundColor Yellow }
        "Error"   { Write-Host "[-] $Message" -ForegroundColor Red }
    }
}

function Test-Administrator {
    <#
    .SYNOPSIS
        Check if the current PowerShell session is running with Administrator privileges.
    .DESCRIPTION
        Returns $true if the current user has Administrator privileges,
        $false otherwise.
    .EXAMPLE
        if (Test-Administrator) {
            Write-Status "Running as admin" "Success"
        } else {
            Write-Status "Not running as admin" "Warning"
        }
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Command {
    <#
    .SYNOPSIS
        Check if a command exists in PATH.
    .DESCRIPTION
        Tests whether a given command name is available in the current
        session. This includes executables in PATH, PowerShell cmdlets,
        functions, and aliases.
    .PARAMETER Name
        The name of the command to check for.
    .EXAMPLE
        if (Test-Command "git") {
            Write-Status "Git is installed" "Success"
        }
    .EXAMPLE
        if (-not (Test-Command "nvim")) {
            Write-Status "Neovim not found in PATH" "Warning"
        }
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )

    $command = Get-Command -Name $Name -ErrorAction SilentlyContinue
    return $null -ne $command
}

function New-SymlinkOrCopy {
    <#
    .SYNOPSIS
        Create a symbolic link with fallback to copy if not running as Administrator.
    .DESCRIPTION
        Attempts to create a symbolic link from Target to Path. If the current
        session lacks Administrator privileges (required for symlinks on Windows),
        falls back to copying the source to the destination instead.

        Handles both files and directories automatically.
    .PARAMETER Path
        The path where the symlink (or copy) will be created.
    .PARAMETER Target
        The source path that the symlink should point to (or copy from).
    .PARAMETER Force
        If specified, removes any existing item at Path before creating
        the symlink or copy.
    .OUTPUTS
        PSCustomObject with properties:
        - Success: $true if operation succeeded
        - Method: "Symlink" or "Copy"
        - Path: The destination path
        - Target: The source path
    .EXAMPLE
        $result = New-SymlinkOrCopy -Path "$env:LOCALAPPDATA\nvim" -Target "C:\dotfiles\config\nvim"
        if ($result.Success) {
            Write-Status "Created $($result.Method) successfully" "Success"
        }
    .EXAMPLE
        # With Force to overwrite existing
        New-SymlinkOrCopy -Path "~\.gitconfig" -Target "C:\dotfiles\git\gitconfig" -Force
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Target,

        [switch]$Force
    )

    $result = [PSCustomObject]@{
        Success = $false
        Method  = $null
        Path    = $Path
        Target  = $Target
    }

    # Verify source exists
    if (-not (Test-Path $Target)) {
        Write-Status "Source path does not exist: $Target" "Error"
        return $result
    }

    # Determine if source is a directory or file
    $isDirectory = (Get-Item $Target).PSIsContainer

    # Handle existing item at destination
    if (Test-Path $Path) {
        if ($Force) {
            try {
                Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
                Write-Status "Removed existing item at: $Path" "Info"
            }
            catch {
                Write-Status "Failed to remove existing item: $($_.Exception.Message)" "Error"
                return $result
            }
        }
        else {
            # Check if it's already a correct symlink
            $item = Get-Item $Path -Force -ErrorAction SilentlyContinue
            if ($item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
                $linkTarget = $item.Target | Select-Object -First 1
                $normalizedLink = [System.IO.Path]::GetFullPath($linkTarget)
                $normalizedTarget = [System.IO.Path]::GetFullPath($Target)
                if ($normalizedLink -eq $normalizedTarget) {
                    Write-Status "Symlink already correctly configured" "Success"
                    $result.Success = $true
                    $result.Method = "Symlink"
                    return $result
                }
            }
            Write-Status "Path already exists: $Path (use -Force to overwrite)" "Error"
            return $result
        }
    }

    # Ensure parent directory exists
    $parentDir = Split-Path -Parent $Path
    if ($parentDir -and -not (Test-Path $parentDir)) {
        try {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
            Write-Status "Created parent directory: $parentDir" "Info"
        }
        catch {
            Write-Status "Failed to create parent directory: $($_.Exception.Message)" "Error"
            return $result
        }
    }

    # Try to create symlink if running as administrator
    if (Test-Administrator) {
        try {
            New-Item -ItemType SymbolicLink -Path $Path -Target $Target -ErrorAction Stop | Out-Null
            Write-Status "Created symlink: $Path -> $Target" "Success"
            $result.Success = $true
            $result.Method = "Symlink"
            return $result
        }
        catch {
            Write-Status "Failed to create symlink: $($_.Exception.Message)" "Warning"
            Write-Status "Falling back to copy..." "Info"
        }
    }
    else {
        Write-Status "Not running as Administrator, using copy instead of symlink" "Warning"
    }

    # Fallback to copy
    try {
        if ($isDirectory) {
            Copy-Item -Path $Target -Destination $Path -Recurse -Force -ErrorAction Stop
        }
        else {
            Copy-Item -Path $Target -Destination $Path -Force -ErrorAction Stop
        }
        Write-Status "Copied: $Target -> $Path" "Success"
        Write-Status "Note: Changes to source won't auto-sync. Re-run to update." "Warning"
        $result.Success = $true
        $result.Method = "Copy"
        return $result
    }
    catch {
        Write-Status "Failed to copy: $($_.Exception.Message)" "Error"
        return $result
    }
}
