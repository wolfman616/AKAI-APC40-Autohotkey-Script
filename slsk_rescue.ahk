#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;Run, "C:\Program Files (x86)\SoulseekNS\slsk2.exe" ;Windowed Projector (Scene) - Scene
;obs64.exe ;Qt5QWindowIcon
;Menu, Tray, Icon, C:\ICON\32\obs.ico
;#notrayicon
#persistent
DetectHiddenWindows, On
#SingleInstance force
WinGet, slskpid, pid, SoulSeek [headcrack] - [Transfers]
WinGet, hWindow, ID, SoulSeek [headcrack] - [Transfers]

Winshow , SoulSeek [headcrack] - [Transfers]
IfWinNotExist, SoulSeek
    tooltip, giant throbbing bellend,,,1
else
{
WinActivate  SoulSeek
;WinMaximize , SoulSeek
WinGetPos,,, Width, Height, %WinTitle%
    WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
winrestore
;winset, region, W200 H250, SoulSeek
    return
}
tooltip, %slskpid% id %hwindow% hwind, ,,2
;	WinGet, CtrlID, ControlListHwnd,ahk_id %hWindow%
;		Controlgettext, hWnd2, CtrlID, ahk_id %hWindow%
		;ToolTip, %hWnd2% secret %CtrlID% CtrlList
;GuiControl, Font, 578, Options
;WinSet, Style, 0x10000000, Windowed Projector (Scene) - Scene
;WinSet, ExStyle, 0x00000000, Windowed Projector (Scene) - Scene
;0x14000000
;0x00000008
sleep 1000

