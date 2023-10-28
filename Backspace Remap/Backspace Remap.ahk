#Requires AutoHotkey v2.0
#SingleInstance Force

SetWorkingDir A_ScriptDir

if (not A_IsAdmin) {
	;	MsgBox("Not admin")
	;	MsgBox(A_ScriptFullPath)
	Run '*RunAs "' A_ScriptFullPath '" /restart'
} else if (A_IsAdmin) {
	;	MsgBox("Admin")
	;	MsgBox(A_ScriptFullPath)
}

; Create this using the "Hotkey" Function and just disable it when the program is not yet started

; ======================== Turn off Hotkeys by Default ======================= ;
BR_DisableBackSpaceRemap() {
	Hotkey("CapsLock", "Off")
	Hotkey("RCtrl", "Off")
	Hotkey("PgUp", "Off")
	Hotkey("PgDn", "Off")
	Hotkey("RShift & 1", "Off")
	Hotkey("RShift & 2", "Off")
}

; for future use
BR_EnableBackSpaceRemap() {
	Hotkey("CapsLock", "On")
	Hotkey("RCtrl", "On")
	Hotkey("PgUp", "On")
	Hotkey("PgDn", "On")
	Hotkey("RShift & 1", "On")
	Hotkey("RShift & 2", "On")
}

BR_StartBackspaceRemap() {
	Hotkey("CapsLock", "Backspace")
	Hotkey("RCtrl", "CapsLock")

	Hotkey("PgUp", "Home")
	Hotkey("PgDn", "End")

	Hotkey("RShift & 1", SendInput("``"))
	Hotkey("RShift & 2", "~")
}

; =================================== Main =================================== ;
BR_StartBackspaceRemap()

; ================================== Hotkeys ================================= ;
b_press := 0

; #HotIf GetKeyState("RShift") && GetKeyState("s", "P")
RShift & b::{
	b_press := 1
}
RShift & b UP::{
	b_press := 0
}

>+x::{
	if b_press {
		BR_DisableBackSpaceRemap()
	}
}

; ================================= OnMessage ================================ ;

OnMessage(0x5555, BR_EnableBackSpaceRemap) ; Show spotify