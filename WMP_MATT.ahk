#NoEnv 		
SetWorkingDir %A_ScriptDir% 		
#persistent 		
#singleinstance force
#Include VA.ahk
SendMode Input
Menu, Tray, Icon, wmp.ico
setbatchlines -1
;Pause=18808
Stop=18809
Play=0x2e0000
Pause=32808
Prev=18810
Next=18811
Vol_Up=32815
Vol_Down=32816
;VARs::::::::::::

SkipD = 86   ;Skip Distance after track change
wmp := new RemoteWMP
;WinTitle=ahk_class WMPlayerApp
WinTitle=Windows Media Player
sleep 20,
media := wmp.player.currentMedia
controls := wmp.player.controls


;Binds::::::::::::


^>+PgUp::PostMessage, 0x111, vol_up, 0, ,%WinTitle% 	; Volume Up 		- 		;ctrl shift page up
return

^>+PgDn::PostMessage,  0x111, vol_down, 0, ,%WinTitle% 	; Volume Down	-		;ctrl shift page down
return

^>+Enter::			;ctrl shift enter
;tooltip, % media.sourceURL
wmp := new RemoteWMP
unc= % media.sourceURL
media := wmp.player.currentMedia
controls := wmp.player.controls
sleep 250
1st:= RegExReplace(unc, "^.+\\|\.[^.]+$")
		2nd := RegExReplace(1st, "[\-1234567890&@'~!£$%^&*]")
tooltip, %unc%
clipboard:= 2nd
clipwait
settimer, ToolTip_Off, -4000
return

^>+Up::			;ctrl shift del
GoSub WMP_Copy_Search
Return

^>+Del::			;ctrl shift del
GoSub WMP_Del
Return

^>+Space::		;ctrl shift space
GoSub WMP_Pause
Return

^>+Left::			;ctrl shift left
GoSub WMP_Prev
Return

^>+Right::		;ctrl shift right
GoSub WMP_Next
Return

^>+Down::		;ctrl shift down 
Path2File:=media.sourceURL

if InvokeVerb(Path2File, "Cut")
{ 
    Process,Exist
    hwnd:=WinExist("ahk_class tooltips_class32 ahk_pid " Errorlevel)
}  ; run wmp_cut.ahk ;cut mp3 to clipboard
clipwait
Menu, Tray, Icon, copy.ico
Monster_Clip=%clipboard%
settimer Clip_Commander, 1000
Return

Clip_Commander:
if clipboard!=%Monster_Clip%
	settimer Clip_Commander, off
else
	Menu, Tray, Icon, wmp.ico
return

;OTHER SHIT::::::::::::


; MsgBox, % media.sourceURL
; MsgBox, % controls.currentPosition . "`n"
        ; . controls.currentPositionString
; MsgBox, % media.getItemInfo("WM/AlbumTitle")
; All attribute names you can get with media.getItemInfo(attributeName)
; Loop % media.attributeCount
   ; attributes .= media.getAttributeName(A_Index - 1) . "`r`n"
; MsgBox, % Clipboard := attributes

