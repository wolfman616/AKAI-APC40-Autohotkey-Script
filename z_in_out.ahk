SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
setbatchlines -1
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#persistent
#SingleInstance force
#Include VA.ahk
#inputlevel 1
01=
	menu, tray, add, Toggle Midi Channels, Toggle_midi_In_out,

readini() ; load previous midi settings

if A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME ; if not xp or 2000 quit
{
	MsgBox Error Win2k/XP or later minimum.
	ExitApp
}

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
Menu, Tray, Add, Open script folder, Open_script_folder,
Menu, Tray, Standard




gosub, MidiPortRefresh ; used to refresh the input and output port lists - see label below
port_test(numports,numports2) ; test the ports - check for valid ports?
gosub, midiin_go ; opens the midi input port listening routine
gosub, midiout ; opens the midi out port

SendLevel 99
;Send, #^r

; =============== set variables you use in MidiRules section
nn=1
fun=42
timeoutreload := 100
cc_msg = 73,74 ; ++++++++++++++++ you might want to add other vars that load in auto execute section This example goes with
channel = 1 ; default channel =1
ccnum = 7 ; 7 is volume
BrowserVol = 25
cack=10
WMPVol := 10
Master_Volume = 10
volVal = 0 ; Default zero for volume
volDelta = 10 ; Amount to change volume
NoteVel := 127 ; Colour and Luminosity
Sbyte := 144
Mnote= 0
Bank:= 0 ; bank key un-lit /  Bind shift disabled
yFaderGroup =7
xFadeB1=66
yMaster =14
XFader = 15
FaderSByte =176
;176, 177, 178, 179, 180, 181, 182
yfads:= [%YfCh1%, %YfCh2%, %YfCh3%, %YfCh4%, %YfCh5%, %YfCh6%, %YfCh7%, %YfCh8%]
ch8lights:=[6, 14, 22, 40]
xCh8 =7 
xCh7 =6 
xCh6 =5 
xCh5 =4 
xCh4 =3 
xCh3 =2 
xCh2 =1 
xCh1=0
global Pstate_answer=42
global Pstate_answer_old=69
skipD = 86
XfOffB2=0
XfLEFTB2=1
XfRIGHTB2=2
XfCh8=151
XfCh8Off=135
XfCh7=150
XfCh7Off=134
XfCh6=149
XfCh6Off=133
XfCh5=148
XfCh5Off=132
XfCh4=147
XfCh4Off=131
XfCh3=146
XfCh3Off=130
XfCh2=145
XfCh2Off=129
XfCh1=144
XfCh1Off=128
YfCh8=183
YfCh7=182
YfCh6=181
YfCh5=180
YfCh4=179
YfCh3=178
YfCh2=177
YfCh1=176
global xSByteFlashPause=143
global xSByteFadePlay=133
global xSByteONNormal=144
global B2PausedColor
global B2UnPausedColor
global BounceCol
global bounceincdelay
iniread, B2PausedColor, z.ini, colours, pausedcolour, 69
iniread, B2UnPausedColor, z.ini, colours, unpausecolour, 69
iniread, BounceCol, z.ini, colours, bouncecol, 69
iniread, bounceincdelay, z.ini, Bounce, bounceincdelay, 195



Ascending:=1
bouncefade:=129
; bounceincdelay:= 195
bounceloc=1
bounceoffloc=1
;bounceofflocreal:=bounceoffloc+ 31 ;32 -39 top row
bounceendpause= 300
bouncing=1
updatelights:=0
Brightne55:= Format("100", int*)
n :=1
;Light Array not yet implemented
lights:= [] 
lights[1] := "xSByteFlashPause" 
lights[2] := "xSByteFadePlay"
lights[3] := "xSByteONNormal"
lights[4] := "B2PausedColor"
lights[5] := "B2UnPausedColor"
AppVolume("firefox.exe").getmute(twatty) ;AppVolume("firefox.exe").ToggleMute()
AppVolume("firefox.exe").getvolume(awatty2)
cffmute=1



 
;Array := {1: ValueA, KeyB: ValueB, ..., KeyZ: ValueZ}
OnExit("Parp")


