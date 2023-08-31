#SingleInstance Force
#Requires AutoHotkey v2.0
Persistent
DetectHiddenWindows True

Spotify_HWND := 0

StartPrograms(Run_Spotify := true, Run_Toastify := true) {
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

SpotityisVisible() {
    try { 
        return (WinGetStyle(Spotify_HWND) & 0x10000000) > 0 
    }    
    catch Error as err {
        StartPrograms(true, false)
    }
}

ToggleVisibility(*) {
    ; MsgBox TodoisVisible()
    ; MsgBox Spotify_HWND

    if SpotityisVisible() {
        WinHide Spotify_HWND
    } else {
        WinShow Spotify_HWND
        WinWait Spotify_HWND
        WinActivate Spotify_HWND
    }
}

ShowSpotify(*) {
    WinShow Spotify_HWND
}

ExitSc(*) {
    ExitApp
}

BeforeExit(*) {
    
    try { 
        WinClose Spotify_HWND
        WinClose "Toastify"
    }
    catch Error as err {
        MsgBox(err)
    }
}

main() {
    systray := A_TrayMenu
    
    systray.Delete()
    systray.Add("Toggle Visibility", ToggleVisibility)
    systray.Add("Show Spotify", ShowSpotify)
    systray.Add("Exit", ExitSc)
    
    OnExit(BeforeExit)

    StartPrograms()
}

Numpad0 & Numpad1::{
    ToggleVisibility()
}

main()

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

; the only purpose of this script is to hide the window in the first run. when you show the spotify it will manage its systemtray in it's own

; I didn't know that the hide option will move the window to the systemtray