class RemoteWMP
{
   __New()  {
      static IID_IOleClientSite := "{00000118-0000-0000-C000-000000000046}"
           , IID_IOleObject     := "{00000112-0000-0000-C000-000000000046}"
      Process, Exist, wmplayer.exe
      if !ErrorLevel
         throw Exception("wmplayer.exe is not running")
      if !this.player := ComObjCreate("WMPlayer.OCX.7")
         throw Exception("Failed to get WMPlayer.OCX.7 object")
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
   
   TogglePause()  {
      if (this.player.playState = 3)  ; Playing = 3
         this.player.Controls.pause()
      else
         this.player.Controls.play()
   }
}

IWMPRemoteMediaServices_CreateInstance()
{
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

IUnknown_QueryInterface(this_, riid, ppvObject)
{
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
return

WMP_Pause:
	Process, Exist, wmplayer.exe
	ifwinnotexist, Windows Media Player
		TrayTip, Windows Media Player, Process found but window Not,3000,2
	Else
		PostMessage, 0x111, Pause, 0, ,%WinTitle%
	return

WMP_Prev:
	Process, Exist, wmplayer.exe
	ifwinnotexist, Windows Media Player
		TrayTip, Windows Media Player, Process found but window Not,3000,2
	Else
		{
		PostMessage, 0x111, Stop, 0, ,%WinTitle%
		sleep, 50
		PostMessage, 0x111, Prev, 0, ,%WinTitle%
		sleep, 50
		; wmp := new RemoteWMP
		; media := wmp.player.currentMedia
		; controls := wmp.player.controls
		thecall2:
		gosub thetry
		if newsong =% oldsong
			{
			;tooltip, newsong = oldsong
			sleep 100
			gosub thecall2
			}
		else
			{
			wmp.jump(skipD)
			sleep 350
			PostMessage, 0x319, 0, Play, ,%WinTitle%
			;TOOLTIP, congrats you changed to the next tune you bell
			RETURN
			}
		return
		}
	return

WMP_NEXT:
Process, Exist, wmplayer.exe
ifwinnotexist, Windows Media Player
	{
	TrayTip, Windows Media Player, Process found but window Not,3000,2
	Return
	}
Else
	{
	PostMessage, 0x111, Stop, 0, ,%WinTitle%
	sleep, 50
	PostMessage, 0x111, Next, 0, ,%WinTitle%
	sleep 50
	thecall1:
	gosub thetry
	if newsong =% oldsong
		{
		;tooltip, newsong = oldsong
		sleep 100
		gosub thecall1
		}
	else
		{
		wmp.jump(skipD)
		sleep 100
		PostMessage, 0x319, 0, Play, ,%WinTitle%
		;TOOLTIP, congrats you changed to the next tune you bell
		}
	}
return

WMP_Copy_Search:
{
wmp := new RemoteWMP
sleep, 20
media := wmp.player.currentMedia
controls := wmp.player.controls
sleep, 20
fullpath:=media.sourceurl
sleep, 20
Process, Exist, slsk2.exe
     if !ErrorLevel
{
		tooltip, error slsk not open
		settimer, ToolTip_Off, -4000
}
	else
		{
		1st:= RegExReplace(fullpath, "^.+\\|\.[^.]+$")
		2nd := RegExReplace(1st, "[\-1234567890&@'~!£$%^&*]")
		MouseGetPos, orig_x, orig_y
		WinGet, slskpid, pid, SoulSeek [headcrack] - [Transfers]
		WinGet, hWindow, ID, SoulSeek [headcrack] - [Transfers]
		Winshow , SoulSeek [headcrack] - [Transfers]
		WinActivate  SoulSeek
		MouseMove, 145, 90,,
		Send {LButton}
		Send % 3rd := RegExReplace(2nd, "[/_()/]", " ")  ;"/[\-_]/", " "
		Send {enter}
		MouseMove, 1421, 243,,
		Send {LButton}
		MouseMove, orig_x, orig_y, 
		Clipboard:=3rd
		return
		}
}

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
return

WMP_Del: 
{
 Process, Exist, wmplayer.exe
{
wmp2del := new RemoteWMP
sleep 300
media2del := wmp2del.player.currentMedia
gosub wmp_next
tooltip, Deletion Releasing, 4000, 3000

;settimer, tooltip_off, -3000
settimer, DELETE_, -6000
return
}}

DELETE_:   
{   
;iniwrite, % media2del, Deletions.ini, yep_gone
;tooltip, test,,,6
;wmp2del.delete
try 
File2Del= % media2del.sourceURL
catch
gosub WMP_Del
FileRecycle, % File2Del
;F2dName := RegExReplace(File2Del, "^.+\\|\.[^.]+$")
;TrayTip, Windows Media Player, Deleted %media2del%, 3, 1
settimer ToolTip_Off, -5000 
return
}


InvokeVerb(path, menu, validate=True) {
    objShell := ComObjCreate("Shell.Application")
    if InStr(FileExist(path), "D") || InStr(path, "::{") {
        objFolder := objShell.NameSpace(path)   
        objFolderItem := objFolder.Self
    } else {
        SplitPath, path, name, dir
        objFolder := objShell.NameSpace(dir)
        objFolderItem := objFolder.ParseName(name)
    }
    if validate {
        colVerbs := objFolderItem.Verbs   
        loop % colVerbs.Count {
            verb := colVerbs.Item(A_Index - 1)
            retMenu := verb.name
            StringReplace, retMenu, retMenu, &       
            if (retMenu = menu) {
                verb.DoIt
                Return True
            }
        }
		Return False
    } else
        objFolderItem.InvokeVerbEx(Menu)
} 
sleep 2000
return

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


; --- Vista Audio Additions ---
;
; ISimpleAudioVolume : {87CE5498-68D6-44E5-9215-6DA47EF883D8}
;
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


ToolTip_Off:
{	
ToolTip,
settimer ToolTip_Off, off
return
}

/* 
Play
WinMsg - Post Message
Current Window
Message ID: 0x319
WParam: 0
LParam: 0x2e0000


Pause
WinMsg - Post Message
Current Window
Message ID: 0x319
WParam: 0
LParam: 0x2f0000 


Toggle play/pause

WinMsg - Post Message
Current Window (Or search by window title "Windows Media Player")
Message ID: 0x111
WParam: 32808
LParam: 0 

WParams:

16000 - Go to "Now Playing"
16001 - Go to "Guide"
16002 - Go to "Service Task 1" This is the "Music" tab on my player
16003 - Go to "Rip"
16004 - Go to "Library"
16005 - Go to "Service Task 3" This is the "Video" tab on my player
16006 - Go to "Burn"
16007 - Go to "Sync"
16008 - Go to "Service Task 2" This is the "Radio" tab on my player

16009 - Skin Chooser

18724 - Rip Audio CD Doesn't do anything if media is playing

18777 - "Rip" tab

18779 - Open "Properties" dialog RC=FAIL. Use 32779 or PostMessage
18780 - View Full Mode
18781 - View Compact Mode
18782 - Full screen (toggle)
18783 - Show/Hide Playlist (toggle)

18787 - Show/Hide Media Information (toggle)

18789 - Show/Hide Enhancements (toggle)

18791 - Show/Hide Title (toggle)

18799 - Video Size: 50%
18800 - Video Size: 100%
18801 - Video Size: 200%
18802 - Video Size: Fit Video to Player on Resize (toggle)

18805 - Video Size: Fit Player to Video on Start (toggle)

18808 - Play/Pause Track (toggle)
18809 - Stop
18810 - Previous Track
18811 - Next track
18812 - Rewind Only works on video?
18813 - Fast Forward (toggle)

18815 - Volume: Up
18816 - Volume: Down
18817 - Volume: Mute (toggle)

18824 - View Privacy Statement Link to external web page
18825 - Open "Options" dialog RC=FAIL. Use 32825 or PostMessage
18826 - Open "Windows Media Player Help"

18834 - Play Speed: Fast
18835 - Play Speed: Normal
18836 - Play Speed: Slow

18842 - Shuffle (toggle)
18843 - Repeat (toggle)

18846 - Download: Visualizations Link to external web page

18849 - Open "Add to Library by Searching Computer" dialog RC=FAIL. Use 32849 or PostMessage
18850 - Open "Monitory Folders" dialog RC=FAIL. Use 32850 or PostMessage

18861 - Open "File Open" dialog RC=FAIL. Use 32861 or PostMessage
18862 - Open "Open URL" dialog RC=FAIL. Use 32862 or PostMessage

18871 - Open "Manage Licenses" dialog RC=FAIL. Use 32871 or PostMessage
18872 - Open "Open URL" dialog (Same as 18862?) RC=FAIL. Use 32862 or PostMessage

Codes 18880 to ????? causes WMP to crash. RC=FAIL or
RC=0. Haven't tried PostMessage


18889 - Save "Now Playing List" As RC=FAIL. Use ????? or PostMessage

18904 - Work Offline (toggle)

18907 - Burn Audio CD

18909 - Synchronize

18794 - Open "Statistics" dialog

19102 - Print Label Not sure when this is available

19011 - Open "Save As" dialog RC=FAIL. Use ????? or PostMessage

19013 - Save "Now Playling List"
19014 - New "Now Playing List"

19141 - Windows Media Player Online Link to external web page
19142 - Download: Supported Devices and Drivers Link to external web page
19143 - Download: Skins Link to external web page

19160 - Troubleshooting Link to external web page

19200 - Info Center View (Under "Now Playing" tab)

19230 - Display "Quiet Mode" Shows "Enhancements" window
19231 - Display "Color Chooser" Shows "Enhancements" window
19232 - Display "Crossfading and Auto Volume Leveling" Shows "Enhancements" window
19233 - Display "Graphic Equalizer" Shows "Enhancements" window
19234 - Display "Media Link for E-Mail" Shows "Enhancements" window
19235 - Display "Play Speed Settings" Shows "Enhancements" window
19236 - Display "SRS WOW Effects" Shows "Enhancements" window
19237 - Display "Video Settings" Shows "Enhancements" window

19497 - Download Plug-ins Link to external web page
19498 - Open Plug-ins Options dialog

19500 - DVD: Root Menu
19501 - DVD: Title Menu Returns 1 if menu is not available (?)
19502 - DVD: Close Menu (Resume)
19503 - DVD: Back

19572 - Update DVD Information RC=FAIL. Use ????? or PostMessage

19681 - DVD, VCD or CD Audio

19721 - Show Menu Bar
19722 - Hide Menu Bar
19723 - Autohide Menu Bar
19724 - Hide Taskbar (toggle)

19998 - Download: Plug-ins Link to external web page
19999 - Open Plug-ins Options dialog RC=FAIL. Use 19498 or PostMessage

26000 - Services List



32777 - Info Center View (Under "Now Playing" tab)

32779 - Open "Properties" dialog
32780 - View Full Mode
32781 - View Compact Mode
32782 - Full screen (toggle)
32783 - Show/Hide Playlist (toggle)

32787 - Show/Hide Media Information (toggle)

32789 - Show/Hide Equilizer (toggle)

32791 - Show/Hide Title (toggle)

32794 - Open "Statistics" dialog

32797 - *** Locks up WMP & eats up CPU. Don't know why ***
32798 - *** Locks up WMP & eats up CPU. Don't know why ***

32805 - "Music" tab
32806 - "Library" tab

32808 - Play/Pause Track (toggle)
32809 - Stop
32810 - Previous Track
32811 - Next Track

32813 - Fast Forward (toggle)

32815 - Volume Up
32816 - Volume Down
32817 - Volume Mute (toggle)

32824 - Link to Privacy Statement (web)
32825 - Open "Options" dialog
32826 - Open "Windows Media Player Help"

32834 - Play Speed: Fast
32835 - Play Speed: Normal
32836 - Play Speed: Slow

32842 - Shuffle (toggle)
32843 - Repeat (toggle)

32846 - Download: Visualizations Link to external web page

32849 - Open "Add to Library by Searching Computer" dialog
32850 - Open "Monitory Folders" dialog

32861 - Open "File Open" dialog
32862 - Open "Open URL" dialog

32871 - Open "Manage Licenses" dialog
32872 - Open "Open URL" dialog (Same as 32862?)

Codes 32880 to ????? causes WMP to crash. RC=FAIL or
RC=0. Haven't tried PostMessage.


57601 - Open "File Open" dialog RC=FAIL. Use 32861 or PostMessage
57602 - File Close

57665 - Exit


 */