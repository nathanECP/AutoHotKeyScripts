#Requires AutoHotkey v2.0
#SingleInstance Force
; ====================================================================
; AutoHotkey v2 — CapsLock Hyper Key + App Shortcuts
; ====================================================================

A_LocalAppData := EnvGet("LocalAppData")

; ---------------------------
; SECTION 0 — CONFIG
; ---------------------------
HyperTimeout := 200  ; ms to distinguish tap vs hold

; ---------------------------
; SECTION 1 — KEY REMAPS
; ---------------------------

; Swap Left Ctrl ↔ Left Alt
SC01D::Alt
SC038::Ctrl

; RAlt → Backspace
RAlt::Backspace

; Copilot Key, Right Ctrl -> Enter
+#F23:: Send("{Enter}")
RControl::Enter

; Alt+Tab passthrough
#HotIf !GetKeyState("Ctrl", "P") && !GetKeyState("Shift", "P")
!Tab:: Send("^Tab")       ; Alt+Tab → Ctrl+Tab (only when not Ctrl+Shift+Alt)
^Tab:: Send("!{Tab}")     ; Ctrl+Tab → Alt+Tab
#HotIf                    ; end context-sensitive hotkeys

; ---------------------------
; SECTION 2 — CAPSLOCK Hyper Key
; ---------------------------
CapsLock:: {
    start := A_TickCount

    ; Wait until key released
    KeyWait("CapsLock", "D") ; wait until press
    KeyWait("CapsLock")      ; wait until release

    elapsed := A_TickCount - start
    if (elapsed < HyperTimeout) {
        ; Tapped → Escape
        Send("{Escape}")
    }
    ; Held → do nothing, used as modifier
}

; ---------------------------
; SECTION 3 — HYPER HOTKEYS (CapsLock as modifier)
; ---------------------------

; Chrome
~CapsLock & c:: {
    if WinExist("ahk_exe chrome.exe")
        WinActivate()
    else
        Run('"C:\Program Files\Google\Chrome\Application\chrome.exe" --auto-open-devtools-for-tabs')
}

; Explorer
~CapsLock & e:: {
    ; Get a visible Explorer window
    win := WinExist("ahk_class CabinetWClass")  ; Explorer main window
    if win {
        WinActivate(win)  ; Bring it to foreground
    } else {
        Run("explorer.exe")
    }
}

; Firefox
~CapsLock & f:: {
    if WinExist("ahk_exe firefox.exe")
        WinActivate()
    else
        Run("C:\Program Files\Mozilla Firefox\firefox.exe")
}

; Windows Terminal
~CapsLock & r:: {
    if WinExist("ahk_exe WindowsTerminal.exe")
        WinActivate()
    else
        Send("#6") ; Cant get below working
    ;Run("explorer.exe 'shell:AppsFolder\???'")
}

; Teams
~CapsLock & t:: {
    if WinExist("ahk_exe Teams.exe") && WinActive("ahk_exe Teams.exe")
        WinActivate()
    else
        Send("#2") ; Cant get below working
    ;Run("explorer.exe 'shell:AppsFolder\MSTeams_8wekyb3d8bbwe!MSTeams'")
}

; VS Code
~CapsLock & v:: {
    if WinExist("ahk_exe Code.exe")
        WinActivate()
    else {
        VSCPath := A_LocalAppData "\Programs\Microsoft VS Code\Code.exe"
        Run(VSCPath)
    }
}

; WezTerm
~CapsLock & w:: {
    if WinExist("ahk_exe wezterm-gui.exe")
        WinActivate()
    else
        Run("C:\Program Files\WezTerm\wezterm-gui.exe")
}

; Zed
~CapsLock & z:: {
    if WinExist("ahk_exe Zed.exe")
        WinActivate()
    else {
        ZedPath := A_LocalAppData "\Programs\Zed\Zed.exe"
        Run(ZedPath)
    }
}

; ---------------------------
; SECTION 4 — APP SPECIFIC (FIREFOX example)
; ---------------------------
; #HotIf WinActive("ahk_exe firefox.exe")
; ^Left:: Send("!{Left}")    ; Ctrl+Left → Alt+Left
; ^Right:: Send("!{Right}")  ; Ctrl+Right → Alt+Right
; #HotIf

; ====================================================================
; END OF FILE
; ====================================================================
