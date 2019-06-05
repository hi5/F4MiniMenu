/*

Foreground menu - uses lib\GetPos.ahk
Include for F4MiniMenu.ahk

*/

ShowMenu:
CoordMode, Menu, Client
Coord:=GetPos(MatchList.settings.MenuPos,MatchList.MaxIndex())
Menu, MyMenu, Show, % Coord["x"], % Coord["y"] 
Return

; Build menu based on defined editors

BuildMenu:
Menu, MyMenu, Add,
Menu, MyMenu, DeleteAll

for k, v in MatchList
	{
	 If (k = "settings")
		Continue ; skip settings
	 ExeName:=v.exe
	 SplitPath, ExeName, ShortName
	 If (v.name <> "")
		ShortName:=v.name

	 If InStr(ShortName,"&")
		ShortName:=MenuPadding ShortName
	 else
		ShortName:=MenuPadding "&" ShortName
	 Menu, MyMenu, Add, %ShortName%, MenuHandler

	 Try
		{
		 If (v.icon = "")
			Menu, MyMenu, Icon, %ShortName%, % StrReplace(ExeName,"%Commander_Path%",Commander_Path)
		 Else
			Menu, MyMenu, Icon, %ShortName%, % StrReplace(v.icon,"%Commander_Path%",Commander_Path)
		}
	 Catch ; it is not an EXE 
		{
		 Menu, MyMenu, Icon, %ShortName%, shell32.dll, 3
		}
	 If (k = 1) ; Add line after default editors
		Menu, MyMenu, Add
	}

; Program options
Menu, MyMenu, Add
Menu, MyMenu, Add,  %MenuPadding%Add new Editor,    ConfigEditorsNew
Menu, MyMenu, Icon, %MenuPadding%Add new Editor,    shell32.dll, 176
Menu, MyMenu, Add,  %MenuPadding%Settings,          MenuHandler
Menu, MyMenu, Icon, %MenuPadding%Settings,          shell32.dll, 170
Menu, MyMenu, Add,  %MenuPadding%Configure Editors, ConfigEditors
Menu, MyMenu, Icon, %MenuPadding%Configure Editors, shell32.dll, 70
Menu, MyMenu, Add,  %MenuPadding%Scan Document Templates, DocumentTemplatesScan
Menu, MyMenu, Icon, %MenuPadding%Scan Document Templates, shell32.dll, 172

Menu, MyMenu, Add,  %MenuPadding%Exit,              MenuHandler
Menu, MyMenu, Icon, %MenuPadding%Exit,              shell32.dll, 132

Return

; If the tray icon is double click we do not actually want to do anything
DoubleTrayClick: 
Send {rbutton} ; show tray menu
Return


; Tray menu
MenuHandler:
; MsgBox % A_ThisMenuItemPos-1 ":" MatchList[A_ThisMenuItemPos-1].exe ; debug

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
	 ProcessFiles(Matchlist, 1)
	 Return
	}
Else
	ProcessFiles(Matchlist, A_ThisMenuItemPos-1) ; proceed with the selected editor. Menu order = editor order.

Return
