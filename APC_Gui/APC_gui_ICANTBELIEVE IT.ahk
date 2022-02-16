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
global Rot_Num_in, global Rot_Led_in, global Rot_Num, global Rot_Led, global RotLed_Old , global xnow, global ynow, global Y_pos_1, global X_pos_1, global X_pos_2, global sByte, global chan_num := "CH1", global string, global MiDi_inout, global chan_num

autosave 		:= 	True
apcgui 			:= 	"Images\apctest.png"	;	Main
knob1 			:= 	"Images\knobtest.png"	; 	replace with individual images of knobs
Rot_Mask 		:= 	"Images\mask.png" 		;	Rotary-LED Alpha-notched-Mask
channel_LED	 	:= 	"Images\channel_LED"
Anus 			:= 	-19.3					;	Rotary-LED separation offset degrees 
MiDi_inout		:= 	"z_in_out.ahk ahk_class AutoHotkey" 	;	Midi feedback
KNob_Ini 		:= 	"knobs.ini"
global ALL_O 	:= 	"Images\LIGHTS_ALL_TEST.png"
wm_allow()	

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


; rotarys:
		 gosub knob_positions_load
 
loop 16 {
	Rot_Num := a_index
	;sFile%A_index% 	:=  Rot_Mask
	CuntHole 		:= 	("Dripp" . A_index)
	GapedJap		:= 	("Tr4ny" . A_index)
	switch a_index{
		case "1":    
			global oldrot1
			Y_pos_1 := "y15", X_pos_2 := "x14" 
		case "2":                                              
			global oldrot2
			Y_pos_1 := "y15", X_pos_2 := ("x" . 99)
		case "3":                              
			global oldrot3
			Y_pos_1 := "y15", X_pos_2 := ("x" . 181)
		case "4":                              
			global oldrot4
			Y_pos_1 := "y15", X_pos_2 := ("x" . 265)
		case "5":    
			global oldrot5
			Y_pos_1 := "y15", X_pos_2 := ("x" . 349)
		case "6":                              
			global oldrot6
			Y_pos_1 := "y15", X_pos_2 := ("x" . 437)
		case "7":                              
			global oldrot7
			Y_pos_1 := "y15", X_pos_2 := ("x" . 520)
		case "8":                              
			global oldrot8
			Y_pos_1 := "y15", X_pos_2 := ("x" . 605)
		case "9":                                              
			global oldrot9
			Y_pos_1 := "y228", X_pos_2 := "x758"
		case "10":                                              
			global oldrot10
			Y_pos_1 := "y228", X_pos_2 := "x843"
		case "11":                                              
			global oldrot11
			Y_pos_1 := "y228", X_pos_2 := "x927"
		case "12":                                              
			global oldrot12
			Y_pos_1 := "y228", X_pos_2 := "x1011"
		case "13":                                              
			global oldrot13
			Y_pos_1 := "y315", X_pos_2 := "x758"
		case "14":                                              
			global oldrot14
			Y_pos_1 := "y315", X_pos_2 := "x840"
		case "15":                                              
			global oldrot15
			Y_pos_1 := "y315", X_pos_2 := "x927"
		case "16":                                              
			global oldrot16
			Y_pos_1 := "y315", X_pos_2 := "x1011"			
	}	
	gui, 	%CuntHole%:New, +OwnDialogs -Caption +ParentAPCBackMain -DPIScale +AlwaysOnTop -SysMenu +ToolWindow, midi ;Layerr%A_index%
	gui, 	%CuntHole%: +LastFound -Caption +hwnd%cunthole%, midi ; 
	
	gui, 	%CuntHole%:Color, 000000	;	DllCall("SetParent", "uint", %CuntHole%, "uint", MainhWnd)
	gui, 	%CuntHole%:Add, Picture,X0 Y0 w80 h80 BackgroundTrans , %knob1%	; 
	gui, 	%CuntHole%:Show, %X_pos_2% %Y_pos_1% w80 h80 , midi
	WinSet, TransColor, 000000
	%CuntHole%dc 	:= DllCall("GetDC", UInt, %CuntHole%)
	;gui, 	%CuntHole%:hide

					gui, 	APCBackMain:Show,x433 y433 w1110 h666, APCBackMain

	gui, 	%GapedJap%:New, -DPIScale +ParentAPCBackMain +hwndhwnd%GapedJap% -SysMenu +E0x80000, midi
	gui, 	%GapedJap%: +LastFound -Caption	; DllCall("SetParent", "uint", hwnd%GapedJap%, "uint", MainhWnd)
	hwnd%GapedJap% 	:= WinExist()

	pToken%A_index% := Gdip_Startup()
	pImage%A_index% := Gdip_LoadImageFromFile(Rot_Mask)
	 	nH:=80,	nw:=80

	;noW%A_index%	:= Gdip_GetImageWidth2(pImage%A_index%)
	;noH%A_index%	:= Gdip_GetImageHeight2(pImage%A_index%)
	;nh := (noH%A_index%), 	nw := (noW%A_index%)	
	ynh:= ("h" .  nh), 		ynw:= ("w" .  nw)
	mDC%A_index%	:= Gdi_CreateCompatibleDC(0)
	mBM%A_index%	:= Gdi_CreateDIBSection(mDC%A_index%, nW, nH, 32)
	oBM%A_index%	:= Gdi_SelectObject(mDC%A_index%, mBM%A_index%)
	Gdip_DrawImageRectI(pGraphics%A_index%:=Gdip_CreateFromHDC(mDC%A_index%), pImage%A_index%, 0, 0, nW, nH)
	
	;DllCall("gdi32.dll\SetStretchBltMode", "Uint", mDC%A_index%, "Int", 5)
	;DllCall("gdi32.dll\StretchBlt", "Uint", mDC%A_index%, "Int", 0, "Int", 0, "Int", nH , "Int", nH , "UInt", %CuntHole%dc, "UInt", 0, "UInt", 0, "Int", nW, "Int", nH, "UInt", "0x00440328")
	;DllCall("UpdateLayeredWindow", "Uint", hwnd%GapedJap%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%A_index%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)



	;	DllCall("SetParent", "uint", hwnd%GapedJap%, "uint", MainhWnd)

	gui, 	%GapedJap%:Show, %X_pos_2% %Y_pos_1% h80 w80, midi
	gui, 	%GapedJap%: +LastFound -Caption 
	;		WinSet, TransColor, ffffff
	gui, 	%CuntHole%:hide


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
DllCall("gdi32.dll\StretchBlt", "Uint",mDC%A_index%, "Int", 0, "Int", 0, "Int", nH , "Int", nH , "UInt", %CuntHole%dc, "UInt", 0, "UInt", 0, "Int", nW, "Int", nH, "UInt", "0x00440328")
DllCall("UpdateLayeredWindow", "Uint", hwnd%GapedJap%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%A_index%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)

	;if A_index > 1
		;DllCall("SetParent", "uint", %CuntHole%, "uint", hwndTr4ny1)
	;else if A_index = 1
	
		;DllCall("SetParent", "uint", hwndTr4ny1, "uint", MainhWnd)
}
;gosub allon

