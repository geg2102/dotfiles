#Requires -Version 5.1
<#
.SYNOPSIS
    PowerShell profile with aliases, environment setup, and utility functions.
.DESCRIPTION
    This profile provides:
    - Aliases for common tools (vim -> nvim, lg -> lazygit)
    - Environment variables for editors
    - zoxide integration for smart directory navigation
    - vf function for fuzzy file finding with preview
.NOTES
    Installed via dotfiles automation. Source: config/windows/Microsoft.PowerShell_profile.ps1
#>

# ==============================================================================
# Aliases
# ==============================================================================

Set-Alias -Name vim -Value nvim -ErrorAction SilentlyContinue
Set-Alias -Name lg -Value lazygit -ErrorAction SilentlyContinue

# ==============================================================================
# Environment Variables
# ==============================================================================

$env:EDITOR = 'nvim'
$env:GIT_EDITOR = 'nvim'

# ==============================================================================
# zoxide - smarter cd command
# ==============================================================================

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# ==============================================================================
# Functions
# ==============================================================================

function vf {
    <#
    .SYNOPSIS
        Fuzzy find and open files in Neovim.
    .DESCRIPTION
        Uses fd to find files, fzf for fuzzy selection with bat preview,
        and opens the selected file in Neovim.

        Keybindings in fzf:
        - Ctrl-h: Include hidden files
        - Ctrl-b: Include hidden, ignored, and follow symlinks
    .EXAMPLE
        vf
    #>

    # Check required commands
    if (-not (Get-Command fd -ErrorAction SilentlyContinue)) {
        Write-Host "Error: fd is not installed. Install via: winget install sharkdp.fd" -ForegroundColor Red
        return
    }
    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Host "Error: fzf is not installed. Install via: winget install junegunn.fzf" -ForegroundColor Red
        return
    }
    if (-not (Get-Command bat -ErrorAction SilentlyContinue)) {
        Write-Host "Error: bat is not installed. Install via: winget install sharkdp.bat" -ForegroundColor Red
        return
    }
    if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
        Write-Host "Error: nvim is not installed" -ForegroundColor Red
        return
    }

    $file = fd --type f --exclude .git | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' `
        --header 'Ctrl-h: hidden | Ctrl-b: all (hidden + ignored + symlinks)' `
        --prompt 'files> ' `
        --bind 'ctrl-h:reload(fd --type f --exclude .git -H)' `
        --bind 'ctrl-b:reload(fd --type f --exclude .git -H -I -L)'

    if ($file) {
        Write-Host $file
        nvim $file
    }
}

# ==============================================================================
# Optional: Load local customizations
# ==============================================================================

$localProfile = Join-Path (Split-Path $PROFILE) "profile_local.ps1"
if (Test-Path $localProfile) {
    . $localProfile
}
