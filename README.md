# AKAI_APC40_Autohotkey_Midi_&_Script_host
Full MIDI IN / OUT via WinApi calls
Z_in_out.ahk is the main script

WMP scripts are for controlling Windows Media Player
MessageWin is to communicate between script and WMP regularly via WMPPstate.ahk :
Allowing offloading of regular and on demand WMP "Playing" status updates
(and confirmations on state changes in playing /not playing 
(mainly for the flashing light paused indicator and later superfluously to asssis in paused track skip))

Cut currently playing in WMP to clipboard
Paste context Menu

Assign any applications Volume to any Y Fader
Assign any applications Volume to X Fader A or B

Playing WMP Indicator and Paused / stopped flashing LED 

WMP transport assigned to Xfader by default when no Xfader mappings exist (very handy)
skip tracks directly to specific offset when traversing playlist with D Pad (SkipD)

AutoSearch For WMP Currently playng in Soulseek and clipboard

Display brightness control

Aeroglass opacity/blur/reflection control

Color change for event, next track / stopped / playing / bounce effect
ini file working to save settings
