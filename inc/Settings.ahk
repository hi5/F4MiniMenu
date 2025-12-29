/*

General program settings GUI
Include for F4MiniMenu.ahk

*/

Settings:

Gui, Browse:Destroy

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
Gui, Settings: font,              % dpi("s8"), MS Shell Dlg
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

Gui, Settings: Font, % dpi("cGreen"), MS Shell Dlg
;Gui, Settings: Add, Text,         % dpi("xp+240 yp gFMMCloseHelpText"), (?)
Gui, Settings: Add, Picture, % dpi("xp+245 yp+1 gFMMCloseHelpText w12 h-1"), %A_ScriptDir%\res\help-browser.ico
;Gui, Settings: Add, Text,         % dpi("xp+260 yp gFMMPathsHelpText"), (?)
Gui, Settings: Add, Picture, % dpi("xp+250 yp+1 gFMMPathsHelpText w12 h-1"), %A_ScriptDir%\res\help-browser.ico

Gui, Settings: Font, % dpi("cBlack"), MS Shell Dlg
Gui, Settings: Font, ; needed as theme is stripped from control @ https://www.autohotkey.com/boards/viewtopic.php?p=399355#p399355
Gui, Settings: Font, % dpi("s8"), MS Shell Dlg

Gui, Settings: Add, GroupBox, % dpi("x16 yp+34 w260 h94"), Other prg. (Hotkey: Copy File Names w. Full Path)

Gui, Settings: Add, ListView, % dpi("x20 yp+16 w200 h72 checked grid vSelItem gOtherProgramEdit"), Program (double click to edit)

Gui, Settings: Font, % dpi("s8 cGreen"), MS Shell Dlg
;Gui, Settings: Add, Text,      % dpi("xp+225 yp gOtherProgramHelp"), ⚠ (?) ; was gFMMFileManText
Gui, Settings: Add, Picture, % dpi("xp+225 yp+1 gOtherProgramHelp w12 h-1"), %A_ScriptDir%\res\dialog-warning.ico
Gui, Settings: Add, Picture, % dpi("xp+13 yp gOtherProgramHelp w12 h-1"), %A_ScriptDir%\res\help-browser.ico

Gui, Settings: Font, % dpi("cBlack"), MS Shell Dlg
Gui, Settings: Font, ; see note above, required to reset style
Gui, Settings: Font, % dpi("s8"), MS Shell Dlg

;Gui, Settings: Add, Button, % dpi("xp-17 yp+15 w46 h25 gOtherProgram"), Add
Gui, Settings: Add, Button, % dpi("xp-32 yp+15 w46 h25 gOtherProgram"), Add

Gui, Settings: Add, Button, % dpi("xp    yp+30 w46 h25 gDeleteProgram"), Del

Gui, Settings: Add, GroupBox, % dpi("xp+54 yp-63 w276 h94"), Use elsewhere in TC (no menu) -- Misc.

Checked:=MatchList.settings.Lister
Gui, Settings: Add, Checkbox,  % dpi("xp+10 yp+20 w220 h16 Checked" checked " vLister"), Lister (+ use F4Edit setting in wincmd.ini)

Checked:=MatchList.settings.QuickView
Gui, Settings: Add, Checkbox,  % dpi("xp    yp+20 w120 h16 Checked" checked " vQuickView"), QuickView (see ?)

Checked:=MatchList.settings.FindFiles
Gui, Settings: Add, Checkbox,  % dpi("xp+160 yp w80 h16 Checked" checked " vFindFiles"), Find Files

Gui, Settings: Font, % dpi("s8 cGreen"), MS Shell Dlg
;Gui, Settings: Add, Text,      % dpi("xp+75 yp-28 gFMMTCElseWhere"), (?)
Gui, Settings: Add, Picture, % dpi("xp+70 yp-28 gFMMTCElseWhere w12 h-1"), %A_ScriptDir%\res\help-browser.ico

Gui, Settings: Font, % dpi("cBlack"), MS Shell Dlg
Gui, Settings: Font, ; see note above, required to reset style
Gui, Settings: Font, % dpi("s8"), MS Shell Dlg

Gui, Settings: Font, % dpi("s8 cc0c0c0"), MS Shell Dlg
Gui, Settings: Add, Text,      % dpi("xp-230 yp+42 h10 "), ───────────────────────────────
Gui, Settings: Font, % dpi("cBlack"), MS Shell Dlg
Gui, Settings: Font, ; see note above, required to reset style
Gui, Settings: Font, % dpi("s8"), MS Shell Dlg

Gui, Settings: Add, Text,  % dpi("xp yp+16 w167 h16"), TC Copy Delay (ms, 0=ClipWait):

