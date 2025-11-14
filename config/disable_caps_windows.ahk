#Requires AutoHotkey v2.0

; Treat only the built-in RDP client as “remote”
RdpWin := "ahk_exe mstsc.exe|ahk_class TscShellContainerClass"

; ---- IN RDP: forward real down/up so Linux/X11/XRDP can remap properly ----
#HotIf WinActive(RdpWin)
$*CapsLock::             SendInput "{vk14sc03A down}"   ; keydown
$*CapsLock up::          SendInput "{vk14sc03A up}"     ; keyup
#HotIf

; ---- OUTSIDE RDP: block both down and up (no effect in Windows) ----
#HotIf !WinActive(RdpWin)
$*CapsLock::             Return
$*CapsLock up::          Return
#HotIf