chanled:
gui, 	chanled:New, +ParentAPCBackMain -DPIScale +toolwindow -SysMenu +E0x80000, midi ;
gui, 	chanled:+LastFound +Hwndchannel_LED -Caption 
cGui 	:= WinExist()
lToken	:= Gdip_Startup()
IImage	:= Gdip_LoadImageFromFile(channel_LED)
cW 		:= 87, cH := 39
iDC 	:= Gdi_CreateCompatibleDC(0)
iBM 	:= Gdi_CreateDIBSection(iDC, cW, cH, 32)
ioBM 	:= Gdi_SelectObject(iDC, iBM)

switch chan_num {
	case "ch1":
		xx := *("x" . 10), yy := "y354"
	case "ch2":
		xx := "x" . 96 yy := "y354"
	case "ch3":
		xx := "x" . 178, yy := "y354"
	case "ch4":
		xx := "x" . 265, yy := "y354"
	case "ch5":
		xx := "x" . 343, yy := "y354"
	case "ch6":
		xx := "x" . 434, yy := "y354"
	case "ch7":
		xx := "x" . 518, yy := "y354"
	case "ch8":
		xx := "x" . 602, yy := "y354"
}
gui, 	chanled:Show,%xx% %yy% w%cW% h%cH%, midi
gui, 	chanled: -Caption +AlwaysOnTop +LastFound +hwndchannel_LED -Caption -DPIScale +AlwaysOnTop +disabled -SysMenu +ToolWindow +owndialogs
Gdip_DrawImageRectI(iGraphics:=Gdip_CreateFromHDC(iDC), IImage, 0, 0, cW, cH)
DllCall("UpdateLayeredWindow", "Uint", cGui, "Uint", 0, "Uint", 0, "int64P", cW|cH<<32, "Uint", iDC, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
GDI_SelectObject(iDC, ioBM)
Gdi_DeleteObject(iBM)
Gdi_DeleteDC(iDC)
Gdip_DeleteGraphics(iGraphics)
Gdip_DisposeImage(IImage)
Gdip_Shutdown(lToken) 


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
if !counta
	counta := 1
else
	counta := counta +1 ; tooltip % counta " ! " cnt " ! " wnd

mousegetpos, x, y, ;wnd, cnt
if (floor(x)>1025 && floor(x)<1067 && floor(y)<104 && floor(y)>30) ; the "0" of apc40
	exitapp
sByte 	:= 175 + chan_num
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
		if x between 758 and  842
			Rot_Num := (chan_num + 	(8 + (chan_num -1)))
		else
		if x between 843 and  927
			Rot_Num	:= (chan_num + 	(9 + (chan_num -1)))
		else
		if x between 928 and  1010
			Rot_Num	:=	(chan_num + (10 + (chan_num -1)))
		else
		if x between 1011 and 1093
			Rot_Num	:=	(chan_num + (11 + (chan_num -1)))
	} else {
		if x between 758 and  842
			Rot_Num	:=	(chan_num + (12 + (chan_num -1)))
		else
		if x between 843 and  927
			Rot_Num	:=	(chan_num + (13 + (chan_num -1)))
		else
		if x between 928 and  1010
			Rot_Num	:=	(chan_num + (14 + (chan_num -1)))
		else
		if x between 1011 and 1093
			Rot_Num	:=	(chan_num + (15 + (chan_num -1)))
	}	
}
;tooltip % Rot_Num "`n" x "," y

