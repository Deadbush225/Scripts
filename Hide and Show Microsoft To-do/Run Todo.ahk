#Requires AutoHotkey v2.0
#SingleInstance Force

; make this run on start
; instead of the todo

IniWrite(runToDo(), "latest_hwnd.ini", "Latest hWnd", "hWnd")

runToDo() {
	;MsgBox("Running")
    run "shell:AppsFolder\Microsoft.Todos_8wekyb3d8bbwe!App"
    
    ; myGui := Gui()
    ; myGui.Show()
    ; gui_hwnd := myGui.Hwnd    

    ; WinWaitNotActive gui_hwnd, , 3
    
    TODO_HWND := WinWaitActive("Microsoft To Do")

    ; myGui.destroy()

    ; Todo_HWND := WinExist("Microsoft To Do")

    ; MsgBox(Todo_HWND)

    return Todo_HWND
}

Sleep 250

ExitApp
