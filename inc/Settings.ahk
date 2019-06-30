/*

General program settings GUI
Include for F4MiniMenu.ahk

*/

Settings:

Gui, Browse:Destroy

; Variables
SelectMenuPos:=MatchList.settings.MenuPos
SelectTCStart:=MatchList.settings.TCStart
FGHKey:=MatchList.settings.ForegroundHotkey
BGHKey:=MatchList.settings.BackgroundHotkey
TMHKey:=MatchList.settings.FilteredHotkey
;SettingsFormat:=MatchList.settings.SettingsFormat

;If (SettingsFormat = "")
;	SettingsFormat:=1

;OldSettingsFormat:=SettingsFormat

; Turn hotkeys off to be sure
HotKeyState:="Off"
Gosub, SetHotkeys

; Gui for general program settings
Gui, +OwnDialogs
Gui, font,              % dpi("s8")
Gui, Add, GroupBox,     % dpi("x16 y7 w540 h70"), Menu
Gui, Add, Text,         % dpi("x25 y25 w309 h16"), &Selection menu appears
Gui, Add, DropDownList, % dpi("x328 y20 w219 h25 r4 Choose" SelectMenuPos " vMenuPos AltSubmit"), 1 - At Mouse cursor|2 - Centered in window|3 - Right next to current file|4 - Docked next to current file (opposite panel)
Gui, Add, Text,         % dpi("x25 yp+35 w309 h16"), &Accelerator key for full menu (for use in filtered menu, 1 char.)
Gui, Add, Edit,         % dpi("x328 yp-5 w219 h21 vFullMenu"), % MatchList.settings.FullMenu ; %

Gui, Add, GroupBox,     % dpi("x16 yp+60 w540 h45"), Files
Gui, Add, Text,         % dpi("x25 yp+20 w309 h16"), &Maximum number of files to be opened
Gui, Add, Edit,         % dpi("x328 yp-5 w219 h21 Number vMaxFiles"), % MatchList.settings.Maxfiles ; %
	
Gui, Add, GroupBox,     % dpi("x16 yp+40 w540 h70"), Total Commander
Gui, Add, DropDownList, % dpi("x25 yp+15 w240 h25 R3 Choose" SelectTCStart " vTCStart AltSubmit"), 1 - Do not start TC (default)|2 - Start TC if not Running (set TC Path)|3 - Always start TC (set TC Path) 
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
Gui, Font, cGreen
Gui, Add, Text,         % dpi("xp+250 yp gFMMCloseHelpText"), (?)
Gui, Font, cBlack
Gui, Add, GroupBox,     % dpi("x16 yp+35 w395 h120"), Hotkeys

Gui, Add, Text,         % dpi("x25 yp+25 w150 h16"), &Background mode (direct)
Gui, Add, Radio,        % dpi("xp+130 yp w45 h16 vBesc"), Esc
Gui, Add, Radio,        % dpi("xp+45  yp w45 h16 vBWin"), Win

; Always annoying to work around Hotkey control limit, use boxes for Win & Esc keys
If InStr(BGHKey,"#")
	{
	 StringReplace, BGHKey, BGHKey, #, , All
	 GuiControl, , BWin, 1
	}
If InStr(BGHKey,"Esc &")
	{
	 StringReplace, BGHKey, BGHKey, Esc &, , All
	 StringReplace, BGHKey, BGHKey, Esc &amp`;, , All
	 StringReplace, BGHKey, BGHKey, Esc &amp;, , All
	 StringReplace, BGHKey, BGHKey, %A_Space%, , All
	 GuiControl, , BEsc, 1
	}

Gui, Add, Hotkey, % dpi("xp+50 yp-3 w140 h20 vBGHKey"), %BGHKey%

Gui, Add, Text, % dpi("x25 yp+35 w150 h16"), &Foreground mode (menu)
Gui, Add, Radio, % dpi("xp+130 yp w45 h16 vFesc"), Esc
Gui, Add, Radio, % dpi("xp+45  yp w45 h16 vFWin"), Win

If InStr(FGHKey,"#")
	{
	 StringReplace, FGHKey, FGHKey, #, , All
	 GuiControl, ,FWin, 1
	}

If InStr(FGHKey,"Esc &")
	{
	 StringReplace, FGHKey, FGHKey, Esc &, , All
	 StringReplace, FGHKey, FGHKey, Esc &amp`;, , All
	 StringReplace, FGHKey, FGHKey, Esc &amp;, , All
	 StringReplace, FGHKey, FGHKey, %A_Space%, , All
	 GuiControl, , FEsc, 1
	}
	
Gui, Add, Hotkey, % dpi("xp+50 yp-3 w140 h20 vFGHKey"), %FGHKey% 