Parp() {
iniwrite, %BounceCol% , z.ini , Colours, bouncecol
sleep 200
iniwrite, %B2PausedColor%  , z.ini , Colours, pausedcolour
sleep 200
iniwrite, %B2UnPausedColor% , z.ini, Colours, unpausecolour
sleep 200
iniwrite, %bounceincdelay% , z.ini, Bounce, bounceincdelay
sleep 200
tooltip, byee
sleep 200
tooltip,
}

return ; DO NOT REMOVE

MidiRules: ; Tip is: ++++++ for where you might want to add
; avoid these !!!!!!!!!!



if((byte1=103) && (statusbyte=144))  { ; APC BANK BUTTON LIT/  BANK MODEON
	Bank := 1 
	Gui, Add, Picture, w784 h467 BackgroundTrans, apc40mk2.png
	;gui, add, picture, apc40mk2.png,
	Gui, Show,x400 y400 w790 h475, MIDI IN / OUT, 
	tooltip, 
}

if( (byte1=103) && (statusbyte=128)) { ;APC BANK BUTTON UNLIT/OFF
	Bank := 0 
	Gui, Show, , SACK
	Gui, Hide
}


If((byte1=yMaster) && (statusbyte=FaderSByte)) { ;  APC MASTER FADER   
	SoundGet, WankingRaw
	UpperLim := WankingRaw + 10
	Master_VolumeNewRaw :=  Byte2 / 1.23 
	if Master_VolumeNewRaw  between 0 and %UpperLim%
	{
		Master_VolumeNew := Round(Master_VolumeNewRaw)
		Soundset,  Master_VolumeNew    ;
	} Else
		Traytip,  Main Volume, Attempted Gain diference of +10 Detected 	; add a mitigation
}
if((byte1=yFaderGroup) && (statusbyte=180)) { 			;  APC FADER 5
tooltip xbxbxcb
	gameraw:=AppVolume("Discord.exe")
UpperLim := gameraw + 10
	gameNEWRAW := Byte2 / 1.23
if gameNEWRAW between 0 and %UpperLim%
	{
		gameNEW:=Round(gameNEWRAW)
		AppVolume("RobloxPlayerBeta.exe").setVolume(gameNEW)
	} Else
		Traytip,  game Volume, Attempted Gain diference of +10 Detected		; add a mitigation
}

if((byte1=yFaderGroup) && (statusbyte=181)) { 				;  APC FADER 6

	vlcraw:=AppVolume("VLC.exe")
	UpperLim := vlcraw + 10
	VLCNEWRAW := Byte2 / 1.23
	if VLCNEWRAW between 0 and %UpperLim%
	{
		VLCNEW:=Round(VLCNEWRAW)
		AppVolume("VLC.exe").setVolume(VLCNEW)
	} Else
		Traytip,  VLC Volume, Attempted Gain diference of +10 Detected		; add a mitigation
}

if((byte1=yFaderGroup) && (statusbyte=182)) { 				;  APC FADER 7   
	BrowserRAW1:=AppVolume("chrome.exe").GetVolume()
	BrowserRAW2:=AppVolume("firefox.exe").GetVolume()
	if BrowserRAW1 {
		if UpperLim1<UpperLim2
			UpperLim := UpperLim1  + 20
	} Else 
		UpperLim := BrowserRAW2  + 20
	BrowserNEWRAW := Byte2 / 1.23
	if BrowserNEWRAW between 0 and %UpperLim% 
	{
		BrowserNEW:=Round(BrowserNEWRAW)
		AppVolume("chrome.exe").setVolume(BrowserNEW)
		AppVolume("firefox.exe").setVolume(BrowserNEW)
	} Else
		Traytip,  Browser Volume, Attempted Gain diference of +10 Detected		; add a mitigation
}

if((byte1=yFaderGroup) && (statusbyte=YfCh8)) {		;  APC FADER 8   
	WMPVol:=round(Byte2 / 1.23)
	wmpraw:=AppVolume("wmplayer.exe").GetVolume()
	UpperLim := wmpraw  + 20
	wmprawnew := Byte2 / 1.23
	if wmprawnew between 0 and %UpperLim%
	{
		wmpNEW:=Round(wmprawnew)
		AppVolume("wmplayer.exe").setVolume(wmpNEW)
	} Else
		Traytip,  Browser Volume, Attempted Gain diference of +10 Detected		; add a mitigation
}

