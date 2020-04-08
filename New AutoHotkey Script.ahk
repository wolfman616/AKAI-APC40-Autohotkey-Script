#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
RegWrite, REG_SZ, HKCU, SOFTWARE\Classes\*\shell\mp3\command,,"c:\program files\AutoHotkey.exe" "C:\script\AHK\Z_MIDI_IN_OUT\wmp_paste.ahk" "`%1"