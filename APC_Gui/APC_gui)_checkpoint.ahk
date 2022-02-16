#noEnv ; #warn
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
;global RotLedsLoaded := "cunthole"
global faggotomg
;global nH:=80, global	nw:=80
global Rot_Num_in, global Rot_Led_in, global Rot_Num, global Rot_Led, global RotLed_Old , global xnow, global ynow, global Y_pos_1, global X_pos_1, global X_pos_2, global statusbyte
autosave 		:= 	True
apcgui 			:= 	"Images\apctest.png"	;	Main
knob1 			:= 	"Images\knobtest.png"	; 	replace with individual images of knobs
Rot_Mask 		:= 	"Images\mask.png" 		;	Rotary-LED Alpha-notched-Mask
Anus 			:= 	-19.3					;	Rotary-LED separation offset degrees 
global WM_Target 		:= 	"z_in_out.ahk ahk_class AutoHotkey" 	;	Midi feedback
global string
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
winSet, TransColor, EEAA99 
gui, 	APCBackMain:Color, EEAA99 	;gui, 	APCBackMain:Show,x433 y433 w1110 h640, APCBackMain
gui, 	APCBackMain:-Caption

;winSet, TransColor, 1188AA  
 gosub knob_positions_load

; rotarys:
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
DetectHiddenWindows On
SetTitleMatchMode 2
	gui, 	%CuntHole%:New, +OwnDialogs -Caption +ParentAPCBackMain -DPIScale +AlwaysOnTop -SysMenu +ToolWindow, p00 ;Layerr%A_index%
	gui, 	%CuntHole%: +LastFound -Caption +hwnd%cunthole% ; 
	gui, 	%CuntHole%:Color, 000000	;	DllCall("SetParent", "uint", %CuntHole%, "uint", MainhWnd)
	gui, 	%CuntHole%:Add, Picture,X0 Y0 w80 h80 BackgroundTrans , %knob1%	; 
	gui, 	%CuntHole%:Show, %X_pos_2% %Y_pos_1% w80 h80 , %CuntHol%
	WinSet, TransColor, 000000
	%CuntHole%dc 	:= DllCall("GetDC", UInt, %CuntHole%)
	;gui, 	%CuntHole%:hide
	winSet, TransColor, 1188AA  
	gui, 	%GapedJap%:New, -DPIScale +ParentAPCBackMain +hwndhwnd%GapedJap% -SysMenu +E0x80000, %GapedJap%
	gui, 	%GapedJap%: +LastFound -Caption	; DllCall("SetParent", "uint", hwnd%GapedJap%, "uint", MainhWnd)
	pToken%A_index% := Gdip_Startup()
	pImage%A_index% := Gdip_LoadImageFromFile(Rot_Mask)
	noW%A_index%	:= Gdip_GetImageWidth2(pImage%A_index%)
	noH%A_index%	:= Gdip_GetImageHeight2(pImage%A_index%)
	nh := (noH%A_index%), 	nw := (noW%A_index%)	
	ynh:= ("h" .  nh), 		ynw:= ("w" .  nw)
	mDC%A_index%	:= Gdi_CreateCompatibleDC(0)
	mBM%A_index%	:= Gdi_CreateDIBSection(mDC%A_index%, nW, nH, 32)
	oBM%A_index%	:= Gdi_SelectObject(mDC%A_index%, mBM%A_index%)
	Gdip_DrawImageRectI(pGraphics%A_index%:=Gdip_CreateFromHDC(mDC%A_index%), pImage%A_index%, 0, 0, nW, nH)
	
	;DllCall("gdi32.dll\SetStretchBltMode", "Uint", mDC%A_index%, "Int", 5)
	;DllCall("gdi32.dll\StretchBlt", "Uint", mDC%A_index%, "Int", 0, "Int", 0, "Int", nH , "Int", nH , "UInt", %CuntHole%dc, "UInt", 0, "UInt", 0, "Int", nW, "Int", nH, "UInt", "0x00440328")
	;DllCall("UpdateLayeredWindow", "Uint", hwnd%GapedJap%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%A_index%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
	if !init {
		gui, 	APCBackMain:Show,x433 y433 w1110 h666, APCBackMain
		global init:= true
	}
	gui, 	%GapedJap%:Show, %X_pos_2% %Y_pos_1% h80 w80, %GapedJap%
		hwnd%GapedJap% 	:= WinExist()

	;	DllCall("SetParent", "uint", hwnd%GapedJap%, "uint", MainhWnd)
			gui, 	%CuntHole%:hide

	gui, 	%GapedJap%: +LastFound -Caption 
	;WinSet, TransColor, ffffff

		;gui, 	%CuntHole%:hide

 	nH:=80,	nw:=80
 	pBitmap%A_index% := Gdip_CreateBitmapFromFile(Rot_Mask)
	;Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1)
	;Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh)
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

