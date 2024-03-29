SetWorkingDir A_ScriptDir
if not A_IsAdmin
	Run '*RunAs "' A_ScriptFullPath '" /restart' ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.


; NumpadDot & j::
; NumpadDot::
	; ^a::MsgBox, , ,% A_ThisHotkey " pressed with ^k",
	; return

removeDoubleSpace(word) {
	; count := 0
	Loop 
		{ 
		word := StrReplace(word, "  ", " ",,&count)
		if (count = 0)  ; No more replacements needed. 
			break
		}
	
	; msgBox("removeDoubleSpace", word)
	return word	
}

removeNewline(word) {
	return removeDoubleSpace(RegExReplace(word, "(\n|\r\n)", " "))
}

; REMOVE NEWLINE IN SELECTION, NECESSARILY CONVERTING IT TO ONELINE
; NumpadDot & o::
NumpadDot & y::{
	; MsgBox, , "Working", "Working", 5
	A_Clipboard := ""
	Send("^c")
	ClipWait 1
	; if ErrorLevel
		; MsgBox, , "Error", %A_Clipboard%, 5
		; return

	; MsgBox("Cliboard", A_Clipboard)

	A_Clipboard := removeNewline(A_Clipboard)
	; A_Clipboard := "removeNewline"
	Send("^v")
	; MsgBox("Working", "'" . A_Clipboard . "'", 5)
}

; CALLOUTS

; ADDS "> [!source-image]+"
; NumpadDot & y::
NumpadDot & j::{
	A_Clipboard := "> [!source-image]+"
	Send("^v")
}

; ADDS "> [!source-image]-"
; NumpadDot & i::
NumpadDot & u::{
	A_Clipboard := "> [!source-image]-"
	Send("^v")
}

NumpadDot & n::{
	A_Clipboard := "> [!note]-"
	Send("^v")
}

NumpadDot & m::{
	A_Clipboard := "> [!note]+"
	Send("^v")
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
}

; remove double space
; NumpadDot & d::
NumpadDot & s::{

	A_Clipboard := ""
	Send("^c")
	
	ClipWait(1)

	A_Clipboard := removeDoubleSpace(A_Clipboard)
	Send("^v")
}

;lowercase
; NumpadDot & l::
NumpadDot & i::{
	A_Clipboard := ""
	Send("^c")
	
	ClipWait(1)
	
	A_Clipboard := StrLower(A_Clipboard)
	Send("^v")
}

;upper
; NumpadDot & u::
NumpadDot & l::{
	A_Clipboard := ""
	Send("^c")
	
	ClipWait(1)
	
	A_Clipboard := StrUpper(A_Clipboard)
	Send("^v")
}

;Sentence Case
; NumpadDot & s::
NumpadDot & r::{
	A_Clipboard := ""
	Send("^c")

	ClipWait(1)


	A_Clipboard := RegExReplace(A_Clipboard, "^\w|(?:\.|:)\s+\K\w", "$U0")
	Send("^v")
}

;Title Case
; NumpadDot & t::
NumpadDot & g::{
	A_Clipboard := ""
	Send("^c")
	
	ClipWait(1)
	
	A_Clipboard := StrTitle(A_Clipboard)
	Send("^v")
}


;delete lines

; NumpadDot & k::
NumpadDot & e::{
	Send("{End}{ShiftDown}{Home}{ShiftUp}{Del}{BackSpace}{Down}")
}

;transform numbered list to heading
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


; /////// functions
; removeDoubleSpace(word) {
; 	; count := 0
; 	Loop 
; 		{ 
; 		word := StrReplace(word, "  ", " ",,&count)
; 		if (count = 0)  ; No more replacements needed. 
; 			break
; 		}
	
; 	; msgBox("removeDoubleSpace", word)
; 	return word	
; }

; removeNewline(word) {
; 	return removeDoubleSpace(RegExReplace(word, "(\n|\r\n)", " "))
; }

; /////// functions

; COLEMAK LAYOUT
*`;::Send "{Blind}o"
*d::Send "{Blind}s"
*e::Send "{Blind}f"
*f::Send "{Blind}t"
*g::Send "{Blind}d"
*i::Send "{Blind}u"
*j::Send "{Blind}n"
*k::Send "{Blind}e"
*l::Send "{Blind}i"
*n::Send "{Blind}k"
*o::Send "{Blind}y"
*p::{
	Send "{Blind}`;"
}
*+p::{
	Send "{Blind}:"
}
*r::Send "{Blind}p"
*s::Send "{Blind}r"
*t::Send "{Blind}g"
*u::Send "{Blind}l"
*y::Send "{Blind}j"

CapsLock::BackSpace
RCtrl::CapsLock
; end of COLEMAK LAYOUT



