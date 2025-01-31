#Requires AutoHotkey v2.0

SetWorkingDir A_ScriptDir
if not A_IsAdmin{
	Run '*RunAs "' A_ScriptFullPath '" /restart' ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.
}

; ======================== Helper Functions ======================== ;

!v::{
	A_Clipboard := removeNewline(A_Clipboard)
	; MsgBox(te)
	; A_Clipboard := te
	ClipWait(2)
	Send("^v")
}

~s & v::{
	Send("^c")
	Send("!v")
}

removeDoubleSpace(word) {
	; count := 0
	Loop 
		{ 
		word := StrReplace(word, "  ", " ",,&count)
		if (count = 0)  ; No more replacements needed. 
			break
		}

	return word	
}

!r::{
    Send("^c")
    te := removeDoubleSpace(A_Clipboard)
	MsgBox(te)
	A_Clipboard := te
	Send("^v")
}

removeNewline(word) {
	return removeDoubleSpace(RegExReplace(word, "(\n|\r\n)", " "))
}

clearClipBoard() {
	; MsgBox("Clearing")
	A_Clipboard := ""
}

clipboard_timeout := -2000



; ============================= Hotkeys ============================ ;

global q_pressed

>+q::{
    global q_pressed := 1
}
>+q UP::{
    global q_pressed := 0
}

; Remove newline in selection, Necessarily converting it to oneline
; NumpadDot & o::
NumpadDot & y::{
	A_Clipboard := ""
	Send("^c")
	ClipWait 1

	A_Clipboard := removeNewline(A_Clipboard)
	Send("^v")
	
	SetTimer(clearClipBoard, clipboard_timeout)
}

; +++ CALLOUTS +++

; ADDS "> [!source-image]+"
; NumpadDot & y::
#Hotif GetKeyState("Shift", "P")
NumpadDot & j::{
	A_Clipboard := "> [!source-image]+"
	Send("^v")

	SetTimer(clearClipBoard, clipboard_timeout)
}

; ADDS "> [!source-image]-"
; NumpadDot & i::
#HotIf
NumpadDot & j::{
	A_Clipboard := "> [!source-image]-"
	Send("^v")
	
	SetTimer(clearClipBoard, clipboard_timeout)
}

#Hotif GetKeyState("Shift", "P")
NumpadDot & n::{
	A_Clipboard := "> [!note]+"
	Send("^v")
	
	SetTimer(clearClipBoard, clipboard_timeout)
}

#HotIf
NumpadDot & n::{
	A_Clipboard := "> [!note]-"
	Send("^v")

	SetTimer(clearClipBoard, clipboard_timeout)
}

#Hotif GetKeyState("Shift")
NumpadDot & m::{
	A_Clipboard := "> [!remember]+"
	Send("^v")

	SetTimer(clearClipBoard, clipboard_timeout)
}

#HotIf
NumpadDot & m::{
	A_Clipboard := "> [!remember]-"
	Send("^v")

	SetTimer(clearClipBoard, clipboard_timeout)
}

; ADDS "-" AFTER THE NEWLINE CHAR, NECESSARILY CONVERTS THE SELECTED LINES TO BULLET
; unchanged
NumpadDot & -::{
	A_Clipboard := ""
	Send("^c")
	
	ClipWait(1)
		; return


	str := ""

	Loop Parse Trim(A_Clipboard, "`n`r"), "`n", "`r" {
		; ommited the last new line to preseve it and to have some spacing
		; delimited by `n, and ignore `r as what others normally do when working with strings
		; `r will be removed at the start and end of every substring
		if InStr(A_LoopField, " - ") {
			; str .= A_LoopField
			Continue
		}

		str .= "`n - " . A_LoopField
	}

	A_Clipboard := str
	Send("^v")
	
	SetTimer(clearClipBoard, clipboard_timeout)
}

