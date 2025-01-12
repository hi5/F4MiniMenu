/*

General program settings GUI
Include for F4MiniMenu.ahk

*/

Settings:

Gui, Browse:Destroy

; Variables
;SelectMenuPos:=MatchList.settings.MenuPos
;SelectTCStart:=MatchList.settings.TCStart
;SettingsFormat:=MatchList.settings.SettingsFormat
;If (SettingsFormat = "")
;	SettingsFormat:=1
;OldSettingsFormat:=SettingsFormat

If (MatchList.settings.FilteredMenuAutoEdit = "")
	MatchList.settings.FilteredMenuAutoEdit:=1
FGHKey:=MatchList.settings.ForegroundHotkey
BGHKey:=MatchList.settings.BackgroundHotkey
TMHKey:=MatchList.settings.FilteredHotkey


; Turn hotkeys off to be sure
HotKeyState:="Off"
Gosub, SetHotkeys

; Gui for general program settings
Gui, Settings: +OwnDialogs
Gui, Settings: font,              % dpi("s8")
Gui, Settings: Add, GroupBox,     % dpi("x16 y7 w540 h70"), Menu
Gui, Settings: Add, Text,         % dpi("x25 y25 w309 h16"), &Selection menu appears (TC only)
Gui, Settings: Add, DropDownList, % dpi("x328 y20 w219 h25 r4 Choose" MatchList.settings.MenuPos " vMenuPos AltSubmit"), 1 - At Mouse cursor|2 - Centered in window|3 - Right next to current file|4 - Docked next to current file (opposite panel)
Gui, Settings: Add, Text,         % dpi("x25 yp+35 w309 h16"), &Accelerator key for full menu (for use in filtered menu, 1 char.)
Gui, Settings: Add, Edit,         % dpi("x328 yp-5 w30 h21 vFullMenu"), % MatchList.settings.FullMenu ; %
Gui, Settings: Add, Text,         % dpi("x365 yp+5 w70 h16"), If one result:
Gui, Settings: Add, DropDownList, % dpi("x430 yp-5 w117 h25 r2 Choose" MatchList.settings.FilteredMenuAutoEdit " vFilteredMenuAutoEdit AltSubmit"), 1 - Show menu|2 - Edit directly

Gui, Settings: Add, GroupBox,     % dpi("x16 yp+40 w260 h45"), Files
Gui, Settings: Add, Text,         % dpi("x25 yp+20 w209 h16"), &Maximum number of files to be opened
Gui, Settings: Add, Edit,         % dpi("x227 yp-5 w40 h21 Number vMaxFiles"), % MatchList.settings.Maxfiles ; %

Gui, Settings: Add, GroupBox,     % dpi("x280 yp-15 w276 h45"), WinWait
Gui, Settings: Add, Text,         % dpi("x289 yp+20 w209 h16"), &Seconds (max) to wait for program window
Gui, Settings: Add, Edit,         % dpi("x507 yp-5 w40 h21")
Gui, Settings: Add, UpDown, vMaxWinWaitSec Range2-10, % MatchList.Settings.MaxWinWaitSec ; %


Gui, Settings: Add, GroupBox,     % dpi("x16 yp+40 w540 h100"), Total Commander
Gui, Settings: Add, DropDownList, % dpi("x25 yp+20 w240 h25 R3 Choose" MatchList.settings.TCStart " vTCStart AltSubmit"), 1 - Do not start TC (default)|2 - Start TC if not Running (set TC Path)|3 - Always start TC (set TC Path) 
Gui, Settings: Add, Text,         % dpi("xp+250 yp+5 w50 h16"), TC Path
If !FileExist(MatchList.settings.TCPath)
	MatchList.settings.TCPath:=""
Gui, Settings: Add, Edit  ,       % dpi("xp+53  yp-5 w180 h21 vTCPath"), % MatchList.settings.TCPath ; %
Gui, Settings: Add, Button,       % dpi("xp+187  yp   w30  h20 gSelectExe"), >>

Gui, Settings: Add, Text,         % dpi("xp-238 yp+30 w50 h16"), INI Path
If !FileExist(MatchList.settings.TCIniPath)
	MatchList.settings.TCIniPath:=""