Gui, Settings: Add, DropDownList,  % dpi("xp+170 yp-3 w60 h20 r7 vTCDelay"), 0|100|200|300|400|500|600|700|800|900|1000
GuiControl, Settings:, TCDelay, % "|" LTrim(StrReplace("|0|100|200|300|400|500|600|700|800|900|1000|", "|" Matchlist.Settings.TCDelay "|", "|" Matchlist.Settings.TCDelay "||"),"|")

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

Gui, Settings: Add, Link,   % dpi("x20 yp+35"), F4MiniMenu %F4Version%: Open selected file(s) from TC in defined editor(s). More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>.

Gosub, ParseSettingsF4MMOtherPrograms
LV_ModifyCol(1,170)

Gui, Settings: Show,        % dpi("center w570"), F4MiniMenu - Settings

Return

; note: we read settings in ReadSettingsF4MMOtherPrograms.ahk
ParseSettingsF4MMOtherPrograms:
If !FileExist(A_ScriptDir "\F4MMOtherPrograms.ini")
	{
	 Gui, Settings: Default
	 GuiControl, Disable, F4MMOtherPrograms
	 Return
	}
; "ProgramExe,ProgramShortCut,ProgramDelay,ProgramSendMethod,Active,Name"
Gui, Settings: ListView, SelItem
Gui, Settings: Default
LV_Delete()
for k, v in F4MMOtherPrograms
	{
	 if (k = "settings")
		continue
	 if F4MMOtherPrograms[k].Name ; we have .group and .active so we only need to add actual program
		LV_Add(F4MMOtherPrograms[k].Active ? "check" : "", F4MMOtherPrograms[k].Name)
	}

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
MatchList.settings.TCDelay:=TCDelay

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

MatchList.settings.Lister:=Lister
MatchList.settings.QuickView:=QuickView
MatchList.settings.FindFiles:=FindFiles

Gui, Settings:Default
ProgramStateToSave:=""
Loop, % LV_GetCount()
	{
	 LV_GetText(ProgramStateToSave, A_Index, 1)
	 If (ProgramStateToSave = "") ; or (ProgramStateToSave = "Program")
		Continue
	 If (LV_GetNext(A_Index-1, "Checked") = A_Index)
		IsProgramChecked:=1
	 Else
		IsProgramChecked:=0
	 IniWrite, %IsProgramChecked%, %A_ScriptDir%\F4MMOtherPrograms.ini, %ProgramStateToSave%, Active
	 IsProgramChecked:=0
	 ProgramStateToSave:=""
	}

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


/*
[ProgramName]
ProgramExe=Everything.exe
ProgramShortCut=!Ins
ProgramDelay=300
ProgramSendMethod=ControlSend
ProgramActive=1

*/
DeleteProgram:
ControlFocus, SysListView321, F4MiniMenu - Settings
SelItem := LV_GetNext()
If (SelItem = 0)
	SelItem = 1
LV_GetText(ProgramToEdit, SelItem, 1)
MsgBox, % 36+8192, Delete editor, Delete %ProgramToEdit% from F4MiniMenu?
IfMsgBox, No
	Return
LV_Delete(SelItem)
IniDelete, F4MMOtherPrograms.ini, %ProgramToEdit%
If !ErrorLevel
	{
	 ReadSettingsF4MMOtherPrograms()
	 MsgBox,% 64+8192,Delete editor, %ProgramToEdit% deleted.
	 Gosub, ParseSettingsF4MMOtherPrograms
	}
Return

OtherProgramEdit:

if A_GuiControlEvent not in DoubleClick
	Return
ProgramEditSettings:=1
ControlFocus, SysListView321, F4MiniMenu - Settings
SelItem := LV_GetNext()
If (SelItem = 0)
	SelItem = 1
LV_GetText(ProgramToEdit, SelItem, 1)
OtherProgram:

Gui, Settings:+Disabled
Gui, OtherProgram:Destroy
Gui, OtherProgram:+OwnerSettings -SysMenu +Toolwindow
;Gui, OtherProgram: -SysMenu +Toolwindow
Gui, OtherProgram:font,              bold, MS Shell Dlg
Gui, OtherProgram:Add, Text, , Configure third party programs.`nSee help for details.
Gui, OtherProgram:font,
Gui, OtherProgram:font, , MS Shell Dlg
Gui, OtherProgram:Add, Text, , Program Name:
Gui, OtherProgram:Add, Edit, % dpi("w300 h20 vProgramName"),
Gui, OtherProgram:Add, Text, , Program Executable(s) [comma separated]:
Gui, OtherProgram:Add, Edit, % dpi("w300 h20 vProgramExe"),
Gui, OtherProgram:Add, Text, , Shortcut to copy file path(s):
Gui, OtherProgram:Add, Hotkey, % dpi("w300 h20 vProgramShortCut"),
Gui, OtherProgram:Add, Text, , Copy Delay (ms, 0=ClipWait):
Gui, OtherProgram:Add, DropDownList, % dpi("w140 R6 vProgramDelay"), 0|100||200|300|400|500
Gui, OtherProgram:Add, Text, % dpi("xp+159 yp-19"), Send Method:
Gui, OtherProgram:Add, DropDownList, % dpi("w140 R2 vProgramSendMethod"), Send||ControlSend
Gui, OtherProgram:Add, Button, % dpi("w30  x9     yp+40  gOtherProgramHelp")  ,?
Gui, OtherProgram:Add, Button, % dpi("w100 x+65   yp     gOtherProgramCancel"),Cancel
Gui, OtherProgram:Add, Button, % dpi("w100 xp+105 yp     gOtherProgramSave")  ,Save
If ProgramEditSettings
	{
	 GuiControl,OtherProgram:,ProgramName      , %ProgramToEdit%
	 GuiControl,OtherProgram:Disable,ProgramName, ; only allow progam name change in INI
	 GuiControl,OtherProgram:,ProgramExe       , % F4MMOtherPrograms[ProgramToEdit,"ProgramExe"]
	 GuiControl,OtherProgram:,ProgramShortCut  , % F4MMOtherPrograms[ProgramToEdit,"ProgramShortCut"]
	 GuiControl,OtherProgram:,ProgramDelay     , |
	 GuiControl,OtherProgram:,ProgramSendMethod, |
	 GuiControl,OtherProgram:,ProgramDelay     , % LTrim(StrReplace("|0|100|200|300|400|500|","|" F4MMOtherPrograms[ProgramToEdit,"ProgramDelay"]      . "|","|" F4MMOtherPrograms[ProgramToEdit,"ProgramDelay"]      . "||"),"|")
	 GuiControl,OtherProgram:,ProgramSendMethod, % LTrim(StrReplace("|Send|ControlSend|"     ,"|" F4MMOtherPrograms[ProgramToEdit,"ProgramSendMethod"] . "|","|" F4MMOtherPrograms[ProgramToEdit,"ProgramSendMethod"] . "||"),"|")
	}
If !ProgramEditSettings
	{
	 Gui, OtherProgram:font,              s14, MS Shell Dlg
	 Gui, OtherProgram:Add, Button, % dpi("0x8000 x280 y5 w30 h30 gOtherProgramProcessClipboard"), % Chr(128203) ; 128203=Clipboard
	 Gui, OtherProgram:font,              s8, MS Shell Dlg
	}
Gui, OtherProgram:Show,,F4MiniMenu - Setup other programs
Return

OtherProgramCancel:
OtherProgramGuiEscape:
OtherProgramGuiClose:
ProgramToEdit:=""
ProgramEditSettings:=0
Gui, OtherProgram:Destroy
Gui, Settings:-Disabled
WinActivate, F4MiniMenu - Settings ahk_class AutoHotkeyGUI
Return

OtherProgramSave:
Gui, OtherProgram:Submit,NoHide
If (Trim(ProgramName," `r`n`t") = "") or (Trim(ProgramExe," `r`n`t") = "") or (Trim(ProgramShortCut," `r`n`t") = "")
	{
	 MsgBox, % 16+8192, F4MiniMenu, Program Name, Executable, and Shortcut are required.
	 Return
	}
Gui, Settings:-Disabled
Gui, OtherProgram:Destroy
IniWrite, %ProgramExe%       , %A_ScriptDir%\F4MMOtherPrograms.ini, %ProgramName%, ProgramExe
IniWrite, %ProgramShortCut%  , %A_ScriptDir%\F4MMOtherPrograms.ini, %ProgramName%, ProgramShortCut
IniWrite, %ProgramDelay%     , %A_ScriptDir%\F4MMOtherPrograms.ini, %ProgramName%, ProgramDelay
IniWrite, %ProgramSendMethod%, %A_ScriptDir%\F4MMOtherPrograms.ini, %ProgramName%, ProgramSendMethod
IniWrite, 1                  , %A_ScriptDir%\F4MMOtherPrograms.ini, %ProgramName%, Active

Gui, Settings: Default
Gui, ListView, SelItem

LV_Delete()

ReadSettingsF4MMOtherPrograms()

Gosub, ParseSettingsF4MMOtherPrograms

ProgramToEdit:=""
ProgramEditSettings:=0
WinActivate, F4MiniMenu - Settings ahk_class AutoHotkeyGUI
Return

OtherProgramProcessClipboard:
If !InStr(Clipboard,"ProgramExe=") and !InStr(Clipboard,"ProgramShortCut=")
	{
	 MsgBox, 16, F4MiniMenu, No setup found in clipboard
	 Return
	}