if((byte1=13) && (statusbyte=176) && (byte2= 1) && (editch8=1)) { ;  APC  Tempo Knob
	lightsvar:= % lights[n]
	tooltip, editing %lightsvar% use knob below :)
	n:=n+1
	return
}

if((byte1=13) && (statusbyte=176) && (byte2= 127) && (editch8=1)) { ;   APC  Tempo Knob
	Brightne55 := Brightne55 - 10
	SetDisplayBrightness(%Brightne55%)
	tooltip brightness -1`n%Brightne55%
}

if((byte1=xCh8) && (Byte2=127) && (statusbyte=144) && (Bank=1)) {
	tooltip, Edit me
	editch8=1
	return
}

if((byte1=xCh8) && (Byte2=127) && (statusbyte=144) && (Bank=1) && (editch8=1)) {
	tooltip, % n
	return
}

if((byte1=19) && (StatusByte=184) && (editch8=1)) {
	%lightsvar% := %Byte2%
	tooltip %lightsvar% = %Byte2%
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
	gosub update_lights
	return
}

if((byte1=52) && (byte2=127) && (StatusByte=150) && (CFFMute=2)) {
	AppVolume("chrome.exe").ToggleMute()
	AppVolume("firefox.exe").ToggleMute()
	CFFMute=1
	AppVolume("firefox.exe").getmute()
	tooltip, %bmute% b
	gosub update_lights
	return
}

if((byte1=94) && (Byte2=127) && (statusbyte=144)) { ;  BANK SELECT UP
	Process, Exist, slsk2.exe
	if !ErrorLevel
		tooltip, error slsk not open
	else
		run WMP_SLSK.ahk
}
;if  (byte1=94) && (Byte2=127) && (statusbyte=144) && (Bankmode=1)
if((byte1=96) && (statusbyte=144)) { ;  BANK SELECT RIGHT
	;Process, Exist, wmplayer.exe
	gosub WMP_NEXT
	return
}

if((byte1=97) && (statusbyte=144)) { ;  BANK SELECT LEFT
	GoSub WMP_Prev
	Return
}

if((byte1=95) && (statusbyte=144)) { ;  BANK SELECT DOWN
	run wmp_cut.ahk ;cut mp3 to clipboard
}

if (statusbyte=151) && (Byte2=127) && (Bank =0) {
	if (Process, Exist, "wmplayer.exe") {
		ControlSend , ,^p, Windows Media Player
		sleep, 100
		gosub, WMP_CHECK
		gosub update_lights
	}
}

if (statusbyte=151) && (Byte2=127) && (Bank =1) ; DELETE currently playing file WMP
{
	gosub WMP_Del
}


if (updatelights=1)
{
	;tooltip 4546463636
	updatelights:=0
}

if (statusbyte=FaderSByte) && (Byte1=55)
{
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
settimer rainbow, 150
return
}
 */
bowcol=1



if((byte1=16) && (StatusByte=184) && (bank=1)) { ; AEROGLASS TRANS
	sendmessage, 0x0422, , round(Byte2 / 1.23), msctls_trackbar327, Aero Glass for Win8.x+
	return
}

if (byte1=17) && (StatusByte=184) && (bank=1) ; AEROGLASS REFLECTION
{
	sendmessage, 0x0422, , round(Byte2 / 1.23), msctls_trackbar321, Aero Glass for Win8.x+
	return
}

if (byte1=18) && (StatusByte=184) && (bank=1) ; AEROGLASS REFLECTION
{
	sendmessage, 0x0422, , round(Byte2 / 1.23), msctls_trackbar322, Aero Glass for Win8.x+
	return
}


;XFADE STUFF

if (statusbyte=XfCh8) && (Byte2=1)
{
	ASSHOLE:=1
	xFadeLeftOld:=xFadeLeft
	xFadeLeft=8 
	if xfaderight=8
	xFadeRight:=xFadeRightOld
}

if (statusbyte=XfCh7) && (Byte2=1)
{
	xFadeLeftOld:=xFadeLeft
	xFadeLeft=7
	if xfaderight=7
	xFadeRight:=xFadeRightOld
}


if (statusbyte=XfCh6) && (Byte2=1)
{
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
	ASSHOLE:=1
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
	ASSHOLE:=0
	TrayTip, X-FADER, Channel Unassigned
}

if (StatusByte=XfCh7Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	TrayTip, X-FADER, Channel Unassigned
	ASSHOLE:=0
}

if (StatusByte=XfCh6Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	TrayTip, X-FADER, Channel Unassigned
	ASSHOLE:=0
}

if (StatusByte=XfCh5Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	TrayTip, X-FADER, Channel Unassigned
	ASSHOLE:=0
}

if (StatusByte=XfCh4Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	TrayTip, X-FADER, Channel Unassigned
	ASSHOLE:=0
}

if (StatusByte=XfCh3Off) && (Byte2=0) && (Byte1=XfadeB1)
{
	TrayTip, X-FADER, Channel Unassigned
	ASSHOLE:=0
}

if (StatusByte=XfCh2Off) && (Byte2=0) && (Byte1=XfadeB1)
;TrayTip, X-FADER, Channel Unassigned
	ASSHOLE:=0

if (StatusByte=XfCh1Off) && (Byte2=0) && (Byte1=XfadeB1)
;TrayTip, X-FADER, Channel Unassigned
	ASSHOLE:=

;68 0 135                   0 135 CH8 XFADE OFF  1 151CH8XFADE A 2 151 CH8XFADEB

/* 
if (byte1=XFader) && (statusbyte=FaderSByte) && (xFadeRight=8) && (ASSHOLE=1)
{
WMPSumval:=round((WMPVol * round(Byte2 / 1.23)) /30)
AppVolume("wmplayer.exe").setVolume(WMPSumval)
}

if (byte1=XFader) && (statusbyte=FaderSByte) && (xFadeLeft=8) && (ASSHOLE=1)
{
WMPSumval:= (WMPVol * (100 - round(Byte2 / 1.23)))/30
AppVolume("wmplayer.exe").setVolume(WMPSumval)
}
 */
if (byte1=XFader) && (statusbyte=FaderSByte) && (xFadeRight=8) && (ASSHOLE=1)
{
	Master_Volume:=round(round(Byte2 / 1.23)*2)
	soundset, master_volume
	;AppVolume("wmplayer.exe").setVolume(WMPSumval)
}

if((byte1=XFader) && (statusbyte=FaderSByte) && (xFadeLeft=8) && (ASSHOLE=1)) {
	Soundget, An00s
	Priiiiick := round(50-((Byte2 / 1.23)/2))
	master_volume_new :=   100*(An00s / Priiiiick)
	soundset, master_volume_new
	;AppVolume("wmplayer.exe").setVolume(WMPSumval)
}

if((byte1=XFader) && (statusbyte=FaderSByte) && (xFadeRight=7)) {
	CFFSumval:=round((BrowserVol * round(Byte2 / 1.23)) /100)
	AppVolume("chrome.exe").setVolume(CFFSumval)
	AppVolume("firefox.exe").setVolume(CFFSumval)
}

if((byte1=15) && (statusbyte=FaderSByte) && (xFadeLeft=7)) {
	wmpcall=1
	CFFSumval:=100 - round((BrowserVol * round(Byte2 / 1.23)) /100)
	AppVolume("firefox.exe").setVolume(CFFSumval)
	AppVolume("chrome.exe").setVolume(CFFSumval)
}

if((byte1=XFader) && (statusbyte=FaderSByte) && (!ASSHOLE)) {
	WMP_Dur:=% media.getItemInfo("Duration")
	WMP_Cur:=% controls.currentPosition
	Duration:= round(WMP_Dur-8)
	Desired:=((Duration * round(Byte2 / 1.23) ) / 100)
	current:=round(WMP_Cur)
	resultant:=desired - current
	wmp.jump(resultant)
	;tooltip, Desired:%desired%`nCurrent:%current%`nsum %resultant%`nTotal :%Duration%,4000,2000
}

