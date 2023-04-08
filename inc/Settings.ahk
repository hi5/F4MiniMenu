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
Gui, +OwnDialogs
Gui, font,              % dpi("s8")
Gui, Add, GroupBox,     % dpi("x16 y7 w540 h70"), Menu
Gui, Add, Text,         % dpi("x25 y25 w309 h16"), &Selection menu appears
Gui, Add, DropDownList, % dpi("x328 y20 w219 h25 r4 Choose" MatchList.settings.MenuPos " vMenuPos AltSubmit"), 1 - At Mouse cursor|2 - Centered in window|3 - Right next to current file|4 - Docked next to current file (opposite panel)
Gui, Add, Text,         % dpi("x25 yp+35 w309 h16"), &Accelerator key for full menu (for use in filtered menu, 1 char.)
Gui, Add, Edit,         % dpi("x328 yp-5 w30 h21 vFullMenu"), % MatchList.settings.FullMenu ; %
Gui, Add, Text,         % dpi("x365 yp+5 w70 h16"), If one result:
Gui, Add, DropDownList, % dpi("x430 yp-5 w117 h25 r2 Choose" MatchList.settings.FilteredMenuAutoEdit " vFilteredMenuAutoEdit AltSubmit"), 1 - Show menu|2 - Edit directly

Gui, Add, GroupBox,     % dpi("x16 yp+40 w260 h45"), Files
Gui, Add, Text,         % dpi("x25 yp+20 w209 h16"), &Maximum number of files to be opened
Gui, Add, Edit,         % dpi("x227 yp-5 w40 h21 Number vMaxFiles"), % MatchList.settings.Maxfiles ; %

Gui, Add, GroupBox,     % dpi("x280 yp-15 w276 h45"), WinWait
Gui, Add, Text,         % dpi("x289 yp+20 w209 h16"), &Seconds (max) to wait for program window
Gui, Add, Edit,         % dpi("x507 yp-5 w40 h21")
Gui, Add, UpDown, vMaxWinWaitSec Range2-10, % MatchList.Settings.MaxWinWaitSec ; %


Gui, Add, GroupBox,     % dpi("x16 yp+40 w540 h70"), Total Commander
Gui, Add, DropDownList, % dpi("x25 yp+15 w240 h25 R3 Choose" MatchList.settings.TCStart " vTCStart AltSubmit"), 1 - Do not start TC (default)|2 - Start TC if not Running (set TC Path)|3 - Always start TC (set TC Path) 
Gui, Add, Text,         % dpi("xp+250 yp+5 w50 h16"), TC Path
If !FileExist(MatchList.settings.TCPath)
	{
	 RegRead TCPath, HKEY_CURRENT_USER, Software\Ghisler\Total Commander, InstallDir
	 TCPath = %TCPath%\TotalCmd.exe
	 If FileExist(TCPath)
		MatchList["settings","TCPath"]:=TCPath
	 TCPath:=""	
	}
Gui, Add, Edit  ,       % dpi("xp+53  yp-5 w180 h21 vTCPath"), % MatchList.settings.TCPath ; %
Gui, Add, Button,       % dpi("xp+187  yp   w30  h20 gSelectExe"), >>

Checked:=MatchList.settings.F4MMCloseAll
Gui, Add, Checkbox,     % dpi("x25 yp+30  w250 h16 Checked" checked " vF4MMCloseAll"), Close F4MM when all copies of TC close
Checked:=MatchList.settings.F4MMClosePID
Gui, Add, Checkbox,     % dpi("xp+250 yp  w250 h16 Checked" checked " vF4MMClosePID"), Close F4MM when TC closes started by F4MM
Gui, Font, % dpi("cGreen")
Gui, Add, Text,         % dpi("xp+250 yp gFMMCloseHelpText"), (?)
Gui, Font, % dpi("cBlack")
Gui, Font, ; needed as theme is stripped from control @ https://www.autohotkey.com/boards/viewtopic.php?p=399355#p399355
Gui, Font, % dpi("s8")
Gui, Add, GroupBox,     % dpi("x16 yp+35 w395 h120"), Hotkeys

