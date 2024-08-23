#SingleInstance Force
#Requires AutoHotkey v2.0
;Persistent True
DetectHiddenWindows True

; https://www.autohotkey.com/docs/v2/lib/ComCall.htm#ExTaskbar
class TaskbarList {
    static IID := "{56FDF342-FD6D-11d0-958A-006097C9A090}"
    static CLSID := "{56FDF344-FD6D-11d0-958A-006097C9A090}"
    
    ; Called on startup to initialize the class.
    static __new() {
        ; Get the base object for all instances of TaskbarList.
        proto := this.Prototype
        
        ; Bound functions can be used to predefine parameters, making
        ; the methods more usable without requiring wrapper functions.
        ; HrInit itself has no parameters, so bind only the index,
        ; and the caller will implicitly provide 'this'.
        proto.HrInit := ComCall.Bind(3)
        
        ; Leave a parameter blank to let the caller provide a value.
        ; In this case, the blank parameter is 'this' (normally hidden).
        proto.AddTab := ComCall.Bind(4,, "ptr")
        
        ; An object or Map can be used to reduce repetition.
        for name, args in Map(
            "DeleteTab", [5,,"ptr"],
            "ActivateTab", [6,,"ptr"],
            "SetActiveAlt", [7,,"ptr"]) {
            proto.%name% := ComCall.Bind(args*)
        }
    }
    
    ; Called by TaskbarList() on the new instance.
    __new() {
        this.comobj := ComObject(TaskbarList.CLSID, TaskbarList.IID)
        this.ptr := this.comobj.ptr
        ; Request initialization via ITaskbarList.
        this.HrInit()
    }
}

; =============================== Run as Admin =============================== ;

SetWorkingDir A_ScriptDir

if (not A_IsAdmin) {
	;	MsgBox("Not admin")
	;	MsgBox(A_ScriptFullPath)
	Run '*RunAs "' A_ScriptFullPath '" /restart'
} else if (A_IsAdmin) {
    ; Do nothing, already admin
}

; ============================= Global Variables ============================= ;

Todo_HWND := 0 

; =============================== TWM Functions ============================== ;

TWM_StartToDo() {
    RunWait("Run Todo.exe")
    
    global Todo_HWND := Integer(IniRead("latest_hwnd.ini", "Latest hWnd", "hWnd"))
}


TWM_HideToDo() {
    ; WinHide Todo_HWND
    WinMinimize Todo_HWND
    
    ; tbl := TaskbarList()

    ; ; activeHwnd := WinExist("A")
    ; suc := tbl.DeleteTab(Todo_HWND)
    ; ; MsgBox(suc)

    ; tbl := ""
}

TWM_ShowToDo(*) {
    ; WinShow Todo_HWND
    WinRestore Todo_HWND
}

TWM_KeepontopToDo() {
; Screen:	x: 1037	y: 319	w: 398	h: 546
; Client:	x: 1045	y: 319	w: 382	h: 538
; Client:	x: 1069	y: 358	w: 360	h: 501
; Client:	x: 1068	y: 356	w: 360	h: 501

    WinMove(1062, 358, 360, 501, Todo_HWND)

    WinSetAlwaysOnTop(1, Todo_HWND)
}

TWM_HWND_Modifier() {
    if (WinGetTitle(Todo_HWND) == "Microsoft To Do" ) {
        MsgBox "HWND Verified"        
    } else {
        MsgBox "HWND Mismatch"
        TWM_StartToDo()
    }
}

TWM_PositionToDo(*) {
    ; Sleep 1000

    WinActivate Todo_HWND
    WinMove(1062, 358, 360, 501, Todo_HWND)
}

TWM_ExitSc(*) {
    if WinExist(Todo_HWND) {
        TWM_ShowToDo()
    }
    ExitApp
}

TWM_WinExist() {
    return WinExist(Todo_HWND)
}

/**
 * 
 * @param {number} visibilityMode
 *      - 0: Check then, just show the window
 *      - 1: Check then, toggle the visibility
 */
