#Requires AutoHotkey v2.0
DetectHiddenWindows True
DetectHiddenText True

; WinExist("Microsoft To Do")
; WinExist("ahk_class ApplicationFrameWindow")
; WinExist("ahk_exe ApplicationFrameHost.exe")
; WinExist("ahk_pid " 4204)
; WinExist("ahk_id " 4653868)

; -----------------------------

; MyGui := Gui(, "Process List")
; LV := MyGui.Add("ListView", "x2 y0 w400 h500", ["HWND", "Process Name","Command Line"])

; GetTodoHandle() {
;     for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process") {
;         ; LV.Add("", process.Handle, process.Name, process.CommandLine)
;         if process.Name == "Todo.exe" {
;             MsgBox "Todo processId: " process.ProcessId
;             return process.ProcessId
;         }
;     }
;     return -1
; }

; MyGui.Show

; -----------------------------

; WinGetListWithChildren() {
;     WindowArray := []
;     for hwnd in WinGetList() {
;         GetAllProcessesRecursive(hwnd, &WindowArray)
;     }
;     GetAllProcessesRecursive(hwnd, &WindowArray, level := 0, parentHwnd := -1) {
;         try {
;             ProcessName_ := WinGetProcessName(hwnd)
;             ; ProcessName_ := ProcessGetName(hwnd)
;         } catch {
;             return
;         }

;         if ProcessName_ == 'ApplicationFrameHost.exe' {
;             for hwnd_ in WinGetControlsHwnd(hwnd) {
;                 GetAllProcessesRecursive(hwnd_, &WindowArray, level++, hwnd)
;             }
;         } else {
;             ; ProcessName_ := WinGetProcessName(hwnd)
;             ; MsgBox ProcessName
;             WindowArray.push(hwnd " : " ProcessName_)
;             if ProcessName_ == "Todo.exe" {
;                 MsgBox "Match!!"
;             }
;         }
;     }
;     return WindowArray
; }
; ids := WinGetListWithChildren()
; ; MsgBox(window.ProcessName())

; ; ids := WinGetList()

; ; ids := []

; MyGui := Gui()
; MyGui.AddListBox("h700 w600", ids)
; MyGui.Show()

; -----------------------------

x := 1150
y := 300

Found_hWnd := DllCall("WindowFromPoint", "UInt64", x|(y << 32), "Ptr")
ChFound_hWnd := DllCall("ChildWindowFromPointEx", "ptr", 0, "UInt64", x|(y << 32), "uint", 0x0000, "Ptr")

MsgBox WinGetTitle(Found_hWnd) " : " Found_hWnd " : " ChFound_hWnd
; WinExist(Found_hWnd)

; -----------------------------

; MyGui := Gui()
; Lv := MyGui.Add("ListView", "h700 w600",["HWND", "Process Name"])
; MyGui.Show()

ms := []

DllCall("EnumChildWindows", "ptr", 0, "ptr", callbackCreate(EnumChildWindows, "F"), "uint", 0)

EnumChildWindows(hwnd) {
    ; try {
        ; pn := WinGetProcessName(hwnd)
    ; } 
    ; catch {
        ; return True
    ; }

    ; popup_hwnd := DllCall("", "ptr", hwnd, "uint", 6, "uint", 0)
    ; if popup_hwnd == True {
        ; ms.push(popup_hwnd)
    ; }

    DllCall("EnumChildWindows", "ptr", hwnd, "ptr", callbackCreate(EnumChildWindows, "F"), "uint", 0)
    ; ms.push(hwnd)
    ; Lv.add("", hwnd, pn)

    ; if pn == "Todo.exe" {
        ; MsgBox "Match!!"
    ; }
    if hwnd == Found_hWnd {
        MsgBox "Found it!!"
    }

    Ancestor := DllCall("")

    return True
}

; hwnd := DllCall("FindWindowEx", "ptr", 0, "ptr", 0, "Str", "ApplicationFrameWindow", "ptr", 0, "uint", 0)

; MyGui := Gui()
; Lv := MyGui.Add("ListView", "h700 w600",["HWND", "Process Name"])
; MyGui.AddListBox("h700 w600", ms)
; MsgBox hwnd
; MyGui.Show()
; ; -----------------------------

; x := 1150
; y := 300

; hWnd := DllCall("WindowFromPoint", "UInt64", x|(y << 32), "Ptr")
; MsgBox WinGetTitle(hWnd) " : " hWnd " : "
; WinExist(hWnd)

; ; -----------------------------

; truWindow := 0

; ; for each, p_hwid in ids {
; p_hwid := 0
; MouseGetPos(,,&win)

;     try {
;         pn := WinGetProcessName(p_hwid)
;     } catch Error {
;         MsgBox "Error"
;     }

;     if pn == "ApplicationFrameHost.exe" {    
;         DllCall("EnumChildWindows", "ptr", p_hwid, "ptr", callbackCreate(EnumChildWindows, "F"), "uint", 0)
;         MsgBox truWindow
;     }
; ; }

; EnumChildWindows(hwnd) {
;     try {
;         pn := WinGetProcessName(hwnd)
;     } catch Error {
;         MsgBox "Error"
;     }

;     if pn != "ApplicationFrameHost.exe"{
;         truWindow := hwnd
;         return False
;     }
;     return True
; }

; loop through each of the windows 
    ; chech if an the WinGetProccesName() of the current window matches "todo.exe"
    ; if match then just save the todePID to the current


; win_id := WinGetList(, , "")

;

; ; hWnd_ := DllCall("WindowFromPoint", "Int", 1150, "Int", 300 )

; x := 1150
; y := 300

; ; hWnd := DllCall("WindowFromPoint", "UInt64", x|(y << 32), "Ptr")
; hWnd := DllCall("FindWindowA", "Str", "Todo.exe", "uInt", 0, "Ptr")
; ; ; hParent := DllCall("GetAncestor", "Ptr", hWnd_, "UInt", GA_ROOT := 2, "Ptr")

; msgbox hWnd

; ExitApp

; title := WinGetTitle(hwnd)
; text_ := WinGetProcessName(hwnd)
; ; ; ptitle := WinGetTitle(hParent)
; msgbox title " : " hwnd " : " text_
; WinKill(hwnd)
; ; WinActivate hWnd_
; ; hwnd_ := WinGetProcessName("Microsoft To Do")

; ; MsgBox hwnd_

; ; ; pid := WinGetPID("Microsoft To Do")
; ; ; pid := WinGetPID(hwnd_)
; ; pid := WinGetProcessName(hwnd_)
; ; MsgBox pid

; ;

; RmvDuplic2(object) {
;     secondobject := []
;     Loop object.Length
;     {
;         value:=Object.RemoveAt(1)
;         Loop secondobject.Length
;             If (value=secondobject[A_Index])
;                 Continue 2 ; jump to the top of the outer loop, we found a duplicate, discard it and move on
;         secondobject.Push(value)
;     }
;     Return secondobject
; }


; ; ; WinGet Bar, List


; ;     ; 0000000000000000000

; ; there's so much random IME
; ids := WinGetList(, , "IME")

; names := []
; processNames := []
; ; unique := RmvDuplic2(ids)

; for this_id in ids {
;     try {
;         process_Name := WinGetProcessName(this_id)

;         if (process_Name == "Todo.exe") {
;             MsgBox "id: " this_id
;         }

;     } catch Error as e {
;         MsgBox e.message
;     }
    

;     ; }
; }



; ;     ; 0000000000000000000

; processNames := RmvDuplic2(processNames)
; MyGui := Gui()
; MyGui.AddListBox("h700 w600", processNames)
; MyGui.Show()
