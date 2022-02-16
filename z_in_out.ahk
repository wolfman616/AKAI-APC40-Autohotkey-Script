SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
setbatchlines -1
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#persistent
SetTitleMatchMode 2
detecthiddenwindows on
#SingleInstance force
ListLines, Off

#Include VA.ahk
;#inputlevel 1
01=
menu, tray, add, Toggle Midi Channels, Toggle_midi_In_out
menu, tray, add, APC GuI, APC_GuI

readini() ; load previous midi settings

;SYSTRAY MENU 
;==============================================================================
; Menu, Tray, NoStandard
Menu, Tray, Icon, akaiapc_32.ico
;==============================================================================
; Menu, submenu1, Add, MIDI IN 0 / OUT 1, 
; if 01
; Menu, submenu1, Check, MIDI IN 0 / OUT 1
;==============================================================================

;===============Enabling==Menu==&=Re-add= Standard=items=below=======
; Menu, Tray, Add, Settings, :submenu1
; Menu, Tray, Standard

Menu, Tray, noStandard
menu, tray, add, 	Open script location, Open_ScriptDir
Menu, Tray, Standard
Menu, Tray, Standard
Menu, Tray, add, % "Tooltip MASTERVOL", TTMVolTogl


gosub, MidiPortRefresh ; used to refresh the input and output port lists - see label below
port_test(numports,numports2) ; test the ports - check for valid ports?
gosub, midiin_go ; opens the midi input port listening routine
gosub, midiout ; opens the midi out port
;SendLevel 99
;Send, #^r
vars:
global h_midiout
; =============== set variables you use in MidiRules section
timeoutreload := 100
cc_msg  :=  73,74 ; ++++++++++++++++ you might want to add other vars that load in auto execute section This example goes with
channel  :=  1 ; default channel  := 1
ccnum  :=  7 ; 7 is volume
global attended := True
global chan_c
global Master_VolumeNew 
global WMP_Volnew := 20
global TTMVol
global volm_nu := 20
global byte10ld
global byte20ld
global sbyte0ld
global mmsg
global wwmsg
global Vol_Master_Get

		

global GUI_Byte1, global GUI_Byte2, global GUI_sByte, global GUI_Midi_Waiting, global counta, 
global GUI_Script := "C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\APC_gui.ahk"
global Path_PH := "C:\Apps\Ph\processhacker\x64\ProcessHacker.exe"
global NoteVel := 127 ; Colour and Luminosity
global Sbyte := 144
global byte2old
global byte2old2
global mMsg
global Mnote := 0
global Bank := 0 ; bank key un-lit / Bind shift disabled
global yFaderGroup  := 7
global xFadeB1 := 66
global yMaster := 14
global XFader :=  15
global FaderSByte := 176
global FaderSByte := 176
global volpeak
global peakValue
global channel := 1
global ch
global chold := 1

global st:=1
global BouncingThen := false
global WMP, global controls, global media, global asong
BrowserVol := 25, WMPVol := 10, Master_Volume := 10, volVal := 0, volDelta := 10 ; Amount to change volume
fun := 42
global st:=1


global initblud
;176, 177, 178, 179, 180, 181, 182
yfads := []
yfads := [%YfCh1%, %YfCh2%, %YfCh3%, %YfCh4%, %YfCh5%, %YfCh6%, %YfCh7%, %YfCh8%]
ch8lights := []
ch8lights := [6, 14, 22, 40]
xCh8 := "7", xCh7 := "6", xCh6 := "5", xCh5 := "4", xCh4 := "3", xCh3 := "2", xCh2 := "1", xCh1 := "0"
global Pstate_answer := 42
global Pstate_answer_old := 69
skipD  := 86
XfOffB2 := 0
XfLEFTB2 := 1
XfRIGHTB2 := 2
XfCh8 := 151
XfCh7 := 150
XfCh8Off := 135
XfCh7Off := 134
XfCh6 := 149
XfCh6Off := 133
XfCh5:=148
XfCh5Off := 132
XfCh4 := 147
XfCh4Off := 131
XfCh3 := 146
XfCh3Off := 130
XfCh2 := 145
XfCh2Off := 129
XfCh1 := 144
XfCh1Off := 128
YfCh8 := 183
YfCh7 := 182
YfCh6 := 181
YfCh5 := 180
YfCh4 := 179
YfCh3 := 178
YfCh2 := 177
YfCh1 := 176
B2ErrorColor := 106

global 	B2ErrorColor
global 	xSByteFlashPause=143
global 	xSByteFlashfast=141
global 	xSByteFlashfaster=140
global 	xSByteFlashfasterstill=139
global 	xSByteFadePlay=133 
global 	xSByteONNormal=144
global 	B2PausedColor
global 	B2UnPausedColor
global 	BounceCol
global 	bounceincdelay
global 	GuiScriptTitle := "APC_gui.ahk ahk_class AutoHotkey"
global initblud
wm_allow()

OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA

; Loop, Reg, % wintitlekey
; {
    ; if (A_LoopRegType = "REG_SZ") {
        ; value1 	:= A_LoopRegKey . "\" . A_LoopRegSubKey
        ; regRead, value2, %value1%, %A_LoopRegName%
		; Style_wintitleList2 := Style_wintitleList2 . value2 . "‡"	
		; retpos 	:= RegExMatch(A_LoopRegName, "^0.{9}" , 		ret_style, p0s := 1)
		; retpos 	:= RegExMatch(A_LoopRegName, "(\»)\K(.{10})" , 	ret_exstyle, p0s := 1)
		; Array_wintitleList.push(ret_style . "»" . ret_exstyle . "»" . "µ" . value2)
	; }
; }
iniread, B2PausedColor, 	z.ini, colours, pausedcolour, 69 ; iniread, B2ErrorColor, z.ini, colours, pausedcolour, 106 red
iniread, B2UnPausedColor, 	z.ini, colours, unpausecolour, 69
iniread, BounceCol, 		z.ini, colours, bouncecol, 69
iniread, bounceincdelay, 	z.ini, Bounce, 	bounceincdelay, 195
Ascending 	:= 	1
bouncefade 	:= 	129
; bounceincdelay:= 195
bounceloc := 1
bounceoffloc := 1
;bounceofflocreal:=bounceoffloc+ 31 ;32 -39 top row
bounceendpause := 300
bouncing := 1
updatelights := 0
Brightne55 := Format("100", int*)
n := 1
;Light Array not yet implemented
lights 		:= 	[] 
lights[1] 	:= 	"xSByteFlashPause" 
lights[2] 	:= 	"xSByteFadePlay"
lights[3] 	:= 	"xSByteONNormal"
lights[4] 	:= 	"B2PausedColor"
lights[5] 	:= 	"B2UnPausedColor"
AppVolume("firefox.exe").getmute(twatty) ;AppVolume("firefox.exe").ToggleMute()
AppVolume("firefox.exe").getvolume(awatty2)
cffmute := 1

;settimer, stupid, -1
settimer, bummy, -1

settimer, WMP_CHECK, 4500
;settimer, audioMeter_Timerinit, -1
;settimer, bounce, -1

;Array := {1: ValueA, KeyB: ValueB, ..., KeyZ: ValueZ}

OnExit("Parp")
Parp() {
	iniwrite, %BounceCol% , z.ini , Colours, bouncecol
	sleep 150
	iniwrite, %B2PausedColor% , z.ini , Colours, pausedcolour
	sleep 150
	iniwrite, %B2UnPausedColor% , z.ini, Colours, unpausecolour
	sleep 150
	iniwrite, %bounceincdelay% , z.ini, Bounce, bounceincdelay
	tooltip, byee
	sleep 400
}
return ; DO NOT REMOVE

MidiRules: ; incoming midi filtering
	;_sb 	    := 	mMsg & 0xFF ; EXTRACT THE STATUS BYTE (WHAT KIND OF MIDI MESSAGE IS IT?)t
	;_b1 		:= 	(mMsg >> 8) & 0xFF ; THIS IS DATA1 VALUE = NOTE NUMBER OR CC NUMBER
	;_b2 		:= 	(mMsg >> 16) & 0xFF ; DATA2 VALUE IS NOTE VELEOCITY OR CC VALUE
;	tooltip % _sb "`n" _b1 "`n" _b2 "`n" 
;	msgbox % Rot_Led "`n" byte1 "`n" byte2 "`n" statusbyte 
If (( byte1 = yMaster) && (statusbyte = FaderSByte )) { 	; APC MASTER FADER 176
;volm_old 	:= 	volm_nu
volm_nu 	:= 	(Byte2 - 25)
Soundset, volm_nu ;format("{:g}", (Byte2 * 0.8))  
}


if((byte1=yFaderGroup) && (statusbyte=YfCh8)) {				;		 APC FADER 8 
	WMP_Volnew := (Byte2 - 25) ;)format("{:g}", 

	AppVolume("wmplayer.exe").setVolume(WMP_Volnew)
}



If GUI_Midi_Waiting 
	gosub Supplant_Bytes
	
; if(byte1=16) && (statusbyte=176) { ;CHAN 1 SELECT
	; if channel != 1
	; {
		; traytip CHANNEL CHANGED, CHANNEL CH1 
	; result := Send_WM_COPYDATA("CH1,", GuiScriptTitle)
	; msgbox % channel " but recvd " 
	; }
; }
	
if(byte10ld=23) && (statusbyte=176) { ;CHAN 1 SELECT
 ch :=  1 ;(statusbyte - 175)
	if ch != chold

	{
		niggerdick :=  ("CH" . ch ",cunt")
		Send_WM_COPYDATA(niggerdick, GuiScriptTitle)
		;traytip CHANNEL CHANGED you spastic fucking cunt, CHANNEL %CHANNEL%
		;msgbox % CHANNEL "b2 "byte2 "`nb2o " byte2old "`nb2bo2 " byte2old2 ".`n" CHANNEL " chan change " byte2
	}
	byte2old2 := byte2old
 chold := ch
}

if((byte10ld=23) && (statusbyte BETWEEN 177 and 184)) { ;CHAN 2 - 8 SELECT
 ch :=   (statusbyte - 175)
	if ch != chold
	
	{
		;niggerdick := ("CH" . ch)
		niggerdick :=  ("CH" . ch ",cunt")
Send_WM_COPYDATA(niggerdick, GuiScriptTitle)
		;traytip CHANNEL CHANGED you spastic fucking cunt, CHANNEL %CHANNEL%
		;msgbox % CHANNEL "b2 "byte2 "`nb2o " byte2old "`nb2bo2 " byte2old2 ".`n" CHANNEL " chan change " byte2
	}
	byte2old2 := byte2old
	chold :=   ch
}

