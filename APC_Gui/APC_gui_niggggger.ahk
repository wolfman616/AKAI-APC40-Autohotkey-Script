#noEnv ; #warn
#persistent
#SingleInstance force
sendMode Input
#include C:\Script\AHK\- LiB\GDI+_All.ahk
setWorkingDir %a_scriptDir% ;setbatchlines -1
DetectHiddenWindows On
SetTitleMatchMode 2
;SetControlDelay, 	0
;SetKeyDelay, 		0
global faggotomg ;global nH:=80, global	nw:=80
global Rot_Num_in, global Rot_Led_in, global Rot_N, global Rot_Num, global Rot_Led, global RotLed_Old , global xnow, global ynow, global Y_pos_1, global X_pos_1, global X_pos_2, global sByte, global chan_num := 1,  global channum_old := 1,global string, global MiDi_inout, global gayniggers, global boner, global channel_LED, global channel_master, global initted, global inittedmast, global RotLedsLoaded
global total 
global RotLedsSaved
global shitty 
global autosave 		:= 	True
apcgui 			:= 	"Images\apctest.png"	;	Main
knob1 			:= 	"Images\knobtest.png"	; 	replace with individual images of knobs
Rot_Mask 		:= 	"Images\mask.png" 		;	Rotary-LED Alpha-notched-Mask
channel_LED	 	:= 	"Images\channel_LED.png"
channel_master 	:= 	"C:\Script\AHK\Z_MIDI_IN_OUT\APC_Gui\Images\chmasterLED.png"
wm_allow()	

Anus 			:= 	-19.3					;	Rotary-LED separation offset degrees 
MiDi_inout		:= 	"z_in_out.ahk ahk_class AutoHotkey" 	;	Midi feedback
KNob_Ini 		:= 	"knobs.ini"
global ALL_O 	:= 	"Images\LIGHTS_ALL_TEST.png"

menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard

OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA
		;; window message for the mouse left click
OnMessage(0x201, "WM_LBUTTONDOWN")

gui, 	APCBackMain:New, -DPIScale +toolwindow +owner -SysMenu +AlwaysOnTop, APCBackMain ;+E0x80000
gui, 	APCBackMain:+LastFound +HwndMainhWnd
gui, 	APCBackMain:Color, EEAA99 	;gui, 	APCBackMain:Show,x433 y433 w1110 h640, APCBackMain
gui, 	APCBackMain:-Caption

winSet, TransColor, 1188AA 
winSet, TransColor, EEAA99 


; rotarys :
gosub knob_positions_load
 global nH:=80, global	nw:=80