; remove double space
; NumpadDot & d::
NumpadDot & s::{

	A_Clipboard := ""
	Send("^c")
	
	ClipWait(1)

	A_Clipboard := removeDoubleSpace(A_Clipboard)
	Send("^v")
	
	SetTimer(clearClipBoard, clipboard_timeout)
}

; remove single space
; NumpadDot & f::
NumpadDot & t::{
	A_Clipboard := ""
	Send("^c")

	ClipWait(1)
	A_Clipboard := StrReplace(A_Clipboard, " ", "")
	Send("^v")
	
	SetTimer(clearClipBoard, clipboard_timeout)
}


; lowercase
; NumpadDot & l::
>+i::{
	if (not q_pressed) {
		return
	}

	A_Clipboard := ""
	Send("^c")
	
	ClipWait(1)
	
	A_Clipboard := StrLower(A_Clipboard)
	Send("^v")
	
	SetTimer(clearClipBoard, clipboard_timeout)
}

; uppercase
; NumpadDot & u::
>+l::{
	if (not q_pressed) {
		return
	}
		 		 
	A_Clipboard := ""
	Send("^c")
	
	ClipWait(1)
	
	A_Clipboard := StrUpper(A_Clipboard)
	Send("^v")
	
	SetTimer(clearClipBoard, clipboard_timeout)
}

; Sentence Case
; NumpadDot & s::
>+r::{
	if (not q_pressed) {
		return
	}

	A_Clipboard := ""
	Send("^c")
	
	ClipWait(1)
	
	
	A_Clipboard := RegExReplace(A_Clipboard, "^\w|(?:\.|:)\s+\K\w", "$U0")
	Send("^v")
	
	SetTimer(clearClipBoard, clipboard_timeout)
}

; Title Case
; NumpadDot & t::
NumpadDot & g::{
	A_Clipboard := ""
	Send("^c")
	
	ClipWait(1)
	
	A_Clipboard := StrTitle(A_Clipboard)
	Send("^v")
	
	SetTimer(clearClipBoard, clipboard_timeout)
}

; delete lines
; NumpadDot & k::
NumpadDot & e::{
	Send("{End}{ShiftDown}{Home}{ShiftUp}{Del}{BackSpace}{Down}")
}

; ============================= Headers ============================ ;
; transform numbered list to heading

NumpadDot & Numpad1::
NumpadDot & 1::{
	Send "{Home}{Home}{Text}# "
	Send "{End}"
}

NumpadDot & Numpad2::
NumpadDot & 2::{
	send "{Home}{Home}{Text}## "
	Send "{End}"
}

NumpadDot & Numpad3:: 
NumpadDot & 3::{
	send "{Home}{Home}{Text}### "
	Send "{End}"
}

NumpadDot & Numpad4:: 
NumpadDot & 4::{
	send "{Home}{Home}{Text}#### "
	Send "{End}"
}

NumpadDot & Numpad5:: 
NumpadDot & 5::{
	send "{Home}{Home}{Text}##### "
	Send "{End}"
}

NumpadDot & Numpad6:: 
NumpadDot & 6::{ 
	send "{Home}{Home}{Text}###### "
	Send "{End}"
}

; ========================= Colemak layout ========================= ;

~RCtrl & RShift::CapsLock

; *`;::Send "{Blind}o"
; *d::Send "{Blind}s"
; *e::Send "{Blind}f"
; *f::Send "{Blind}t"
; *g::Send "{Blind}d"
; *i::Send "{Blind}u"
; *j::Send "{Blind}n"
; *k::Send "{Blind}e"
; *l::Send "{Blind}i"
; *n::Send "{Blind}k"
; *o::Send "{Blind}y"
; *p::{
; 	Send "{Blind}`;"
; }
; *+p::{
; 	Send "{Blind}:"
; }
; *r::Send "{Blind}p"
; *s::Send "{Blind}r"
; *t::Send "{Blind}g"
; *u::Send "{Blind}l"
; *y::Send "{Blind}j"
; CapsLock::BackSpace
; RCtrl::CapsLock


