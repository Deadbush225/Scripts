#SingleInstance Force
#Requires AutoHotkey v2.0
;Persistent True
DetectHiddenWindows True

; ============================= Global Variables ============================= ;

Spotify_HWND := 0


; ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ SWM Helpers ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ;

SWM_SpotityisVisible() {
    try { 
        return (WinGetStyle(Spotify_HWND) & 0x10000000) > 0 
    }    
    catch Error as err {
        ; MsgBox("Error Occured, Starting Programs")
        SWM_StartPrograms(true, false)
    }
}

SWM_ShowSpotify(*) {
    ; MsgBox("Showing Spotify")
    if !SWM_SpotifyIsThere() {
        SWM_StartPrograms()
    }
    
    WinShow Spotify_HWND
}

SWM_ToggleVisibility(*) {
    ; ret := SpotityisVisible()
    
    ; MsgBox ret
    ; MsgBox "Spotify_HWND"
    
    if !SWM_SpotifyIsThere() {
        ; MsgBox("Fresh launch")
        SWM_StartPrograms()
    }
    
    if !SWM_ToastifyIsThere() {
        SWM_StartPrograms(false, true)
    }

    if SWM_SpotityisVisible(){
        WinHide Spotify_HWND
    } else {
        WinShow Spotify_HWND
        WinWait Spotify_HWND
        WinActivate Spotify_HWND
    }

    ; Show the Spotify Winndow first then check if toastify is present
    ; SWM_SpotifyWindowCheck()
}

; =============================== SWM Functions ============================== ;

SWM_StartPrograms(Run_Spotify := true, Run_Toastify := true) {
    ; MsgBox(Run_Spotify " : " Run_Toastify)
    
    if (Run_Spotify) {
        Run("C:\Users\Administrator\AppData\Roaming\Spotify\Spotify.exe") ; ; &Spotify_HWND
        ; Sleep 3000
    }
    
    if (Run_Toastify) {
        ; Run(A_ScriptDir "/Toastify.lnk")
        Run("C:\Program Files\Toastify\Toastify.exe")
        ; Sleep 1000
    }
    
    ; global Spotify_HWND := WinGetID("ahk_exe Spotify.exe")
    global Spotify_HWND := WinWaitActive("ahk_exe Spotify.exe")
    ; MsgBox Spotify_HWND
    
    WinHide Spotify_HWND
}

SWM_SpotifyIsThere() {
return WinExist(Spotify_HWND) && (Spotify_HWND != 0)
}

SWM_ToastifyIsThere() {
return ProcessExist("Toastify.exe")
}

SWM_SpotifyWindowCheck() {
    ; serves as a safeguard incase Spotify is already open
    
    ; MsgBox("Spotify: " WinExist(Spotify_HWND) " : " (Spotify_HWND != 0))

    spotify_exists := SWM_SpotifyIsThere()
    
    ; MsgBox("Toastify: " ProcessExist("Toastify.exe"))
    toastify_exists := SWM_ToastifyIsThere()
    
    SWM_StartPrograms(!spotify_exists, !toastify_exists)
    
    if spotify_exists {
        SWM_ShowSpotify()
    }
}


SWM_ExitSc(*) {
    
    ; try { 
    ;     WinClose Spotify_HWND
    ;     WinClose "Toastify"
    ; }
    ; catch Error as err {
    ; }

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

~>+s::{
    global s_pressed := 1
}
~>+s UP::{
    global s_pressed := 0
}

~>+v::{
    global s_pressed
    ; MsgBox("SWM: RShift + v")

    if (not s_pressed) {
        return
    }
    
    ; MsgBox("Toggling Visibility")
    ; if SWM_SpotifyIsThere() {
        ; MsgBox("Spotify is there, Toggling")
        SWM_ToggleVisibility()
    ; }
}

; =================================== Main =================================== ;

SWM_main()

; ============================= Disable Shortcuts ============================ ;

; >+s::{
; }

; ================================= OnMessage ================================ ;

OnMessage(0x5555, SWM_ShowSpotify) ; Show spotify