﻿#noEnv ; #warn
#persistent
#SingleInstance force
sendMode Input
#include C:\Script\AHK\- LiB\GDI+_All.ahk
setWorkingDir %a_scriptDir%
setbatchlines -1
global Rot_Num_in, global Rot_Led_in, global Rot_Num, global Rot_Led, global RotLed_Old , global xnow, global ynow, global Y_pos_1, global Y_pos_2, global X_pos_1, global X_pos_2
autosave 		:= True
apcgui 			:= "Images\apctest.png"		;	Main
knob1 			:= "Images\knobtest.png"	; 	replace with individual images of knobs
Rot_Mask 		:= "Images\mask.png" 		;	Rotary-LED Alpha-notched-Mask
Anus 			:= -19.3					;	Rotary-LED separation offset degrees 
WM_Target 		:= "z_in_out.ahk ahk_class AutoHotkey" 	;	Midi feedback
KNob_Ini 		:= "knobs.ini"
wm_allow()
sleep 20
wm_allow()
menu, tray, add, Open Script Folder, Open_ScriptDir,
menu, tray, standard
gosub knob_positions_load

OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA
		;; window message for the mouse left click
OnMessage(0x201, "WM_LBUTTONDOWN")

gui, 	APCBackMain:New, -DPIScale +toolwindow +owner -SysMenu , APCBackMain ;+E0x80000
gui, 	APCBackMain:+LastFound +HwndMainhWnd

;gui, 	APCBackMain:Add, Picture,x0 y0 w1122 h666 BackgroundTrans, %apcgui%
gui, 	APCBackMain:Color, EEAA99
gui, 	APCBackMain:Show,x433 y433 w1110 h640, APCBackMain
gui, 	APCBackMain:-Caption

;winSet, TransColor, EEAA99

;winSet, TransColor, EEAA99

