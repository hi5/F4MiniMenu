/*

Foreground menu - uses lib\GetPos.ahk
Include for F4MiniMenu.ahk

*/

ShowMenu:

; Add Default editor first


Menu, MyMenu, Add,
Menu, MyMenu, DeleteAll
Name:=MatchList[1].exe
SplitPath, Name, DefaultShortName
DefaultShortName:=MenuPadding DefaultShortName
Menu, MyMenu, Add, %DefaultShortName%, MenuHandler
Try
	{
	  Menu, MyMenu, Icon, %DefaultShortName%, %name%
	}
Catch
	{
	 Menu, MyMenu, Icon, %DefaultShortName%, shell32.dll, 3
	}

Menu, MyMenu, Add

; Build menu based on defined editors
; Loop % MatchList.MaxIndex() ; %
for k, v in MatchList
	{
	 If (k = 1) or (k = "settings")
		Continue ; skip default
     Name:=v.exe
     SplitPath, Name, ShortName
	 ShortName:=MenuPadding "&" ShortName
	 Menu, MyMenu, Add, %ShortName%, MenuHandler
	 
	 Try
	 	{
	 	  Menu, MyMenu, Icon, %ShortName%, %name%
	 	}
	 Catch ; it is not an EXE 
	 	{
	 	 Menu, MyMenu, Icon, %ShortName%, shell32.dll, 3
	 	}
	}

; Program options	
Menu, MyMenu, Add
Menu, MyMenu, Add,  %MenuPadding%Add new Editor,    ConfigEditorsNew
Menu, MyMenu, Icon, %MenuPadding%Add new Editor,    shell32.dll, 176
Menu, MyMenu, Add,  %MenuPadding%Settings,          MenuHandler
Menu, MyMenu, Icon, %MenuPadding%Settings,          shell32.dll, 170
Menu, MyMenu, Add,  %MenuPadding%Configure Editors, ConfigEditors
Menu, MyMenu, Icon, %MenuPadding%Configure Editors, shell32.dll, 70
Menu, MyMenu, Add,  %MenuPadding%Exit,              MenuHandler
Menu, MyMenu, Icon, %MenuPadding%Exit,              shell32.dll, 132
	
CoordMode, Menu, Client
Coord:=GetPos(MatchList.settings.MenuPos,MatchList.MaxIndex())
Menu, MyMenu, Show, % Coord["x"], % Coord["y"] 
Return

; If the tray icon is double click we do not actually want to do anything
DoubleTrayClick: 
Return

; Tray menu
MenuHandler:

; Easy & Quick options first
If (A_ThisMenuItem = "&Reload this script")
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

; Settings menu

Else If (A_ThisMenuItem = "   Exit")
	Return
Else If (A_ThisMenuItemPos = 1) ; Default editor
	{
	 ProcessFiles(Matchlist, 1)
	 Return
	}
Else If (A_ThisMenuItem = "   Settings")
	{
	 Gosub, Settings
	 Return
	}

; Now we need to find the selected editor

Selected:=1
; Loop % MatchList.MaxIndex() ; %
for k, v in MatchList
	{
	 If (k = 1) or (k = "settings")
		Continue ; skip default
	 Name:=v.exe
     SplitPath, Name, ShortName
	 If (A_ThisMenuItem = MenuPadding "&" ShortName)
		{
		 Selected:=A_Index
		 Break
		}
	 }
	 
ProcessFiles(Matchlist, Selected)

Return