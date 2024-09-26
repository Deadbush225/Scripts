#Requires AutoHotkey v2.0
#SingleInstance Force

HWND := 0

isVisible() {
    return (WinGetStyle(HWND) & 0x10000000) > 0
}

toggle() {
    if isVisible() {
        WinHide HWND
    } else {
        WinShow HWND
        WinActivate HWND
    }
}

main() {
    global HWND := WinExist("Document - Vivaldi")
}

try {
    main()
} catch Error as e {
    
}


NumpadDot & NumpadDiv::{
    toggle()
}