loop 16 {
	global Rot_Num := a_index
	global ("oldrot" . 	a_index)
	global ("pImage" . 	A_index)
	global ("pBitmap" . A_index)
	global ("mBM" . 	A_index)
	global ("oBM" . 	A_index)
	global ("pGraphics" . A_index)
	global ("mDC" . 	A_index)




	;sFile%A_index% 	:=  Rot_Mask
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
	gui, 	%C_Whole%:New, +OwnDialogs -Caption +ParentAPCBackMain -DPIScale +AlwaysOnTop -SysMenu +ToolWindow, midi ; classname is blacklisted from Aeroglass, will be using for all controls  ;Layerr%A_index% 
	gui, 	%C_Whole%: +LastFound -Caption +hwnd%C_Whole%, midi ; 
	gui, 	%C_Whole%:Color, 000000	;	DllCall("SetParent", "uint", %C_Whole%, "uint", MainhWnd)
	gui, 	%C_Whole%:Add, Picture,X0 Y0 w80 h80 BackgroundTrans , %knob1%	; 
	gui, 	%C_Whole%:Show, %X_pos_2% %Y_pos_1% w80 h80 , midi
	WinSet, TransColor, 000000 		; 	doesnt need full alpha so this gui is done for now
	%C_Whole%dc 	:= DllCall("GetDC", UInt, %C_Whole%)

	gui, 	APCBackMain:Show,x433 y433 w1110 h666, APCBackMain

	gui, 	%gaP_Wince%:New, -DPIScale +ParentAPCBackMain +hwndhwnd%gaP_Wince% -SysMenu +E0x80000, midi
	gui, 	%gaP_Wince%: +LastFound -Caption	; DllCall("SetParent", "uint", hwnd%gaP_Wince%, "uint", MainhWnd)
	hwnd%gaP_Wince% 	:= WinExist()
	;setup gdip om the wince
	pToken%A_index% := Gdip_Startup()
	pImage%A_index% := Gdip_LoadImageFromFile(Rot_Mask)
	;nH:=80, nw:=80	;noW%A_index%	:= Gdip_GetImageWidth2(pImage%A_index%)	;noH%A_index%	:= Gdip_GetImageHeight2(pImage%A_index%) ;nh := (noH%A_index%), 	nw := (noW%A_index%)	
	ynh:= ("h" .  nh), 		ynw:= ("w" .  nw)
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
	;		WinSet, TransColor, ffffff
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
gosub chanled
sleep 200
gui, 	 cockMain:New, +ParentAPCBackMain -DPIScale +toolwindow -SysMenu ;
gui, 	 cockMain:+LastFound +Hwndcock
gui, 	 cockMain:Add, Picture,x0 y0 w1122 h666 BackgroundTrans, %apcgui%
gui, 	 cockMain:Color, EEAA99
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

OnExit,  Exitt
return

GuiEscape:
ExitApp

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
			;gosub Knob_Upd8 ;update gui lights

chanled:
gosub Channel_switch
if chan_num < 9 
{
	if !initted {
		initted := true
		





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
		loop 8 {
			rot_num := a_index + 8
			Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
			;settimer, Knob_Upd8, -1
		}					
		;settimer, Knob_Upd8, -1
	} else {
		cW 		:= 87, cH := 39
		if channum_old > 8  iW
			gui, chanledmaster:hide
		else gui, chanled:hide
		if (chan_num != channum_old) {
			gui, chanled:Show,%xx% %yy% w%cW% h%cH%, midi	
			loop 8 {
				rot_num := a_index + 8
				Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
				;settimer, Knob_Upd8, -1
			}	
		}
	}
			
} else {
	if !inittedmast {
		inittedmast := true
						mW 		:= 60, mH := 37
	gui, 	chanledmaster:New, +ParentAPCBackMain -DPIScale +toolwindow -SysMenu +E0x80000, midi ;
		gui, 	chanledmaster:+LastFound +Hwndchannel_LEDmaster -Caption 
		mGui 	:= WinExist()
		mToken	:= Gdip_Startup()
		mImage	:= Gdip_LoadImageFromFile(channel_master)
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
		Gdip_Shutdown(mToken) 

			gui, chanledmaster:Hide,
	if channum_old < 9 

		gui, chanled:hide,
					;gui, chanledmaster:Show,, midi

		loop 8{
			rot_num := a_index + 8
			Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
			;msgbox % rot_%rotN%
				;settimer, Knob_Upd8, -1
		}	
	} else {
		if channum_old < 9 
		{
			gui, chanled:hide,
			gui, chanledmaster:Show,
			loop 8{
				rot_num := a_index + 8
				Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
				;msgbox % rot_%rotN%,
				;settimer, Knob_Upd8, -1
			}	
		}
	}
}
	channum_old := chan_num

	;	byte1 	:= 	rot_num + 47
sByte	:= 	chan_num + 175	; knob num
byte1	:= 	16
b2	:= 	("rot_" . (16 + (8 * chan_num)) )	; value
byte2	:= 	%b2%
if !byte2
byte2 := "0"
string	:= 	(sByte . "," . byte1 . "," . byte2)
;msgbox % string
;Send_WM_COPYDATA(string, MiDi_inout) 	;send midi 	;tooltip % Rot_Num "`n" string "`n" rot_n

return

Channel_switch:
switch chan_num {
	case "1":
		xx := "x" . 8, yy := "y358"
	case "2":
		xx := "x" . 93 yy := "y358"
	case "3":
		xx := "x" . 177, yy := "y358"
	case "4":
		xx := "x" . 263, yy := "y358"
	case "5":
		xx := "x" . 347, yy := "y358"
	case "6":
		xx := "x" . 434, yy := "y358"
	case "7":
		xx := "x" . 517, yy := "y358"
	case "8":
		xx := "x" . 601, yy := "y358"
	case "9":
		xx := "x" . 687, yy := "y358"
}
return

allon:
gui, 	ALL_ON:New, +ParentAPCBackMain -DPIScale +toolwindow -SysMenu +E0x80000, midi ;
gui, 	ALL_ON:+LastFound +HwndALL_ON -Caption 
iGui 	:= WinExist()
lToken	:= Gdip_Startup()
IImage	:= Gdip_LoadImageFromFile(ALL_O)
iW 		:= 1122, iH := 560
iDC 	:= Gdi_CreateCompatibleDC(0)
iBM 	:= Gdi_CreateDIBSection(iDC, iW, iH, 32)
ioBM 	:= Gdi_SelectObject(iDC, iBM)
gui, 	ALL_ON:Show,x-7 y0 w1110 h540, midi
gui, 	ALL_ON: -Caption +AlwaysOnTop +LastFound +hwndALL_ON -Caption -DPIScale +AlwaysOnTop +disabled -SysMenu +ToolWindow +owndialogs
Gdip_DrawImageRectI(iGraphics:=Gdip_CreateFromHDC(iDC), IImage, 0, 0, iW, iH)
DllCall("UpdateLayeredWindow", "Uint", iGui, "Uint", 0, "Uint", 0, "int64P", iW|iH<<32, "Uint", iDC, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
GDI_SelectObject(iDC, ioBM)
Gdi_DeleteObject(iBM)
Gdi_DeleteDC(iDC)
Gdip_DeleteGraphics(iGraphics)
Gdip_DisposeImage(IImage)
Gdip_Shutdown(lToken) 
return

caluclate:
if	!counta
	 counta := 1
else counta := counta +1 ; tooltip % counta " ! " cnt " ! " wnd
mousegetpos, x, y, ;wnd, cnt
if (floor(x)>1025 && floor(x)<1067 && floor(y)<104 && floor(y)>30) ; the "0" of apc40
	exitapp
if ((x < 685) && (y < 94)) {
;tooltip % x
	if x between 1 	and  98    
		Rot_Num	:=	1
	else
	if x between 98 and  178  
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
	
		if x between 744 and  842
		{
			Rot_Num := 9
		}
		else
		if x between 843 and  927
			Rot_Num	:= 10
		else
		if x between 928 and  1010
			Rot_Num	:=	11
		else
		if x between 1011 and 1093
			Rot_Num	:=	12
	} else {
	
		
		if x between 10 and  94
		{
			chan_num := 1
			settimer, chanled, -1
		}
		if x between 95 and  179
		{
			chan_num := 2	
 			settimer, chanled, -1
		}
		if x between 180 and  262
		{	
			chan_num := 3	
			settimer, chanled, -1
		}
		if x between 263 and  346
		{	
			chan_num := 4		
			settimer, chanled, -1
		}
		if x between 347 and  434
		{	
			chan_num := 5
			settimer, chanled, -1
		}
		if x between 435 and  518
		{	
			chan_num := 6	
			settimer, chanled, -1
		}
		if x between 519 and  602
		{
			chan_num := 7	
			settimer, chanled, -1
		}
		if x between 603 and  686
		{	
			chan_num := 8
			settimer, chanled, -1
		}	
		if x between 687 and  743
		{
			chan_num := 9
			settimer, chanled, -1
		}
		if x between 758 and  842
			Rot_Num	:=	13
		else
		if x between 843 and  927
			Rot_Num	:=	14
		else
		if x between 928 and  1010
			Rot_Num	:=	15
		else
		if x between 1011 and 1093
			Rot_Num	:=	16
}	}	

if (GetKeyState("Lbutton", "P")) 							{
	oldrot%Rot_Num% := Rot_%Rot_Num%
	while (GetKeyState("Lbutton", "P")) 					{
		mousegetpos, , ynow,	;xres := floor(x - xnow)
		Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
		msgbox % rot_N
		yres := (y - ynow),	 Y 	:= 	YNOW
		Rot_LED := format("{:g}", (Rot_%Rot_N% + (yres * 0.1))) ; value
		IF (floor(Rot_Led)		>	13)
			Rot_Led 			:= 	14
		else if (floor(Rot_Led)	<	0)
			Rot_Led 			:= 	0
		Rot_%Rot_Num% := Rot_LED
		if !oldrot%Rot_N% || if (Rot_Led != oldrot%Rot_N%) 	{	
			ROT_%Rot_N% 		:= 	Rot_Led
			if (Rot_Num > 8 && Rot_Num < 17 ) 				{
				byte1 	:= 	Rot_Num + 7
				; msgbox % "GAYKNObS " byte1
 				sByte 	:= 	chan_num + 175 
				byte2	:= 	FLOOR(9.07 * Rot_Led)	; value

			} else 											{
				byte1 	:= 	rot_num + 47
				sByte	:= 	176	; knob num
				byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
			}
			string	:= 	(sByte . "," . byte1 . "," . byte2)
			msgbox 
			gosub Knob_Upd8 ;update gui lights
			Send_WM_COPYDATA(string, MiDi_inout) 	;send midi 	;tooltip % Rot_Num "`n" string "`n" rot_n
			oldrot%Rot_N% := Rot_%Rot_N%
}	}	}	
return

#D::
gosub knob_positions_save
return 

Knob_Upd8:
Rot_%Rot_N% := 8

 ;if chan_num;nH:=80, nw:=80;pBitmap%Rot_Num% := Gdip_CreateBitmapFromFile(Rot_Mask);Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1);Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh);G%Rot_Num%:=Gdip_GraphicsFromHDC(mdc%Rot_Num%)
