#Requires AutoHotkey v2.0
#SingleInstance Force

SendLevel 1
DetectHiddenWindows 1

; #Include "../Hide and Show Microsoft To-do/Todo Window Manager.ahk"
; #Include "../Spotify and Toastify/Spotify Window Manager.ahk"
; #Include "../Backspace Remap/Backspace Remap.ahk"

; compressing to one executable isn't that practical, it is preferable to use standalone scripts for a particular program

; ================================ Auto Start ================================ ;
StartPrograms() {
    if (not WinExist("Text Operations")) {
        Run("D:\System\Scripts\Text Operations\Text Operations.exe")
        Sleep(1500)
    }
    
    if (not WinExist("Backspace Remap")) {
        Run("D:\System\Scripts\Backspace Remap\Backspace Remap.exe")
        Sleep(1500)
    }

    if (not WinExist("Todo Window Manager.exe")) {
        Run("D:\System\Scripts\Hide and Show Microsoft To-do\Todo Window Manager.exe")
        Sleep(1500)
    }

    ; if (not WinExist("Linkbar.exe")) {
    ;     Run("D:\System\Programs\Linkbar\Linkbar_1_6_9\Linkbar.exe")
    ;     Sleep(1500)
    ; }

    ; if (not WinExist("Portals.exe")) {
    ;     Run("C:\Program Files\Portals\Portals.exe")
    ;     Sleep(1500)
    ; }
}


; ============================= Conditional Start ============================ ;
AL_RunSpotify(*) {
    ; MsgBox("Running Spotify")
    
    spotify_exist := WinExist("Spotify Window Manager.exe")
    
    if not spotify_exist {
        Run("D:\System\Scripts\Spotify and Toastify\Spotify Window Manager.exe")
    } else if spotify_exist {
        ; MsgBox("Spotify exist, opening...")
        PostMessage(0x5555) ; show spotify
        ; Send("{RShift Down}sv")
        ; Sleep(500)
        ; Send("{RShift Up}")
        ; - run short cut for showing spotify (Spotify Window Manager)
    }
}

AL_RunTodo(*) {
    ; MsgBox("Running Todo")
    
    todo_exist := WinExist("Todo Window Manager.exe")
    
    if not todo_exist {
        Run("D:\System\Scripts\Hide and Show Microsoft To-do\Todo Window Manager.exe")
    } else if todo_exist {
        ; MsgBox("Todo exist, opening...")
        PostMessage(0x5555) ; show todo
    }
}

AL_RunBackspaceRemap(*) {
    MsgBox("Running Backspace Remap")
    
    br_exist := WinExist("Backspace Remap.exe")
    
    if not br_exist {
        Run("D:\System\Scripts\Backspace Remap\Backspace Remap.exe")
    } else if br_exist {
        ; MsgBox("Todo exist, opening...")
        PostMessage(0x5555) ; enable backspace remap
    }
}

AL_RunPeace(*) {
    peace_exist := WinExist("Peace.exe")
    
    if not peace_exist {
        Run("C:/Program Files/EqualizerAPO/config/Peace.exe")
    } else if peace_exist {
        WinShow("Peace.exe")
    }
}

AL_RunTextOperations(*) {
    if not WinExist("Text Operations.exe") {
        Run("D:/System/Scripts/Text Operations/Text Operations.exe")
    }
}

Ex(*) {
    ExitApp()
}

AL_main() {
    global a_pressed := 0
    
    systray := A_TrayMenu
    
    systray.Delete()
    systray.Add("Run `"Spotify`"", AL_RunSpotify)
    systray.Add("Run `"Todo`"", AL_RunTodo)
    ; systray.Add("Run `"Backspace Remap`"", AL_RunBackspaceRemap)
    systray.Add("Run `"Peace`"", AL_RunPeace)
    systray.Add("Run `"Text Operations`"", AL_RunTextOperations)
    systray.Add("Exit", Ex)
    
    ; systray.Add("Exit", ExitSc)
    StartPrograms()
    ; OnExit(BeforeExit)
}

; ================================= Shortcuts ================================ ;
/**
 * Visibility, and ThingsBeforeExit are handled by the imported script
*/

>+a::{
    global a_pressed := 1
    ; MsgBox("Pressed " a_pressed)
}
>+a UP::{
    global a_pressed := 0
    ; MsgBox("Lifted " a_pressed)
}

; #HotIf GetKeyState("RShift") && GetKeyState("a", "P")
>+s::{
    global a_pressed
    ; MsgBox("AL: RShift + s : " a_pressed)
    
    ; MsgBox(a_pressed)
    
    if (not a_pressed) {
        ; MsgBox("A is not pressed")
        return
    }
    
    ; MsgBox("AL: Running Spotify")
    AL_RunSpotify()
}

; #HotIf GetKeyState("RShift") && GetKeyState("a", "P")
>+t::{
    global a_pressed
    
    if (not a_pressed) {
        return
    }

    AL_RunToDo()
}
    
; #HotIf GetKeyState("RShift") && GetKeyState("a", "P")
>+b::{
    global a_pressed
    
    if (not a_pressed) {
        return
    }

    AL_RunBackspaceRemap()
}
        
; #HotIf GetKeyState("RShift") && GetKeyState("a", "P")
>+p::{
    global a_pressed
    
    if (not a_pressed) {
        return
    }

    AL_RunPeace()
}

; #HotIf GetKeyState("RShift") && GetKeyState("a", "P")
>+o::{
    global a_pressed
    
    if (not a_pressed) {
        return
    }

    AL_RunTextOperations()
}

; ============================= Disable shortcuts ============================ ;
; >+a::{
    ;     }
    
; =================================== Main =================================== ;
AL_main()    