Gui, Settings: Add, Edit  ,       % dpi("xp+51  yp-5 w180 h21 vTCIniPath"), % MatchList.settings.TCIniPath ; %
Gui, Settings: Add, Button,       % dpi("xp+187 yp   w30  h20 gSelectIni"), >>

Checked:=MatchList.settings.F4MMCloseAll
Gui, Settings: Add, Checkbox,     % dpi("x25 yp+3   w240 h16 Checked" checked " vF4MMCloseAll"), Close F4MM when all copies of TC close
Checked:=MatchList.settings.F4MMClosePID
Gui, Settings: Add, Checkbox,     % dpi("x25 yp+25  w240 h16 Checked" checked " vF4MMClosePID"), Close F4MM when TC closes started by F4MM
Gui, Settings: Font, % dpi("cGreen")
Gui, Settings: Add, Text,         % dpi("xp+240 yp gFMMCloseHelpText"), (?)
Gui, Settings: Add, Text,         % dpi("xp+260 yp gFMMPathsHelpText"), (?)
Gui, Settings: Font, % dpi("cBlack")
Gui, Settings: Font, ; needed as theme is stripped from control @ https://www.autohotkey.com/boards/viewtopic.php?p=399355#p399355
Gui, Settings: Font, % dpi("s8")

Gui, Settings: Add, GroupBox,     % dpi("x16 yp+35 w395 h120"), Hotkeys

Gui, Settings: Add, Text,         % dpi("x25 yp+25 w150 h16"), &Background mode (direct)
;Gui, Settings: Add, Radio,        % dpi("xp+130 yp w45 h16 vBEsc"), Esc
;Gui, Settings: Add, Radio,        % dpi("xp+45  yp w45 h16 vBWin"), Win
Gui, Settings: Add, DropDownList, % dpi("xp+140 yp-3 w70 R3 vBMod"), |Esc|Win

; Always annoying to work around Hotkey control limit, use boxes for Win & Esc keys
Gui, Settings: Default
If InStr(BGHKey,"#")
	{
	 StringReplace, BGHKey, BGHKey, #, , All
	 GuiControl, Choose, BMod, 3
	}
If InStr(BGHKey,"Esc &")
	{
	 StringReplace, BGHKey, BGHKey, Esc &, , All
	 StringReplace, BGHKey, BGHKey, Esc &amp`;, , All
	 StringReplace, BGHKey, BGHKey, Esc &amp;, , All
	 StringReplace, BGHKey, BGHKey, %A_Space%, , All
	 GuiControl, Choose, BMod, 3
	}

Gui, Settings: Add, Hotkey, % dpi("xp+90 yp w140 h20 vBGHKey"), %BGHKey%

Gui, Settings: Add, Text, % dpi("x25 yp+35 w150 h16"), &Foreground mode (menu)
;Gui, Settings: Add, Radio, % dpi("xp+130 yp w45 h16 vFEsc"), Esc
;Gui, Settings: Add, Radio, % dpi("xp+45  yp w45 h16 vFWin"), Win
Gui, Settings: Add, DropDownList, % dpi("xp+140 yp-3 w70 R3 vFMod"), |Esc|Win

Gui, Settings: Default

If InStr(FGHKey,"#")
	{
	 StringReplace, FGHKey, FGHKey, #, , All
	 GuiControl, Choose, FMod, 3
	}

If InStr(FGHKey,"Esc &")
	{
	 StringReplace, FGHKey, FGHKey, Esc &, , All
	 StringReplace, FGHKey, FGHKey, Esc &amp`;, , All
	 StringReplace, FGHKey, FGHKey, Esc &amp;, , All
	 StringReplace, FGHKey, FGHKey, %A_Space%, , All
	 GuiControl, Choose, FMod, 2
	}
	
Gui, Settings: Add, Hotkey, % dpi("xp+90 yp w140 h20 vFGHKey"), %FGHKey% 
;Gui, Settings: Add, Button, % dpi("xp+110 yp w30 h20 gButtonClearFG"), clear