Loop, parse, Clipboard, `n, `r
	{
	If RegExMatch(A_LoopField,"\[(.*)\]")
		GuiControl, OtherProgram:, ProgramName, % Trim(A_LoopField," []")
	If InStr(A_LoopField,"ProgramExe=")
		GuiControl, OtherProgram:, ProgramExe, % Trim(StrSplit(A_LoopField,"=").2," `r`n`t")
	If InStr(A_LoopField,"ProgramShortCut"  )
		GuiControl, OtherProgram:, ProgramShortCut, % Trim(StrSplit(A_LoopField,"=").2," `r`n`t")
	If InStr(A_LoopField,"ProgramDelay"     ) and RegExMatch(A_LoopField,"i)\b(0|100|200|300|400|500)\b")
		GuiControl, OtherProgram:, ProgramDelay, % "|" StrReplace("0|100|200|300|400|500|",Trim(StrSplit(A_LoopField,"=").2," `r`n`t"), Trim(StrSplit(A_LoopField,"=").2," `r`n`t") "|")
	If InStr(A_LoopField,"ProgramSendMethod") and RegExMatch(A_LoopField,"i)\b(send|controlsend)\b")
		GuiControl, OtherProgram:, ProgramSendMethod, % "|" RegExReplace("Send|ControlSend|","iU)\b" Trim(StrSplit(A_LoopField,"=").2," `r`n`t") "\b", Trim(StrSplit(A_LoopField,"=").2," `r`n`t") "|")
	}
Return

FMMPathsHelpText:
MsgBox, 8224, TC/INI Paths (experimental) - Help,
(join`n
TC Path: Attempt is made to read from the registry, can be set manually.

INI Path: As F4MM can be launched first or used "portable", it may not be able to read one or more settings from wincmd.ini.
Set manually if this is the case (see Lister/F4Edit setting).

When set manually the registry will not be read.

(Relative paths from the F4MM program folder).
)
Return

FMMCloseHelpText:
MsgBox, 8224, F4MMClose (experimental) - Help,
(join`n
F4MiniMenu - %F4Version% can automatically exit from memory using the following rules:

[1] Close F4MM when all copies of TC close:
waits until all running copies of Total Commander are closed.

[2] Close F4MM when TC closes started by F4MM:
If you have started (a new) Total Commander via F4MiniMenu, wait until that specific Total Commander closes.

)
Return

FMMTCElseWhere:
MsgBox, 8224, Use elsewhere in TC (experimental) - Help,
(join`n
As of TC 11.03 it is natively possible to "Edit" files from Lister (see TC Help, especially [lister] F4Edit and Editor settings).
F4MM also opens files that are shown using plugins whereas TC only when used in internal mode (no plugins).

F4MM can read the F4Edit and also close the Lister window, or use TC's native "edit" feature by unchecking the Lister box.

F4MM also works in the Find Files window by default, this can be turn off. Otherwise TC will use the Editor defined in the configuration (note F4TCIE could be used there).

QuickView is experimental: when checked, it will try to open the file that is currently open in the QuickView panel, even if multiple files are selected in the active TC panel and
the focus is NOT on the QuickView panel it self.
The foreground and filtered menus can be opened in the QuickView panel, but here also only the one "viewed" file will be opened.
When unchecked all selected files will be opened even when QuickView is being used.

TC Copy Delay: 0 will use another method to wait for the clipboard to receive the (selected) filepath(s) [the AutoHotkey ClipWait command], otherwise it will wait the selected number of milliseconds before continuing.
)
Return

OtherProgramHelp:
MsgBox, 8224, Setup other programs - Help,
(join`n
F4MM will try to copy the (selected) path of the (selected) file(s) to the clipboard for further processing by sending the shortcut that has to be available in the "target" program. Often this will be Ctrl+C. Consult the documentation of the target program(s) for the correct shortcut or how to change it.

⚠ Important: Adding and Removing have an immediate effect, even if you CANCEL the General Settings Window.

The Program Name, Executable(s), and shortcuts are mandatory.

Program Delay: 0 will use another method to wait for the clipboard to receive the (selected) filepath(s) [the AutoHotkey ClipWait command], otherwise it will wait the selected number of milliseconds before continuing.

Send Method: Choose between Send (default) and ControlSend. If Send fails, ControlSend may work. If both methods do not work a custom solution for the target application might be required to be implemented in F4MM. Open an Issue at GitHub with the program details (name + version).

When a "setup" has been copied to the clipboard, pressing the Clipboard icon will fill in the fields accordingly. The readme.md has some examples.

When a program is added or edited it is automatically "Active" for F4MM. Use the Checkboxes to change the state (active/inactive).
)
Return
