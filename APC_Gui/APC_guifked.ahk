#noEnv 
#persistent
#SingleInstance,	Force
sendMode, 			Input
#include 			C:\Script\AHK\- LiB\GDI+_All.ahk
setWorkingDir 		%a_scriptDir% 
;setbatchlines, 	-1
DetectHiddenWindows,On
SetTitleMatchMode, 	2
SetWinDelay, 		-1
SetControlDelay, 	-1
;SetKeyDelay, 		0

menu, tray, add, PAl GuI, Pal_GuI
  
;global nH:=80, global	nw:=80
global Rot_P_in, global Rot_Led_in, global Rot_N, global Rot_P, global Rot_Led, global RotLed_Old, global xnow, global ynow, global Y_pos_1, global X_pos_1, global X_pos_2, global sByte, global chan_num := 1, global channum_old := 1,global string, global MiDi_inout, global RXknobdata, global channel_LED, global channel_master, global initted, global inittedmast, global RotLedsLoaded, global xx, global yy, global total, global Degree_Increment, global Rotary_string2save, global RotLedsSaved, global shitarsecunt, global ALL_O, global trigger_rot_Hover, global mW := 60, global mH := 37, global AutoSave

global AutoSave := 	True
apcgui 			:= 	"Images\apctest.png"	;	Main
;apcgui 		:= 	"apctest.png"			;	Palette
knob1 			:= 	"Images\knobtest.png"	; 	replace with individual images of knobs
Rot_Mask 		:= 	"Images\mask.png" 		;	Rotary-LED Alpha-notched-Mask
channel_LED	 	:= 	"Images\channel_LED.png"
ALL_O 			:= 	"Images\LIGHTS_ALL_TEST.png"
channel_master 	:= 	"C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\Images\chmasterLED.png"
MiDi_inout		:= 	"z_in_out.ahk ahk_class AutoHotkey" 	;	Midi feedback
KNob_Ini 		:= 	"knobs.ini"
Degree_Increment:= 	-19.3					;	Rotary-LED separation offset degrees 

menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard

wm_allow()	

gosub, knob_positions_load