gui, 	ALL_ON:New, +ParentAPCBackMain -DPIScale +toolwindow -SysMenu +E0x80000, ALL_ON ;
gui, 	ALL_ON:+LastFound +HwndALL_ON -Caption 
; gui, 	ALL_ON:Add, Picture,x0 y0 w1122 h560 BackgroundTrans, %ALL_ON%
; gui, 	ALL_ON:Color, EEAA99
; gui, 	ALL_ON:Show,x0 y0 w1110 h640, ALL_ON
; gui, 	ALL_ON:-Caption

;Gui, +LastFound -Caption +E0x80000
iGui := WinExist()

lToken   := Gdip_Startup()
IImage   := Gdip_LoadImageFromFile(ALL_O)
;iW   := Gdip_GetImageWidth(IImage)
;iH   := Gdip_GetImageHeight(IImage)
iW   := 1122
iH   := 560

iDC   := Gdi_CreateCompatibleDC(0)
iBM   := Gdi_CreateDIBSection(iDC, iW, iH, 32)
ioBM   := Gdi_SelectObject(iDC, iBM)
gui, 	ALL_ON:Show,x-7 y0 w1110 h540, ALL_ON
 
;Gui, AL; gui, 	ALL_ON:Show,x0 y0 w1110 h640, ALL_ON
	gui, ALL_ON: -Caption +AlwaysOnTop +LastFound +hwndALL_ON -Caption -DPIScale +AlwaysOnTop +disabled -SysMenu +ToolWindow +owndialogs

Gdip_DrawImageRectI(iGraphics:=Gdip_CreateFromHDC(iDC), IImage, 0, 0, iW, iH)
DllCall("UpdateLayeredWindow", "Uint", iGui, "Uint", 0, "Uint", 0, "int64P", iW|iH<<32, "Uint", iDC, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)

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
gui, 	 cockMain:Show,x0 y0 w1110 h640, cockMain
gui, 	 cockMain:-Caption
loop 3 {
	gui, ALL_ON:hide
	sleep 600
	gui, ALL_ON:Show,x-7 y0 w1110 h540
	sleep 300
}
gui, 	 ALL_ON:hide
gosub 	Knob_Upd8

OnExit,  Exitt
return

GuiEscape:
ExitApp

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
caluclate:
if !counta
	counta := 1
else
	counta := counta +1
	mousegetpos, x, y, ;wnd, cnt
;tooltip % counta " ! " cnt " ! " wnd

if (floor(x)>1025 && floor(x)<1067 && floor(y)<104 && floor(y)>30) { ; the "0" of apc40
	; Show a glowing circle? then
	;msgbox % X "`n" Y " ass"

	exitapp
}