if((byte1=102) && (statusbyte=144) && (byte2=127) ) { 
	Active_hwnd := (WinExist("A"))
	wingettitle, Title_last, ahk_id %Active_hwnd%	
	winget PName, ProcessName, ahk_id %Active_hwnd%
	tooltip %  ProcessName PName "`n" Title_last  
	MSGBOX % PName . ", " . Title_last ", " . Active_hwnd
}

if((byte1=103) && (statusbyte=144)) { 		; 		!!!!!!!!!! APC  	BANK 	BUTTON   !!!!!!!!!  ON
	; Bank := True		;		 gui, add, picture, apc40mk2.png,
	; gui, -DPIScale
	; Gui, Color, EEAA99
	; Gui +LastFound  ; Make the GUI window the last found window for use by the line below.	;Gui, Add, Slider, +BackgroundTrans x38 y495 w56 h170 Vertical vMySlider, 50
	; Gui, Add, Picture,x0 y0 w1122 h666 , %apcgui%	; BackgroundTrans
	; Gui, +AlwaysOnTop -SysMenu +ToolWindow +Owner  ; +Owner avoids a taskbar button.	;WinSet, TransColor, EEAA99
	; Gui, Show,x433 y433 w1122 h666 NoActivate, MIDI IN / OUT, 	;WinSet, TransColor, ff00ff 150
	; gui, -Caption 
	; Gui, Color, 22AA99
	if !initblud {
		run, % GUI_Script
		initblud := True
	} else Send_WM_COPYDATA("SHOW", GuiScriptTitle)
}
   
if((byte1=103) && statusbyte=128 && Bank = True) { 		; 		!!!!!!!!!! APC  	BANK 	BUTTON   !!!!!!!!!  OFF
	Bank := False
	Send_WM_COPYDATA("HIDE,", GuiScriptTitle)
}

if (byte1=48) && (statusbyte=176) ; BOUNCE DELAY CH 1 TOP KNOB 
	bounceincdelay := (round((byte2 * 1.83)) +50) ; needs inverting 


if (( byte10ld>47 &&  byte10ld<56 )  && ( statusbyte = 176 )) {	; TOP ROTARY KNOBS and cha1 side|| (byte1>15 && byte1<25))
	gosub p00py ; JUST DO, SOMETHING ....
}
if ( (byte10ld=16 && byte10ld<24)) && ( statusbyte > 176 && statusbyte < 185 ) {	; side   ROTARY KNOBS
	gosub p00py ; JUST DO, SOMETHING ....
}


if (byte1 = yFaderGroup) && (statusbyte = 180 ) {			; APC FADER 5
	rblxVol:=round(Byte2 / 1.23)
	rblxraw:=AppVolume("RobloxPlayerBeta.exe").GetVolume()
	UpperLim := (rblxraw + 20)
	rblxrawnew := round(Byte2 / 1.23)
	if rblxrawnew between 0 and %UpperLim%
	{
		rblxNEW:=Round(rblxrawnew)
		AppVolume("RobloxPlayerBeta.exe").setVolume(rblxNEW)
	} else {
		tooltip, Roblox Volume Attempted Gain diference of +10 Detected		; add a mitigation
		settimer, tooloff, -1000
}	}

if(( byte1 = yFaderGroup ) && ( statusbyte = 181 )) {	
			; APC FADER 6
	Vol_VLC_Raw := AppVolume( VLC )
	Vol_VLC_UpperLim := ( Vol_VLC_Raw + 10 )
	Vol_VLC_New_Raw := ( Byte2 / 1.23 )
	if ( Vol_VLC_New_Raw between 0 and Vol_VLC_UpperLim ) {
		Vol_VLC_New_ := Round(Vol_VLC_New_Raw)
		AppVolume( VLC ).setVolume(Vol_VLC_New_)
	} ; else
		;traytip, VLC Volume, Attempted Gain diference of +10 Detected		; add a mitigation
}

if((byte1=yFaderGroup) && (statusbyte=182)) {			; APC FADER 7 
	BrowserRAW1:=AppVolume("chrome.exe").GetVolume()
	BrowserRAW2:=AppVolume("firefox.exe").GetVolume()
	if BrowserRAW1 {
		if UpperLim1<UpperLim2
			UpperLim := UpperLim1 + 20
	} else 
		UpperLim := BrowserRAW2 + 20
	BrowserNEWRAW := Byte2 / 1.23
	if BrowserNEWRAW between 0 and %UpperLim% 
	{
		BrowserNEW:=Round(BrowserNEWRAW)
		AppVolume("chrome.exe").setVolume(BrowserNEW)
		AppVolume("firefox.exe").setVolume(BrowserNEW)
	} else {
		midiOutShortMsg(h_midiout,144,6,106)
		midiOutShortMsg(h_midiout,133,6,106)
		;traytip, Browser Volume, Attempted Gain diference of +10 Detected		; add a mitigation
}	}
	;WMPVol := round(Byte2 * 0.77)

if((byte1=13) && (statusbyte=176) && (byte2= 1) && (editch8=1)) { ; APC Tempo Knob
	tooltip, Edit me
	return
}

if((byte1=xCh8) && (Byte2=127) && (statusbyte=144) && (Bank=1)) {		
	tooltip, Edit me
	editch8 := 1
	return
}

if((byte1=xCh8) && (Byte2=127) && (statusbyte=144) && (Bank=1) && (editch8=1)) {
	tooltip, % n " cunt"
	return
}

if((byte1=19) && (StatusByte=184) && (editch8=1)) {
	%lightsvar% := %Byte2%
	tooltip %lightsvar% = %Byte2%
	settimer, tooloff, 1000
	gosub update_lights
	return
}

if((byte1=52) && (byte2=127) && (StatusByte=150) && (CFFMute=1)) {
	AppVolume("firefox.exe").GetVolume()
	AppVolume("chrome.exe").ToggleMute()
	AppVolume("firefox.exe").ToggleMute()
	CFFMute:=2 
	AppVolume("firefox.exe").getmute()
	tooltip, %bmute% a %fLevel%
	settimer, tooloff, 1000
	gosub update_lights
	return
}

if((byte1=52) && (byte2=127) && (StatusByte=150) && (CFFMute=2)) {
	AppVolume("chrome.exe").ToggleMute()
	AppVolume("firefox.exe").ToggleMute()
	CFFMute=1
	AppVolume("firefox.exe").getmute()
	tooltip, %bmute% b
	settimer, tooloff, 1000
	gosub update_lights
	return
}

if((byte1=94) && (Byte2=127) && (statusbyte=144)) { ; BANK SELECT UP
	Process, Exist, slsk2.exe
	if !ErrorLevel
		tooltip, error slsk not open
	else
		run WMP_SLSK.ahk
	settimer, tooloff, 1000

}
;if (byte1=94) && (Byte2=127) && (statusbyte=144) && (Bankmode=1)
if((byte1=96) && (statusbyte=144)) { ; BANK SELECT RIGHT
	;Process, Exist, wmplayer.exe
	settimer, WMP_NEXT
	return
}

if((byte1=97) && (statusbyte=144)) { ; BANK SELECT LEFT
	GoSub WMP_Prev
	Return
}

if((byte1=95) && (statusbyte=144)) { ; BANK SELECT DOWN
	run wmp_cut.ahk ;cut mp3 to clipboard
}

if ( (statusbyte=151) && (Byte2=127) && (Bank =0) ) {
	if (Process, Exist, "wmplayer.exe") {
		ControlSend , ,^p, Windows Media Player
		sleep, 100
		gosub, WMP_CHECK
		gosub,  update_lights
	}
}

if ( (statusbyte=151) && (Byte2=127) && (Bank =1) ) { ; DELETE currently playing file WMP
	gosub WMP_Del
	msgbox deleting current
}