OnMessage(0x4a, "Receive_WM_COPYDATA") ; 0x4a is WM_COPYDATA
;; window message for the mouse left click
OnMessage(0x201, "WM_LBUTTONDOWN")
;gosub, COLOUR_SORT
gui, 	APCBackMain:New, -DPIScale +toolwindow +owner -SysMenu +AlwaysOnTop, APCBackMain ;+E0x80000
gui, 	APCBackMain:+LastFound +HwndMainhWnd
gui, 	APCBackMain:color, EEAA99 	;gui, 	APCBackMain:Show,x433 y433 w1110 h640, APCBackMain
gui, 	APCBackMain:-Caption
winSet, Transcolor, 1188AA 
winSet, Transcolor, EEAA99 
; Loop, 72 {
	; global Rot_P := a_index
	; global ("oldrot" . a_index)
; }
Loop, 16 { ; rotarys :
	C_Whole 		:= 	("cWhole" . A_index)
	gaP_Wince		:= 	("gapWince" . A_index)
	switch a_index{
		case "1": 
			Y_pos_1 := "y15", X_pos_2 := "x14" 
		case "2": 
			Y_pos_1 := "y15", X_pos_2 := ("x" . 99)
		case "3": 
			Y_pos_1 := "y15", X_pos_2 := ("x" . 181)
		case "4": 
			Y_pos_1 := "y15", X_pos_2 := ("x" . 265)
		case "5": 
			Y_pos_1 := "y15", X_pos_2 := ("x" . 349)
		case "6": 
			Y_pos_1 := "y15", X_pos_2 := ("x" . 437)
		case "7": 
			Y_pos_1 := "y15", X_pos_2 := ("x" . 520)
		case "8": 
			Y_pos_1 := "y15", X_pos_2 := ("x" . 605)
		case "9": 
			Y_pos_1 := "y228", X_pos_2 := "x758"
		case "10": 
			Y_pos_1 := "y228", X_pos_2 := "x843"
		case "11": 
			Y_pos_1 := "y228", X_pos_2 := "x927"
		case "12": 
			Y_pos_1 := "y228", X_pos_2 := "x1011"
		case "13": 
			Y_pos_1 := "y315", X_pos_2 := "x758"
		case "14": 
			Y_pos_1 := "y315", X_pos_2 := "x840"
		case "15": 
			Y_pos_1 := "y315", X_pos_2 := "x927"
		case "16": 
			Y_pos_1 := "y315", X_pos_2 := "x1011"			
	}	
	gui, 	%C_Whole%:New, +OwnDialogs +ParentAPCBackMain -DPIScale -SysMenu +ToolWindow, midi ; classname blacklisted from Aeroglass
	gui, 	%C_Whole%: +LastFound -Caption +hwnd%C_Whole%, midi ; 
	gui, 	%C_Whole%:color, 000000	;	DllCall("SetParent", "uint", %C_Whole%, "uint", MainhWnd)
	gui, 	%C_Whole%:Add, Picture,X0 Y0 w80 h80 BackgroundTrans , %knob1%	; 
	gui, 	%C_Whole%:Show, noactivate %X_pos_2% %Y_pos_1% w80 h80 , midi
	gui, 	%C_Whole%: +disabled +LastFound -Caption +hwnd%C_Whole%, midi ; 
	WinSet, Transcolor, 000000 		; 	doesnt need full alpha so this gui is done for now
	%C_Whole%dc 	:= DllCall("GetDC", "UInt", %C_Whole%)
	gui, 	APCBackMain:Show, noactivate x433 y433 w1110 h666
	gui, 	%C_Whole%: +disabled +LastFound -Caption, APCBackMain
	gui, 	%gaP_Wince%:New, +ToolWindow +OwnDialogs -Caption +disabled -DPIScale +ParentAPCBackMain +hwndhwnd%gaP_Wince% +AlwaysOnTop -SysMenu +E0x80000, midi
	hwnd%gaP_Wince% 	:= WinExist()
	;setup gdip om the wince
	pToken%A_index% := Gdip_Startup()
	pImage%A_index% := Gdip_LoadImageFromFile(Rot_Mask)
	nH:=80, nw:=80
	ynh:= ("h" . nh), ynw:= ("w" . nw)
	mDC%A_index%	:= Gdi_CreateCompatibleDC(0)
	mBM%A_index%	:= Gdi_CreateDIBSection(mDC%A_index%, nW, nH, 32)
	oBM%A_index%	:= Gdi_SelectObject(mDC%A_index%, mBM%A_index%)
	Gdip_DrawImageRectI(pGraphics%A_index%:=Gdip_CreateFromHDC(mDC%A_index%), pImage%A_index%, 0, 0, nW, nH)
	gui, 	%gaP_Wince%:Show, noactivate %X_pos_2% %Y_pos_1% h80 w80, midi
	gui, 	%gaP_Wince%: +LastFound -Caption +disabled 
	;		WinSet, Transcolor, ffffff
	gui, 	%C_Whole%:hide
 	pBitmap%A_index% := Gdip_CreateBitmapFromFile(Rot_Mask)
	; Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1)
	G%A_index%:=Gdip_GraphicsFromHDC(mdc%A_index%)
	Gdip_GraphicsClear(G%A_index%)
	Gdip_ResetWorldTransform(G%A_index%)
	Gdip_TranslateWorldTransform(G%A_index%, 40, 40)
	Gdip_RotateWorldTransform(G%A_index%, (rsot:= Rot_%A_index% * 19.3))
	Gdip_TranslateWorldTransform(G%A_index%, -40, -40)
	Gdip_DrawImage(G%A_index%, pBitmap%A_index%, 0, 0, nW, nh)
	DllCall("gdi32.dll\SetStretchBltMode", "Uint", mDC%A_index%, "Int", 5)
	DllCall("gdi32.dll\StretchBlt", "Uint",mDC%A_index%, "Int", 0, "Int", 0, "Int", nH , "Int", nH , "UInt", %C_Whole%dc, "UInt", 0, "UInt", 0, "Int", nW, "Int", nH, "UInt", "0x00440328")
	DllCall("UpdateLayeredWindow", "Uint", hwnd%gaP_Wince%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%A_index%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
}

global 	Init2 := true
;gosub, flash
gosub, 	Init_ChanLEDS
gosub, 	knob_positions_load

