#noEnv 
#persistent
#SingleInstance force
sendMode Input
#include C:\Script\AHK\- LiB\GDI+_All.ahk
setWorkingDir %a_scriptDir% 
;setbatchlines -1
DetectHiddenWindows On
SetTitleMatchMode 2

;SetControlDelay, 	0
;SetKeyDelay, 		0
global faggotomg ;global nH:=80, global	nw:=80
global Rot_Num_in, global Rot_Led_in, global Rot_N, global Rot_Num, global Rot_Led, global RotLed_Old, global xnow, global ynow, global Y_pos_1, global X_pos_1, global X_pos_2, global sByte, global chan_num := 1, global channum_old := 1,global string, global MiDi_inout, global gayniggers, global boner, global channel_LED, global channel_master, global initted, global inittedmast, global RotLedsLoaded
global total 
global anus
global RotLedsSaved
global shitarsecunt
global shitty 
global ALL_O 
global mW := 60
global mH := 37
global notarotta
global autosave := 	True
apcgui 			:= 	"Images\apctest.png"	;	Main
knob1 			:= 	"Images\knobtest.png"	; 	replace with individual images of knobs
Rot_Mask 		:= 	"Images\mask.png" 		;	Rotary-LED Alpha-notched-Mask
channel_LED	 	:= 	"Images\channel_LED.png"
channel_master 	:= 	"C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\Images\chmasterLED.png"
wm_allow()	

Anus 			:= 	-19.3					;	Rotary-LED separation offset degrees 
MiDi_inout		:= 	"z_in_out.ahk ahk_class AutoHotkey" 	;	Midi feedback
KNob_Ini 		:= 	"knobs.ini"
ALL_O 	:= 	"Images\LIGHTS_ALL_TEST.png"

menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard

OnMessage(0x4a, "Receive_WM_COPYDATA") ; 0x4a is WM_COPYDATA
		;; window message for the mouse left click
OnMessage(0x201, "WM_LBUTTONDOWN")
gosub COLOUR_SORT
gui, 	APCBackMain:New, -DPIScale +toolwindow +owner -SysMenu +AlwaysOnTop, APCBackMain ;+E0x80000
gui, 	APCBackMain:+LastFound +HwndMainhWnd
gui, 	APCBackMain:color, EEAA99 	;gui, 	APCBackMain:Show,x433 y433 w1110 h640, APCBackMain
gui, 	APCBackMain:-Caption

winSet, Transcolor, 1188AA 
winSet, Transcolor, EEAA99 


; rotarys :
gosub knob_positions_load
 