Gdip_GraphicsClear(G%Rot_Num%)
Gdip_ResetWorldTransform(G%Rot_Num%)
Gdip_TranslateWorldTransform(G%Rot_Num%, 40, 40)
Gdip_RotateWorldTransform(G%Rot_Num%, (rsot := floor(Rot_%Rot_N% * 19.3)))
Gdip_TranslateWorldTransform(G%Rot_Num%, -40, -40) ;win_move((hwndgapWince%Rot_Num%) ,"","","80","80")
Gdip_DrawImage(G%Rot_Num%, pBitmap%Rot_Num%, 0, 0, nW, nh)
	DllCall("gdi32.dll\SetStretchBltMode", "Uint", mDC%A_index%, "Int", 5)

DllCall("gdi32.dll\StretchBlt", "Uint", mDC%Rot_Num%, "Int", 0, "Int", 0, "Int", nH, "Int", nH, "UInt", cWhole%Rot_Num%dc, "UInt", 0,  "UInt", 0, "Int", nW, "Int", nH, "UInt", "0x00440328")
DllCall("UpdateLayeredWindow", "Uint", hwndgapWince%Rot_Num%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%Rot_Num%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
msgbox % Rot_N "`n" Rot_%Rot_N%

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
			else IF (A_LoopField = "HIDE") {
				msgbox hide me				
				return
			} 
			else IF (A_LoopField  = "SHOW") {
				msgbox show me				
				return
			} 
			else sByte := a_loopfield
		}
		if (a_index = "2") 				
		{
			if (A_LoopField = "cunt") 	{
				settimer mydick, -1
				return
				channum_old := Chan_num
				mydick:
				chan_num := strreplace(boner, "CH") 
				if (chan_num != channum_old) {
					gosub chanled
					loop 8{
						rot_num := a_index + 8
						Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
						;msgbox % rot_%rotN%
						;gosub Knob_Upd8
					}	
				}
				return
			} else { 
				Rot_Num := 	a_loopfield
				Rot_N	:=	Rot_Num + ((chan_num -1) * 8) 
		}	}
		if a_index = 3
			Rot_Led := a_loopfield
	}
	Rot_%Rot_N% 	:= Rot_Led
	if (Rot_Led 	!= RotLed_Old) {	
		RotLed_Old 	:= Rot_Led
		;settimer, Knob_Upd8, -1
		;tooltip updating
		settimer tooloff, -500
}	}