gui,	BGMain:New, +ParentAPCBackMain +disabled -DPIScale +toolwindow -SysMenu ;
gui,	BGMain:+LastFound +Hwndcock
gui,	BGMain:Add, Picture,x0 y0 w1122 h666 BackgroundTrans, %apcgui%
gui,	BGMain:color, EEAA99
gui,	BGMain:Show,x0 y0 w1110 h640, midi
gui,	BGMain:-Caption +disabled 

OnExit, Exitt

return

GuiEscape:
Exitapp

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
chanled_send: 
if chan_num = Channum_old
	return
if Init2
	Send_WM_COPYDATA(	("chan" . "," . chan_num), MiDi_inout) 	;send midi 
chanled:
gosub, Channel_switch
if (chan_num < 9) 										  {
	if !initted  										  {
		gosub, Init_ChanLEDS
	Loop, 8										  		  {
		Rot_P 	:= 	a_index + 8
		Rot_N		:=	Rot_P + ((chan_num -1) * 8) 
		byte1 	:= 	Rot_P + 8
		Rot_LED 	:= 	Rot_%Rot_N%
		byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
		sByte	:= 	175	+ chan_num ; knob num
		IF (floor(Rot_Led)		>	13)
			Rot_Led 			:= 	14
		else if (floor(Rot_Led)	<	0)
			Rot_Led 			:= 	0
		; if (Rot_P > 8 && Rot_P < 17 ) 			  	  {
			; byte1 	:= 	Rot_P + 7
			; sByte 	:= 	chan_num + 175 
			; byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
		; } else 									  	  {
			; byte1 	:= 	Rot_P + 47
			; sByte	:= 	175	+ chan_num; knob num
			; byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
		; }
		string	:= 	(sByte . "," . byte1 . "," . byte2)
		if Init2 										  {
			Send_WM_COPYDATA(string, MiDi_inout)	
			gosub, Knob_Upd8
		}	}
	} else {
		if channum_old = 9 
			gui, chanledmaster:hide,
		gui, chanled:hide
		sleep 10
		cW := 87, cH := 39
		gui, chanled:Show, noactivate %xx% %yy% w%cW% h%cH%, midi	
		gui, chanled: -Caption +disabled 
		Loop, 8											  {
			Rot_P 	:= 	a_index + 8
			Rot_N	:=	Rot_P + ((chan_num -1) * 8) 
			Rot_LED := 	Rot_%Rot_N%
			IF (floor(Rot_Led)		>	13)
				Rot_Led 			:= 	14
			else if (floor(Rot_Led)	<	0)
				Rot_Led 			:= 	0
			if (Rot_P > 8 && Rot_P < 17 ) 				  {
				byte1 	:= 	Rot_P + 7
				sByte 	:= 	chan_num + 175 
				byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
			} else 										  {
				byte1 	:= 	Rot_P + 47
				sByte	:= 	176	; knob num
				byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
			}
			string	:= 	(sByte . "," . byte1 . "," . byte2)
			Send_WM_COPYDATA(string, MiDi_inout)	
			;gosub, Knob_Upd8 ;update gui lights
			gosub, Knob_Upd8
	}	}					
} else {
	if channum_old < 9 
		gui, chanled:hide,
	cW := 60, cH := 37
	gui, chanledmaster:Show,%xx% %yy% w%cW% h%cH%, midi
	Loop, 8									{
		Rot_P := 	a_index + 8
		Rot_N	:=	Rot_P + ((chan_num -1) * 8) 
		Rot_LED := 	Rot_%Rot_N%
		
		IF (floor(Rot_Led)		>	13)
			Rot_Led 			:= 	14
		else if (floor(Rot_Led)	<	0)
			Rot_Led 			:= 	0
		
		if (Rot_P > 8 && Rot_P < 17 ) 		{
			byte1 	:= 	Rot_P + 7
 			sByte 	:= 	chan_num + 175 
			byte2	:= 	FLOOR(9.07 * Rot_Led)	; value

		} else 								{
			byte1 	:= 	Rot_P + 47
			sByte	:= 	176	; knob num
			byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
		}
		string	:= 	(sByte . "," . byte1 . "," . byte2)
		;gosub, Knob_Upd8 ;update gui lights
		Send_WM_COPYDATA(string, MiDi_inout)	
		gosub, Knob_Upd8
}	}