Gui, Add, Text,         % dpi("x25 yp+25 w150 h16"), &Background mode (direct)
;Gui, Add, Radio,        % dpi("xp+130 yp w45 h16 vBEsc"), Esc
;Gui, Add, Radio,        % dpi("xp+45  yp w45 h16 vBWin"), Win
Gui, Add, DropDownList, % dpi("xp+140 yp-3 w70 R3 vBMod"), |Esc|Win

; Always annoying to work around Hotkey control limit, use boxes for Win & Esc keys
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

Gui, Add, Hotkey, % dpi("xp+90 yp w140 h20 vBGHKey"), %BGHKey%

Gui, Add, Text, % dpi("x25 yp+35 w150 h16"), &Foreground mode (menu)
;Gui, Add, Radio, % dpi("xp+130 yp w45 h16 vFEsc"), Esc
;Gui, Add, Radio, % dpi("xp+45  yp w45 h16 vFWin"), Win
Gui, Add, DropDownList, % dpi("xp+140 yp-3 w70 R3 vFMod"), |Esc|Win

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
	
Gui, Add, Hotkey, % dpi("xp+90 yp w140 h20 vFGHKey"), %FGHKey% 
;Gui, Add, Button, % dpi("xp+110 yp w30 h20 gButtonClearFG"), clear

Gui, Add, Text, % dpi("x25 yp+35 w150 h16"), Fil&tered mode (menu)
;Gui, Add, Radio, % dpi("xp+130 yp w45 h16 vTEsc"), Esc
;Gui, Add, Radio, % dpi("xp+45  yp w45 h16 vTWin"), Win
Gui, Add, DropDownList, % dpi("xp+140 yp-3 w70 R3 vTmod"), |Esc|Win

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
	
Gui, Add, Hotkey, % dpi("xp+90 yp w140 h20 vTMHKey"), %TMHKey% 
; Gui, Add, Button, % dpi("xp+110 yp w30 h20 gButtonClearTM"), clear

Gui, Add, Button, % dpi("xp+170 yp-75 w120 h25 gButtonOK"), OK
Gui, Add, Button, % dpi("xp     yp+40 w120 h25 gButtonClear"), Clear All Hotkeys
Gui, Add, Button, % dpi("xp     yp+40 w120 h25 gGuiClose"), Cancel

Gui, Add, GroupBox, % dpi("x16 yp+40 w540 h72"), Other programs

Checked:=MatchList.settings.Explorer
Gui, Add, Checkbox,  % dpi("x25 yp+20 w60 h16 Checked" checked " vExplorer"), Explorer

Gui, Add, Text,      % dpi("xp+70 yp+1 w100 h20"), Double Commander:
Gui, Add, Hotkey,    % dpi("xp+100 yp-3 w90 h20 vDoubleCommander"), % MatchList.settings.DoubleCommander
Gui, Add, Text,      % dpi("xp+100 yp+3 w50 h20"), XYPlorer:
Gui, Add, Hotkey,    % dpi("xp+50 yp-3 w90 h20 vXYPlorer"), % MatchList.settings.XYPlorer
Gui, Font, % dpi("s8 cGreen")
Gui, Add, Text,      % dpi("xp+175 yp gFMMFileManText"), (?)
Gui, Font, % dpi("cBlack")
Gui, Font, ; see note above, required to reset style
Gui, Font, % dpi("s8")

Checked:=MatchList.settings.Everything
Gui, Add, Checkbox,  % dpi("x25 yp+30 w100 h16 Checked" checked " vEverything"), Everything