loop 16 {
	global Rot_Num := a_index
	global ("oldrot" . a_index)

	;sFile%A_index% 	:= Rot_Mask
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
	gui, 	%C_Whole%:New, +OwnDialogs -Caption +ParentAPCBackMain -DPIScale +AlwaysOnTop -SysMenu +ToolWindow, midi ; classname is blacklisted from Aeroglass, will be using for all controls ;Layerr%A_index% 
	gui, 	%C_Whole%: +LastFound -Caption +hwnd%C_Whole%, midi ; 
	gui, 	%C_Whole%:color, 000000	;	DllCall("SetParent", "uint", %C_Whole%, "uint", MainhWnd)
	gui, 	%C_Whole%:Add, Picture,X0 Y0 w80 h80 BackgroundTrans , %knob1%	; 
	gui, 	%C_Whole%:Show, %X_pos_2% %Y_pos_1% w80 h80 , midi
	WinSet, Transcolor, 000000 		; 	doesnt need full alpha so this gui is done for now
	%C_Whole%dc 	:= DllCall("GetDC", "UInt", %C_Whole%)

	gui, 	APCBackMain:Show,x433 y433 w1110 h666, APCBackMain

	gui, 	%gaP_Wince%:New, -DPIScale +ParentAPCBackMain +hwndhwnd%gaP_Wince% -SysMenu +E0x80000, midi
	gui, 	%gaP_Wince%: +LastFound -Caption	; DllCall("SetParent", "uint", hwnd%gaP_Wince%, "uint", MainhWnd)
	hwnd%gaP_Wince% 	:= WinExist()
	;setup gdip om the wince
	pToken%A_index% := Gdip_Startup()
	pImage%A_index% := Gdip_LoadImageFromFile(Rot_Mask)
	nH:=80,	nw:=80	;noW%A_index%	:= Gdip_GetImageWidth2(pImage%A_index%)	;noH%A_index%	:= Gdip_GetImageHeight2(pImage%A_index%) ;nh := (noH%A_index%), 	nw := (noW%A_index%)	
	ynh:= ("h" . nh), 		ynw:= ("w" . nw)
	mDC%A_index%	:= Gdi_CreateCompatibleDC(0)
	mBM%A_index%	:= Gdi_CreateDIBSection(mDC%A_index%, nW, nH, 32)
	oBM%A_index%	:= Gdi_SelectObject(mDC%A_index%, mBM%A_index%)
	Gdip_DrawImageRectI(pGraphics%A_index%:=Gdip_CreateFromHDC(mDC%A_index%), pImage%A_index%, 0, 0, nW, nH)
	
	;DllCall("gdi32.dll\SetStretchBltMode", "Uint", mDC%A_index%, "Int", 5)
	;DllCall("gdi32.dll\StretchBlt", "Uint", mDC%A_index%, "Int", 0, "Int", 0, "Int", nH , "Int", nH , "UInt", %C_Whole%dc, "UInt", 0, "UInt", 0, "Int", nW, "Int", nH, "UInt", "0x00440328")
	;DllCall("UpdateLayeredWindow", "Uint", hwnd%gaP_Wince%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%A_index%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
	;	DllCall("SetParent", "uint", hwnd%gaP_Wince%, "uint", MainhWnd)
	gui, 	%gaP_Wince%:Show, %X_pos_2% %Y_pos_1% h80 w80, midi
	gui, 	%gaP_Wince%: +LastFound -Caption 
	;		WinSet, Transcolor, ffffff
	gui, 	%C_Whole%:hide

 	pBitmap%A_index% := Gdip_CreateBitmapFromFile(Rot_Mask)
	; Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1)	; Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh)
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
	;if A_index > 1
		;DllCall("SetParent", "uint", %C_Whole%, "uint", hwndgapWince1)
	;else if A_index = 1
		;DllCall("SetParent", "uint", hwndgapWince1, "uint", MainhWnd)
}
;gosub allon
gosub knob_positions_load
gosub chanled_send
sleep 200
gui, 	 cockMain:New, +ParentAPCBackMain -DPIScale +toolwindow -SysMenu ;
gui, 	 cockMain:+LastFound +Hwndcock
gui, 	 cockMain:Add, Picture,x0 y0 w1122 h666 BackgroundTrans, %apcgui%
gui, 	 cockMain:color, EEAA99
gui, 	 cockMain:Show,x0 y0 w1110 h640, midi
gui, 	 cockMain:-Caption

; loop 3 {
	; gui, ALL_ON:hide
	; sleep 600
	; gui, ALL_ON:Show,x-7 y0 w1110 h540
	; sleep 300
; }
; gui, 	 ALL_ON:hide
; gosub 	Knob_Upd8
global INITCUNT := true
OnExit, Exitt
return

GuiEscape:
ExitApp

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

chanled_send(chun) {
 Send_WM_COPYDATA(	("chan" . "," . (chan_num:=chun)), MiDi_inout) 	;send midi 
}
chanled_send: 
if chan_num = Channum_old
return
if INITCUNT
 Send_WM_COPYDATA(	("chan" . "," . chan_num), MiDi_inout) 	;send midi 


