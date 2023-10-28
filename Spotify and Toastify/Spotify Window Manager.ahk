#SingleInstance Force
#Requires AutoHotkey v2.0
;Persistent True
DetectHiddenWindows True

; ============================= Global Variables ============================= ;

Spotify_HWND := 0

; =============================== SWM Functions ============================== ;

SWM_StartPrograms(Run_Spotify := true, Run_Toastify := true) {
    MsgBox(Run_Spotify " : " Run_Toastify)
    
    if (Run_Spotify) {
        Run "Spotify.lnk" ; ; &Spotify_HWND
        Sleep 3000
    }
    
    if (Run_Toastify) {
        Run "Toastify.lnk"
        Sleep 1000
    }

    ; global Spotify_HWND := WinGetID("ahk_exe Spotify.exe")
    global Spotify_HWND := WinWaitActive("ahk_exe Spotify.exe")
    ; MsgBox Spotify_HWND

    WinHide Spotify_HWND
}

SWM_SpotityisVisible() {
    try { 
        return (WinGetStyle(Spotify_HWND) & 0x10000000) > 0 
    }    
    catch Error as err {
        ; MsgBox("Error Occured, Starting Programs")
        SWM_StartPrograms(true, false)
    }
}

SWM_ToggleVisibility(*) {
    ; ret := SpotityisVisible()

    ; MsgBox ret
    ; MsgBox "Spotify_HWND"

    if SWM_SpotityisVisible() {
        WinHide Spotify_HWND
    } else {
        WinShow Spotify_HWND
        WinWait Spotify_HWND
        WinActivate Spotify_HWND
    }
}

SWM_SpotifyWindowCheck() {
    ; serves as a safeguard incase Spotify is already open

    MsgBox("Spotify: " WinExist(Spotify_HWND) " : " (Spotify_HWND != 0))

    spotify_exists := WinExist(Spotify_HWND) && (Spotify_HWND != 0)
    
    MsgBox("Toastify: " ProcessExist("Toastify.exe"))
    toastify_exists := ProcessExist("Toastify.exe")
    
    SWM_StartPrograms(!spotify_exists, !toastify_exists)
    
    if spotify_exists {
        SWM_ShowSpotify()
    }
}

SWM_ShowSpotify(*) {
    MsgBox("Showing Spotify")

    WinShow Spotify_HWND
}

SWM_ExitSc(*) {
    
    try { 
        WinClose Spotify_HWND
        WinClose "Toastify"
    }
    catch Error as err {
    }

    ExitApp
}

SWM_main() {
    global s_pressed := 0
    
    systray := A_TrayMenu
    
    systray.Delete()
    systray.Add("Toggle Visibility", SWM_ToggleVisibility)
    systray.Add("Show Spotify", SWM_ShowSpotify)
    systray.Add("Exit", SWM_ExitSc)
    
    systray.Default := "Show Spotify"

    SWM_SpotifyWindowCheck()
}

; ================================== Hotkeys ================================= ;

; #HotIf GetKeyState("RShift") && GetKeyState("s", "P")

>+s::{
    global s_pressed := 1
}
>+s UP::{
    global s_pressed := 0
}

>+v::{
    global s_pressed
    ; MsgBox("SWM: RShift + v")

    if (not s_pressed) {
        return
    }
    
    ; MsgBox("Toggling Visibility")

    SWM_ToggleVisibility()
}

; =================================== Main =================================== ;

SWM_main()

; ShowSpotify(*) {
;     WinShow "Spotify Free"
; }

; ExitSc(*) {
;     ShowSpotify()
;     ExitApp
; }


; systray := A_TrayMenu

; systray.Delete()
; systray.Add("ShowSpotify", ShowSpotify, "+BarBreak")
; systray.Add("Exit", ShowSpotify)

; ============================= Disable Shortcuts ============================ ;

; >+s::{
; }

; ================================= OnMessage ================================ ;

OnMessage(0x5555, SWM_ShowSpotify) ; Show spotify