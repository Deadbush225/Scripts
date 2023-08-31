#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; start of WIN + E,I,U for Dexpot
; converts WIN + E,I,U to be used for Dexpot and preserving the native function of the keys by adding SHIFT to the key combination


; F1 - left  - N (J) - Del
; F2 - right - I (L) - PageDown
; F3 - up    - U (I) - Home
; F4 - down  - E (K) - End

; allocate the hotkeys and builds a tunnel that Dexpot only recognize
; remapping literal keys, not the converted to colemak keys

; Switching
#Del::send, #!+{F1}
#PgDn::send, #!+{F2}
#Home::send, #!+{F3}
#End::send, #!+{F4}

; Moving
#!Del::send, #+{F1}
#!PgDn::send, #+{F2}
#!Home::send, #+{F3}
#!End::send, #+{F4}

; Moving and switch
#^Del::send, !#{F1}
#^PgDn::send, !#{F2}
#^Home::send, !#{F3}
#^End::send, !#{F4}

; Copy
#^!Del::send, ^#+{F1}
#^!PgDn::send, ^#+{F2}
#^!Home::send, ^#+{F3}
#^!End::send, ^#+{F4}
