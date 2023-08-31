#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Sleep 2000

Loop, 50 {
    Click, 420,380
    Send {K}
    Send {a}
    Send {p}
    Send {r}
    Send {a}
    Send {Enter}
    Click, 420,527

    Sleep 1000
    Loop, 3 {
        Click, 260,539
        Sleep 500
        Click, 590,430
    }

    Click, 268,410
    Sleep 500
    Click, 590,430

    
    Sleep 500
    Click, 30,22
    Sleep 500
}