Send_WM_COPYDATA(StringToSend, MiDi_inout) {
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0) 
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  
    NumPut(&StringToSend, CopyDataStruct, 2 * A_PtrSize)
	SendMessage, 0x4a, 0, &CopyDataStruct,, % MiDi_inout
    return ErrorLevel
}

knob_positions_load:
sByte 	:= 176 		;		channel 1 rotarys (applies to right side apc rotarys)

IniRead, RotLedsLoaded, %KNob_Ini%, knobs, KnobsLED
sleep 750
if (RotLedsLoaded = "ERROR" || !RotLedsLoaded) {
	traytip, ERROR, error loading knobs
	gosub fuckingcoon
} 	
else {
	result := parseloaded()
	;msgbox result %result%
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
		;if (a_index < 17) 
			;settimer, Knob_Upd8, -1 ;update gui lights
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
	sleep 10
	cuntyfucknig := ("Rot_" . a_index)
	%cuntyfucknig% := "7"
	Rot_N	:=	A_index + ((chan_num -1) * 8) 
	;Rot_LED := format("{:g}", (Rot_%Rot_N% + (yres * 0.1))) ; value
	Rot_LED := FLOOR(9.07 * 7)	; value

	fff := ("rot_" . A_index)
	%fff% := Rot_LED
	;Rot_%A_index% := Rot_LED
	if (A_index > 8 && A_index < 17 ) {
		byte1 	:= 	A_index + 7
		; msgbox % "GAYKNObS " byte1
 		sByte 	:= 	chan_num + 175 
		byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
	} else {
		byte1 	:= 	rot_num + 47
		sByte	:= 	176	; knob num
		byte2	:= 	FLOOR(9.07 * Rot_Led)	; value
	}
	if (a_index < 17) {
		string	:= 	(sByte . "," . byte1 . "," . byte2)
		Send_WM_COPYDATA(string, MiDi_inout) 	;send midi 	;tooltip % Rot_Num "`n" string "`n" rot_n
		oldrot%Rot_N% := Rot_%Rot_N%
		;settimer, Knob_Upd8, -1 ;update gui lights
	}
	; else {
		; Rot_LED := "0"
		; fff := ("rot_" . A_index)
		; %fff% := Rot_LED
	; }
	
	
	if !shitty {
		RotLedsLoaded2 = % ("Rot_" . a_index)
		RotLedsLoaded := %RotLedsLoaded2%
		;msgbox % RotLedsLoaded
		shitty := 1
	} else {
		RotLedsLoaded2 = % ("Rot_" . a_index)
		RotLedsLoaded := RotLedsLoaded . "," . %RotLedsLoaded2%
		shitty := shitty . ",0"
	}
}

	
	Loop, parse, shitty, `,
		newtotal:=a_index
;msgbox % newtotal
gosub knob_positions_save
gosub knob_positions_save_Writeini
return

knob_positions_save:
loop 80 {
if A_index = 1
	RotLedsSaved := Rot_%a_index%
else
if A_index > 1
{
if !RotLedsSaved
msgbox % "Trouble saving"
	RotLedsSaved 	:= 	RotLedsSaved . "," . Rot_%a_index%
}
}
if InStr(RotLedsSaved, ",,")
 (b_thishotkey := strreplace(a_thishotkey, "$"))
msgbox % "empty fields"

return

knob_positions_save_Writeini:
if (RotLedsLoaded = RotLedsSaved) {
	tooltip No changes no save
	sleep 1700
} else IniWrite, % RotLedsSaved, % KNob_Ini, knobs, KnobsLED
return

Knobs_DestroyDcs: 	; 	leaves image on display
Loop 16 {
	SelectObject(mDC%A_index%,obm%A_index%) 
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

/* 

top rotary light mask degree offset
01: 0
02: 18,6
03: 40.3
04: 59
05: 79.1
06: 97.8
07: 118
08: 138
09: 156.7
10: 176.9
11: 176.9 +20.2 197.1
12: 176.9 +38.8 215.7
13: 176.9 +55.9 232.8
14: 176.9 +76 252.9
15: 176.9 +96.2 273.1



 */