Gui, Settings: Add, Text, % dpi("x25 yp+35 w150 h16"), Fil&tered mode (menu)
;Gui, Settings: Add, Radio, % dpi("xp+130 yp w45 h16 vTEsc"), Esc
;Gui, Settings: Add, Radio, % dpi("xp+45  yp w45 h16 vTWin"), Win
Gui, Settings: Add, DropDownList, % dpi("xp+140 yp-3 w70 R3 vTmod"), |Esc|Win

Gui, Settings: Default

If InStr(TMHKey,"#")
	{
	 StringReplace, TMHKey, TMHKey, #, , All
	 GuiControl, Choose , Tmod, 3
	}

If InStr(TMHKey,"Esc &")
	{
	 StringReplace, TMHKey, TMHKey, Esc &, , All
	 StringReplace, TMHKey, TMHKey, Esc &amp`;, , All
	 StringReplace, TMHKey, TMHKey, Esc &amp;, , All
	 StringReplace, TMHKey, TMHKey, %A_Space%, , All
	 GuiControl, Choose, Tmod, 2
	}
	
Gui, Settings: Add, Hotkey, % dpi("xp+90 yp w140 h20 vTMHKey"), %TMHKey% 
; Gui, Settings: Add, Button, % dpi("xp+110 yp w30 h20 gButtonClearTM"), clear

Gui, Settings: Add, Button, % dpi("xp+170 yp-75 w120 h25 gButtonOK"), OK
Gui, Settings: Add, Button, % dpi("xp     yp+40 w120 h25 gButtonClear"), Clear All Hotkeys
Gui, Settings: Add, Button, % dpi("xp     yp+40 w120 h25 gSettingsGuiClose"), Cancel

Gui, Settings: Add, GroupBox, % dpi("x16 yp+40 w260 h72"), Other prg. (Hotkey: Copy File Names w. Full Path)

Gui, Settings: Add, Text,      % dpi("x25 yp+20 w100 h20"), Dbl Cmd:
Gui, Settings: Add, Hotkey,    % dpi("xp+52 yp-3 w90 h20 vDoubleCommander"), % MatchList.settings.DoubleCommander

Gui, Settings: Add, Text,      % dpi("x25 yp+30 w50 h20"), XYPlorer:
Gui, Settings: Add, Hotkey,    % dpi("xp+52 yp-3 w90 h20 vXYPlorer"), % MatchList.settings.XYPlorer

Checked:=MatchList.settings.Explorer
Gui, Settings: Add, Checkbox,  % dpi("xp+100 yp-25 w60 h16 Checked" checked " vExplorer"), Explorer

Checked:=MatchList.settings.Everything
Gui, Settings: Add, Checkbox,  % dpi("xp     yp+28 w80 h16 Checked" checked " vEverything"), Everything

Gui, Settings: Font, % dpi("s8 cGreen")
Gui, Settings: Add, Text,      % dpi("xp+70 yp-28 gFMMFileManText"), (?)
Gui, Settings: Font, % dpi("cBlack")
Gui, Settings: Font, ; see note above, required to reset style
Gui, Settings: Font, % dpi("s8")

Gui, Settings: Add, GroupBox, % dpi("xp+35 yp-19 w270 h72"), Use elsewhere in TC (no menu)

Checked:=MatchList.settings.Lister
Gui, Settings: Add, Checkbox,  % dpi("xp+10 yp+20 w220 h16 Checked" checked " vLister"), Lister (+ use F4Edit setting in wincmd.ini)

Checked:=MatchList.settings.QuickView
Gui, Settings: Add, Checkbox,  % dpi("xp    yp+28 w120 h16 Checked" checked " vQuickView"), QuickView (see ?)

Checked:=MatchList.settings.FindFiles
Gui, Settings: Add, Checkbox,  % dpi("xp+160 yp w80 h16 Checked" checked " vFindFiles"), Find Files

Gui, Settings: Font, % dpi("s8 cGreen")
Gui, Settings: Add, Text,      % dpi("xp+70 yp-28 gFMMTCElseWhere"), (?)
Gui, Settings: Font, % dpi("cBlack")
Gui, Settings: Font, ; see note above, required to reset style
Gui, Settings: Font, % dpi("s8")


; Note: deactivated Everything Directory Tree and DocumentTemplates settings for now
/*
Gui, Settings: Add, Text,      % dpi("xp+70 yp+1 w100 h20"), Ev. Dir Tree:
Gui, Settings: Add, Hotkey,    % dpi("xp+100 yp-3 w90 h20 vEVDirTree"), % MatchList.settings.EVDirTree

Gui, Settings: Add, Text,      % dpi("xp+100 yp+1 w50 h20"), Ev. Path:
Gui, Settings: Add, Edit  ,    % dpi("xp+50  yp-5 w160 h21 vEvPath"), % MatchList.settings.EvPath ; %
Gui, Settings: Add, Button,    % dpi("xp+165  yp   w30  h20 gSelectEv"), >>

Gui, Settings: Add, GroupBox, % dpi("x16 yp+45 w540 h70"), Currently Available Document Templates
Gui, Settings: Add, Edit, % dpi("x25 yp+20 ReadOnly h40 w385 vDocumentTemplates"), % MatchList.Settings.templatesExt
Gui, Settings: Add, Button, % dpi("xp+402 yp w120 h25 gButtonDocumentTemplates"), Update (scan)
*/

;Gui, Settings: Add, GroupBox, x16 yp+40 w395 h60 , Misc.
;perhaps in future versions
;Gui, Settings: Add, Text, x25 yp+25 w150 h16 , Store set&tings in:
;Gui, Settings: Add, DropDownList, xp+225 yp-5 w140 h25 r2 Choose%SettingsFormat% vSettingsFormat AltSubmit, 1 - XML Format|2 - INI format

Gui, Settings: Add, Link,   % dpi("x25 yp+60"), F4MiniMenu %F4Version%: Open selected file(s) from TC in defined editor(s). More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>.

;Gui, Settings: Add, GroupBox, xp+400 yp-85 w122 h60
;Gui, Settings: Add, Link,   xp+5 yp+13, Feedback welcome at`n<a href="http://ghisler.ch/board/viewtopic.php?t=35721">Total Commander forum</a>`nor <a href="https://github.com/hi5/F4MiniMenu">GitHub Issues</a>.

Gui, Settings: Show, % dpi("center w570"), F4MiniMenu - Settings
Return

ButtonDocumentTemplates:
Gosub, DocumentTemplatesScan
Gui, Settings: Default
GuiControl,,DocumentTemplates, % MatchList.Settings.templatesExt
Return

ButtonOK:
Gui, Settings: Submit, NoHide
MatchList.settings.MenuPos:=MenuPos
MatchList.settings.FilteredMenuAutoEdit:=FilteredMenuAutoEdit
If (MaxFiles > 50)
	{
	 MsgBox, 36, Confirm, Are you sure you want to`nset the maximum at %MaxFiles% files?`n(No will set the maximum to 50)
	 IfMsgBox, No
		MaxFiles:=50
	}
MatchList.settings.MaxFiles:=MaxFiles
MatchList.settings.TCStart:=TCStart
MatchList.settings.TCPath:=TCPath
MatchList.settings.F4MMCloseAll:=F4MMCloseAll
MatchList.settings.F4MMClosePID:=F4MMClosePID
MatchList.settings.FullMenu:=trim(SubStr(FullMenu,1,1)," `t&")
MatchList.settings.MaxWinWaitSec:=MaxWinWaitSec

;GuiControlGet, EscFG, , FEsc
;GuiControlGet, WinFG, , FWin
;GuiControlGet, EscBG, , BEsc
;GuiControlGet, WinBG, , BWin
;GuiControlGet, EscTM, , TEsc
;GuiControlGet, WinTM, , TWin

; Revert the boxes to the Hotkey def.
If (FGHKey <> "")	
	{
	 If (FMod = "Win")
		FGHKey:="#" FGHKey
	 If (FMod = "Esc" ) and (RegExMatch(FGHKey,"[\^\+\!\#]") = 0)
		FGHKey:="Esc & " FGHKey
	}

If (BGHKey <> "")
	{
	 If (BMod = "Win")
		BGHKey:="#" BGHKey
	 If (BMod = "Esc") and (RegExMatch(BGHKey,"[\^\+\!\#]") = 0)
		BGHKey:="Esc & " BGHKey
	}

If (TMHKey <> "")
	{
	 If (TMod = "Win")
		TMHKey:="#" TMHKey
	 If (TMod = "Esc") and (RegExMatch(TMHKey,"[\^\+\!\#]") = 0)
		TMHKey:="Esc & " TMHKey
	}

MatchList.settings.ForegroundHotkey:=FGHKey
MatchList.settings.BackgroundHotkey:=BGHKey
MatchList.settings.FilteredHotkey:=TMHKey

MatchList.settings.Explorer:=Explorer
MatchList.settings.Everything:=Everything
;MatchList.settings.EvPath:=EvPath
;MatchList.settings.EVDirTree:=EVDirTree
MatchList.settings.DoubleCommander:=DoubleCommander
MatchList.settings.XYPlorer:=XYPlorer
MatchList.settings.Lister:=Lister
MatchList.settings.QuickView:=QuickView
MatchList.settings.FindFiles:=FindFiles

HotKeyState:="On"
Gosub, SetHotkeys
Gui, Settings:Destroy
Gosub, SaveSettings
Sleep 500
Reload ; v0.96 we may have changed F4MMClose so we need to reload the script to (de)activate the WinWait in F4MiniMenu.ahk
Sleep 500
Return

ButtonClear:
Gui, Settings: Default
GuiControl, Choose, BMod, 0
GuiControl, Choose, FMod, 0
GuiControl, Choose, TMod, 0
GuiControl, , BGHKey,
GuiControl, , FGHKey,
GuiControl, , TMHKey,
Return

SettingsGuiEscape:
SettingsGuiClose:
Gui, Settings: Destroy

HotKeyState:="On"
Gosub, SetHotkeys
Return

FMMPathsHelpText:
MsgBox, 8224, TC/INI Paths (experimental),
(join`n
TC Path: Attempt is made to read from the registry, can be set manually.

INI Path: As F4MM can be launched first or used "portable", it may not be able to read one or more settings from wincmd.ini.
Set manually if this is the case (see Lister/F4Edit setting).

When set manually the registry will not be read.

(Relative paths from the F4MM program folder).
)
Return

FMMCloseHelpText:
MsgBox, 8224, F4MMClose (experimental),
(join`n
F4MiniMenu - %F4Version% can automatically exit from memory using the following rules:

[1] Close F4MM when all copies of TC close:
waits until all running copies of Total Commander are closed.

[2] Close F4MM when TC closes started by F4MM:
If you have started (a new) Total Commander via F4MiniMenu, wait until that specific Total Commander closes.

)
Return

FMMFileManText:
MsgBox, 8224, Other file managers (experimental),
(join`n
F4MiniMenu can also work with other programs.`nTo activate, enter the keyboard shortcut to "Copy File Name(s) with Full Path"`n`
Double Commander default:`tShift+Ctrl+C`n
XYPlorer default:`t`t`tCtrl+p`n
Explorer, Everything:`t`tCheckbox to use F4MM`n
Note: use at your own risk.
)
Return

FMMTCElseWhere:
MsgBox, 8224, Use elsewhere in TC (experimental),
(join`n
As of TC 11.03 it is natively possible to "Edit" files from Lister (see TC Help, especially [lister] F4Edit and Editor settings).
F4MM also opens files that are shown using plugins whereas TC only when used in internal mode (no plugins).

F4MM can read the F4Edit and also close the Lister window, or use TC's native "edit" feature by unchecking the Lister box.

F4MM also works in the Find Files window by default, this can be turn off. Otherwise TC will use the Editor defined in the configuration (note F4TCIE could be used there).

QuickView is experimental: when checked, it will try to open the file that is currently open in the QuickView panel, even if multiple files are selected in the active TC panel and
the focus is NOT on the QuickView panel it self.
The foreground and filtered menus can be opened in the QuickView panel, but here also only the one "viewed" file will be opened.
When unchecked all selected files will be opened even when QuickView is being used.

)


;Ev DirTree:`tReplace TC Dir Tree (Alt-F10)`n
;Ev Path:`t`tPath to eEverything.exe (required by DirTree)`n`n
Return