if (updatelights=1) {
	;`ip 4546463636
	updatelights:=0
}

if ( (statusbyte=FaderSByte) && (Byte1=55) ) {
	Byte2_50:=round((Byte2 / 123)+1)
	wmp.SetRate(Byte2_50)
}
/* 
if (byte1=16) && (StatusByte in %yfads%) && (bank=1) ; finder
{
tooltip %Mnote%
Mnoteold=% mnote
Mnote := byte2
midiOutShortMsg(h_midiout, Sbyte, mnoteold, 0)
settimer, rainbow, 150
return
}
 */
  
;bowcol=1 ; what is this?

if ( (byte1=16) && (StatusByte=184) && (bank=1) ) { ; AEROGLASS TRANS
	sendmessage, 0x0422, , round(Byte2 / 1.23), msctls_trackbar327, Aero Glass for Win8.x+
	return
}

if ( (byte1=17) && (StatusByte=184) && (bank=1) ) { ; AEROGLASS REFLECTION

	sendmessage, 0x0422, , round(Byte2 / 1.23), msctls_trackbar321, Aero Glass for Win8.x+
	return
}

if ( (byte1=18) && (StatusByte=184) && (bank=1) ) { ; AEROGLASS REFLECTION
	sendmessage, 0x0422, , round(Byte2 / 1.23), msctls_trackbar322, Aero Glass for Win8.x+
	return
}


;XFADE STUFF

if ((statusbyte=XfCh8) && (Byte2=1)) {
	test1:=1
	xFadeLeftOld:=xFadeLeft
	xFadeLeft=8 
	if xfaderight=8
	xFadeRight:=xFadeRightOld
}

if ( (statusbyte=XfCh7) && (Byte2=1) ) {
	xFadeLeftOld:=xFadeLeft
	xFadeLeft=7
	if xfaderight=7
	xFadeRight:=xFadeRightOld
}

if ((statusbyte=XfCh6) && (Byte2=1) ) {
	xFadeLeftOld:=xFadeLeft
	xFadeLeft=6
	if xfaderight=6
	xFadeRight:=xFadeRightOld
}

if (statusbyte=XfCh5) && (Byte2=1)
	xfadeleft=5 
else
if (statusbyte=XfCh4) && (Byte2=1)
	xfadeleft=4 
else
if (statusbyte=XfCh3) && (Byte2=1)
	xfadeleft=3 
else
if (statusbyte=XfCh2) && (Byte2=1)
	xfadeleft=2
else
if (statusbyte=XfCh1) && (Byte2=1)
	xfadeleft=1 
else
if (statusbyte=XfCh8) && (Byte2=2)
{
	test1:=1
	xFadeRightOld:=xFadeRight
	xFadeRight=8 
	if xfadeLeft=8
	xFadeLeft:=xFadeLOld
}

if (statusbyte=XfCh7) && (Byte2=2)
{
	xFadeRightOld:=xFadeRight
	xFadeRight=7
	if xfadeLeft=7
	xFadeLeft:=xFadeLOld
}

if (statusbyte=XfCh6) && (Byte2=2)
{
	xFadeRightOld:=xFadeRight
	xFadeRight=6
	if xfadeLeft=6
		xFadeLeft:=xFadeLOld
} 

if (statusbyte=XfCh5) && (Byte2=2)
	if xfaderight !=0
		xfaderightold:=xfaderight
if xfadeleft=5
{
	xfaderight=5 
	xfadeleft:=xfadeLeftOld
}

if (statusbyte=XfCh4) && (Byte2=2)
	xfaderight=4 
if (statusbyte=XfCh3) && (Byte2=2)
	xfaderight=3 
if (statusbyte=XfCh2) && (Byte2=2)
	xfaderight=2
if (statusbyte=XfCh1) && (Byte2=2)
	xfaderight=1 

if (StatusByte=XfCh8Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	test1:=0
	traytip, X-FADER, Channel Unassigned
}

if (StatusByte=XfCh7Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	traytip, X-FADER, Channel Unassigned
	test1:=0
}

if (StatusByte=XfCh6Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	traytip, X-FADER, Channel Unassigned
	test1:=0
}

if (StatusByte=XfCh5Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	traytip, X-FADER, Channel Unassigned
	test1:=0
}

if (StatusByte=XfCh4Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	traytip, X-FADER, Channel Unassigned
	test1:=0
}

if (StatusByte=XfCh3Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	traytip, X-FADER, Channel Unassigned'
	test1:=0
}

if (StatusByte=XfCh2Off) && (Byte2=0) && (Byte1=XfadeB1)
;traytip, X-FADER, Channel Unassigned
	test1:=0

if (StatusByte=XfCh1Off) && (Byte2=0) && (Byte1=XfadeB1) ;traytip, X-FADER, Channel Unassigned
	test1:=

;68 0 135 0 135 CH8 XFADE OFF 1 151CH8XFADE A 2 151 CH8XFADEB

/* 
if (byte1=XFader) && (statusbyte=FaderSByte) && (xFadeRight=8) && (test1=1)
{
WMPSumval:=round((WMPVol * round(Byte2 / 1.23)) /30)
AppVolume("wmplayer.exe").setVolume(WMPSumval)
}

if (byte1=XFader) && (statusbyte=FaderSByte) && (xFadeLeft=8) && (test1=1)
{
WMPSumval:= (WMPVol * (100 - round(Byte2 / 1.23)))/301XG+
AppVolume("wmplayer.exe").setVolume(WMPSumval)
}
 */
; if ( (byte1 = 19) && (statusbyte = 184) ) {
		; TOOLTIP % "display`nbrightness`n" (BP := (0.787 * byte2))
		; SetDisplayBrightness(BP) 
; }

if ( (byte1=XFader) && (statusbyte=FaderSByte) && (xFadeRight=8) && (test1=1) )
{
	Master_Volume := round(round(Byte2 / 1.23)*2)
	soundset, master_volume	;AppVolume("wmplayer.exe").setVolume(WMPSumval)
}

if ( (byte1 = XFader) && (statusbyte = FaderSByte) && (xFadeLeft = 8) && (test1 = 1) ) {
	Soundget, wmpvol1
	fadpos1 := round(50-((Byte2 / 1.23)/2))
	master_volume_new := 100*(wmpvol1 / fadpos1)
	soundset, master_volume_new	;AppVolume("wmplayer.exe").setVolume(WMPSumval)
}

if((byte1=XFader) && (statusbyte=FaderSByte) && (xFadeRight=7)) {
	CFFSumval:=round((BrowserVol * round(Byte2 / 1.23)) /100)
	AppVolume("chrome.exe").setVolume(CFFSumval)
	AppVolume("firefox.exe").setVolume(CFFSumval)
}

if((byte1=15) && (statusbyte=FaderSByte) && (xFadeLeft=7)) {
	wmpcall := 1, CFFSumval := (100 - round((BrowserVol * round(Byte2 / 1.23)) /100))
	AppVolume("firefox.exe").setVolume(CFFSumval)
	AppVolume("chrome.exe").setVolume(CFFSumval)
}

if((byte1=XFader) && (statusbyte=FaderSByte) && (!test1)) { 
	settimer, Xfade_Transport_main, -1	;tt( Desired:%desired%`nCurrent:%current%`nsum %net_jump%`nTotal :%Duration%,4000,2000
}

if((byte1=65) && (byte2=127) && (statusbyte=128) && (bank=1)) {
	tooltip, test
}

;-========================================================================= END XFADE SECT.+++++


if ( (byte1=64) && (byte2=127) && (statusbyte=144) ) ; CLIP DEV VIEW
{
	gosub midi_debug_tt
}


/* HAPPY ATM
if (byte1=49) && (statusbyte=176) ; BOUNCE COLOUR CH 2 TOP KNOB 
	{
	BounceCol := byte2 ;
	}

 */
;ahk_pid 16612; FFToolTip(Text:="", X:="", Y:="", WhichToolTip:=1)

return

;#Space:: wmp.jump(90)ight
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! no edit below here ....
; don't edit or read this part!
MidiMsgDetect(hInput, midiMsg, wMsg) ; Midi input section in "under the hood" calls this function each time a midi message is received. Then the midi message is broken up into parts for manipulation. See http://www.midi.org/techspecs/midimessages.php (decimal values).
{
;msgbox % hInput "`n" midiMsg "`n" wMsg "`n" 
	global statusbyte, chan, note, cc, byte1, byte2
	statusbyte 	:= 	midiMsg & 0xFF ; EXTRACT THE STATUS BYTE (WHAT KIND OF MIDI MESSAGE IS IT?)t
	byte1 		:= 	(midiMsg >> 8) & 0xFF ; THIS IS DATA1 VALUE = NOTE NUMBER OR CC NUMBER
	byte2 		:= 	(midiMsg >> 16) & 0xFF ; DATA2 VALUE IS NOTE VELEOCITY OR CC VALUE
	sbyte0ld 	:= 	statusbyte
	byte10ld 	:= 	byte1
	byte20ld 	:= 	byte2
	mmsg 		:= 	midiMsg
	wwmsg		:= 	wMsg
	gosub, MidiRules ; run the subroutine below
} ; end of MidiMsgDetect funciton
return


; =============== filters/rules subroutine tests
if byte1 
	Menu, Tray, Icon, akaiapc_322.ico
else 
	Menu, Tray, Icon, akaiapc_32.ico
; ========================= end ============================

; =============== Send midi output data =============================
; Red Pulse top row	;	Note 32 - 39

SendNote: ;(h_midiout,Note) ; send out note messages ; this should probably be a funciton but... eh.
note = %byte1% ; this var is added to allow transpostion of a note
return

update_lights:
{
	if (Pstate_answer = 3)	{
		;midiOutShortMsg(h_midiout, xSByteONNormal, xCh8, B2UnPausedColor)
		;midiOutShortMsg(h_midiout, xSByteFadePlay, xCh8, B2UnPausedColor)
		return
	}
	if ((pstate_answer = 2) or (pstate_answer = 1)) {
		;midiOutShortMsg(h_midiout, xSByteONNormal, xCh8, B2PausedColor)
		;midiOutShortMsg(h_midiout, xSByteFlashPause, xCh8, B2PausedColor)
		return
	}

	if (CFFMute=2) {
		midiOutShortMsg(h_midiout, xSByteONNormal, xCh7, B2UnPausedColor)
		midiOutShortMsg(h_midiout, xSByteFadePlay, xCh7, B2UnPausedColor)
		return
	}
	if CFFMute=1 
	{
		midiOutShortMsg(h_midiout, xSByteONNormal, xCh7, B2PausedColor)
		midiOutShortMsg(h_midiout, xSByteFlashPause, xCh7, B2PausedColor)
		return
	}
}
exit

WMP_CHECK:
if !WMP
	wmp := new RemoteWMP
wmp.pstate()
try
{
	controls := wmp.player.controls
	media := wmp.player.currentMedia
	asong := media.getItemInfo("Title")
}
Catch e
{
	tooltip,% "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
	 . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
	loop 10
		sleep 20,
	tooltip,
}
return


ToolTip_Off: 	
ToolTip,
settimer, ToolTip_Off, off
return

WMP_Prev:
ControlSend , ,^b, Windows Media Player 
sleep 300
wmp := new RemoteWMP
media := wmp.player.currentMedia
controls := wmp.player.controls
return

WMP_Del: 
if !wmp
	gosub WMP_CHECK
wmp2del := new RemoteWMP
media2del := wmp.player.currentMedia
gosub wmp_next

;iniwrite, % media2del, Deletions.ini, yep_gone
;wmp2del.delete
try 
	File2Del= % media2del.sourceURL
catch
	gosub WMP_Del
FileRecycle, % File2Del
;F2dName := RegExReplace(File2Del, "^.+\\|\.[^.]+$")
tooltip, Deleted
settimer, ToolTip_Off, -5000 
return

;PUT STUFF HERE to run initally

^#w::
SoundGet, penises
tooltip % penises
penises:=
return

#^r::
bounce:
if !bouncingthen {
	Global bouncingthen:=1
	settimer, bouncing_on, -1
} else bouncingthen:=
Return

bouncing_on:
global bounceloc=0
global bounceoffloc=0
global bouncelocreal:=bounceloc + 31
global bounceofflocreal=% bouncelocreal
if bouncingthen
settimer, cunt, 10
return

cunt:
Loop 7	{
	bounceincdelay := bounceincdelay - 10
	if !fagto {
		fagto := true
		bouncelocreal:=bounceloc + 32
		bounceofflocreal:=bounceoffloc + 32
	} else {
		bouncelocreal:=bounceloc + 31
		bounceofflocreal:=bounceoffloc + 31
	}
	midiOutShortMsg(h_midiout, 144, bouncelocreal, BounceCol)
	sleep, bounceincdelay
	bounceloc := bounceloc + 1
	bounceofflocreal:=bouncelocreal -1
	if !fagto3
		global fagto3 := true
	else
		midiOutShortMsg(h_midiout, 132, bounceofflocreal, BounceCol)
	;bounceoffloc := bounceoffloc + 1
}
Loop 7 { 
	bounceincdelay := bounceincdelay + 10
	fagto := false
	bouncelocreal:=bounceloc + 31
	bounceofflocreal:=bounceoffloc + 31
	midiOutShortMsg(h_midiout, 144, bouncelocreal, fun)
	sleep, bounceincdelay
	bounceloc := bounceloc - 1
	bounceofflocreal:=bouncelocreal +1
	;bounceoffloc := bounceloc
	midiOutShortMsg(h_midiout, 130, bounceofflocreal, BounceCol)
	;bounceoffloc := bounceoffloc - 1
}
return