if GetKeyState("Lbutton", "P") {
	oldrot%Rot_Num% := Rot_%Rot_Num%
	while GetKeyState("Lbutton", "P") 					{
		mousegetpos, , ynow,	;xres := floor(x - xnow)
		yres := (y - ynow),	  Y	:= YNOW
		Rot_LED := (Rot_%Rot_Num% + (yres * 0.1) )
		IF (floor(Rot_Led)		>	13)
			Rot_Led 			:= 	14
		else if (floor(Rot_Led)	<	0)
			Rot_Led 			:= 	0
		if (Rot_Led 			!= 	oldrot%Rot_Num%) 	{	
			ROT_%Rot_Num% 		:= 	Rot_Led
			gosub Knob_Upd8 ;update gui lights
			; concoct ze concatenation 
			if Rot_Num < 9
				 byte1 	:= Rot_Num + 47 				; knob num
			else byte1 	:= Rot_Num + 7 
			byte2 		:= ROUND(9.07 * Rot_Led)	; value
			string 		:= (sByte . "," . byte1 . "," . byte2)
			Send_WM_COPYDATA(string, MiDi_inout)			;send midi
			oldrot%Rot_Num% := Rot_Led
}	}	}	
return

#D::
gosub knob_positions_save
return 

Knob_Upd8:
;nH:=80, nw:=80;pBitmap%Rot_Num% := Gdip_CreateBitmapFromFile(Rot_Mask);Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1);Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh);G%Rot_Num%:=Gdip_GraphicsFromHDC(mdc%Rot_Num%)
Gdip_GraphicsClear(G%Rot_Num%)
Gdip_ResetWorldTransform(G%Rot_Num%)
Gdip_TranslateWorldTransform(G%Rot_Num%, 40, 40)
Gdip_RotateWorldTransform(G%Rot_Num%, (rsot := Rot_%Rot_Num% * 19.3))
Gdip_TranslateWorldTransform(G%Rot_Num%, -40, -40)
;win_move((hwndTr4ny%Rot_Num%) ,"","","80","80")
Gdip_DrawImage(G%Rot_Num%, pBitmap%Rot_Num%, 0, 0, nW, nh)
DllCall("gdi32.dll\StretchBlt","Uint",mDC%Rot_Num%, "Int",0, "Int",0, "Int", nH , "Int", nH , "UInt", Dripp%Rot_Num%dc, "UInt",0, "UInt",0, "Int",nW, "Int",nH, "UInt", "0x00440328")
DllCall("UpdateLayeredWindow", "Uint", hwndTr4ny%Rot_Num%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%Rot_Num%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
return

WM_LBUTTONDOWN() {
	settimer caluclate, -1
	return
}
	
Receive_WM_COPYDATA(wParam, lParam) {
    StringAddress := NumGet(lParam + 2*A_PtrSize)
    WmCoppOffData := StrGet(StringAddress) 
	;tooltip % WmCoppOffData "ghg"
	;msgbox % WmCoppOffData
	;settimer tooloff, -2000
	Loop Parse, WmCoppOffData, `, 
	{
		if a_index = 1 
		{
			IF A_LoopField CONTAINS CH 
			{
				boner := A_LoopField
				;msgbox froom gui love gu
			} 
			else
				IF A_LoopField = HIDE 
			{
				msgbox hide me				
				return
			} 
			else
				IF A_LoopField  = SHOW 
			{
				msgbox show me				
				return
			} 
			else sByte := a_loopfield
		}
		if a_index = 2
		{
			if (A_LoopField = "cunt")
			{
				chan_num := strreplace(boner, "CH") 
				if !chan_num
					msgbox cun t
				loop 8 {
					rot_num := a_index + 8	
					Rot_Nummm := (8 * chan_num ) + a_index
					sByte := chan_num + 175
					byte1 	:= 	a_index	+ 8				; knob num
					byte2 	:= 	rot_%Rot_Nummm% ; value
					string 		:= 	(sByte . "," . byte1 . "," . byte2)
					gosub Knob_Upd8
					Send_WM_COPYDATA(string, MiDi_inout)
				} 
				return			
			}
			else Rot_Num := a_loopfield
		}
		else 
		if a_index = 3
			Rot_Led := a_loopfield
	}
	Rot_%Rot_Num% := Rot_Led
	if (Rot_Led 	!= RotLed_Old) {	
		RotLed_Old 	:= Rot_Led
		gosub 	Knob_Upd8
	}
    return true
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
	sByte 	:= 176 		;		channel 1 rotarys (applies to right side apc rotarys)

	IniRead, RotLedsLoaded, %KNob_Ini%, knobs, KnobsLED
	sleep 750
	if (RotLedsLoaded = "ERROR") {
	msgbox
		traytip, ERROR, error loading knobs
		loop 80 {
			global ("Rot_" . a_index) := 1
			if a_index < 25
				 byte1 	:= 	a_index					; knob num
			else byte1 	:= 	a_index	- 9		
			byte2 		:= 	round(floor(9.07 * a_index)) ; value
			if  a_index 	> 	16
				sByte 	:= 	sByte + 1
			string 		:= 	(sByte . "," . byte1 . "," . byte2)
			Send_WM_COPYDATA(string, MiDi_inout)
		} 	
		
	} 
	else Loop, parse, RotLedsLoaded, `,
	{
		Rot_%a_index% := floor(A_LoopField)
		if a_index < 17
		{
			sbyte := 176
			byte1 	:= 	a_index				; knob num
		}else {
			byte1 	:= 	a_index - 9 		
			sbyte := a_index + 153
		}			; knob num
		if !byte2 
			byte2 	:= 	7
		else
			byte2 	:= floor(9.07 * A_LoopField)	; value
		string 		:= (sByte . "," . byte1 . "," . byte2)
		Send_WM_COPYDATA(string, MiDi_inout)
	}
	return
	
	knob_positions_save:
	loop 80 {
		If !RotLedsSaved
			RotLedsSaved 	:= 	Rot_%a_index%
		else
			RotLedsSaved 	:= 	( RotLedsSaved . "`," . Rot_%a_index%)
	}

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
		DeleteDC(%CuntHole%dc)
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
		louise_cuntford:
		byte1 := ""
		byte2 := ""
		mousegetpos, xnow, ynow,
		;xres := (x - xnow)
		yres := (y - ynow) 
						x := XNOW, Y := YNOW

		Rot_LED := (Rot_%Rot_Num% + (yres * 0.1103)) 
		IF  (Rot_Led > 13)
			Rot_Led := 14
		else {
			if (Rot_Led			<	0)
				Rot_Led 		:= 	0
			if (Rot_Led 		!= 	oldrot%Rot_Num%) {	
				ROT_%Rot_Num% 	:= 	Rot_Led
				;send midi
				if Rot_Num < 9
					 byte1 	:= Rot_Num + 47 				; knob num
				else byte1 	:= Rot_Num + 7 
				byte2 		:= round(9.07 * Rot_Led)	; value
				string 		:= (sByte . "," . byte1 . "," . byte2)
				Send_WM_COPYDATA(string, MiDi_inout)
				oldrot%Rot_Num% := Rot_Led
gosub Knob_Upd8

}	}
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