loop 8 {
	;global ("ROT_" . a_index) 
	sFile%A_index% 	:=  Rot_Mask
	CuntHole 		:= 	("Dripp" . A_index)
	GapedJap		:= 	("Tr4ny" . A_index)
	Y_pos_2 		:= 	"y0"
	switch a_index{
		case "1":                                          
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x" . (445 - 445)
		case "2":                                              
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x" . (530 - 445)
		case "3":                                              
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x" . (610 - 445)
		case "4":                                              
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x" . (695 - 445)
		case "5":                                              
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x" . (775 - 445)
		case "6":                                              
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x" . (860 - 445)
		case "7":                                              
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x" . (945 - 445)
		case "8":                                              
			X_pos_1 := "x0", Y_pos_1 := "y0", X_pos_2 := "x" . (1035 - 445)
	}	
	gui, 	%CuntHole%:New, +ParentAPCBackMain -DPIScale +AlwaysOnTop -SysMenu +ToolWindow, Layerr%A_index%
	gui, 	%CuntHole%:+LastFound -Caption +Hwnd%CuntHole%  ; Make the GUI window the last found window for use by the line below.

		DllCall("SetParent", "uint", %CuntHole%, "uint", MainhWnd)

	gui, 	%CuntHole%:Color, 000000
	gui, 	%CuntHole%:Add, Picture,%X_pos_1% %Y_pos_1% w80 h80 BackgroundTrans , %knob1%	; 

	gui, 	%CuntHole%:Show, %X_pos_2% %Y_pos_1% w80 h80 , %CuntHole%
	WinSet, TransColor, 000000
	gui, 	%CuntHole%:hide
	%CuntHole%dc 	:= DllCall("GetDC", "UInt", %CuntHole%)
	
	gui, 	%GapedJap%:New, -DPIScale +hwnd%GapedJap% +ParentAPCBackMain +AlwaysOnTop -SysMenu +ToolWindow, %GapedJap%
	gui, 	%GapedJap%:+LastFound +Hwnd%GapedJap%
	hwnd%GapedJap% 	:= WinExist()
	;DllCall("SetParent", "uint", %GapedJap%, "uint", MainhWnd)

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
	DllCall("SetStretchBltMode","Uint", mDC%A_index%, "Int", 5)
	DllCall("StretchBlt","Uint",mDC%A_index%, "Int",0, "Int",0, "Int", nH , "Int", nH , "UInt", %CuntHole%dc, "UInt",0, "UInt",0, "Int",nW, "Int",nH, "UInt", "0x00440328")        
	DllCall("UpdateLayeredWindow", "Uint", hwnd%GapedJap%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%A_index%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
	gui, 	%GapedJap%:Show, %X_pos_2% %Y_pos_1% h80 w80, %GapedJap%

	gui, 	%GapedJap%:+LastFound +AlwaysOnTop -Caption 
		;gui, 	%CuntHole%:hide

 	nH:=80,	nw:=80
 	pBitmap%A_index% := Gdip_CreateBitmapFromFile(Rot_Mask)
	;Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1)
	;Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh)
	G%A_index%:=Gdip_GraphicsFromHDC(mdc%A_index%)
	Gdip_GraphicsClear(G%A_index%)
	Gdip_ResetWorldTransform(G%A_index%)
	Gdip_TranslateWorldTransform(G%A_index%, 40, 40)
	Gdip_RotateWorldTransform(G%A_index%, (rsot%Rot_Num%:= Rot_%A_index% * 19.3))
	Gdip_TranslateWorldTransform(G%A_index%, -40, -40)

	Gdip_DrawImage(G%A_index%, pBitmap%A_index%, 0, 0, nW, nh)
	;DllCall("SetStretchBltMode","Uint", mDC%A_index%, "Int", 5)
	;DllCall("StretchBlt","Uint",mDC%A_index%, "Int",0, "Int",0, "Int", nH , "Int", nH , "UInt", %CuntHole%dc, "UInt",0, "UInt",0, "Int",nW, "Int",nH, "UInt", "0x00440328")        
	DllCall("UpdateLayeredWindow", "Uint", hwnd%GapedJap%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%A_index%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
	;if A_index > 1
		;DllCall("SetParent", "uint", %CuntHole%, "uint", hwndTr4ny1)
	;else if A_index = 1
		;DllCall("SetParent", "uint", hwndTr4ny1, "uint", MainhWnd)
}
gui, 	cockMain:New, +ParentAPCBackMain -DPIScale +toolwindow -SysMenu , cockMain ;+E0x80000
gui, 	cockMain:+LastFound +Hwndcock
gui, 	cockMain:Add, Picture,x0 y0 w1122 h666 BackgroundTrans, %apcgui%
gui, 	cockMain:Color, EEAA99
gui, 	cockMain:Show,x0 y0 w1110 h640, cockMain
gui, 	cockMain:-Caption



OnExit, Exitt


return

GuiEscape:
ExitApp

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
caluclate:
	mousegetpos, x, y, wnd, cnt

if (floor(x)>1025 && floor(x)<1067 && floor(y)<104 && floor(y)>30) { ; the "0" of apc40
	; Show a glowing circle? then
	;msgbox % X "`n" Y " ass"

	exitapp
}

if (floor(x)>22 && floor(y)>26 && floor(x)<91   && floor(y)<81) { ; the "0" of apc40
	Rot_Num := 1

if GetKeyState("Lbutton", "P") {	
	;if !oldrot%Rot_Num%  
			oldrot%Rot_Num% := Rot_%Rot_Num%
	while GetKeyState("Lbutton", "P") {
		mousegetpos, xnow, ynow,
		xres := floor(x - xnow)
		yres := floor(y - ynow)
		 
		Rot_LED :=   oldrot%Rot_Num% + (yres * 0.1) 
		
			
		; if !oldrot1  
			; oldrot1 := rot_1
		;Rot_LED := rot_1 
		IF FLOOR(Rot_Led)>13 
			Rot_Led := 14
		ELSE
		IF FLOOR(Rot_Led)<0
			Rot_Led := 0
		if (Rot_Led != oldrot%Rot_Num%) {	
			ROT_%Rot_Num% := Rot_Led
			gosub Knob_Upd8
			oldrot%Rot_Num% := Rot_Led
			x := XNOW
			Y := YNOW
		}
		;gosub Knob_Upd8 
	;tooltip % xres "`n" yres
tooltip % yres "`n" oldrot1 " ass"
	
}	}

return
} 
#D::
gosub knob_positions_save
return 