TWM_ToDoWindowCheck(visibilityMode := 0) {
    
    ; serves also as a safeguard in case the last open before shutdown
    if (TWM_WinExist() && Todo_HWND != 0) {
        if (visibilityMode == 0) {
            TWM_ShowToDo()
        } else if (visibilityMode == 1) {
            if TWM_TodoisVisible() {
                TWM_HideToDo()
            } else {
                TWM_ShowToDo()
            }
        }
    } else {
        TWM_StartToDo()
    }
}

TWM_TodoisVisible() {
    red := (WinGetMinMax(Todo_HWND) =! 1)
    ; MsgBox(red)
    return red
    ; return (WinGetStyle(Todo_HWND) & 0x10000000) > 0
}

; TWM_ToggleVisibility() {
;     ; try to add safeguard to check if Spotify is running
;     if TWM_WinExist() {
;         if TWM_TodoisVisible() {
;             TWM_HideToDo()
;         } else {
;             TWM_ShowToDo()
;         }
;     } else {
;         TWM_StartToDo()
;     }
; }

TWM_Watcher() {
    ; add an additional check if window is just hidden
    if !(WinExist(Todo_HWND)) {
        res := MsgBox("Hey! To do is exited, do you want to open it [yes] or exit the script [no]", , 4)

        if (res == "Yes") {
            TWM_StartToDo()
            TWM_KeepontopToDo()
        }
        else if (res == "No") {
            ; continue
            ExitApp
        }
    }
}

TWM_main() {
    systray := A_TrayMenu
    
    systray.Delete()
    systray.Add("Show To Do", TWM_ShowToDo)
    systray.Add("Position To Do", TWM_PositionToDo)
    systray.Add("Exit", TWM_ExitSc)

    systray.Default := "Show To Do"
    
    global t_pressed := 0

    ; load previous hwnd
    global Todo_HWND := Integer(IniRead("latest_hwnd.ini", "Latest hWnd", "hWnd"))

    TWM_ToDoWindowCheck()
    TWM_KeepontopToDo()

    SetTimer TWM_Watcher, 300000 ; Check every 5 mins

}

; ================================== Hotkeys ================================= ;
/**
 * Just incase you won't be able to use this methodology, you can just create a 
 * separate hotkey when RShift + t is pressed, then it will set a value to a 
 * variable that the inner hotkeys (RShift + v, RShift + p) will check if the 
 * variable's current value is "pressed". You need to create a separate hotkey 
 * when RShift + t is up, so you can reset the value of the variable
 */

/** Shortcuts
 * RShift + T : Make sure todo is running
 * RShift + T + V : Toggle todo window
 * RShift + T + P : Position todo window
 */

global t_pressed

~>+t::{
    global t_pressed := 1
}
~>+t UP::{
    global t_pressed := 0
}

; #HotIf GetKeyState("RShift") && GetKeyState("t", "P") 
~>+v::{
    ; BLOCK V
    global t_pressed

    if (not t_pressed) {
        return
    }
    
    ; try {
        TWM_ToDoWindowCheck(1)
    ; } Catch Error as err {
    ;     ; TWM_ToDoErrorReporter(err)
    ; }
}

; #HotIf GetKeyState("RShift") && GetKeyState("t", "P") 
~>+p::{   
    if (not t_pressed) {
        return
    }
    
    TWM_PositionToDo()
}

; =================================== Main =================================== ;
    TWM_main()
; try {
;     TWM_main()
; }
; Catch Error as err {
;     TWM_ToDoErrorReporter(err) 
; }

; TWM_ToDoErrorReporter(err) {
;     MsgBox Format("{1}: {2}.`n`nFile:`t{3}`nLine:`t{4}`nWhat:`t{5}`nStack:`n{6} `n`nhWnd: {7}"
;         , type(err), err.Message, err.File, err.Line, err.What, err.Stack, Todo_HWND)
;     TWM_ToDoWindowCheck()
; }

; =========================== Disable Outer Hotkey =========================== ;

; >+t::{
; }

; ================================= OnMessage ================================ ;

OnMessage(0x5555, TWM_ShowToDo) ; Show spotify
