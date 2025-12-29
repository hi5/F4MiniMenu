/*

Foreground menu - uses lib\GetPos.ahk
FilteredMenu.ahk makes use of various labels in Menu.ahk
Include for F4MiniMenu.ahk

*/

ShowMenu:
CoordMode, Menu, Client
Coord:=GetPos(MatchList.settings.MenuPos,MatchList.MaxIndex())
WinActivate, % Coord["ActiveProcessTitle"]
Menu, MyMenu, Show, % Coord["x"], % Coord["y"]
MatchList.Temp.Files:="",MatchList.Temp.SelectedExtensions:="",MatchList.Delete("Temp")
Return

; Build menu based on defined editors

BuildMenu:
Menu, MyMenu, Add,
Menu, MyMenu, DeleteAll

MenuName:="MyMenu"

for k, v in MatchList
	{
	 If (k = "settings") or (k = "temp")
		Continue ; skip settings
	 ExeName:=v.exe
	 SplitPath, ExeName, ShortName
	 If (v.name <> "")
		ShortName:=v.name

	 If InStr(ShortName,"&")
		ShortName:=MenuPadding ShortName
	 else
		ShortName:=MenuPadding "&" ShortName

	 Gosub, AddMenuEntry

	}

Gosub, AddMenuProgramOptions

Return

; If the tray icon is double click we do not actually want to do anything
DoubleTrayClick:
Send {rbutton} ; show tray menu
Return


; Tray menu
MenuHandler:
; MsgBox % A_ThisMenu ":" A_ThisMenuItemPos-1 ":" MatchList[A_ThisMenuItemPos-1].exe ; debug
If MatchList.Settings.log
	Log(A_Now " : Menuhandler, call -> A_ThisMenu=" A_ThisMenu "| A_ThisMenuItemPos-1=" A_ThisMenuItemPos-1 "| Exe=" A_ThisMenuItem,MatchList.Settings.logFile)

; Easy & Quick options first
If (A_ThisMenuItem = "&Open")
	{
	 ListHotkeys
	 Return
	}
Else If (A_ThisMenuItem = "&Reload this script")
	{
	 Reload
	 Return
	}
Else If (A_ThisMenuItem = "&Edit this script")
	{
	 Run Edit %A_ScriptName%
	 Return
	}
Else If (A_ThisMenuItem = "&Suspend Hotkeys")
	{
	 Menu, tray, ToggleCheck, &Suspend Hotkeys
	 Suspend
	 Return
	}
Else If (A_ThisMenuItem = "&Pause Script")
	{
	 Menu, tray, ToggleCheck, &Pause Script
	 Pause
	 Return
	}
Else If (A_ThisMenuItem = "   Exit")
	 Return
Else If (A_ThisMenuItem = "   Settings") ; Settings menu
	{
	 Gosub, Settings
	 Return
	}
Else If (A_ThisMenuItemPos = 1) ; Default editor
	{
	 If MatchList.Settings.log
		Log(A_Now " : Menuhandler, selected editor -> Default editor" ,MatchList.Settings.logFile)
	 ProcessFiles(Matchlist, 1)
	 Return
	}
Else
	If (MatchList.Temp.SelectedExtensions = "") or (A_ThisMenu = "MyMenu") ; entire Foreground menu
		{
		 If MatchList.Settings.log
			Log(A_Now " : Menuhandler, selected editor -> editor from entire menu, Exe=" A_ThisMenuItem,MatchList.Settings.logFile)
		 ProcessFiles(Matchlist, A_ThisMenuItemPos-1) ; proceed with the selected editor. Menu order = editor order.
		 MatchList.Temp.Files:="",MatchList.Temp.SelectedExtensions:="",MatchList.Delete("Temp"),MatchListReference:=""
		}
	else                         ; filtered Foreground menu
		{
		 If MatchList.Settings.log
			Log(A_Now " : Menuhandler, selected editor -> editor from filtered menu, Exe=" A_ThisMenuItem,MatchList.Settings.logFile)
		 ProcessFiles(Matchlist, MatchListReference[A_ThisMenuItemPos])
		 MatchList.Temp.Files:="",MatchList.Temp.SelectedExtensions:="",MatchList.Delete("Temp"),MatchListReference:=""
		}

Return

AddMenuEntry:

	 Menu, %MenuName%, Add, %ShortName%, MenuHandler

	 Try
		{
		 If (v.icon = "")
			Menu, %MenuName%, Icon, %ShortName%, % StrReplace(ExeName,"%Commander_Path%",Commander_Path)
		 Else
			Menu, %MenuName%, Icon, %ShortName%, % StrReplace(v.icon,"%Commander_Path%",Commander_Path)
		}
	 Catch ; it is not an EXE
		{
		 Menu, %MenuName%, Icon, %ShortName%, shell32.dll, 3
		}
	 If (k = 1) ; Add line after default editors
		Menu, %MenuName%, Add

If debug
	{
	 debug_menu .= MenuCounter " : " ShortName "`n"
	}
Return

AddMenuProgramOptions:

; Program options
Menu, %MenuName%, Add
If MatchList.Settings.ContextMenu
	{
	 Menu, %MenuName%, Add,  %MenuPadding%Open Context menu, OpenContextMenu
	 Menu, %MenuName%, Icon, %MenuPadding%Open Context menu, %A_WinDir%\System32\imageres.dll, 249
	 Menu, %MenuName%, Add
	}
Menu, %MenuName%, Add,  %MenuPadding%Add new Editor,    ConfigEditorsNew
Menu, %MenuName%, Icon, %MenuPadding%Add new Editor,    shell32.dll, 176
Menu, %MenuName%, Add,  %MenuPadding%Configure Editors, ConfigEditors
Menu, %MenuName%, Icon, %MenuPadding%Configure Editors, shell32.dll, 70
Menu, %MenuName%, Add,  %MenuPadding%Scan Document Templates, DocumentTemplatesScan
Menu, %MenuName%, Icon, %MenuPadding%Scan Document Templates, shell32.dll, 172
Menu, %MenuName%, Add,  %MenuPadding%Settings,          MenuHandler
Menu, %MenuName%, Icon, %MenuPadding%Settings,          shell32.dll, 170

Menu, %MenuName%, Add,  %MenuPadding%Exit,              MenuHandler
Menu, %MenuName%, Icon, %MenuPadding%Exit,              shell32.dll, 132

Return

OpenContextMenu:
Sleep 10
Send +{F10}
Return