Knob_Upd8:
nH:=80, nw:=80
pBitmap%Rot_Num% := Gdip_CreateBitmapFromFile(Rot_Mask)
;Gdip_GetRotatedDimensions(80, 80, 90, rw1, rh1)
;Gdip_GetRotatedDimensions(0, 0, 57.29578 * atan(0/0), rw, rh)
G%Rot_Num%:=Gdip_GraphicsFromHDC(mdc%Rot_Num%)
Gdip_GraphicsClear(G%Rot_Num%)
Gdip_ResetWorldTransform(G%Rot_Num%)

Gdip_TranslateWorldTransform(G%Rot_Num%, 40, 40)
Gdip_RotateWorldTransform(G%Rot_Num%, (rsot%Rot_Num% := Rot_%Rot_Num% * 19.3))
Gdip_TranslateWorldTransform(G%Rot_Num%, -40, -40)
;win_move((hwndTr4ny%Rot_Num%) ,"","","80","80")
 
Gdip_DrawImage(G%Rot_Num%, pBitmap%Rot_Num%, 0, 0, nW, nh)
DllCall("gdi32.dll\SetStretchBltMode","Uint", mDC%Rot_Num%, "Int", 5)
DllCall("gdi32.dll\StretchBlt","Uint",mDC%Rot_Num%, "Int",0, "Int",0, "Int", nH , "Int", nH , "UInt", Dripp%Rot_Num%dc, "UInt",0, "UInt",0, "Int",nW, "Int",nH, "UInt", "0x00440328")
DllCall("UpdateLayeredWindow", "Uint", hwndTr4ny%Rot_Num%, "Uint", 0, "Uint", 0, "int64P", nW|nH<<32, "Uint", mDC%Rot_Num%, "int64P", 0, "Uint", 0, "intP", 0xFF<<16|1<<24, "Uint", 2)
return

WM_LBUTTONDOWN() {
	settimer caluclate, -1
}
	

Receive_WM_COPYDATA(wParam, lParam)
{
    StringAddress := NumGet(lParam + 2*A_PtrSize)
    WmCoppOffData := StrGet(StringAddress) 
tooltip % WmCoppOffData
	settimer tooloff, -2000
	StringLeft, 	Rot_Num_in, WmCoppOffData, 3
	StringRight, 	Rot_Led_in, WmCoppOffData, 3
	switch Rot_Num_in {
		case "048":
			Rot_Num := 1
		case "049":
			Rot_Num := 2
		case "050":
			Rot_Num := 3
		case "051":
			Rot_Num := 4
		case "052":
			Rot_Num := 5
		case "053":
			Rot_Num := 6
		case "054":
			Rot_Num := 7
		case "055":
			Rot_Num := 8
	}
			
	switch Rot_Led_in {
		case 0,8:
			Rot_Led:=0
		case 9,17:
			Rot_Led:=1
		case 18,26:  
			Rot_Led:=2
		case 27,35:
			Rot_Led:=3
		case 36,44:
			Rot_Led:=4
		case 45,53:
			Rot_Led:=5
		case 54,62:
			Rot_Led:=6
		case 63,71:
			Rot_Led:=7
		case 72,80:
			Rot_Led:=8
		case 81,89:
			Rot_Led:=9
		case 90,98:
			Rot_Led:=10
		case 99,107:
			Rot_Led:=11
		case 108,116:
			Rot_Led:=12
		case 117,125:
			Rot_Led:=13
		case 126,127:
			Rot_Led:=14
	}           
	Rot_%Rot_Num% := Rot_Led
		
	
	if (Rot_Led 	!= RotLed_Old) {	
		gosub Knob_Upd8
		RotLed_Old 	:= Rot_Led
	}
    return true
}


Gdi_CreateCompatibleDC(hDC = 0)
{
   Return   DllCall("gdi32\CreateCompatibleDC", "Uint", hDC)
}