if((byte1=65) && (byte2=127) && (statusbyte=128) && (bank=1)) {
	tooltip, test
}

;-========================================================================= END XFADE SECT.+++++


if  (byte1=64) && (byte2=127) && (statusbyte=144)   ; CLIP DEV VIEW
{
	GOTO SumTest
}


if  (byte1=48) && (statusbyte=176) ; BOUNCE DELAY CH 1 TOP KNOB 
{
	bounceincdelay := round((byte2 * 1.83) +50) ; needs inverting 
}

/*  HAPPY ATM
if  (byte1=49) && (statusbyte=176) ; BOUNCE COLOUR CH 2 TOP KNOB 
	{
	BounceCol := byte2 ;
	}

 */
;ahk_pid 16612
; FFToolTip(Text:="", X:="", Y:="", WhichToolTip:=1)
settimer, WMP_CHECK, 3300
return
;#Space:: wmp.jump(90)ight

; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! no edit below here ....
; don't edit or read this part!
MidiMsgDetect(hInput, midiMsg, wMsg) ; Midi input section in "under the hood" calls this function each time a midi message is received. Then the midi message is broken up into parts for manipulation. See http://www.midi.org/techspecs/midimessages.php (decimal values).
{
global statusbyte, chan, note, cc, byte1, byte2

statusbyte := midiMsg & 0xFF ; EXTRACT THE STATUS BYTE (WHAT KIND OF MIDI MESSAGE IS IT?)t
byte1 := (midiMsg >> 8) & 0xFF ; THIS IS DATA1 VALUE = NOTE NUMBER OR CC NUMBER
byte2 := (midiMsg >> 16) & 0xFF ; DATA2 VALUE IS NOTE VELEOCITY OR CC VALUE
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
; Red Pulse top row
;Note 32 - 39


SendNote: ;(h_midiout,Note) ; send out note messages ; this should probably be a funciton but... eh.
note = %byte1% ; this var is added to allow transpostion of a note
return

update_lights:
{
if Pstate_answer=3
{
midiOutShortMsg(h_midiout, xSByteONNormal, xCh8, B2UnPausedColor)
midiOutShortMsg(h_midiout, xSByteFadePlay, xCh8, B2UnPausedColor)
;tooltip, unpasued,100,100,4
return
}
if (pstate_answer=2) or  (pstate_answer=1)
{
midiOutShortMsg(h_midiout, xSByteONNormal, xCh8, B2PausedColor)
midiOutShortMsg(h_midiout, xSByteFlashPause, xCh8, B2PausedColor)
;tooltip, paused,100 , 100,4
return
}

if CFFMute=2  
{
midiOutShortMsg(h_midiout, xSByteONNormal, xCh7, B2UnPausedColor)
midiOutShortMsg(h_midiout, xSByteFadePlay, xCh7, B2UnPausedColor)
;tooltip, unpasued
return
}
if CFFMute=1  
{
midiOutShortMsg(h_midiout, xSByteONNormal, xCh7, B2PausedColor)
midiOutShortMsg(h_midiout, xSByteFlashPause, xCh7, B2PausedColor)
;tooltip, paused
return
}
}
exit

WMP_CHECK:
{

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
sleep 20,
sleep 20,
sleep 20,
sleep 20,
sleep 20,
sleep 20,
sleep 20,
sleep 20,
sleep 20,
sleep 20,
tooltip,
}
return
}