#t::
NoteVel := NoteVel - 1
tooltip % NoteVel
midiOutShortMsg(h_midiout, Sbyte, Mnote, NoteVel)
settimer, tooloff, 1000
return

#y::
NoteVel := NoteVel + 1
tooltip % NoteVel
settimer, tooloff, 1000
midiOutShortMsg(h_midiout, Sbyte, mnote, NoteVel)
return

#h::
Sbyte := Sbyte - 1
tooltip % Sbyte
midiOutShortMsg(h_midiout, Sbyte, mnote, NoteVel)
settimer, tooloff, 1000
return

+#w::
lights_all_on:
settimer allon, 1
return

#Q::
lights_all_off:
settimer alloff, 1
return

alloff: 
if !counta {
	counta := 1, mnote := -200
}
else counta := counta + 1
if counta = 400
{
	counta := ""
	settimer alloff, off
}
midiOutShortMsg(h_midiout, 128, mnote, 144) ;  128 on 144 off
mnote := mnote + 1 ; led position on device
return 

allon:
if !counta {
	counta := 1, mnote := -200
}
else counta := counta + 1
if counta = 400
{
	counta := ""
	settimer allon, off
}
midiOutShortMsg(h_midiout, 144, mnote, 120) ;  128 on 144 off
mnote := mnote + 1 ; led position on device
return 

#j::
Sbyte := Sbyte + 1
midiOutShortMsg(h_midiout, Sbyte, mnote, NoteVel)
return

#k::
audioMeter_Timerinit:
audioMeter := VA_GetAudioMeter()
VA_IAudioMeterInformation_GetMeteringChannelCount(audioMeter, channelCount)
VA_GetDevicePeriod("capture", devicePeriod)
VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue) 
zz:=5
settimer, AudioMeterTimer, % zz
return
AudioMeterTimer:
;Sleep, %devicePeriod%
VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue)	;tooltip % peakValue "`n" volpeak
if (peakValue == 0) { 	
	if (volpeak 	!= 0) {
		if volpeak == 5
			midiOutShortMsg(h_midiout, 132, 84, 69)
		if (volpeak > 	4) {		
			midiOutShortMsg(h_midiout, 132, 84, 69)
			midiOutShortMsg(h_midiout, 130, 82, 69)
		}
		if (volpeak > 	3) {
			midiOutShortMsg(h_midiout, 132, 84, 69)
			midiOutShortMsg(h_midiout, 131, 83, 69)
		}
		if volpeak 	> 	2	
			midiOutShortMsg(h_midiout, 132, 84, 69) 
		if volpeak 	> 	1
			midiOutShortMsg(h_midiout, 132, 85, 69)
		midiOutShortMsg(h_midiout, 132, 84, 69)
		midiOutShortMsg(h_midiout, 132, 86, 69)
	volpeak 		:= 0
	}
} else if (peakValue > 0.01 and peakValue < 0.2) {
	if volpeak 		> 	5	
		midiOutShortMsg(h_midiout, 130, 82, 69)
	if (volpeak 	> 	4)
		midiOutShortMsg(h_midiout, 130, 82, 69)
	if (volpeak 	> 	3) {
		midiOutShortMsg(h_midiout, 132, 84, 69)
		midiOutShortMsg(h_midiout, 131, 83, 69)
	}
	if (volpeak 	> 	2) {
		midiOutShortMsg(h_midiout, 132, 84, 69)
		midiOutShortMsg(h_midiout, 132, 84, 69)
	}	
	if volpeak 	> 	0
		midiOutShortMsg(h_midiout, 132, 85, 69)
	midiOutShortMsg(h_midiout, 144, 86, 42)
	volpeak 		:= 1
} else if ((peakValue > 0.19) and (peakValue < 0.4)) {
	if volpeak 		> 	3
		midiOutShortMsg(h_midiout, 130, 82, 69)
	if volpeak 		> 2
		midiOutShortMsg(h_midiout, 131, 83, 69)
	if (volpeak 	> 1) {
		midiOutShortMsg(h_midiout, 144, 85, 41)
		midiOutShortMsg(h_midiout, 132, 84, 69)
	} 
	midiOutShortMsg(h_midiout, 144, 85, 42)
	midiOutShortMsg(h_midiout, 144, 86, 41)
	volpeak 	:= 	2
} else if ((peakValue > 0.39) and (peakValue < 0.6)) {
	if (volpeak 	> 	4) {
		midiOutShortMsg(h_midiout, 130, 82, 69)
		midiOutShortMsg(h_midiout, 144, 86, 41)
	}  
	if (volpeak 	> 	3) 
		midiOutShortMsg(h_midiout, 132, 83, 69)
	midiOutShortMsg(h_midiout, 144, 85, 41)
	midiOutShortMsg(h_midiout, 144, 84, 79)
	volpeak 		:= 	3
} else if ((peakValue > 0.59) and (peakValue < 0.8)) {
	midiOutShortMsg(h_midiout, 144, 86, 79)
	if (volpeak 	> 	4) {
		midiOutShortMsg(h_midiout, 144, 85, 104)
		bouncecol 	:= 69
	}
	else bouncecol 	:= 79
	midiOutShortMsg(h_midiout, 144, 85, 79)
	midiOutShortMsg(h_midiout, 144, 84, 79)
	midiOutShortMsg(h_midiout, 144, 83, 79)	
	if volpeak > 4
		midiOutShortMsg(h_midiout, 130, 82, 79)
	volpeak := 4
} else if (peakValue > 0.79 and peakValue < 1.01) {
	if (volpeak = 5) {
		midiOutShortMsg(h_midiout, 144, 86, 79)
		midiOutShortMsg(h_midiout, 144, 84, 104)
		midiOutShortMsg(h_midiout, 144, 85, 79)
		midiOutShortMsg(h_midiout, 144, 83, 69)
		bouncecol := 69
	}
	else bouncecol := 79
	midiOutShortMsg(h_midiout, 144, 82, 69)
	volpeak := 5
}
return

#b::
Mnote := Mnote - 1
tooltip % mnote
midiOutShortMsg(h_midiout, Sbyte, Mnote, NoteVel)
seTtimer, tooloff, -2000
return

#n:: ;find midi note indexed position fpr desired light
tooltip % mnote
Mnote := Mnote + 1
midiOutShortMsg(h_midiout, Sbyte, mnote, NoteVel)
setTimer, tooloff, -2000
return

^p::
fun:=fun+1
return

#!t::
DBGTT := !DBGTT
if DBGTT
	settimer, midi_debug_tt, 750,,,2
return

old2new:
asongold =% asong
return

Song_Compare:
{
	if (asong=asongold)
	{
		a:=a
		;tooltip, nochange song,-100,-100,2
	}
	if (asong!=asongold)
	{
		gosub old2new
		Pstate_answer_old=% Pstate_answer
		;tooltip, upd8s0ng,-100,-100,2
		updatelights=1
		gosub update_lights
	}

	if (pstate_answer=pstate_answer_old)
		a:=a

	if (pstate_answer!=pstate_answer_old)
	{
		gosub old2new
		Pstate_answer_old=% Pstate_answer
		;tooltip, change pstate,400,300,5
		updatelights=1
		gosub update_lights
			return
	}
	return
}

midi_debug_tt:
testa=%byte2% + %byte1% + %statusbyte%
sleep 50
ifnotequal, testa, (%byte2% + %byte1% + %statusbyte%)
{
	Menu, Tray, Icon, akaiapc_322.ico
	ToolTip, lParam = %mmsg% `n %channel% `n byte1 = %byte1% %byte10ld% `nbyte2 = %byte2% %byte20ld% `nstatusbyte = %statusbyte% %sbyte0ld% %wMsg% `nBank = %Bank% `nMaster volume %master_volume%
	 , 4000, 2000, 8
	sleep 50
	testa:=(%byte2% + %byte1% + %statusbyte%)
} else {
	Menu, Tray, Icon, akaiapc_32.ico
	ToolTip,
}
Return

;iniRead, playstateini, wmp.ini, status
;midiOutShortMsg(h_midiout, statusbyte, note, byte2) ; call the midi funcitons with these params.

SendCC: ; not sure i actually did anything changing cc's here but it is possible.
midiOutShortMsg(h_midiout, statusbyte, cc, byte2)

Return

SendPC:

Return


;******************************************** midi "under the hood" *********************************************
/*
*/

MidiPortRefresh: ; get the list of ports
MIlist := MidiInsList(NumPorts)
Loop Parse, MIlist, |
{
}
TheChoice := MidiInDevice + 1

MOlist := MidiOutsList(NumPorts2)
Loop Parse, MOlist, |
{
}
TheChoice2 := MidiOutDevice + 1
return

;-----------------------------------------------------------------

ReadIni() ; also set up the tray Menu
{
	;Menu, tray, add, MidiSet ; set midi ports tray item
	;Menu, tray, add, ResetAll ; Delete the ini file for testing --------------------------------
	global MidiInDevice, MidiOutDevice, version ; version var is set at the beginning.
	IfExist, %version%io.ini
	{
		IniRead, MidiInDevice, %version%io.ini, Settings, MidiInDevice , %MidiInDevice% ; read the midi In port from ini file
		IniRead, MidiOutDevice, %version%io.ini, Settings, MidiOutDevice , %MidiOutDevice% ; read the midi out port from ini file
		if (midiInDevice=0) && (midiOutDevice=1)
			01=1
		else 
			01=0
		if (midiInDevice=1) && (midiOutDevice=2)
			12=1
		else 
			12=0
		if (midiInDevice=2) && (midiOutDevice=3)
			23=1
		else 
			23=0
		if (midiInDevice=3) && (midiOutDevice=4)
			34=1
		else 
			(global34=0)
		if (midiInDevice=4) && (midiOutDevice=5)
			(45=1) 
		else 
			(45=0)
	} else {		 ; no ini exists and this is either the first run or reset settings.
		MsgBox, 1, No ini file found, Select midi ports.
		ExitApp
	}
}

;CALLED TO UPDATE INI WHENEVER SAVED PARAMETERS CHANGE
WriteIni()
{
	global MidiInDevice, MidiOutDevice, version
	IfNotExist, %version%io.ini ; if no ini
	FileAppend,, %version%io.ini ; make one with the following entries.
	;IniWrite, %MidiInDevice%, %version%io.ini, Settings, MidiInDevice
	;IniWrite, %MidiOutDevice%, %version%io.ini, Settings, MidiOutDevice
}