Gdi_CreateDIBSection(hDC, nW, nH, bpp = 32, ByRef pBits = "")
{
   NumPut(VarSetCapacity(bi, 40, 0), bi)
   NumPut(nW, bi, 4)
   NumPut(nH, bi, 8)
   NumPut(bpp, NumPut(1, bi, 12, "UShort"), 0, "Ushort")
 
   Return   DllCall("gdi32\CreateDIBSection", "Uint", hDC, "Uint", &bi, "Uint", DIB_RGB_COLORS:=0, "UintP", pBits, "Uint", 0, "Uint", 0)
}

Gdi_SelectObject(hDC, hGdiObj)
{
   Return   DllCall("gdi32\SelectObject", "Uint", hDC, "Uint", hGdiObj)
}

Gdi_DeleteObject(hGdiObj)
{
   Return   DllCall("gdi32\DeleteObject", "Uint", hGdiObj)
}

Gdi_DeleteDC(hDC)
{
   Return   DllCall("gdi32\DeleteDC", "Uint", hDC)
}

Gdip_Startup22()
{
   If Not   DllCall("GetModuleHandle", "str", "gdiplus")
      DllCall("LoadLibrary"    , "str", "gdiplus")
   VarSetCapacity(si, 16, 0), si := Chr(1)
   DllCall("gdiplus\GdiplusStartup", "UintP", pToken, "Uint", &si, "Uint", 0)
   Return   pToken
}

Gdip_Shutdown2(pToken)
{
   DllCall("gdiplus\GdiplusShutdown", "Uint", pToken)
   If   hModule :=   DllCall("GetModuleHandle", "str", "gdiplus")
         DllCall("FreeLibrary"    , "Uint", hModule)
   Return   0
}

Gdip_CreateFromHDC(hDC)
{
   DllCall("gdiplus\GdipCreateFromHDC", "Uint", hDC, "UintP", pGraphics)
   Return   pGraphics
}

Gdip_DeleteGraphics2(pGraphics)
{
   Return   DllCall("gdiplus\GdipDeleteGraphics", "Uint", pGraphics)
}

Gdip_DisposeImage2(pImage)
{
   Return   DllCall("gdiplus\GdipDisposeImage", "Uint", pImage)
}

Gdip_GetImageWidth2(pImage)
{
   DllCall("gdiplus\GdipGetImageWidth", "Uint", pImage, "UintP", nW)
   Return   nW
}

Gdip_GetImageHeight2(pImage)
{
   DllCall("gdiplus\GdipGetImageHeight", "Uint", pImage, "UintP", nH)
   Return   nH
}

Gdip_DrawImageRectI(pGraphics, pImage, nL, nT, nW, nH)
{
   Return   DllCall("gdiplus\GdipDrawImageRectI", "Uint", pGraphics, "Uint", pImage, "int", nL, "int", nT, "int", nW, "int", nH)
}


Send_WM_COPYDATA(ByRef StringToSend, ByRef WM_Target)  ; ByRef saves a little memory in this case.
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
    ; First set the structure's cbData member to the size of the string, including its zero terminator:
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    TimeOutTime := 4000  ; Optional. Milliseconds to wait for response from receiver.ahk. Default is 5000
    ; Must use SendMessage not PostMessage.
    SendMessage, 0x4a, 0, &CopyDataStruct,, %WM_Target%,,,, %TimeOutTime% ; 0x4a is WM_COPYDATA.
    DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
    SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
    return ErrorLevel  ; Return SendMessage's reply back to our caller.
}

	knob_positions_load:
	loop 8
		Rot_%a_index% := 6
	IniRead, RotLedsLoaded, %KNob_Ini%, knobs, KnobsLED
	sleep 300 
	Loop, parse, RotLedsLoaded, `, ;  Parses a comma-separated string.
	{


		Rot_%a_index% := A_LoopField
		
	}
		
	return
	
	knob_positions_save:
	loop 8 {
		If !RotLedsSaved
			RotLedsSaved := Rot_%a_index%
		else
			RotLedsSaved := ( RotLedsSaved . "`," . Rot_%a_index%)
	}

	return
	
	knob_positions_save_Writeini:
	if RotLedsLoaded =% RotLedsSaved 
	{
		tooltip No changes no save
		sleep 1.7
	} else 
		IniWrite, % RotLedsSaved, % KNob_Ini, knobs, KnobsLED
	return

	Knobs_DestroyDcs: 	; 	leaves image on display
	Loop 8 {
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