ToolTip_Off: 	
{
ToolTip,
settimer ToolTip_Off, off
return
}

WMP_Prev:
{
ControlSend , ,^b, Windows Media Player 
sleep 300
wmp := new RemoteWMP
media := wmp.player.currentMedia
controls := wmp.player.controls
return
}

WMP_Del: 
{
 Process, Exist, wmplayer.exe
{
wmp2del := new RemoteWMP
media2del := wmp.player.currentMedia
gosub wmp_next

;iniwrite, % media2del, Deletions.ini, yep_gone
;tooltip, test,,,6
;wmp2del.delete
try 
File2Del= % media2del.sourceURL
catch
gosub WMP_Del
FileRecycle, % File2Del
;F2dName := RegExReplace(File2Del, "^.+\\|\.[^.]+$")
tooltip, Deleted
settimer ToolTip_Off, -5000 
return
}}

;PUT STUFF HERE to run initally

^#w::
SoundGet, penises
tooltip % penises
penises:=
return

#^r::
if !bouncingthen 
{
	Global bouncingthen:=1
	SetTimer bouncing_on, -1
} else {
	Global bouncingthen:=
}
Return

bouncing_on:
bounceloc=1
bounceoffloc=0
bouncelocreal:=bounceloc + 31
bounceofflocreal=% bouncelocreal
if bouncingthen
	Loop {
	if !bouncingthen 
	break
	else
		Loop 7
			{ 
			bouncelocreal:=bounceloc + 31
			bounceofflocreal:=bounceoffloc + 31
			midiOutShortMsg(h_midiout, 144, bouncelocreal, BounceCol)
			sleep, bounceincdelay
			bounceloc := bounceloc + 1
	bounceofflocreal:=bouncelocreal -1
	sleep 10
			midiOutShortMsg(h_midiout, 132, bounceofflocreal, BounceCol)
	;bounceoffloc := bounceoffloc + 1
			}
		Loop 7
			{ 
			bouncelocreal:=bounceloc + 31
			bounceofflocreal:=bounceoffloc + 31
			midiOutShortMsg(h_midiout, 144, bouncelocreal, fun)
			sleep, bounceincdelay
			bounceloc := bounceloc - 1
			bounceofflocreal:=bouncelocreal +1
	sleep 10
			;bounceoffloc :=  bounceloc
			midiOutShortMsg(h_midiout, 130, bounceofflocreal, BounceCol)

	;bounceoffloc := bounceoffloc - 1
			}
		}
	else return

