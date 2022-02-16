gui, palete:New
OnMessage(0x201, "WM_LBUTTONDOWN")
;gosub, COLOUR_SORT
gui, 	palete:New, -DPIScale +toolwindow +owner -SysMenu +AlwaysOnTop, palete ;+E0x80000
gui, 	palete:+LastFound +HwndhWndpalete
gui, 	palete:color, 110033 	;gui, 	APCBackMain:Show,x433 y433 w1110 h640, APCBackMain
gui, 	palete:-Caption

winSet, Transcolor, 110033 

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
Loop, {
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



check:
if !rot_1
msgbox no rot
return 

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
 		
		
		
		
		