;if (floor(x)>22 && floor(y)>26 && floor(x)<91   && floor(y)<81) { ; rotary 1
	;Rot_Num := 1
;gash:=floor(Format("{:d}", x))
;fuk:=floor(Format("{:d}", y))
statusbyte 	:= 176 
if ((x < 685) && (y < 94)) {
;tooltip % x
	if x between 1 and 98    
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
		if x between 758 and 842
		Rot_Num	:=	9
	else
	if x between 843 and 927
		Rot_Num	:=	10
	else
	if x between 928 and 1010
		Rot_Num	:=	11
	else
	if x between 1011 and 1093
		Rot_Num	:=	12
	} else {
		if x between 758 and 842
			Rot_Num	:=	13
		else
		if x between 843 and 927
			Rot_Num	:=	14
		else
		if x between 928 and 1010
			Rot_Num	:=	15
		else
		if x between 1011 and 1093
			Rot_Num	:=	16
	}	
}
;tooltip % Rot_Num "`n" x "," y

if GetKeyState("Lbutton", "P") {
	oldrot%Rot_Num% := Rot_%Rot_Num%
	while GetKeyState("Lbutton", "P") {
		mousegetpos, xnow, ynow,
		;xres := floor(x - xnow)
		yres := floor(y - ynow) 
						x := XNOW, Y := YNOW

		Rot_LED :=   Rot_%Rot_Num% + (yres * 0.1) 
		IF (floor(Rot_Led)		>	13)
			Rot_Led 			:= 	14
		else {
			if (floor(Rot_Led)	<	0)
				Rot_Led 		:= 	0
			if (Rot_Led 		!= 	oldrot%Rot_Num%) {	
				ROT_%Rot_Num% 	:= 	Rot_Led
				gosub Knob_Upd8
				;send midi
				if Rot_Num < 9
				byte1 		:= Rot_Num + 47 				; knob num
				else byte1 	:= Rot_Num + 7 
				byte2 		:= floor(9.07 * Rot_Led)	; value
				string 		:= (byte1 . "," . byte2 "," statusbyte)
				Send_WM_COPYDATA(string, WM_Target)
				oldrot%Rot_Num% := Rot_Led
}	}	}	}
return

#D::
gosub knob_positions_save
return 

Knob_Upd8:
;nH:=80, nw:=80
;pBitmap%Rot_Num% := Gdip_CreateBitmapFromFile(Rot_Mask)
		;Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1)
		;Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh)
;G%Rot_Num%:=Gdip_GraphicsFromHDC(mdc%Rot_Num%)
Gdip_GraphicsClear(G%Rot_Num%)
Gdip_ResetWorldTransform(G%Rot_Num%)

Gdip_TranslateWorldTransform(G%Rot_Num%, 40, 40)
Gdip_RotateWorldTransform(G%Rot_Num%, (rsot := Rot_%Rot_Num% * 19.3))
Gdip_TranslateWorldTransform(G%Rot_Num%, -40, -40)
;win_move((hwndTr4ny%Rot_Num%) ,"","","80","80")
 
Gdip_DrawImage(G%Rot_Num%, pBitmap%Rot_Num%, 0, 0, nW, nh)
;DllCall("gdi32.dll\SetStretchBltMode","Uint", mDC%Rot_Num%, "Int", 5)
DllCall("gdi32.dll\StretchBlt","Uint",mDC%Rot_Num%, "Int",0, "Int",0, "Int", nH , "Int", nH , "UInt", Dripp%Rot_Num%dc, "UInt",0, "UInt",0, "Int",nW, "Int",nH, "UInt", "0x00440328")
DllCall("UpdateLayeredWindow", "Uint", hwndTr4ny%Rot_Num%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%Rot_Num%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)

return

WM_LBUTTONDOWN() {
;if 	!faggotomg
	settimer caluclate, -1
	return
;faggotomg := false

}
	