#t::
{
NoteVel := NoteVel - 1
midiOutShortMsg(h_midiout, Sbyte, Mnote, NoteVel)
return
 }

/* 
#y::
{
NoteVel := NoteVel + 1
midiOutShortMsg(h_midiout, Sbyte, mnote, NoteVel)
return
}
 */

#h::
{
Sbyte := Sbyte - 1
midiOutShortMsg(h_midiout, Sbyte, mnote, 69)
return
 }
 

#j::
{
Sbyte := Sbyte + 1
midiOutShortMsg(h_midiout, Sbyte, mnote, 69)
return
}



#n::
{
Mnote := Mnote - 1
midiOutShortMsg(h_midiout, Mnote, mnote, 69)
return
 }
 

#^m:: ;finder
{
;tooltip test
Mnote := Mnote + 1
midiOutShortMsg(h_midiout, Sbyte, mnote, 69)
return
}

^p::
fun:=fun+1
return

#!t::
{
DBGTT := !DBGTT
if DBGTT
settimer, SumTest, 750
return
}

old2new:
{
asongold=% asong
return
}

Song_Compare:
{
if (asong=asongold)
{
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
{
;tooltip, nochange pstate,400,300,5
}

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


SumTest:
{
	testa=%byte2% + %byte1% + %statusbyte%
	sleep 300
	ifnotequal, testa, (%byte2% + %byte1% + %statusbyte%)
	 {
		Menu, Tray, Icon, akaiapc_322.ico
		ToolTip, byte1 = %byte1% `nbyte2 = %byte2% `nstatusbyte = %statusbyte% %wMsg% `nBank = %Bank% `nMaster volume %master_volume%`n%Pstate_answer% new`nold %Pstate_answer_old%
		 , 4000, 2000, 8
		sleep 50
		testa:=(%byte2% + %byte1% + %statusbyte%)
	}
	Else
	{
		Menu, Tray, Icon, akaiapc_32.ico
		ToolTip,
		Return,
	}
}


;iniRead, playstateini, wmp.ini, status
;midiOutShortMsg(h_midiout, statusbyte, note, byte2) ; call the midi funcitons with these params.

Return

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
	} Else {		 ; no ini exists and this is either the first run or reset settings.
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
		Traytip, MIDI-IN Error, midi out port out of range, ,32
	}
	Else
	{
		MidiIn := 1 ; setting var to non-error state or valid
	}
	; ----- out port selection test based on numports2
	If MidiOutDevice not Between 0 and %numports2%
	{
		MidiOut := 0 ; set var to 0 as Error state.
		If (MidiOutDevice = "") ; if blank
		MidiOutErr = Midi Out Port EMPTY. ; set this error message
		;MsgBox, 0, , midi o port EMPTY
		If (midiOutDevice > %numports2%) ; if greater than number of availble ports
		MidiOutErr = Midi Out Port Out Invalid. ; set this error message
		Traytip, MIDI-OUT Error, midi out port out of range, ,32
	}
	Else
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
	Else
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
Else IfMsgBox Yes
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
		If (result OR ErrorLevel)
		{
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
		Traytip, MIDI ERROR, UNABLE TO OPEN OUTPORT, 32
		sleep 2000
		gosub, midiout
		;tooltip, There was an Error opening the midi port.`nError code %result%`nErrorLevel = %ErrorLevel%
		Return -1
	}
	Return UInt@(&strh_midiout)
}