Gui, Add, Text, % dpi("x25 yp+35 w150 h16"), Fil&tered mode (menu)
Gui, Add, Radio, % dpi("xp+130 yp w45 h16 vTesc"), Esc
Gui, Add, Radio, % dpi("xp+45  yp w45 h16 vTWin"), Win

If InStr(TMHKey,"#")
	{
	 StringReplace, TMHKey, TMHKey, #, , All
	 GuiControl, ,TWin, 1
	}

If InStr(TMHKey,"Esc &")
	{
	 StringReplace, TMHKey, TMHKey, Esc &, , All
	 StringReplace, TMHKey, TMHKey, Esc &amp`;, , All
	 StringReplace, TMHKey, TMHKey, Esc &amp;, , All
	 StringReplace, TMHKey, TMHKey, %A_Space%, , All
	 GuiControl, , TEsc, 1
	}
	
Gui, Add, Hotkey, % dpi("xp+50 yp-3 w140 h20 vTMHKey"), %TMHKey% 

Gui, Add, Button, % dpi("xp+177 yp-78 w120 h25 gButtonOK"), OK
Gui, Add, Button, % dpi("xp     yp+40 w120 h25 gButtonClear"), Clear Hotkeys
Gui, Add, Button, % dpi("xp     yp+40 w120 h25 gGuiClose"), Cancel

Gui, Add, GroupBox, % dpi("x16 yp+40 w540 h70"), Currently Available Document Templates:
Gui, Add, Edit, % dpi("x25 yp+20 ReadOnly h40 w385 vDocumentTemplates"), % MatchList.Settings.templatesExt
Gui, Add, Button, % dpi("xp+402 yp w120 h25 gButtonDocumentTemplates"), Update (scan)

;Gui, Add, GroupBox, x16 yp+40 w395 h60 , Misc.
;perhaps in future versions
;Gui, Add, Text, x25 yp+25 w150 h16 , Store set&tings in:
;Gui, Add, DropDownList, xp+225 yp-5 w140 h25 r2 Choose%SettingsFormat% vSettingsFormat AltSubmit, 1 - XML Format|2 - INI format

Gui, Add, Link,   % dpi("x25 yp+65"), F4MiniMenu %F4Version%: Open selected file(s) from TC in defined editor(s). More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>.

;Gui, Add, GroupBox, xp+400 yp-85 w122 h60
;Gui, Add, Link,   xp+5 yp+13, Feedback welcome at`n<a href="http://ghisler.ch/board/viewtopic.php?t=35721">Total Commander forum</a>`nor <a href="https://github.com/hi5/F4MiniMenu">GitHub Issues</a>.

Gui, Show, % dpi("center w570"), Settings
Return

ButtonDocumentTemplates:
Gosub, DocumentTemplatesScan
GuiControl,,DocumentTemplates, % MatchList.Settings.templatesExt
Return

ButtonOK:
Gui, Submit, NoHide
MatchList.settings.MenuPos:=MenuPos
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

GuiControlGet, EscFG, , FEsc
GuiControlGet, WinFG, , FWin
GuiControlGet, EscBG, , BEsc
GuiControlGet, WinBG, , BWin
GuiControlGet, EscTM, , TEsc
GuiControlGet, WinTM, , TWin

; Revert the boxes to the Hotkey def.
If WinFG
	FGHKey:="#" FGHKey
If (EscFG = 1) and (RegExMatch(FGHKey,"[\^\+\!\#]") = 0)
	FGHKey:="Esc & " FGHKey
If WinBG
	BGHKey:="#" BGHKey
If (EscBG = 1) and (RegExMatch(BGHKey,"[\^\+\!\#]") = 0)
	BGHKey:="Esc & " BGHKey
If WinTM
	TMHKey:="#" TMHKey
If (EscTM = 1) and (RegExMatch(TMHKey,"[\^\+\!\#]") = 0)
	TMHKey:="Esc & " TMHKey

MatchList.settings.ForegroundHotkey:=FGHKey
MatchList.settings.BackgroundHotkey:=BGHKey
MatchList.settings.FilteredHotkey:=TMHKey

HotKeyState:="On"
Gosub, SetHotkeys
Gui, Destroy
Gosub, SaveSettings
Sleep 500
Reload ; v0.96 we may have changed F4MMClose so we need to reload the script to (de)activate the WinWait in F4MiniMenu.ahk
Sleep 500
Return

ButtonClear:
GuiControl, , FEsc, 0
GuiControl, , FWin, 0
GuiControl, , BEsc, 0
GuiControl, , BWin, 0
GuiControl, , TEsc, 0
GuiControl, , TWin, 0
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