;------------ port testing to make sure selected midi port is valid --------------------------------

port_test(numports,numports2) ; confirm selected ports exist ; CLEAN THIS UP STILL
{
	global midiInDevice, midiOutDevice, midiok
	; ----- In port selection test based on numports
	If MidiInDevice not Between 0 and %numports%
	{
		MidiIn := 0 ; this var is just to show if there is an error - set if the ports are valid = 1, invalid = 0
		;MsgBox, 0, , midi in port Error ; (this is left only for testing)
		If (MidiInDevice = "") ; if there is no midi in device
		MidiInerr = Midi In Port EMPTY. ; set this var = error message
		;MsgBox, 0, , midi in port EMPTY
		If (midiInDevice > %numports%) ; if greater than the number of ports on the system.
		MidiInnerr = Midi In Port Invalid. ; set this error message
		traytip, MIDI-IN Error, midi out port out of range, ,32
	}
	else
		MidiIn := 1 ; setting var to non-error state or valid
	; ----- out port selection test based on numports2
	If MidiOutDevice not Between 0 and %numports2%
	{
		MidiOut := 0 ; set var to 0 as Error state.
		If (MidiOutDevice = "") ; if blank
		MidiOutErr = Midi Out Port EMPTY. ; set this error message
		;MsgBox, 0, , midi o port EMPTY
		If (midiOutDevice > %numports2%) ; if greater than number of availble ports
		MidiOutErr = Midi Out Port Out Invalid. ; set this error message
		traytip, MIDI-OUT Error, midi out port out of range, ,32
	}
	else
	{
		MidiOut := 1 ;set var to 1 as valid state.
	}
	; ---- test to see if ports valid, if either invalid load the gui to select.
	;midicheck(MCUin,MCUout)
	If (%MidiIn% = 0) Or (%MidiOut% = 0)
	{
		MsgBox, 49, Midi Port Error!,%MidiInerr%`n%MidiOutErr%`n`nLaunch Midi Port Selection!
		ExitApp
	}
	else
	{
		midiok = 1
		Return ; DO NOTHING - PERHAPS DO THE NOT TEST INSTEAD ABOVE.
	}
}
Return

; ------------------ end of port testing ---------------------------

;MidiSet: ; midi port selection gui

; ------------- MIDI INPUT SELECTION -----------------------
;Gui, Destroy
;Gosub, Suspendit
;Gui, 6: Destroy
;Gui, 2: Destroy
;Gui, 3: Destroy
;Gui, 4: Destroy
;Gui, 5: Destroy
;Gui, 4: +LastFound +AlwaysOnTop +Caption +ToolWindow ;-SysMenu
;Gui, 4: Font, s12
;Gui, 4: add, text, x10 y10 w300 cmaroon, Select Midi Ports. ; Text title
;Gui, 4: Font, s8
;Gui, 4: Add, Text, x10 y+10 w175 Center , Midi In Port ;Just text label
;Gui, 4: font, s8
; midi ins list box
;Gui, 4: Add, ListBox, x10 w200 h100 Choose%TheChoice% vMidiInPort gDoneInChange AltSubmit, %MiList% ; --- midi in listing of ports
;Gui, Add, DropDownList, x10 w200 h120 Choose%TheChoice% vMidiInPort gDoneInChange altsubmit, %MiList% ; ( you may prefer this style, may need tweak)

; --------------- MidiOutSet ---------------------



;-----------------gui done change stuff - see label in both gui listbox line

; ********************** Midi output detection

MidiOut: ; Function to load new settings from midi out menu item
OpenCloseMidiAPI()
h_midiout := midiOutOpen(MidiOutDevice) ; OUTPUT PORT 1 SEE BELOW FOR PORT 2
return

ResetAll: ; for development only, leaving this in for a program reset if needed by user
MsgBox, 33, %version% - Reset All?, This will delete ALL settings`, and restart this program!
IfMsgBox, OK
{
	FileDelete, %version%io.ini ; delete the ini file to reset ports, probably a better way to do this ...
	Reload ; restart the app.
}
IfMsgBox, Cancel
Return

GuiClose: ; on x exit app
Suspend, Permit ; allow Exit to work Paused. I just added this yesterday 3.16.09 Can now quit when Paused.

MsgBox, 4, Exit %version%, Exit %version% %ver%? ;
IfMsgBox No
Return
else IfMsgBox Yes
midiOutClose(h_midiout)

;winclose, Midi_in_2 ;close the midi in 2 ahk file
ExitApp


;############################################## MIDI LIB from orbik and lazslo#############
;-------- orbiks midi input code --------------
; Set up midi input and callback_window based on the ini file above.
; This code copied from ahk forum Orbik's post on midi input

; nothing below here to edit.

; =============== midi in =====================

Midiin_go:
DeviceID := MidiInDevice ; midiindevice from IniRead above assigned to deviceid
CALLBACK_WINDOW := 0x10000 ; from orbiks code for midi input

Gui, +LastFound ; set up the window for midi data to arrive.
hWnd := WinExist() ;MsgBox, 32, , line 176 - mcu-input is := %MidiInDevice% , 3 ; this is just a test to show midi device selection

hMidiIn =
VarSetCapacity(hMidiIn, 4, 0)
result := DllCall("winmm.dll\midiInOpen", UInt,&hMidiIn, UInt,DeviceID, UInt,hWnd, UInt,0, UInt,CALLBACK_WINDOW, "UInt")
If result
{
	return
}

hMidiIn := NumGet(hMidiIn) ; because midiInOpen writes the value in 32 bit binary Number, AHK stores it as a string
result := DllCall("winmm.dll\midiInStart", UInt,hMidiIn)
If result
{
	MsgBox, Error, midiInStart Returned %result%`nRight Click on the Tray Icon - Left click on MidiSet to select valid midi_in port.
	ExitApp
}

OpenCloseMidiAPI()

; ----- the OnMessage listeners ----

; #define MM_MIM_OPEN 0x3C1 /* MIDI input */
; #define MM_MIM_CLOSE 0x3C2
; #define MM_MIM_DATA 0x3C3
; #define MM_MIM_LONGDATA 0x3C4
; #define MM_MIM_ERROR 0x3C5
; #define MM_MIM_LONGERROR 0x3C6

OnMessage(0x3C1, "MidiMsgDetect") ; calling the function MidiMsgDetect in get_midi_in.ahk
OnMessage(0x3C2, "MidiMsgDetect")
OnMessage(0x3C3, "MidiMsgDetect")
OnMessage(0x3C4, "MidiMsgDetect")
OnMessage(0x3C5, "MidiMsgDetect")
OnMessage(0x3C6, "MidiMsgDetect")
Menu, Tray, Icon, akaiapc_32.ico
Return

;--- MIDI INS LIST FUNCTIONS - port handling -----

MidiInsList(ByRef NumPorts)
{ ; Returns a "|"-separated list of midi output devices
	local List, MidiInCaps, PortName, result
	VarSetCapacity(MidiInCaps, 50, 0)
	VarSetCapacity(PortName, 32) ; PortNameSize 32

	NumPorts := DllCall("winmm.dll\midiInGetNumDevs") ; #midi output devices on system, First device ID = 0

	Loop %NumPorts%
	{
		result := DllCall("winmm.dll\midiInGetDevCapsA", UInt,A_Index-1, UInt,&MidiInCaps, UInt,50, UInt)
		If (result OR ErrorLevel) {
			List .= "|-Error-"
			Continue
		}
		DllCall("RtlMoveMemory", Str,PortName, UInt,&MidiInCaps+8, UInt,32) ; PortNameOffset 8, PortNameSize 32
		List .= "|" PortName
	}
	Return SubStr(List,2)
}

MidiInGetNumDevs() { ; Get number of midi output devices on system, first device has an ID of 0
	Return DllCall("winmm.dll\midiInGetNumDevs")
}

MidiInNameGet(uDeviceID = 0) { ; Get name of a midiOut device for a given ID
	;MIDIOUTCAPS struct
	; WORD wMid;
	; WORD wPid;
	; MMVERSION vDriverVersion;
	; CHAR szPname[MAXPNAMELEN];
	; WORD wTechnology;
	; WORD wVoices;
	; WORD wNotes;
	; WORD wChannelMask;
	; DWORD dwSupport;
	VarSetCapacity(MidiInCaps, 50, 0) ; allows for szPname to be 32 bytes
	OffsettoPortName := 8, PortNameSize := 32
	result := DllCall("winmm.dll\midiInGetDevCapsA", UInt,uDeviceID, UInt,&MidiInCaps, UInt,50, UInt)
	If (result OR ErrorLevel) {
		MsgBox Error %result% (ErrorLevel = %ErrorLevel%) in retrieving the name of midi Input %deviceID%
		Return -1
	}
	VarSetCapacity(PortName, PortNameSize)
	DllCall("RtlMoveMemory", Str,PortName, Uint,&MidiInCaps+OffsettoPortName, Uint,PortNameSize)
	Return PortName
}

MidiInsEnumerate() { ; Returns number of midi output devices, creates global array MidiOutPortName with their names
	local NumPorts, PortID
	MidiInPortName =
	NumPorts := MidiInGetNumDevs()

	Loop %NumPorts% {
		PortID := A_Index -1
		MidiInPortName%PortID% := MidiInNameGet(PortID)
	}
	Return NumPorts
}

; =============== end of midi selection stuff

MidiOutsList(ByRef NumPorts)
{ ; Returns a "|"-separated list of midi output devices
	local List, MidiOutCaps, PortName, result
	VarSetCapacity(MidiOutCaps, 50, 0)
	VarSetCapacity(PortName, 32) ; PortNameSize 32

	NumPorts := DllCall("winmm.dll\midiOutGetNumDevs") ; #midi output devices on system, First device ID = 0

	Loop %NumPorts%
	{
		result := DllCall("winmm.dll\midiOutGetDevCapsA", UInt,A_Index-1, UInt,&MidiOutCaps, UInt,50, UInt)
		If (result OR ErrorLevel) {
			List .= "|-Error-"
			Continue
		}
		DllCall("RtlMoveMemory", Str,PortName, UInt,&MidiOutCaps+8, UInt,32) ; PortNameOffset 8, PortNameSize 32
		List .= "|" PortName
	}
	Return SubStr(List,2)
}
;---------------------midiOut from TomB and Lazslo and JimF --------------------------------

;THATS THE END OF MY STUFF (JimF) THE REST ID WHAT LASZLo AND PAXOPHONE WERE USING ALREADY
;AHK FUNCTIONS FOR MIDI OUTPUT - calling winmm.dll
;http://msdn.microsoft.com/library/default.asp?url=/library/en-us/multimed/htm/_win32_multimedia_functions.asp
;Derived from Midi.ahk dated 29 August 2008 - streaming support removed - (JimF)


OpenCloseMidiAPI() { ; at the beginning to load, at the end to unload winmm.dll
	static hModule
	If hModule
	DllCall("FreeLibrary", UInt,hModule), hModule := ""
	If (0 = hModule := DllCall("LoadLibrary",Str,"winmm.dll")) {
		MsgBox Cannot load libray winmm.dll
		Exit
	}
}

;FUNCTIONS FOR SENDING SHORT MESSAGES

midiOutOpen(uDeviceID = 0) {		 ; Open midi port for sending individual midi messages --> handle
	strh_midiout = 0000
	result := DllCall("winmm.dll\midiOutOpen", UInt,&strh_midiout, UInt,uDeviceID, UInt,0, UInt,0, UInt,0, UInt)
	If (result or ErrorLevel) {
		;run error_tooltip.ahk
		traytip, MIDI ERROR, UNABLE TO OPEN OUTPORT, 32
		sleep 2000
		gosub, midiout
		;tooltip, There was an Error opening the midi port.`nError code %result%`nErrorLevel = %ErrorLevel%
		Return -1
	}
	Return UInt@(&strh_midiout)
}
midiOutShortMsg1(h_midiout, EventType, Channel, Param1, Param2)
{
  ;h_midiout is handle to midi output device returned by midiOutOpen function
  ;EventType and Channel are combined to create the MidiStatus byte.  
  ;MidiStatus message table can be found at http://www.harmony-central.com/MIDI/Doc/table1.html
  ;Possible values for EventTypes are NoteOn (N1), NoteOff (N0), CC, PolyAT (PA), ChanAT (AT), PChange (PC), Wheel (W) - vals in () are optional shorthand 
  ;SysEx not supported by the midiOutShortMsg call
  ;Param3 should be 0 for PChange, ChanAT, or Wheel.  When sending Wheel events, put the entire Wheel value
  ;in Param2 - the function will split it into it's two bytes 
  ;returns 0 if successful, -1 if not.  
  
  ;Calc MidiStatus byte
  If (EventType = "NoteOn" OR EventType = "N1")
    MidiStatus :=  143 + Channel
  Else if (EventType = "NoteOff" OR EventType = "N0")
    MidiStatus := 127 + Channel
  Else if (EventType = "CC")
    MidiStatus := 175 + Channel
  Else if (EventType = "PolyAT" OR EventType = "PA")
    MidiStatus := 159 + Channel
  Else if (EventType = "ChanAT" OR EventType = "AT")
    MidiStatus := 207 + Channel
  Else if (EventType = "PChange" OR EventType = "PC")
    MidiStatus := 191 + Channel
  Else if (EventType = "Wheel" OR EventType = "W")
  {  
    MidiStatus := 223 + Channel
    Param2 := Param1 >> 8 ;MSB of wheel value
    Param1 := Param1 & 0x00FF ;strip MSB, leave LSB only
  }

  ;Midi message Dword is made up of Midi Status in lowest byte, then 1st parameter, then 2nd parameter.  Highest byte is always 0
  dwMidi := MidiStatus + (Param1 << 8) + (Param2 << 16)
  
  ;Call api function to send midi event  
  result := DllCall("winmm.dll\midiOutShortMsg"
            , UInt, h_midiout
            , UInt, dwMidi
            , UInt)
  
  if (result or errorlevel)
  {
    msgbox, There was an error sending the midi event
    return -1
  }
return
}
midiOutShortMsg(h_midiout, MidiStatus, Param1, Param2) {

	result := DllCall("winmm.dll\midiOutShortMsg", UInt,h_midiout, UInt, MidiStatus|(Param1<<8)|(Param2<<16), UInt)
	;Menu, Tray, Icon, akaiapc_322.ico
	If (result or ErrorLevel) {
		MIDI_OK := False
		tooltip There was an Error Sending the midi event: (%result%`, %ErrorLevel%) `npass back to reload script as this was occuring intermittently.
		;midiOutClose(h_midiout) 
		
		;settimer, MidiRetry, 5000
		settimer, restart_plx, 5000
		
		MidiRetry:
		gosub, MidiPortRefresh  
		;port_test(numports,numports2) ; test the ports - check for valid ports?
		gosub, midiin_go ; opens the midi input port listening routine
		gosub, midiout ; opens the midi out port
		msgbox retrying
		return
	}
	else 
		MIDI_OK := True
	if !MIDI_OK {
		msgbox % "midi fucked reload"
		ifmsgbox ok
			reload
	}
	; =============================================B%%%%
}

midiOutClose(h_midiout) { ; Close MidiOutput
	Loop 80 {
		result := DllCall("winmm.dll\midiOutClose", UInt,h_midiout)
		If !(result or ErrorLevel)
		Return
		Sleep 250
	}
	sleep 2000
	;MsgBox Error in closing the midi output port. There may still be midi events being Processed.
	Return -1
}

;UTILITY FUNCTIONS
MidiOutGetNumDevs() { ; Get number of midi output devices on system, first device has an ID of 0
	Return DllCall("winmm.dll\midiOutGetNumDevs")
}

MidiOutNameGet(uDeviceID = 0) { ; Get name of a midiOut device for a given ID
	;MIDIOUTCAPS struct
	; WORD wMid;
	; WORD wPid;
	; MMVERSION vDriverVersion;
	; CHAR szPname[MAXPNAMELEN];
	; WORD wTechnology;
	; WORD wVoices;
	; WORD wNotes;
	; WORD wChannelMask;
	; DWORD dwSupport;
	VarSetCapacity(MidiOutCaps, 50, 0) ; allows for szPname to be 32 bytes
	OffsettoPortName := 8, PortNameSize := 32
	result := DllCall("winmm.dll\midiOutGetDevCapsA", UInt,uDeviceID, UInt,&MidiOutCaps, UInt,50, UInt)
	If (result OR ErrorLevel) {
		MsgBox Error %result% (ErrorLevel = %ErrorLevel%) in retrieving the name of midi output %deviceID%
		Return -1
	}

	VarSetCapacity(PortName, PortNameSize)
	DllCall("RtlMoveMemory", Str,PortName, Uint,&MidiOutCaps+OffsettoPortName, Uint,PortNameSize)
	Return PortName
}

MidiOutsEnumerate() { ; Returns number of midi output devices, creates global array MidiOutPortName with their names
	local NumPorts, PortID
	MidiOutPortName =
	NumPorts := MidiOutGetNumDevs()

	Loop %NumPorts% {
		PortID := A_Index -1
		MidiOutPortName%PortID% := MidiOutNameGet(PortID)
	}
	Return NumPorts
}

UInt@(ptr) {
	Return *ptr | *(ptr+1) << 8 | *(ptr+2) << 16 | *(ptr+3) << 24
}

PokeInt(p_value, p_address) { ; Windows 2000 and later
	DllCall("ntdll\RtlFillMemoryUlong", UInt,p_address, UInt,4, UInt,p_value)
}

;=remote WMP stuff
class RemoteWMP
{
	__New() {
		static IID_IOleClientSite := "{00000118-0000-0000-C000-000000000046}"
		, IID_IOleObject := "{00000112-0000-0000-C000-000000000046}"
		Process, Exist, wmplayer.exe
		if !ErrorLevel
			return
		;throw Exception("wmplayer.exe is not running")
		if !this.player := ComObjCreate("WMPlayer.OCX.7")
			return
		;throw Exception("Failed to get WMPlayer.OCX.7 object")
		this.rms := IWMPRemoteMediaServices_CreateInstance()
		this.ocs := ComObjQuery(this.rms, IID_IOleClientSite)
		this.ole := ComObjQuery(this.player, IID_IOleObject)
		DllCall(NumGet(NumGet(this.ole+0)+3*A_PtrSize), "Ptr", this.ole, "Ptr", this.ocs)
	}
	
	__Delete() {
		if !this.player
		Return
		DllCall(NumGet(NumGet(this.ole+0)+3*A_PtrSize), "Ptr", this.ole, "Ptr", 0)
		for k, obj in [this.ole, this.ocs, this.rms]
		ObjRelease(obj)
		this.player := ""
	}
	
	Jump(sec) {
		this.player.Controls.currentPosition += sec
	}
	
	Pstate() {
	if (Pstate_answer=42) { ; a token declaring as a num for init
			gosub old2new ;tooltip, INIT 
			Pstate_answer = % this.player.playState
			Pstate_answer_old = % this.player.playState
			gosub update_lights
			return
		} else {
		try
		{
			Pstate_answer := this.player.playState
		}
		Catch
		{
			sleep 250
			ABC_FGH:
			try
			{
				Pstate_answer := this.player.playState
			}
			Catch
			{
				sleep 250
				GOTO ABC_FGH
				
}}} ;¬¬¬¬¬¬
			;sleep 1000
			gosub Song_Compare
			return
		}
		
	TogglePause() {
		if (this.player.playState = 3) ; Playing = 3
		this.player.Controls.pause()
		else
		this.player.Controls.play()
}	}

IWMPRemoteMediaServices_CreateInstance() {
	static vtblUnk, vtblRms, vtblIsp, vtblOls, vtblPtrs := 0, size := (A_PtrSize + 4)*4 + 4
	if !VarSetCapacity(vtblUnk) {
		extfuncs := ["QueryInterface", "AddRef", "Release"]
		
		VarSetCapacity(vtblUnk, extfuncs.Length()*A_PtrSize)
		
		for i, name in extfuncs
		NumPut(RegisterCallback("IUnknown_" . name), vtblUnk, (i-1)*A_PtrSize)
	}
	if !VarSetCapacity(vtblRms) {
		extfuncs := ["GetServiceType", "GetScriptableObject", "GetCustomUIMode"]
		
		VarSetCapacity(vtblRms, (3 + extfuncs.Length())*A_PtrSize)
		DllCall("ntdll\RtlMoveMemory", "Ptr", &vtblRms, "Ptr", &vtblUnk, "Ptr", A_PtrSize*3)
		
		for i, name in extfuncs
		NumPut(RegisterCallback("IWMPRemoteMediaServices_" . name, "Fast"), vtblRms, (2+i)*A_PtrSize)
	}
	if !VarSetCapacity(vtblIsp) {
		VarSetCapacity(vtblIsp, 4*A_PtrSize)
		DllCall("ntdll\RtlMoveMemory", "Ptr", &vtblIsp, "Ptr", &vtblUnk, "Ptr", A_PtrSize*3)
		NumPut(RegisterCallback("IServiceProvider_QueryService", "Fast"), vtblIsp, A_PtrSize*3)
	}
	if !VarSetCapacity(vtblOls) {
		extfuncs := ["SaveObject", "GetMoniker", "GetContainer", "ShowObject", "OnShowWindow", "RequestNewObjectLayout"]
		VarSetCapacity(vtblOls, (3 + extfuncs.Length())*A_PtrSize)
		DllCall("ntdll\RtlMoveMemory", "Ptr", &vtblOls, "Ptr", &vtblUnk, "Ptr", A_PtrSize*3)
		
		for i, name in extfuncs
		NumPut(RegisterCallback("IOleClientSite_" . name, "Fast"), vtblOls, (2+i)*A_PtrSize)
	}
	if !vtblPtrs
	vtblPtrs := [&vtblUnk, &vtblRms, &vtblIsp, &vtblOls]
	
	pObj := DllCall("GlobalAlloc", "UInt", 0, "Ptr", size, "Ptr")
	for i, ptr in vtblPtrs {
		off := A_PtrSize*(i - 1) + 4*(i - 1)
		NumPut(ptr, pObj+0, off, "Ptr")
		NumPut(off, pObj+0, off + A_PtrSize, "UInt")
	}
	NumPut(1, pObj+0, size - 4, "UInt")
	
	return pObj
}

IUnknown_QueryInterface(this_, riid, ppvObject) {
	static IID_IUnknown, IID_IWMPRemoteMediaServices, IID_IServiceProvider, IID_IOleClientSite
	if !VarSetCapacity(IID_IUnknown) {
		VarSetCapacity(IID_IUnknown, 16), VarSetCapacity(IID_IWMPRemoteMediaServices, 16), VarSetCapacity(IID_IServiceProvider, 16), VarSetCapacity(IID_IOleClientSite, 16)
		DllCall("ole32\CLSIDFromString", "WStr", "{00000000-0000-0000-C000-000000000046}", "Ptr", &IID_IUnknown)
		DllCall("ole32\CLSIDFromString", "WStr", "{CBB92747-741F-44FE-AB5B-F1A48F3B2A59}", "Ptr", &IID_IWMPRemoteMediaServices)
		DllCall("ole32\CLSIDFromString", "WStr", "{6d5140c1-7436-11ce-8034-00aa006009fa}", "Ptr", &IID_IServiceProvider)
		DllCall("ole32\CLSIDFromString", "WStr", "{00000118-0000-0000-C000-000000000046}", "Ptr", &IID_IOleClientSite)
	}
	
	if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IUnknown) {
		off := NumGet(this_+0, A_PtrSize, "UInt")
		NumPut(this_ - off, ppvObject+0, "Ptr")
		IUnknown_AddRef(this_)
		return 0 ; S_OK
	}
	
	if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IWMPRemoteMediaServices) {
		off := NumGet(this_+0, A_PtrSize, "UInt")
		NumPut((this_ - off)+(A_PtrSize + 4), ppvObject+0, "Ptr")
		IUnknown_AddRef(this_)
		return 0 ; S_OK
	}
	
	if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IServiceProvider) {
		off := NumGet(this_+0, A_PtrSize, "UInt")
		NumPut((this_ - off)+((A_PtrSize + 4)*2), ppvObject+0, "Ptr")
		IUnknown_AddRef(this_)
		return 0 ; S_OK
	}
	
	if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IOleClientSite) {
		off := NumGet(this_+0, A_PtrSize, "UInt")
		NumPut((this_ - off)+((A_PtrSize + 4)*3), ppvObject+0, "Ptr")
		IUnknown_AddRef(this_)
		return 0 ; S_OK
	}
	
	NumPut(0, ppvObject+0, "Ptr")
	return 0x80004002 ; E_NOINTERFACE
}

IUnknown_AddRef(this_)
{
	off := NumGet(this_+0, A_PtrSize, "UInt")
	iunk := this_-off
	NumPut((_refCount := NumGet(iunk+0, (A_PtrSize + 4)*4, "UInt") + 1), iunk+0, (A_PtrSize + 4)*4, "UInt")
	return _refCount
}

IUnknown_Release(this_) {
	off := NumGet(this_+0, A_PtrSize, "UInt")
	iunk := this_-off
	_refCount := NumGet(iunk+0, (A_PtrSize + 4)*4, "UInt")
	if (_refCount > 0) {
		NumPut(--_refCount, iunk+0, (A_PtrSize + 4)*4, "UInt")
		if (_refCount == 0)
		DllCall("GlobalFree", "Ptr", iunk, "Ptr")
	}
	return _refCount
}

IWMPRemoteMediaServices_GetServiceType(this_, pbstrType)
{
	NumPut(DllCall("oleaut32\SysAllocString", "WStr", "Remote", "Ptr"), pbstrType+0, "Ptr")
	return 0
}

IWMPRemoteMediaServices_GetScriptableObject(this_, pbstrName, ppDispatch)
{
	return 0x80004001
}

IWMPRemoteMediaServices_GetCustomUIMode(this_, pbstrFile)
{
	return 0x80004001
}

IServiceProvider_QueryService(this_, guidService, riid, ppvObject)
{
	return IUnknown_QueryInterface(this_, riid, ppvObject)
}

WMP_NEXT:
Process, Exist, wmplayer.exe
ControlSend , ,^f, Windows Media Player 
ifwinnotexist, Windows Media Player
{
	traytip, Windows Media Player, Process found but window Not,3000,2
	Return
} else {
		oldsong := newsong
		PostMessage, 0x111, Stop, 0, ,%WinTitle%
		sleep, 50
		PostMessage, 0x111, Next, 0, ,%WinTitle%
		sleep 50
		thecall1:
		gosub thetry
		if (newsong = oldsong) {
			traytip Windows Media Player, End of Playlist		
			;tooltip, newsong = oldsong
			exit
		} else {
			wmp.jump(skipD)
			sleep 100
			PostMessage, 0x319, 0, Play, ,%WinTitle%
			;tooltip, congrats you changed to the next tune bell
	}	}
return

WMP_Refresh: 
wmp 	:= new RemoteWMP
media 	:= wmp.player.currentMedia
controls := wmp.player.controls
return


THETRY:
sleep, 200
gosub WMP_refresh
sleep 200
newsong= % media.sourceURL
sleep 200
return

;	END WMP 	;	APP VOL

AppVolume(app:="", device:="")
{
	return new AppVolume(app, device)
}

class AppVolume
{
	ISAVs := []
	
	__New(app:="", device:="")
	{
		static IID_IASM2 := "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}"
		, IID_IASC2 := "{BFB7FF88-7239-4FC9-8FA2-07C950BE9C6D}"
		, IID_ISAV := "{87CE5498-68D6-44E5-9215-6DA47EF883D8}"
		
		; Activate the session manager of the given device
		pIMMD := VA_GetDevice(device)
		VA_IMMDevice_Activate(pIMMD, IID_IASM2, 0, 0, pIASM2)
		ObjRelease(pIMMD)
		
		; Enumerate sessions for on this device
		VA_IAudioSessionManager2_GetSessionEnumerator(pIASM2, pIASE)
		ObjRelease(pIASM2)
		
		; Search for audio sessions with a matching process ID or Name
		VA_IAudioSessionEnumerator_GetCount(pIASE, Count)
		Loop, % Count
		{
			; Get this session's IAudioSessionControl2 via its IAudioSessionControl
			VA_IAudioSessionEnumerator_GetSession(pIASE, A_Index-1, pIASC)
			pIASC2 := ComObjQuery(pIASC, IID_IASC2)
			ObjRelease(pIASC)
			
			; If its PID matches save its ISimpleAudioVolume pointer
			VA_IAudioSessionControl2_GetProcessID(pIASC2, PID)
			if (PID == app || this.GetProcessName(PID) == app)
				this.ISAVs.Push(ComObjQuery(pIASC2, IID_ISAV))
			
			ObjRelease(pIASC2)
		}
		
		; Release the IAudioSessionEnumerator
		ObjRelease(pIASE)
	}
	
	__Delete() {
		for k, pISAV in this.ISAVs
			ObjRelease(pISAV)
	}
	
	AdjustVolume(Amount) {
		return this.SetVolume(this.GetVolume() + Amount)
	}
	
	GetVolume() {
		for k, pISAV in this.ISAVs
		{
			VA_ISimpleAudioVolume_GetMasterVolume(pISAV, fLevel)
			return fLevel * 100
		}
	}
	
	SetVolume(level) {
		level := level>100 ? 100 : level<0 ? 0 : level ; Limit to range 0-100
		for k, pISAV in this.ISAVs
			VA_ISimpleAudioVolume_SetMasterVolume(pISAV, level / 100)
		return level
	}
	
	GetMute() {
		for k, pISAV in this.ISAVs
		{
			VA_ISimpleAudioVolume_GetMute(pISAV, bMute)
			return bMute
		}
	}
	
	SetMute(bMute)
	{
		for k, pISAV in this.ISAVs
			VA_ISimpleAudioVolume_SetMute(pISAV, bMute)
		return bMute
	}
	
	ToggleMute()
	{
		return this.SetMute(!this.GetMute())
	}
	
	GetProcessName(PID) {
		hProcess := DllCall("OpenProcess"
		, "UInt", 0x1000 ; DWORD dwDesiredAccess (PROCESS_QUERY_LIMITED_INFORMATION)
		, "UInt", False ; BOOL bInheritHandle
		, "UInt", PID ; DWORD dwProcessId
		, "UPtr")
		dwSize := VarSetCapacity(strExeName, 512 * A_IsUnicode, 0) // A_IsUnicode
		DllCall("QueryFullProcessImageName"
		, "UPtr", hProcess ; HANDLE hProcess
		, "UInt", 0 ; DWORD dwFlags
		, "Str", strExeName ; LPSTR lpExeName
		, "UInt*", dwSize ; PDWORD lpdwSize
		, "UInt")
		DllCall("CloseHandle", "UPtr", hProcess, "UInt")
		SplitPath, strExeName, strExeName
		return strExeName
	}
}

VA_ISimpleAudioVolume_SetMasterVolume(this, ByRef fLevel, GuidEventContext="") {
	return DllCall(NumGet(NumGet(this+0)+3*A_PtrSize), "ptr", this, "float", fLevel, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMasterVolume(this, ByRef fLevel) {
	return DllCall(NumGet(NumGet(this+0)+4*A_PtrSize), "ptr", this, "float*", fLevel)
}
VA_ISimpleAudioVolume_SetMute(this, ByRef Muted, GuidEventContext="") {
	return DllCall(NumGet(NumGet(this+0)+5*A_PtrSize), "ptr", this, "int", Muted, "ptr", VA_GUID(GuidEventContext))
}
VA_ISimpleAudioVolume_GetMute(this, ByRef Muted) {
	return DllCall(NumGet(NumGet(this+0)+6*A_PtrSize), "ptr", this, "int*", Muted)
}

;Dsiplay Brightness 
SetDisplayBrightness(Brightness) {
	Static Minimum := "0", Current := "", Maximum := "5000"
	HMON := DllCall("User32.dll\MonitorFromWindow", "Ptr", 0, "UInt", 0x02, "UPtr")
	DllCall("Dxva2.dll\GetNumberOfPhysicalMonitorsFromHMONITOR", "Ptr", HMON, "UIntP", PhysMons, "UInt")
	VarSetCapacity(PHYS_MONITORS, (A_PtrSize + 256) * PhysMons, 0) ; PHYSICAL_MONITORS
	DllCall("Dxva2.dll\GetPhysicalMonitorsFromHMONITOR", "Ptr", HMON, "UInt", PhysMons, "Ptr", &PHYS_MONITORS, "UInt")
	HPMON := NumGet(PHYS_MONITORS, 0, "UPtr")
	DllCall("Dxva2.dll\GetMonitorBrightness", "Ptr", HPMON, "UIntP", Minimum, "UIntP", Current, "UIntP", Maximum, "UInt")
	If Brightness Is Not Integer
		Brightness := Current
	If (Brightness < Minimum)
		Brightness := Minimum
	If (Brightness > Maximum)
		Brightness := Maximum
	DllCall("Dxva2.dll\SetMonitorBrightness", "Ptr", HPMON, "UInt", Brightness, "UInt")
	DllCall("Dxva2.dll\DestroyPhysicalMonitors", "UInt", PhysMons, "Ptr", &PHYS_MONITORS, "UInt")
	Return Brightness
}

chanledssweep1:
if !_index
_index := 1
else _index := _index + 1
if _index = 9
	settimer, chanledssweep1, off
s1 := _index
GUI_sByte := _index + 143
GUI_Byte1 := 51
GUI_Byte2 := 127
;midiOutShortMsg(h_midiout, GUI_sByte, 51, 127)
midiOutShortMsg1(h_midiout, "NoteOn", s1, 51, 127)
sleep 44
midiOutShortMsg1(h_midiout, "NoteOff", s1, 51, 127)
return

chanledssweep2:
if( st = "20")
settimer chanledssweep2, off
midiOutShortMsg1(h_midiout, "NoteOn", 1, 1 + st, 100-((st*3)-(2*(st+8))))
sleep 44
midiOutShortMsg1(h_midiout, "Noteoff", 1, st, 0)
st:=st+1
return

chanledssweep3:
if( st = "40" )
settimer chanledssweep3, off
midiOutShortMsg1(h_midiout, "NoteOn", 1, 1 + (((st+1)*2)-(st-1*2)), 127-st)
midiOutShortMsg1(h_midiout, "NoteOff", 1, st, 0)
st:=st+1
return

regulator:
loop 						{
	if (ST = "60")			{
	st := st-1
		if no bumbum
			bumbum :=1
		else {
			bumbum :=bumbum +1
				st := st-2
				}
		if 	bumbum := 2 	{
			settimer, chanledssweep1, off
			sleep 1000 
			settimer, chanledssweep2, off
			sleep 100
			settimer, chanledssweep3, off
			bumbum := "", st := 1
			break
}	}	}

Receive_WM_COPYDATA(wParam, lParam) {

    StringAddress 	:= 	NumGet(lParam + 2*A_PtrSize) 
    CopyOfData 		:= 	StrGet(StringAddress) 
	;tooltip % CopyOfData " Recvd@MidiInOut", 500, 599
	TT((CopyOfData " Recvd@MidiInOut"),"777")
	settimer, tooloff, -1000
	;global statusbyte, byte1, byte2
	Loop Parse, CopyOfData, `,
	{
		switch a_index {
			case 1:
				if (A_Loopfield = "chan") {
					chan_c	:= true
				} else {
					statusbyte 	:= a_loopfield
					GUI_sByte 	:= a_loopfield
				}
			case 2:
			;msgbox % chold "`n" ch
				if chan_c {
					if (ch != a_loopfield )	{
						ch := a_loopfield 
						midiOutShortMsg1(h_midiout, "NoteOff", chold, 51, 127)
						sleep 88
						midiOutShortMsg1(h_midiout, "NoteOn", a_loopfield, 51, 127)
					}
					chold := ch
					chan_c := False
					
					
				} else {
					byte1 		:= a_loopfield
					GUI_Byte1 	:= a_loopfield
					}
			case 3:
					byte2 		:= a_loopfield
					GUI_Byte2 	:= a_loopfield
				
		}  
	}
 	midiOutShortMsg(h_midiout, GUI_sByte, GUI_Byte1, GUI_Byte2)
  	GUI_Midi_Waiting 	:= true
	gosub midirules ; this will enact the desired change via a virtual midi set of data described above
   
}

Send_WM_COPYDATA(ByRef StringToSend,ByRef TargetScriptTitle) 
{
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  
	Prev_DetectHiddenWindows := A_DetectHiddenWindows
	Prev_TitleMatchMode := A_TitleMatchMode
	DetectHiddenWindows On
	SetTitleMatchMode 2
	TimeOutTime := 4000
	SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%,,,, %TimeOutTime% 
	DetectHiddenWindows %Prev_DetectHiddenWindows%  
	SetTitleMatchMode %Prev_TitleMatchMode%  
}

test11:
tooltip, Vol Attempted Gain +10 %bouncecol% Detected		; add a mitigation
midiOutShortMsg(h_midiout,144,7,106)
midiOutShortMsg(h_midiout,133,7,106)
;sleep 100
;midiOutShortMsg(h_midiout, "140", "7", "106")
settimer, tooloff, -1000
return

ProcessHackerLaunch: 				;				 Process Hacker CTRL ALT ENTER
run % Path_PH
return

Xfade_Transport_main:
media 		:= 	wmp.player.currentMedia
Current		:= 	floor(controls.currentPosition)
Duration 	:= 	floor(media.getItemInfo("Duration")) - 8
Desired 	:= 	floor((Duration * (Byte2 * 0.77) ) * 0.01)
Fader_dz_A	:= 	floor(Duration * 0.02)

if (floor(Desired) < floor(Fader_dz_A)) {	
	desired := 0
	wmp.jump((0-current-2))
}
net_jump	:= (desired - current)
if (net_jump < Duration) {
	;if !desired 
	;	tooltip tits
	;else
if desired 
	wmp.jump(net_jump)
} else {
	Tooltip % "Jumpin outta time and space, Professor..."
	settimer, tooloff, -333
}
return

ttovervol:
tooltip % ("Over Volume " (Vol_Master_Get + 20))
return

mvolset:
Soundset, volm_nu ;format("{:g}", (Byte2 * 0.8))  
	volm_nu := (Byte2 - 25)
return
	

	if TTMVol 
		settimer, 	TTMVol, 	-1
return

TTMVol:
tooltip % "Volume: " Master_VolumeNew, a_screenwidth - 300, a_screenheight -300
return



if 	!attended {
	WMPraw := AppVolume("wmplayer.exe").GetVolume()	;UpperLim := (WMPraw + 20)
	if (WMP_Volnew between 0 and (WMPraw + 20)) {
		AppVolume("wmplayer.exe").setVolume(WMP_Volnew)
		settimer, attend_refresh, -1
	}
	else tooltip % ("Over Volume " (WMPraw + 20))
} else { 
	AppVolume("wmplayer.exe").setVolume(WMP_Volnew)
	settimer, attend_refresh, -1
	;tooltip % WMP_Volnew " wmp Vol new"
}
return

stupid:
	settimer, chanledssweep1, 1
sleep 1000 
	settimer, chanledssweep2, 1
sleep 1000
	settimer, chanledssweep3, 1
	settimer, regulator, -1
return



attend_refresh:	; 5 sec without upperlimit testing
attended := true
settimer, attend_end, -5000
return

attend_end:
attended := False
return

Supplant_Bytes:
byte1 := GUI_Byte1,	byte2 := GUI_Byte2,	STATUSBYTE := GUI_sByte, GUI_Midi_Waiting := False
return

p00py:
if  byte10ld between 48 and 55
	byte11 	:= 	byte1 - 47 				; knob num
else
if  byte10ld between 16 and 23
	byte11	:= 	byte10ld - 7 
byte22 		:= 	round(byte2 * 0.11025)	; value
;tooltip % statusbyte . "," . byte1 . "," . byte2
result 		:= 	Send_WM_COPYDATA( (statusbyte . "," . byte11 . "," . byte22), GuiScriptTitle)
return

ROT_TOP_SWEEP:
loop 8 {
	if a_index = 1
		global ccn:=49
	else ccn := ccn+1
	loop 16 {
		if a_index = 1
			global fff:=1
		else fff:= fff+8
		midiOutShortMsg1(h_midiout, "CC", 1, ccn, fff)
		sleep 10
		fff:= fff+1
}	}
return
bummy:
loop 8 {
	if a_index = 1
		global ccn:=16
	else ccn := ccn+1
	loop 16 {
		if a_index = 1
			global fff:=1
		else fff:= fff+8
		midiOutShortMsg1(h_midiout, "CC", 2, ccn, fff)
		sleep 10
		fff:= fff+1
}	}
return

TTMVolTogl:
TTMVol := !TTMVol
if !TTMVol {
	global TTMVol := 	True
	menu, tray, 		check,  % 	"Tooltip MASTERVOL",
} else {	
	menu, tray, 		uncheck,  % "Tooltip MASTERVOL",
	TTMVol		  :=	False
}
return
Toggle_midi_In_out:
if	 MidiInDevice 	= 	1
	 MidiInDevice 	= 	0
else MidiInDevice 	= 	1
if	 MidiOutDevice 	= 	0
	 MidiOutDevice 	= 	1
else MidiOutDevice 	= 	0
gosub, MidiPortRefresh	 ; used to refresh the input and output port lists - see label below
port_test(numports,numports2) ; test the ports - check for valid ports?
gosub, midiin_go ; opens the midi input port listening routine
gosub, midiout ; opens the midi out port
return

APC_GuI:
a := ("" "C:\Program Files\Autohotkey\AutoHotkeyU64.exe" " " . GUI_Script)
tooltip % a
run %a%,,hide,zinout_pid
return

 
Restart_plx:
Reload

Open_ScriptDir()