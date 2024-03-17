#Requires AutoHotkey v2.0
#SingleInstance Force

; Shorten H command for highlight
^h::^!h

; Remove highlight
^+h::Send("!hin")

; !hi

#HotIf GetKeyState("Shift", "P")
Space & i::{
    Send("^b!hi{Down 6}{Enter}") ;ice blue
}

#HotIf GetKeyState("Shift", "P")
Space & r::{
    Send("^b!hi{Down 6}{Right 1}{Enter}") ;rose
}

#HotIf GetKeyState("Shift", "P")
Space & g::{
    Send("^b!hi{Down 6}{Right 2}{Enter}") ;light green
}

#HotIf GetKeyState("Shift", "P")
Space & l::{
    Send("^b!hi{Down 6}{Right 3}{Enter}") ;lavander
}

#HotIf GetKeyState("Shift", "P")
Space & o::{
    Send("^b!hi{Down 6}{Right 4}{Enter}") ;light orange
}

#HotIf GetKeyState("Shift", "P")
Space & y::{
    Send("^b!hi{Down 3}{Enter}") ;yellow
}

#HotIf GetKeyState("Shift", "P")
Space & b::{
    Send("^b!hi{Down 3}{Right 2}{Enter}") ;skyblue
}


