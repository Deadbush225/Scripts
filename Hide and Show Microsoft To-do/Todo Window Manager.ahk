#SingleInstance Force
#Requires AutoHotkey v2.0
;Persistent True
DetectHiddenWindows True

SetWorkingDir A_ScriptDir
;if not A_IsAdmin
;	Run '*RunAs "' A_ScriptFullPath '" /restart' ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

if (not A_IsAdmin) {
	;	MsgBox("Not admin")
	;	MsgBox(A_ScriptFullPath)
	Run '*RunAs "' A_ScriptFullPath '" /restart'
} else if (A_IsAdmin) {
	;	MsgBox("Admin")
	;	MsgBox(A_ScriptFullPath)
	;Run '*RunAs "' A_ScriptFullPath '" /restart'
}

Todo_HWND := 0 
isKeepOnTop := False

thirty_10sec := 0

runToDo() {
    RunWait("Run Todo.exe")
    ; sleep 1000
    
    global Todo_HWND := Integer(IniRead("latest_hwnd.ini", "Latest hWnd", "hWnd"))

    ; MsgBox("Read Hwnd: " . Todo_HWND)

    ; WinSetAlwaysOnTop(0, Todo_HWND)
    ; WinSetExStyle("+0x80", Todo_HWND)
}

; disolve this function as it seemed to be a redundancy
; validateHWND() {
;     if ((!WinExist(Todo_HWND)) || (Todo_HWND != 0)) {
;         runToDo()
;     }
; }

HideToDo() {
    WinHide Todo_HWND
}

ShowToDo(*) {
    WinShow Todo_HWND
}

KeepontopToDo() {
; Screen:   x: 1043	y: 326	w: 398	h: 546
; Client:	x: 1051	y: 326	w: 382	h: 538


    WinMove(1043, 326, 398, 546, Todo_HWND)
    ; global isKeepOnTop := True
    ; ShowToDo()

    ; Sleep 250
    ; WinActivate Todo_HWND
    ; Send "!{Up}"

    ; ; double check if a window intercepts
    ; Sleep 250
    ; WinActivate Todo_HWND
    ; Send "!{Up}"

    ; ; Sleep 750
    ; ; WinActivate Todo_HWND
    ; ; Send "!{Up}"

    ; Sleep 250
    ; PositionToDo()
    
    ; Sleep 250
    ; PositionToDo()
    
    ; ; final safe play
    ; ; Sleep 750
    ; ; PositionToDo()
}

PositionToDo(*) {
    ; Sleep 1000
    WinActivate Todo_HWND
    WinMove(925, 410, ,, Todo_HWND)
}

ExitSc(*) {
    if WinExist(Todo_HWND) {
        ShowToDo()
    }
    ExitApp
}

ToDoWindowCheck() {
    ; serves also as a safeguard in case the last open before shutdown
    if (WinExist(Todo_HWND) && Todo_HWND != 0) {
        ; MsgBox "Window already exist, showing the instance: " . Todo_HWND , ,2000
        ShowToDo()
    } else {
        ; MsgBox "Window doesn't exist, running new instance: " . Todo_HWND , ,2000
        runToDo()
        ; MsgBox()
        ; validateHWND()
    }
}

TodoisVisible() {
    ; MsgBox WinGetStyle(Todo_HWND)
    ; MsgBox WinGetExStyle(Todo_HWND)
    return (WinGetStyle(Todo_HWND) & 0x10000000) > 0
}

ToggleVisibility() {
    ; ToDoWindowCheck()
    ; KeepontopToDo()
    ; MsgBox TodoisVisible()
    if TodoisVisible() {
        HideToDo()
    } else {
        ShowToDo()
    }
}

Watcher() {
    ; add an additional check if window is just hidden
    if !(WinExist(Todo_HWND)) {
        res := MsgBox("Hey! To do is exited, do you want to open it [yes] or exit the script [no]", , 4)

        if (res == "Yes") {
            runToDo()
            KeepontopToDo()
        }
        else if (res == "No") {
            ; continue
            ExitApp
        }
    }
}

; LateLoginMinimizer() {
;     if !(isKeepOnTop) {
;         ToDoWindowCheck()
;         KeepontopToDo()
;     }
; }

main() {

    ; start-up delay
    ; sleep(20000)

    systray := A_TrayMenu
    
    systray.Delete()
    systray.Add("Show To Do", ShowToDo)
    systray.Add("Position To Do", PositionToDo)
    systray.Add("Exit", ExitSc)

    ;load previous hwnd
    global Todo_HWND := Integer(IniRead("latest_hwnd.ini", "Latest hWnd", "hWnd"))

    ; run to do if it doesn't exist
    ; if WinExist("Microsoft To Do")
        ; MsgBox "Window Already Exists"

    ToDoWindowCheck()
    KeepontopToDo()

    ; SetTimer Watcher, 60000 ; Check every 1 min
    ; SetTimer LateLoginMinimizer, 10000 ; Check every 5 mins
    SetTimer Watcher, 300000 ; Check every 5 mins

}

Numpad0 & Numpad2::{
    try {
        ToggleVisibility()
    } Catch Error as err{
        MsgBox Format("{1}: {2}.`n`nFile:`t{3}`nLine:`t{4}`nWhat:`t{5}`nStack:`n{6} `n`nhWnd: {7}"
        , type(err), err.Message, err.File, err.Line, err.What, err.Stack, Todo_HWND) 
    }
}

try {
    main()
}
Catch Error as err {
    MsgBox Format("{1}: {2}.`n`nFile:`t{3}`nLine:`t{4}`nWhat:`t{5}`nStack:`n{6} `n`nhWnd: {7}"
        , type(err), err.Message, err.File, err.Line, err.What, err.Stack, Todo_HWND)
}