; Note: deactivated Everything Directory Tree and DocumentTemplates settings for now
/*
Gui, Add, Text,      % dpi("xp+70 yp+1 w100 h20"), Ev. Dir Tree:
Gui, Add, Hotkey,    % dpi("xp+100 yp-3 w90 h20 vEVDirTree"), % MatchList.settings.EVDirTree

Gui, Add, Text,      % dpi("xp+100 yp+1 w50 h20"), Ev. Path:
Gui, Add, Edit  ,    % dpi("xp+50  yp-5 w160 h21 vEvPath"), % MatchList.settings.EvPath ; %
Gui, Add, Button,    % dpi("xp+165  yp   w30  h20 gSelectEv"), >>

Gui, Add, GroupBox, % dpi("x16 yp+45 w540 h70"), Currently Available Document Templates
Gui, Add, Edit, % dpi("x25 yp+20 ReadOnly h40 w385 vDocumentTemplates"), % MatchList.Settings.templatesExt
Gui, Add, Button, % dpi("xp+402 yp w120 h25 gButtonDocumentTemplates"), Update (scan)
*/

;Gui, Add, GroupBox, x16 yp+40 w395 h60 , Misc.
;perhaps in future versions
;Gui, Add, Text, x25 yp+25 w150 h16 , Store set&tings in:
;Gui, Add, DropDownList, xp+225 yp-5 w140 h25 r2 Choose%SettingsFormat% vSettingsFormat AltSubmit, 1 - XML Format|2 - INI format

Gui, Add, Link,   % dpi("x25 yp+35"), F4MiniMenu %F4Version%: Open selected file(s) from TC in defined editor(s). More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>.

;Gui, Add, GroupBox, xp+400 yp-85 w122 h60
;Gui, Add, Link,   xp+5 yp+13, Feedback welcome at`n<a href="http://ghisler.ch/board/viewtopic.php?t=35721">Total Commander forum</a>`nor <a href="https://github.com/hi5/F4MiniMenu">GitHub Issues</a>.

Gui, Show, % dpi("center w570"), F4MiniMenu - Settings
Return

ButtonDocumentTemplates:
Gosub, DocumentTemplatesScan
GuiControl,,DocumentTemplates, % MatchList.Settings.templatesExt
Return

ButtonOK:
Gui, Submit, NoHide
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

HotKeyState:="On"
Gosub, SetHotkeys
Gui, Destroy
Gosub, SaveSettings
Sleep 500
Reload ; v0.96 we may have changed F4MMClose so we need to reload the script to (de)activate the WinWait in F4MiniMenu.ahk
Sleep 500
Return

ButtonClear:
GuiControl, Choose, BMod, 0
GuiControl, Choose, FMod, 0
GuiControl, Choose, TMod, 0
GuiControl, , BGHKey,
GuiControl, , FGHKey,
GuiControl, , TMHKey,
Return

GuiEscape:
GuiClose:
Gui, Destroy

HotKeyState:="On"
Gosub, SetHotkeys
Return

FMMCloseHelpText:
MsgBox, 32, F4MMClose (experimental),
(join`n
F4MiniMenu - %F4Version% can automatically exit from memory using the following rules:

[1] Close F4MM when all copies of TC close:
waits until all running copies of Total Commander are closed.

[2] Close F4MM when TC closes started by F4MM:
If you have started (a new) Total Commander via F4MiniMenu, wait until that specific Total Commander closes,

)
Return

FMMFileManText:
MsgBox, 32, Other file managers (experimental),
(join`n
F4MiniMenu can also work with other programs.`nTo activate enter the keyboard shortcut to "Copy Filename(s) with Full Path"`n`
Double Commander default:`tShift+Ctrl+C`n
XYPlorer default:`tCtrl+p`n
Everything:`tCheckbox to use F4MiniMenu`n
Note: use at your own risk.
)
;Ev DirTree:`tReplace TC Dir Tree (Alt-F10)`n
;Ev Path:`t`tPath to eEverything.exe (required by DirTree)`n`n
Return
