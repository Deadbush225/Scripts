#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.

; #UseHook

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; 3 & j::Send {Left}
; 3 & l::Send {Right}
; 3 & k::Send {Down}
; 3 & i::Send {Up}

; backspace remap
~j & k::Send {BackSpace}{BackSpace}
~k & j::Send {BackSpace}{BackSpace}

; | and \ remap

; +BackSpace::|
; BackSpace::\
; $CapsLock::Send {BackSpace}
; $RCtrl::
;     if GetKeyState("CapsLock", "T") = 1
;     {
;         ; Input, SingleKey, V L1
;         SetCapsLockState, off
;     }
;     else if GetKeyState("CapsLock", "F") = 0
;     {
;         ; Input, SingleKey, V L1
;         SetCapsLockState, on
;     }
; \::Enter