chanled:
gosub Channel_switch
if chan_num < 9
{
	if !initted {
		initted := true
		mW := 60, mH := 37
	gui, 	chanledmaster:New, +ParentAPCBackMain -DPIScale +toolwindow -SysMenu +E0x80000, midi ;
		gui, 	chanledmaster: +LastFound +Hwndhwndchannel_LEDmaster -Caption 
		mGui 	:= WinExist()
		mToken	:= Gdip_Startup()
		mImage	:= Gdip_LoadImageFromFile("C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\Images\chmasterLED.png")
		mW 		:= 60, mH := 37
		mmDC 	:= Gdi_CreateCompatibleDC(0)
		mmBM 	:= Gdi_CreateDIBSection(mmDC, mW, mH, 32)
		moBM 	:= Gdi_SelectObject(mmDC, mmBM)
			gui, chanledmaster:Show, x687 y358 w%mW% h%mH%, midi
		gui, chanledmaster: -Caption +AlwaysOnTop +LastFound +Hwndchannel_LEDmaster -Caption -DPIScale +AlwaysOnTop +disabled -SysMenu +ToolWindow +owndialogs
		Gdip_DrawImageRectI(mGraphics:=Gdip_CreateFromHDC(mmDC), mImage, 0, 0, mW, mH)
		DllCall("UpdateLayeredWindow", "Uint", mGui, "Uint", 0, "Uint", 0, "int64P", mW|mH<<32, "Uint", mmDC, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)

		GDI_SelectObject(mmDC, moBM)
		Gdi_DeleteObject(mmBM)
		Gdi_DeleteDC(mmDC)
		Gdip_DeleteGraphics(mGraphics)
		Gdip_DisposeImage(mImage)

		gui, chanledmaster:Hide
		
		gui, 	chanled:New, +ParentAPCBackMain -DPIScale +toolwindow -SysMenu +E0x80000, midi ;
		gui, 	chanled:+LastFound +Hwndchannel_LED -Caption 
		cGui 	:= WinExist()
		lToken	:= Gdip_Startup()
		IImage	:= Gdip_LoadImageFromFile("C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\Images\channel_LED.png")
		cW 		:= 87, cH := 39
		iDC 	:= Gdi_CreateCompatibleDC(0)
		iBM 	:= Gdi_CreateDIBSection(iDC, cW, cH, 32)
		ioBM 	:= Gdi_SelectObject(iDC, iBM)
		gui, chanled:Show,%xx% %yy% w%cW% h%cH%, midi
		gui, chanled: -Caption +AlwaysOnTop +LastFound +hwndchannel_LED -Caption -DPIScale +AlwaysOnTop +disabled -SysMenu +ToolWindow +owndialogs
		Gdip_DrawImageRectI(iGraphics:=Gdip_CreateFromHDC(iDC), IImage, 0, 0, cW, cH)
		DllCall("UpdateLayeredWindow", "Uint", cGui, "Uint", 0, "Uint", 0, "int64P", cW|cH<<32, "Uint", iDC, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
		GDI_SelectObject(iDC, ioBM)
		Gdi_DeleteObject(iBM)
		Gdi_DeleteDC(iDC)
		Gdip_DeleteGraphics(iGraphics)
		Gdip_DisposeImage(IImage)
		Gdip_Shutdown(lToken) 
		loop 8									{
			rot_num 	:= 	a_index + 8
			Rot_N		:=	Rot_Num + ((chan_num -1) * 8) 
			byte1 	:= 	Rot_Num + 8
			Rot_LED 	:= 	Rot_%Rot_N%
			byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
			sByte	:= 	175	+ chan_num ; knob num
			IF (floor(Rot_Led)		>	13)
				Rot_Led 			:= 	14
			else if (floor(Rot_Led)	<	0)
				Rot_Led 			:= 	0
			; if (Rot_Num > 8 && Rot_Num < 17 ) 	{
				; byte1 	:= 	Rot_Num + 7
				; sByte 	:= 	chan_num + 175 
				; byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
			; } else 								{
				; byte1 	:= 	rot_num + 47
				; sByte	:= 	175	+ chan_num; knob num
				; byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
			; }
			string	:= 	(sByte . "," . byte1 . "," . byte2)
			if INITCUNT
						Send_WM_COPYDATA(string, MiDi_inout)	
			gosub, Knob_Upd8
		}				
	} else {
		if channum_old = 9
			gui, chanledmaster:hide,
		else if chan_num != channum_old
		{
		 
			gui, chanled:hide,
			cW := 87, cH := 39
			gui, chanled:Show,%xx% %yy% w%cW% h%cH%, midi	
			loop 8									{
				rot_num := 	a_index + 8
				Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
				Rot_LED := 	Rot_%Rot_N%
				IF (floor(Rot_Led)		>	13)
					Rot_Led 			:= 	14
				else if (floor(Rot_Led)	<	0)
					Rot_Led 			:= 	0
				
				if (Rot_Num > 8 && Rot_Num < 17 ) 	{
					byte1 	:= 	Rot_Num + 7
					sByte 	:= 	chan_num + 175 
					byte2	:= 	FLOOR(9.07 * Rot_Led)	; value

				} else 								{
					byte1 	:= 	rot_num + 47
					sByte	:= 	176	; knob num
					byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
				}
				string	:= 	(sByte . "," . byte1 . "," . byte2)
				;gosub Knob_Upd8 ;update gui lights
		Send_WM_COPYDATA(string, MiDi_inout)	
		gosub, Knob_Upd8
				}					
		
		}
	}
} else {
	if channum_old < 9 
		gui, chanled:hide,
	cW := 60, cH := 37
	gui, chanledmaster:Show,%xx% %yy% w%cW% h%cH%, midi
	loop 8									{
		rot_num := 	a_index + 8
		Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
		Rot_LED := 	Rot_%Rot_N%
		IF (floor(Rot_Led)		>	13)
			Rot_Led 			:= 	14
		else if (floor(Rot_Led)	<	0)
			Rot_Led 			:= 	0
		
		if (Rot_Num > 8 && Rot_Num < 17 ) 	{
			byte1 	:= 	Rot_Num + 7
 			sByte 	:= 	chan_num + 175 
			byte2	:= 	FLOOR(9.07 * Rot_Led)	; value

		} else 								{
			byte1 	:= 	rot_num + 47
			sByte	:= 	176	; knob num
			byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
		}
		string	:= 	(sByte . "," . byte1 . "," . byte2)
		;gosub Knob_Upd8 ;update gui lights
Send_WM_COPYDATA(string, MiDi_inout)	
				gosub, Knob_Upd8
				}
	 ;s
channum_old:= chan_num
}
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


caluclate:
if	!counta
	 counta := 1
else counta := counta +1
mousegetpos, x, y, ;wnd, cnt
if (floor(x)>1025 && floor(x)<1067 && floor(y)<104 && floor(y)>30) ; the "0" of apc40
	exitapp
if ((x < 685) && (y < 94)) {
	if x between 1 	and 98 
		Rot_Num	:=	1
	else
	if x between 98 and 178 
		Rot_Num	:=	2
	else
	if x between 179 and 264
		Rot_Num	:=	3
	else
	if x between 265 and 343
		Rot_Num	:=	4
	else
	if x between 344 and 428
		Rot_Num	:=	5
	else
	if x between 429 and 513
		Rot_Num	:=	6
	else
	if x between 514 and 604
		Rot_Num	:=	7
	else
	if x between 605 and 684 
		Rot_Num	:=	8
} else {
	if (y < 310) {
	
		if x between 744 and 842
		{
			Rot_Num := 9
		}
		else
		if x between 843 and 927
			Rot_Num	:= 10
		else
		if x between 928 and 1010
			Rot_Num	:=	11
		else
		if x between 1011 and 1093
			Rot_Num	:=	12
	} else {
	
	;1792 mmsg offset 
		
	;
		notarotta:= true

		if x between 10 and 94
			shitsendled(1)	
		else if x between 95 and 179
			shitsendled(2)
		else if x between 180 and 262
			shitsendled(3)
		else if x between 263 and 346
			shitsendled(4)
		else if x between 347 and 434
			shitsendled(5)
		else if x between 435 and 518
			shitsendled(6)
		else if x between 519 and 602
			shitsendled(7)
		else if x between 603 and 686
			shitsendled(8)
		else if x between 687 and 743
			shitsendled(9)
		else notarotta := false
		
		if x between 758 and 842
		{
			
			Rot_Num	:=	13
			}
		else
		if x between 843 and 927
		{
			Rot_Num	:=	14
			}
		else
		if x between 928 and 1010
		{
			Rot_Num	:=	15
			
			}
		else
		if x between 1011 and 1093
			Rot_Num	:=	16

}	}	


if (GetKeyState("Lbutton", "P")) 							{
if !notarotta 
	while (GetKeyState("Lbutton", "P")) 					{
	
		mousegetpos, , ynow,	;xres := floor(x - xnow)
		if rot_Num > 8
			Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
		else rot_n := rot_num
		yres := (y - ynow),	 Y 	:= 	YNOW
		Rot_LED := format("{:g}", (Rot_%Rot_N% + (yres * 0.1))) ; value
		IF (floor(Rot_Led)		>	13)
			Rot_Led 			:= 	14
		else if (floor(Rot_Led)	<	0)
			Rot_Led 			:= 	0
		;tooltip	% rot_num "`n" rot_n
		Rot_%Rot_N% := Rot_LED
	;	if !oldrot%Rot_N% || if (Rot_Led != oldrot%Rot_N%) 		{	
			ROT_%Rot_N% 		:= 	Rot_Led
			if ((Rot_Num > 8) && (Rot_Num < 17 ) )				{
			;msgbox % rot_num "`n" rot_n
				byte11 	:= 	Rot_Num + 7
 				sBytee 	:= 	chan_num + 175 
				byte22	:= 	FLOOR(9.07 * Rot_Led)	; value

			} else 												{
				byte11 	:= 	rot_num + 47
				sBytee	:= 	176
				byte22	:= 	FLOOR(9.07 * Rot_Led)	; value
				
			}
			;tooltip % string
			string	:= 	(sBytee . "," . byte11 . "," . byte22)
								gosub Knob_Upd8 ;update gui lights
	Send_WM_COPYDATA(string, MiDi_inout) 	;send midi 	 
;}
oldrot%Rot_N% := Rot_%Rot_N%

	}	
	notarotta := false

	}	
return



Knob_Upd8:
 if !Rot_%Rot_N%
 Rot_%Rot_N% := 7
;msgbox % Rot_Num ;if chan_num;nH:=80, nw:=80;pBitmap%Rot_Num% := Gdip_CreateBitmapFromFile(Rot_Mask);Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1);Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh);G%Rot_Num%:=Gdip_GraphicsFromHDC(mdc%Rot_Num%)
Gdip_GraphicsClear(G%Rot_Num%)
Gdip_ResetWorldTransform(G%Rot_Num%)
Gdip_TranslateWorldTransform(G%Rot_Num%, 40, 40)
Gdip_RotateWorldTransform(G%Rot_Num%, (rsot := floor(Rot_%Rot_N% * 19.3)))
Gdip_TranslateWorldTransform(G%Rot_Num%, -40, -40) ;win_move((hwndgapWince%Rot_Num%) ,"","","80","80")
Gdip_DrawImage(G%Rot_Num%, pBitmap%Rot_Num%, 0, 0, nW, nh)
DllCall("gdi32.dll\StretchBlt","Uint",mDC%Rot_Num%, "Int",0, "Int",0, "Int", nH , "Int", nH , "UInt", cWhole%Rot_Num%dc, "UInt",0, "UInt",0, "Int",nW, "Int",nH, "UInt", "0x00440328")
DllCall("UpdateLayeredWindow", "Uint", hwndgapWince%Rot_Num%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%Rot_Num%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
return

WM_LBUTTONDOWN() {
	settimer caluclate, -1
	return
}
	
Receive_WM_COPYDATA(wParam, lParam) 
{
 StringAddress := NumGet(lParam + 2*A_PtrSize)
 WmCoppOffData := StrGet(StringAddress) 
	Loop Parse, WmCoppOffData, `, 
	{
		if (a_index = "1") 
		{
			IF A_LoopField CONTAINS CH 
				boner := A_LoopField
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
		if (a_index = "2") 				
		{
			if (A_LoopField = "cunt") 		{
				settimer mydick, -1
				return
				mydick:
				chan_num := strreplace(boner, "CH") 
				if chan_num != channum_old
				{
					;gosub chanled_send
					
						gosub rotupd8
						
									channum_old := Chan_num

				}
			
			} else { 

				Rot_Num := 	a_loopfield
				Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
			}	
		}
		if a_index = 3
		{ 
					Rot_Led := a_loopfield
			Rot_%Rot_N% 	:= Rot_Led

		}
		if Rot_Led 	!= RotLed_Old) 
		{	
			RotLed_Old 	:= Rot_Led
		gosub Knob_Upd8	
		}
	}	
}

Send_WM_COPYDATA(StringToSend, MiDi_inout) {
 VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0) 
 SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
 NumPut(SizeInBytes, CopyDataStruct, A_PtrSize) 
 NumPut(&StringToSend, CopyDataStruct, 2 * A_PtrSize)
	SendMessage, 0x4a, 0, &CopyDataStruct,, % MiDi_inout
 return ErrorLevel
}


knob_positions_load:

sByte := 176 		;		channel 1 rotarys (applies to right side apc rotarys)

IniRead, RotLedsLoaded, %KNob_Ini%, knobs, KnobsLED
sleep 750
if (RotLedsLoaded = "ERROR" || !RotLedsLoaded || InStr(RotLedsLoaded, ",,")) {
	traytip, ERROR, error loading knobs
	gosub fuckingcoon
} else {
	result := parseloaded()
}
return

parseloaded() {
	Loop, parse, RotLedsLoaded, `,
	{			
		total := a_index
		;msgbox % "." a_loopfield "." 
		if A_LoopField
				 global ("Rot_" . a_index) := floor(A_LoopField)
		else 
			global ("Rot_" . a_index) := 1
			if (a_index < 8 ) 	
				byte1 	:= 	a_index

			if (a_index > 8 && a_index < 17 ) 	
			{
				byte1 	:= 	a_index + 7
				; msgbox % "GAYKNObS " byte1
 				sByte 	:= 	chan_num + 175 

			} else
				byte1 	:= 	a_index + 47
				
		sByte 		:= 	chan_num + 175 
		if !byte2 
			byte2 	:= 	0.5
		else
			byte2 	:= floor(9.07 * A_LoopField)	; value
		string 		:= (sByte . "," . byte1 . "," . byte2)
		;msgbox % string
		Send_WM_COPYDATA(string, MiDi_inout)
	}
	if total != 80
	{
		msgbox gay total %total%
		gosub fuckingcoon
	}
	return 1	
}

fuckingcoon:
shitty := ""
loop 80 {
	cuntyfucknig := ("Rot_" . a_index)
	%cuntyfucknig% := 7
	if 	!shitarsecunt
		 shitarsecunt:= 7
	else shitarsecunt:= shitarsecunt . ",7"
}
if !(InStr(RotLedsLoaded, ",,"))
	Loop, parse, shitarsecunt, `,
		total:= A_Index
; else 
; msgbox totalcunt %total% 
sByte := 176
loop 16 {
		byte1 	:= 	a_index		; 	knob num
	byte2 	:= 	floor(9.07 * 7)
	string 	:= 	(sByte . "," . byte1 . "," . byte2)
;	Send_WM_COPYDATA(string, MiDi_inout)
	gosub Knob_Upd8
}


; gosub knob_positions_save
; gosub knob_positions_save_Writeini
return

knob_positions_save:
loop 80 {
if A_index = 1
	RotLedsSaved 	:= 	Rot_%a_index%
else
	RotLedsSaved 	:= 	RotLedsSaved . "," . Rot_%a_index%
}
	Loop, parse, RotLedsSaved, `,
		total:=a_index
; msgbox % total
return

knob_positions_save_Writeini:
return
if (RotLedsLoaded = RotLedsSaved) {
	tooltip No changes no save
	sleep 1700
} else IniWrite, % RotLedsSaved, % KNob_Ini, knobs, KnobsLED
return
return
Knobs_DestroyDcs: 	; 	leaves image on display
Loop 16 {
	SelectObject(mDC%A_index%, obm%A_index%) 
	DeleteObject(mBM%A_index%)
	DeleteDC(%C_Whole%dc)
	Gdip_DeleteGraphics(G%A_index%), 
	Gdip_DisposeImage(pBitmap%A_index%)
	Gdip_Shutdown(pToken%A_index%)
}
return

Exitt:
gosub Knobs_DestroyDcs
gosub knob_positions_save
if autosave
	gosub knob_positions_save_Writeini
exitapp
return,

Open_ScriptDir:
toolTip %a_scriptFullPath%
z=explorer.exe /select,%a_scriptFullPath%
run %comspec% /C %z%,, hide
sleep 1250

ToolOff:
toolTip,
return

shitsendled(cha) {
	chan_num := cha	
	gosub chanled_send
	gosub rotupd8
}

rotupd8:
loop 8 {
	rot_num := a_index + 8
	Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
	gosub Knob_Upd8
}	
return


COLOUR_SORT:
return
colourlist:="000000,1E1E1E,7F7F7F,FFFFFF,FF4C4C,FF0000,590000,190000,FFBD6C,FF5400,591D00,271B00,FFFF4C,FFFF00,595900,191900,88FF4C,54FF00,1D5900,142B00,4CFF4C,00FF00,005900,001900,4CFF5E,00FF19,00590D,001902,4CFF88,00FF55,00591D,001F12,4CFFB7,00FF99,005935,001912,4CC3FF,00A9FF,004152,001019,4C88FF,0055FF,001D59,000819,4C4CFF,0000FF,000059,000019,874CFF,5400FF,190064,0F0030,FF4CFF,FF00FF,590059,190019,FF4C87,FF0054,59001D,220013,FF1500,993500,795100,436400,033900,005735,00547F,0000FF,00454F,2500CC,7F7F7F,202020,FF0000,BDFF2D,AFED06,64FF09,108B00,00FF87,00A9FF,002AFF,3F00FF,7A00FF,B21A7D,402100,FF4A00,88E106,72FF15,00FF00,3BFF26,59FF71,38FFCC,5B8AFF,3151C6,877FE9,D31DFF,FF005D,FF7F00,B9B000,90FF00,835D07,392b00,144C10,0D5038,15152A,16205A,693C1C,A8000A,DE513D,D86A1C,FFE126,9EE12F,67B50F,1E1E30,DCFF6B,80FFBD,9A99FF,8E66FF,404040,757575,E0FFFF"

global totall
global totall2

array_colour_start 	:= []
array_winner   		:= []
array_winner_bk   	:= []
array_loser 		:= []
array_loser_bk		:= []

loop, parse, colourlist, `,
{
	array_colour_start[a_index] := "0x" . A_loopfield
	totall:=A_index
}
for index, element in array_colour_start
{
	totall2:=A_index
	if !stringss
		global stringss := element
	else
		stringss := stringss . "," . element
}
	
msgbox % Totall "1`n" totall2 "2`n" stringss

nignog(array_colour_start)
array_winner_bk  := array_winner
array_loser_bk 	:= array_loser
Sort_count := 1
loop {
	nignog(array_winner)
	nignog(array_loser)

	if array_winner != array_winner_bk
		Sort_count := Sort_count + 1
	else {
		msgbox array 1 sorted %Sort_count%
		global array1ok := true
	}
	if array_loser != array_loser_bk
		Sort_count := Sort_count + 1
	else {
		msgbox array 2 sorted %Sort_count%
		global array2ok := true
	}
	if !array1ok 
		array_winner_bk  := array_winner
	else
	if !array2ok 
		aarray_loser_bk 	:= array_loser
	else 
		if array1ok {
			msgbox win
			break
		}	
if a_index = 10000
{
global nignogggg
global niga:=123
	for index, element in array_winner
	{
		niga:= (niga . "," . Element . ",")
		nignogggg:= a_index
	}
	msgbox % nignogggg
}
}

return
colourCompare(c1, c2) {

	colourRGBToHSL("0x" c1, h1, s1, l1)
	colourRGBToHSL("0x" c2, h2, s2, l2)

	if h1 < h2
		return -1
	if h1 > h2
		return 1
		
	if s1 < s2
		return -1
	if s1 > s2
		return 1
		
	if l1 < l2
		return -1
	if l1 > l2
		return 1
	return 0 ; both HSL are equal
}

nignog(inputarray) 									{
	for index, element in inputarray
	{	
		if (index = "1") 								; odd := true
			element_old := element
		else 										{ 	;odd := !odd 
			if win:=colourCompare(element_old, element) 
			{	;if Odd {
				msgbox % win " " element "  " element_old
				array_1.push(element_old)
				array_2.push(element)					;} else {
			}	else msgbox lose							;array_2.push(element_old)
			element_old := element
		}													;array_1.push(element)
	}													;}
}
	
	
colourRGBToHSL(rgb, ByRef h, ByRef l, ByRef s) {
	static Shlwapi := DllCall("LoadLibrary", "Str", "Shlwapi.dll", "Ptr")
	static colourRGBToHSL := DllCall("GetProcAddress", "Ptr", Shlwapi, "AStr", "colorRGBToHSL", "Ptr")

	r := (rgb & 0xFF0000) >> 16
	g := (rgb & 0x00FF00)
	b := (rgb & 0x0000FF) << 16
	bgr := r | b | g ; colourREF format is 0x00BBGGRR
msgbox % bgr
	DllCall(colorRGBToHSL, "UInt", bgr, "UShort*", h := 0, "UShort*", l := 0, "UShort*", s := 0)
}

Brightness(c) {
	r := "0x" SubStr(c, 1, 2), r += 0
	g := "0x" SubStr(c, 3, 2), g += 0
	b := "0x" SubStr(c, 5, 2), b += 0
	return Sqrt(0.241 * r ** 2 + 0.691 * g ** 2 + 0.068 * b ** 2)
}





/* 

Rotary increment degree offset:

01: 0
02: 18,6
03: 40.3
04: 59
05: 79.1
06: 97.8
07: 118
08: 138				~		19.3 deg
09: 156.7
10: 176.9
11: 197.1
12: 215.7
13: 232.8
14: 252.9
15: 273.1

RGB LEDs:

Col 	Vel
#000000 0
#1E1E1E 1
#7F7F7F 2
#FFFFFF 3
#FF4C4C 4
#FF0000 5
#590000 6
#190000 7
#FFBD6C 8
#FF5400 9
#591D00 10
#271B00 11
#FFFF4C 12
#FFFF00 13
#595900 14
#191900 15
#88FF4C 16
#54FF00 17
#1D5900 18
#142B00 19
#4CFF4C 20
#00FF00 21
#005900 22
#001900 23
#4CFF5E 24
#00FF19 25
#00590D 26
#001902 27
#4CFF88 28
#00FF55 29
#00591D 30
#001F12 31
#4CFFB7 32
#00FF99 33
#005935 34
#001912 35
#4CC3FF 36
#00A9FF 37
#004152 38
#001019 39
#4C88FF 40
#0055FF 41
#001D59 42
#000819 43
#4C4CFF 44
#0000FF 45
#000059 46
#000019 47
#874CFF 48
#5400FF 49
#190064 50
#0F0030 51
#FF4CFF 52
#FF00FF 53
#590059 54
#190019 55
#FF4C87 56
#FF0054 57
#59001D 58
#220013 59
0xED4325 #FF1500 60
0xBD6100 #993500 61
0xB08B00 #795100 62
0x85961F #436400 63
0x539F31 #033900 64
0x0A9C8E #005735 65
0x007ABD #00547F 66
0x0303FF #0000FF 67
0x2F52A2 #00454F 68
0x624BAD #2500CC 69
0x7B7B7B #7F7F7F 70
0x3C3C3C #202020 71
0xFF0505 #FF0000 72
0xBFBA69 #BDFF2D 73
0xA6BE00 #AFED06 74
0x7AC634 #64FF09 75
0x3DC300 #108B00 76
0x00BFAF #00FF87 77
0x10A4EE #00A9FF 78
0x5480E4 #002AFF 79
0x886CE4 #3F00FF 80
0xA34BAD #7A00FF 81
0xB73D69 #B21A7D 82
0x965735 #402100 83
0xF66C03 #FF4A00 84
0xBFFB00 #88E106 85
0x87FF67 #72FF15 86
0x1AFF2F #00FF00 87
0x25FFA8 #3BFF26 88
0x5CFFE8 #59FF71 89
0x19E9FF #38FFCC 90
0x8BC5FF #5B8AFF 91
0x92A7FF #3151C6 92
0xB88DFF #877FE9 93
0xD86CE4 #D31DFF 94
0xFF39D4 #FF005D 95
0xFFA529 #FF7F00 96
0xFFF034 #B9B000 97
0xE3F403 #90FF00 98
0xDBC300 #835D07 99
0xBE9D63 #392b00 100
0x89B47D #144C10 101
0x88C2BA #0D5038 102
0x9BB3C4 #15152A 103
0x85A5C2 #16205A 104
0xC68B7C #693C1C 105
0xF14080 #A8000A 106
0xFF94A6 #DE513D 107
0xFFA374 #D86A1C 108
0xFFEE9F #FFE126 109
0xD2E498 #9EE12F 110
0xBAD074 #67B50F 111
0xA9A9A9 #1E1E30 112
0xD4FDE1 #DCFF6B 113
0xCDF1F8 #80FFBD 114
0xB9C1E3 #9A99FF 115
0xCDBBE4 #8E66FF 116
0xD0D0D0 #404040 117
0xDFE6E5 #757575 118
0xFFFFFF #E0FFFF 119
Red #A00000 120
Red Half #350000 121
Green #1AD000 122
Green Half #074200 123
Yellow #B9B000 124
Yellow Half #3F3100 125
Amber #B35F00 126

Amber Half #4B1502 127


 */