midiOutShortMsg(h_midiout, MidiStatus, Param1, Param2) { ;Channel,
;h_midiout: handle to midi output device returned by midiOutOpen
;EventType, Channel combined -> MidiStatus byte: http://www.harmony-central.com/MIDI/Doc/table1.html
;Param3 should be 0 for PChange, ChanAT, or Wheel
;Wheel events: entire Wheel value in Param2 - the function splits it into two bytes
/*
If (EventType = "NoteOn" OR EventType = "N1")
MidiStatus := 143 + Channel
Else If (EventType = "NoteOff" OR EventType = "N0")
MidiStatus := 127 + Channel
Else If (EventType = "CC")
MidiStatus := 175 + Channel
Else If (EventType = "PolyAT" OR EventType = "PA")
MidiStatus := 159 + Channel
Else If (EventType = "ChanAT" OR EventType = "AT")
MidiStatus := 207 + Channel
Else If (EventType = "PChange" OR EventType = "PC")
MidiStatus := 191 + Channel
Else If (EventType = "Wheel" OR EventType = "W") {
MidiStatus := 223 + Channel
Param2 := Param1 >> 8 ; MSB of wheel value
Param1 := Param1 & 0x00FF ; strip MSB
}
*/
result := DllCall("winmm.dll\midiOutShortMsg", UInt,h_midiout, UInt, MidiStatus|(Param1<<8)|(Param2<<16), UInt)
;Menu, Tray, Icon, akaiapc_322.ico
If (result or ErrorLevel) {
	;MsgBox There was an Error Sending the midi event: (%result%`, %ErrorLevel%) ; pass back to reload script as this was occuring intermittently.
	midiOutClose(h_midiout)
	gosub, MidiPortRefresh
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
   __New()  {
      static IID_IOleClientSite := "{00000118-0000-0000-C000-000000000046}"
           , IID_IOleObject     := "{00000112-0000-0000-C000-000000000046}"
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
   
   __Delete()  {
      if !this.player
         Return
      DllCall(NumGet(NumGet(this.ole+0)+3*A_PtrSize), "Ptr", this.ole, "Ptr", 0)
      for k, obj in [this.ole, this.ocs, this.rms]
         ObjRelease(obj)
      this.player := ""
   }
   
   Jump(sec)  {
      this.player.Controls.currentPosition += sec
   }
   
	Pstate()  {
	if (Pstate_answer=42) { ; a token declaring as a num for init
			gosub old2new  ;tooltip, INIT 
			Pstate_answer = % this.player.playState
			Pstate_answer_old = % this.player.playState
			gosub update_lights
			return
		} else {
		try
		{
			Pstate_answer :=  this.player.playState
		}
		Catch
		{
			sleep 250
			try
			{
				Pstate_answer :=  this.player.playState
			}
			Catch
			{
				sleep 250
				try
				{
					Pstate_answer :=  this.player.playState
				}
				Catch
				{
					sleep 250
					try
					{
						Pstate_answer :=  this.player.playState
					}
					Catch
					{
						sleep 250
						try
						{
							Pstate_answer :=  this.player.playState
}}}}} ;¬¬¬¬¬¬
		;sleep 1000
		gosub Song_Compare
		return
	}}
	
   TogglePause() {
      if (this.player.playState = 3)  ; Playing = 3
         this.player.Controls.pause()
      else
         this.player.Controls.play()
   }
   
}

IWMPRemoteMediaServices_CreateInstance() {
   static vtblUnk, vtblRms, vtblIsp, vtblOls, vtblPtrs := 0, size := (A_PtrSize + 4)*4 + 4
   if !VarSetCapacity(vtblUnk)  {
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
   if !VarSetCapacity(IID_IUnknown)  {
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

   if DllCall("ole32\IsEqualGUID", "Ptr", riid, "Ptr", &IID_IOleClientSite)  {
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
	TrayTip, Windows Media Player, Process found but window Not,3000,2
	Return
}
Else
	{
		oldsong:=newsong
		PostMessage, 0x111, Stop, 0, ,%WinTitle%
		sleep, 50
		PostMessage, 0x111, Next, 0, ,%WinTitle%
		sleep 50
		thecall1:
		gosub thetry
		if newsong =% oldsong
		{
			traytip Windows Media Player, End of Playlist		
			;tooltip, newsong = oldsong
			exit
		}
		else
		{
			wmp.jump(skipD)
			sleep 100
			PostMessage, 0x319, 0, Play, ,%WinTitle%
			;tooltip, congrats you changed to the next tune bell
		}
	}
return

WMP_Refresh: 
{
	wmp := new RemoteWMP
	media := wmp.player.currentMedia
	controls := wmp.player.controls
	return
}

THETRY:
{
	sleep, 200
	gosub WMP_refresh
	sleep 200
	newsong= % media.sourceURL
	sleep 200
	return
}

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
	
	__Delete()
	{
		for k, pISAV in this.ISAVs
			ObjRelease(pISAV)
	}
	
	AdjustVolume(Amount)
	{
		return this.SetVolume(this.GetVolume() + Amount)
	}
	
	GetVolume()
	{
		for k, pISAV in this.ISAVs
		{
			VA_ISimpleAudioVolume_GetMasterVolume(pISAV, fLevel)
			return fLevel * 100
		}
	}
	
	SetVolume(level)
	{
		level := level>100 ? 100 : level<0 ? 0 : level ; Limit to range 0-100
		for k, pISAV in this.ISAVs
			VA_ISimpleAudioVolume_SetMasterVolume(pISAV, level / 100)
		return level
	}
	
	GetMute()
	{
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
		, "UInt", False  ; BOOL  bInheritHandle
		, "UInt", PID    ; DWORD dwProcessId
		, "UPtr")
		dwSize := VarSetCapacity(strExeName, 512 * A_IsUnicode, 0) // A_IsUnicode
		DllCall("QueryFullProcessImageName"
		, "UPtr", hProcess  ; HANDLE hProcess
		, "UInt", 0         ; DWORD  dwFlags
		, "Str", strExeName ; LPSTR  lpExeName
		, "UInt*", dwSize   ; PDWORD lpdwSize
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
return

rainbow:
{
	loop
	{
		loop 128 {
			midiOutShortMsg(h_midiout, Sbyte, mnote, bowcol)
			bowcol:=bowcol+1
		}
	}
	loop 128 {			
		midiOutShortMsg(h_midiout, Sbyte, mnote, bowcol)
		bowcol:=bowcol-1
	}
	return
}

Toggle_midi_In_out:
if MidiInDevice = 1
	MidiInDevice = 0
else MidiInDevice = 1
if MidiOutDevice = 0
	MidiOutDevice = 1
else MidiOutDevice = 0
gosub, MidiPortRefresh ; used to refresh the input and output port lists - see label below
port_test(numports,numports2) ; test the ports - check for valid ports?
gosub, midiin_go ; opens the midi input port listening routine
gosub, midiout ; opens the midi out port
return


Restart_plx:
Reload

;credits to Orbik and all the AHK forum

Open_script_folder:
Run %COMSPEC% /c explorer.exe /select`, "%A_ScriptFullPath%",, Hide
return