Receive_WM_COPYDATA(wParam, lParam) {
    StringAddress := NumGet(lParam + 2*A_PtrSize)
    WmCoppOffData := StrGet(StringAddress) 
	;tooltip % WmCoppOffData "ghg"
	;settimer tooloff, -2000
	Loop Parse, WmCoppOffData, `, 
	{
		if a_index = 1
			Rot_Num := a_loopfield
		if a_index = 2
			Rot_Led := a_loopfield
		}

	; switch Rot_Num_in {
		; case "48":
			; Rot_Num := 1
		; case "49":
			; Rot_Num := 2
		; case "50":
			; Rot_Num := 3
		; case "51":
			; Rot_Num := 4
		; case "52":
			; Rot_Num := 5
		; case "53":
			; Rot_Num := 6
		; case "54":
			; Rot_Num := 7
		; case "55":
			; Rot_Num := 8
		; case "16":
			; Rot_Num := 9
		; case "17":
			; Rot_Num := 10
		; case "18":
			; Rot_Num := 11
		; case "19":
			; Rot_Num := 12
		; case "20":
			; Rot_Num := 13
		; case "21":
			; Rot_Num := 14
		; case "22":
			; Rot_Num := 15
		; case "23":
			; Rot_Num := 16
	; }
			
	; switch Rot_Led_in {
		; case 0,8:
			; Rot_Led	:=	0
		; case 9,17:	
			; Rot_Led	:=	1
		; case 18,26:  	
			; Rot_Led	:=	2
		; case 27,35:	
			; Rot_Led	:=	3
		; case 36,44:	
			; Rot_Led	:=	4
		; case 45,53:	
			; Rot_Led	:=	5
		; case 54,62:	
			; Rot_Led	:=	6
		; case 63,71:	
			; Rot_Led	:=	7
		; case 72,80:	
			; Rot_Led	:=	8
		; case 81,89:	
			; Rot_Led	:=	9
		; case 90,98:	
			; Rot_Led	:=	10
		; case 99,107:	
			; Rot_Led	:=	11
		; case 108,116:	
			; Rot_Led	:=	12
		; case 117,125:	
			; Rot_Led	:=	13
		; case 126,127:
			; Rot_Led	:=	14
	; }           
	Rot_%Rot_Num% := Rot_Led
	
	if (Rot_Led 	!= RotLed_Old) {	
		RotLed_Old 	:= Rot_Led
		gosub 	Knob_Upd8
	}
    return true
}

Send_WM_COPYDATA(StringToSend, WM_Target) {
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0) 
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  
    NumPut(&StringToSend, CopyDataStruct, 2 * A_PtrSize)
	SendMessage, 0x4a, 0, &CopyDataStruct,, % WM_Target
    return ErrorLevel
}

	knob_positions_load:
	
	IniRead, RotLedsLoaded, %KNob_Ini%, knobs, KnobsLED
	sleep 750
	statusbyte 	:= 176 							; top knobs midi iirc
	if (RotLedsLoaded = "ERROR") {
		traytip, ERROR, error loading knobs
		loop 16 {
			Rot_%a_index% := a_index -2
			if a_index > 8
				 byte1 	:= a_index + 7 				; knob num
			else byte1 	:= a_index + 47 				; knob num
			byte2 		:= 	round(floor(9.07 * a_index))	; value
			string 		:= 	(byte1 . "," . byte2 . "," . statusbyte)
			Send_WM_COPYDATA(string, WM_Target)
	} 	} 
	else Loop, parse, RotLedsLoaded, `,
	{
		sleep 20
		Rot_%a_index% := floor(A_LoopField)
		if a_index > 8
			byte1 	:= 	a_index + 7 				; knob num
		else
			byte1 	:= 	a_index + 47 				; knob num
		if !byte2 
			byte2 	:= 	7
		else
			byte2 	:= floor(9.07 * A_LoopField)	; value
		 
		string 		:= (byte1 . "," . byte2 . "," . statusbyte)
		bumface(string,WM_Target)
	
	}
	return
	
	knob_positions_save:
	loop 16 {
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
				string 		:= (byte1 . "," . byte2 "," statusbyte)
				Send_WM_COPYDATA(string, WM_Target)
				oldrot%Rot_Num% := Rot_Led
gosub Knob_Upd8

}	}
return
	bumface(string,WM_Target) {
			bum := Send_WM_COPYDATA(string, WM_Target)
		
		}


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