channum_old:= chan_num
return

Channel_switch:
switch chan_num {
	case "1":
		xx := "x" . 8, yy := "y357"
	case "2":
		xx := "x" . 93 yy := "y357"
	case "3":
		xx := "x" . 177, yy := "y357"
	case "4":
		xx := "x" . 263, yy := "y357"
	case "5":
		xx := "x" . 347, yy := "y357"
	case "6":
		xx := "x" . 434, yy := "y357"
	case "7":
		xx := "x" . 517, yy := "y357"
	case "8":
		xx := "x" . 601, yy := "y357"
	case "9":
		xx := "x" . 687, yy := "y358"
}
return

Knob_Upd8:
if !Rot_%Rot_N%
	Rot_%Rot_N% := 7
Gdip_GraphicsClear(G%Rot_P%)
Gdip_ResetWorldTransform(G%Rot_P%)
Gdip_TranslateWorldTransform(G%Rot_P%, 40, 40)
Gdip_RotateWorldTransform(G%Rot_P%, (rsot := floor(Rot_%Rot_N% * 19.3)))
Gdip_TranslateWorldTransform(G%Rot_P%, -40, -40)
Gdip_DrawImage(G%Rot_P%, pBitmap%Rot_P%, 0, 0, nW, nh)
DllCall("gdi32.dll\StretchBlt","Uint",mDC%Rot_P%, "Int",0, "Int",0, "Int", nH , "Int", nH , "UInt", cWhole%Rot_P%dc, "UInt",0, "UInt",0, "Int",nW, "Int",nH, "UInt", "0x00440328")
DllCall("UpdateLayeredWindow", "Uint", hwndgapWince%Rot_P%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%Rot_P%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
return

WM_LBUTTONDOWN(wParam, lParam) {
	global xxx := lParam & 0xFFFF
	global yyy := lParam >> 16
    if A_GuiControl
        Ctrl := "`n(in control " . A_GuiControl . ")"
	if ((yyy < 94) && (xxx < 685)) {
		if xxx between 1 and 98 
			Rot_P	:=	1
		if xxx between 98 and 178 
			Rot_P	:=	2
		if xxx between 179 and 264
			Rot_P	:=	3
		if xxx between 265 and 343
			Rot_P	:=	4
		if xxx between 344 and 428
			Rot_P	:=	5
		if xxx between 429 and 513
			Rot_P	:=	6
		if xxx between 514 and 604
			Rot_P	:=	7
		if xxx between 605 and 684 
			Rot_P	:=	8
	} else {
		if (yyy < 310) {
		tooltip, % xxx " " yyy,,,2

			if xxx between 744 and 842
				Rot_P := 9
			else
			if xxx between 843 and 927
				Rot_P	:= 10
			else
			if xxx between 928 and 1010
				Rot_P	:=	11
			else
			if xxx between 1011 and 1093
				Rot_P	:=	12
		} else {
			if xxx between 758 and 842
				Rot_P	:=	13
			else if xxx between 843 and 927
				Rot_P	:=	14
			else if xxx between 928 and 1010
				Rot_P	:=	15
			else if xxx between 1011 and 1093 
				Rot_P	:=	16 ;1792 mmsg offset 
			else {
				if xxx between 10 and 94
					shitsendled("1")	
				else if xxx between 95 and 179
					shitsendled("2")
				else if xxx between 180 and 262
					shitsendled("3")
				else if xxx between 263 and 346
					shitsendled("4")
				else if xxx between 347 and 434
					shitsendled("5")
				else if xxx between 435 and 518
					shitsendled("6")
				else if xxx between 519 and 602
					shitsendled("7")
				else if xxx between 603 and 686
					shitsendled("8")
				else if xxx between 687 and 743
					shitsendled("9")
			}
			trigger_rot_Hover := false
	}	}

	if (floor(xxx)>1025 && floor(xxx)<1067 && floor(yyy)<104 && floor(yyy)>30) 
		exitapp										   ; the "0" of apc40

	if (GetKeyState("Lbutton", "P")) 									{
		if !trigger_rot_Hover  													{
			while (GetKeyState("Lbutton", "P")) 						{
				mousegetpos, , ynow				; xres := floor(x - xnow)
				if Rot_P > 8
					Rot_N	:=	Rot_P + ((chan_num -1) * 8) 
				else rot_n 	:= Rot_P
				yres := (yyy - ynow),	 yyY 	:= 	YNOW		  ; value
				Rot_LED := format("{:g}", 	(Rot_%Rot_N% + (yres * 0.1))) 
				IF (floor(Rot_Led)		>	13)
					Rot_Led 			:= 	14
				else if (floor(Rot_Led)	<	0)
					Rot_Led 			:= 	0
				Rot_%Rot_N% := Rot_LED
				ROT_%Rot_N% 			:= 	Rot_Led
				if ( ( Rot_P > 8) && (Rot_P < 17 ) )					{
					byte11 	:= 	Rot_P 	+ 7
					sBytee 	:= 	chan_num 	+ 175 
					byte22	:= 	FLOOR(9.07 	* Rot_Led)		  	  ; value
				} else 													{
					byte11 	:= 	Rot_P 	+ 47
					sBytee	:= 	176
					byte22	:= 	FLOOR(9.07 	* Rot_Led)		  	  ; value
				}
				string	:= 	(sBytee . "," . byte11 . "," . byte22)
				gosub, Knob_Upd8 				   	  ; update gui lights
				Send_WM_COPYDATA(string, MiDi_inout)  ; 		send midi 	 
			}	
			oldrot%Rot_N% := Rot_%Rot_N%
			trigger_rot_Hover := false
			return
}	}	}		
	
Receive_WM_COPYDATA(wParam, lParam) 		{
	StringAddress := NumGet(lParam + 2*A_PtrSize)
	WmCoppOffData := StrGet(StringAddress) 
	Loop, Parse, WmCoppOffData, `, 
	{
		if (a_index = "1")					{
			IF A_LoopField CONTAINS CH 
				RXknobdata := A_LoopField
			else IF (A_LoopField = "HIDE") 	{
				msgbox hide me				
				return
			} 
			else IF (A_LoopField = "SHOW") 	{	
				msgbox show me				
				return
			} 
			else sByte := a_loopfield
		}
		if (a_index = "2") 					{
			if (A_LoopField = "cunt") 		{
				chan_num := strreplace(RXknobdata, "CH") 
				if chan_num != channum_old
				{
					gosub, chanled_send
					gosub, rotupd8
					channum_old := Chan_num
				}
				RETURN
			 } else { 
				Rot_P 	:= 	a_loopfield
				Rot_N	:=	Rot_P + ((chan_num -1) * 8) 
		}	}	
		if (a_index = "3") { 
			Rot_Led 	:= a_loopfield
			Rot_%Rot_N% := Rot_Led
		}
		if  Rot_Led 	!= RotLed_Old
		{	
			RotLed_Old 	:= Rot_Led
			gosub, Knob_Upd8	
}	}	}

Send_WM_COPYDATA(StringToSend, MiDi_inout)	{
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0) 
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize) 
	NumPut(&StringToSend, CopyDataStruct, 2 * A_PtrSize)
	SendMessage, 0x4a, 0, &CopyDataStruct,, % MiDi_inout
	return ErrorLevel
}

; flash:
; Loop, 3 {
	; gui, ALL_ON:hide
	; sleep 600
	; gui, ALL_ON:Show,x-7 y0 w1110 h540
	; sleep 300
; }
; gui, 	 ALL_ON:hide
; gosub, 	Knob_Upd8
; return


knob_positions_load:
sByte := 176 		;		channel 1 rotarys (applies to right side apc rotarys)

IniRead, RotLedsLoaded, C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\knobs.ini, knobs, KnobsLED
sleep 750
loop 3
	if InStr(RotLedsLoaded, ",,")
		RotLedsLoaded := strreplace(RotLedsLoaded, ",," , ",7,")
if InStr(RotLedsLoaded, ",,")
	msgbox, 1, % "i found the canka. DEL?"
ifmsgbox, yes
{
	gosub, delete_ini
	gosub, knob_positions_save
}
if (RotLedsLoaded = "ERROR" ) {
	msgbox rotload error
	goto, delete_ini
}
gosub, 	Rotary_load7s
return

gosub, 	delete_ini
gosub, 	knob_positions_save
gosub, 	knob_positions_save_Writeini
traytip,% "Error!",% "Loading knobs encountered an error"
global 	donotsavenow := True
gosub, 	delete_ini
return

Rotary_load7s:
Loop, parse, RotLedsLoaded, `,
{
	if rot_%A_index% != ""
	{
		if (rot_%A_index% > 13)
			rot_%A_index% := 13
		else rot_%A_index% =% A_loopfield
	} else rot_%A_index% := 7
}
return

Loop, parse, RotLedsLoaded, `,
{			
	global ("Rot_" . a_index) 
	rot%A_index% := A_LoopField
	rot%A_index% := A_LoopField
	total := a_index
}
if (total != "72") {
	msgbox total %total%
	gosub, delete_ini
}
else gosub, rotupd16
return

delete_ini:
filedelete, C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\knobs.ini
Loop, 72 {
	cuntyfucknig := ("Rot_" . a_index)
	%cuntyfucknig% := 7
	if 	!shitarsecunt
		 shitarsecunt:= 7
	else shitarsecunt:= shitarsecunt . ",7"
}

; else 
; msgbox totalcunt %total% 
sByte := 176
Loop, 16 {
		byte1 	:= 	a_index		; 	knob num
	byte2 	:= 	floor(9.07 * 7)
	string 	:= 	(sByte . "," . byte1 . "," . byte2)
;	Send_WM_COPYDATA(string, MiDi_inout)
	;gosub, Knob_Upd8
}

return

knob_positions_save:
Loop, 72 {
if(A_index = "1")
Rotary_string2save 	:=  ROT_%A_INDEX%

else 
	Rotary_string2save 	:= 	(Rotary_string2save . "," .  ROT_%A_INDEX%)	

	}

msgbox % Rotary_string2save
IniWrite, %Rotary_string2save%, % KNob_Ini, knobs, KnobsLED
return

Loop, parse, RotLedsSaved, `,
	total:=a_index
	msgbox % RotLedsSaved
return

knob_positions_save_Writeini:
return
if RotLedsLoaded = RotLedsSaved
{
	tooltip, No changes no save
	sleep 1700
} else if donotsavenow {
	RotLedsSaved := shitarsecunt
filedelete, C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\knobs.ini
tooltip deleting CANCERs	
	}

sleep 1000

return

Knobs_DestroyDcs: 	; 	leaves image on display
Loop, 16 {
	SelectObject(mDC%A_index%, obm%A_index%) 
	DeleteObject(mBM%A_index%)
	DeleteDC(%C_Whole%dc)
	Gdip_DeleteGraphics(G%A_index%), 
	Gdip_DisposeImage(pBitmap%A_index%)
	Gdip_Shutdown(pToken%A_index%)
}
return

Exitt:
gosub, knob_positions_save
; if autosave
	; gosub, knob_positions_save_Writeini
gosub, Knobs_DestroyDcs
exitapp

Open_ScriptDir:
tooltip, %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return

Init_ChanLEDS:
mW := 60, mH := 37
gui, 	chanledmaster:New, +ParentAPCBackMain -DPIScale +toolwindow +disabled -SysMenu +E0x80000, midi ;
gui, 	chanledmaster: +LastFound +Hwndhwndchannel_LEDmaster -Caption 
mGui 	:= WinExist()
mToken	:= Gdip_Startup()
mImage	:= Gdip_LoadImageFromFile("C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\Images\chmasterLED.png")
mW 		:= 60, mH := 37
mmDC 	:= Gdi_CreateCompatibleDC(0)
mmBM 	:= Gdi_CreateDIBSection(mmDC, mW, mH, 32)
moBM 	:= Gdi_SelectObject(mmDC, mmBM)
gui, chanledmaster:Show , noactivate x687 y358 w%mW% h%mH%, midi
gui, chanledmaster: -Caption +LastFound +Hwndchannel_LEDmaster -DPIScale +AlwaysOnTop +disabled
Gdip_DrawImageRectI(mGraphics:=Gdip_CreateFromHDC(mmDC), mImage, 0, 0, mW, mH)
DllCall("UpdateLayeredWindow", "Uint", mGui, "Uint", 0, "Uint", 0, "int64P", mW|mH<<32, "Uint", mmDC, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
GDI_SelectObject(mmDC, moBM)
Gdi_DeleteObject(mmBM)
Gdi_DeleteDC(mmDC)
Gdip_DeleteGraphics(mGraphics)
Gdip_DisposeImage(mImage)
gui, chanledmaster:hide
gui, 	chanled:New, +ParentAPCBackMain -DPIScale +toolwindow +disabled -SysMenu +E0x80000, midi ;
gui, 	chanled:+LastFound +Hwndchannel_LED -Caption 
cGui 	:= WinExist()
lToken	:= Gdip_Startup()
IImage	:= Gdip_LoadImageFromFile("C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\Images\channel_LED.png")
cW 		:= 87, cH := 39
iDC 	:= Gdi_CreateCompatibleDC(0)
iBM 	:= Gdi_CreateDIBSection(iDC, cW, cH, 32)
ioBM 	:= Gdi_SelectObject(iDC, iBM)
gui, chanled:Show,noactivate %xx% %yy% w%cW% h%cH%, midi
gui, chanled: -Caption +hwndchannel_LED -DPIScale +disabled
Gdip_DrawImageRectI(iGraphics:=Gdip_CreateFromHDC(iDC), IImage, 0, 0, cW, cH)
DllCall("UpdateLayeredWindow", "Uint", cGui, "Uint", 0, "Uint", 0, "int64P", cW|cH<<32, "Uint", iDC, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
GDI_SelectObject(iDC, ioBM)
Gdi_DeleteObject(iBM)
Gdi_DeleteDC(iDC)
Gdip_DeleteGraphics(iGraphics)
Gdip_DisposeImage(IImage)
Gdip_Shutdown(lToken) 
	initted := true

return

shitsendled(cha) {
	trigger_rot_Hover:= true
	chan_num := cha	
	settimer, chanled_send, -1
	settimer, rotupd8, -1
}

rotupd8:
Loop, 8 {
	Rot_PM := a_index + 8
		byte111 	:= 	Rot_PM + 7
	IF CHAN_NUM > 1 
	{
		Rot_NNN	:=	Rot_PM + ((chan_num -1) * 8) 
		sByteEE	:= 	175	+ chan_num ; num
	} ELSE {
		sByteEE	:= 	176
		Rot_NNN := Rot_PM
	}
		Rot_LEDD 	:= 	FLOOR(9.07 * Rot_%Rot_NNN%)	
		Rot_P := Rot_PM
		ROT_N:= Rot_NNN
		gosub, Knob_Upd8
		Send_WM_COPYDATA((sByteEE . "," . byte111 . "," . Rot_LEDD), MiDi_inout)	
	}	
return
rotupd16:

Loop, 16 {
	RT_nN := a_index
	RT_N	:=	RT_nN + ((chan_num -1) * 8) 
			Rot_LEDDDD 	:= FLOOR(9.07 * Rot_%RT_N%)		
			;byte2	:= 	; value
		IF a_INDEX > 8
		{
			byte1111 	:= 	RT_nN + 7
	IF CHAN_NUM > 1
				sByteW	:= 	175	+ chan_num ; num
			ELSE
				sByteW	:= 	176
		} ELSE {
					sByteW	:= 	176
				byte1111 	:= 	RT_nN +47
				}
			; if (RT_nN > 8 && RT_nN < 17 ) 	{
				; byte1 	:= 	RT_nN + 7
				; sByteW 	:= 	chan_num + 175 
				; byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
			; } else 								{
				; byte1 	:= 	RT_nN + 47
				; sByteW	:= 	175	+ chan_num; knob num
				; byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
			; }
	Send_WM_COPYDATA(	(sByteW . "," . byte1111 . "," . Rot_LEDDDD), MiDi_inout)	
	Rot_P := RT_nN
	ROT_N:= RT_N
	gosub, Knob_Upd8
}
gosub, Knob_Upd8
return

Pal_GuI:
run, % ( "C:\Program Files\Autohotkey\AutoHotkeyU64.exe " . "C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\pal.ahk" )
return



