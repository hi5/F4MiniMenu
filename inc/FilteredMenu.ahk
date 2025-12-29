/*

Foreground menu - show matching programs only based on .ext - uses lib\GetPos.ahk
Shares code with menu.ahk (building menu, AddMenuEntry + AddMenuProgramOptions labels, menuhandler)
Include for F4MiniMenu.ahk

*/


FilteredMenu:
GetExt(GetFiles())
If debug
	{
	 debug_ext:=MatchList.Temp.SelectedExtensions
	 debug_files:=MatchList.Temp.Files
	}
CoordMode, Menu, Client
Gosub, BuildFilteredMenu
; MsgBox % MatchList.settings.FilteredMenuAutoEdit
If (MenuCounter = 3) and (MatchList.Settings.FilteredMenuAutoEdit = 2)
	{
	 ; only found one editor so run automatically
	 ; TODO how to get from here to openfiles????
	 ProcessFiles(Matchlist, MatchListReference[3])
	 OSDTIP_Pop("F4MiniMenu", "Only found one editor.`nOpening file automatically", -750,"W230 H80 U1")
;	 MsgBox
	}
Else
	{
	 Coord:=GetPos(MatchList.settings.MenuPos,MatchList.MaxIndex())
	 WinActivate, % Coord["ActiveProcessTitle"]
	 Menu, %MenuName%, Show, % Coord["x"], % Coord["y"] 
	}	
MatchList.Temp.Files:="",MatchList.Temp.SelectedExtensions:="",MatchList.Delete("Temp")
MenuCounter:=""
Return

; Build menu based on defined editors

BuildFilteredMenu:
Menu, MyFilteredMenu, Add,
Menu, MyFilteredMenu, DeleteAll

MenuName:="MyFilteredMenu"

MatchListReference:=[] ; Object and counter below used to keep track of the original position in MatchList so
MenuCounter:=0         ; we select the correct editor in the filtered menu as we use A_ThisMenuItemPos in menuhandler

for k, v in MatchList
	{
	 If (k = "settings") or (k = "temp")
		Continue ; skip settings
	 If RegExMatch(MatchList.Temp.SelectedExtensions,StrReplace(RegExExtensions(v.ext),",","|")) or (k = 1)
		{
		 MenuCounter++
		 ExeName:=v.exe
		 SplitPath, ExeName, ShortName
		 If (v.name <> "")
			ShortName:=v.name

		 If InStr(ShortName,"&")
			ShortName:=MenuPadding ShortName
		 else
			ShortName:=MenuPadding "&" ShortName

		 MatchListReference[MenuCounter]:=A_Index

		 If (k = 1) ; because we add a separator line we need to keep track of this
			MenuCounter++

		 Gosub, AddMenuEntry
		}
	}

Menu, MyFilteredMenu, Add, 
Menu, MyFilteredMenu, Add, % MatchList.settings.FullMenu ? "&" MatchList.settings.FullMenu " Full menu" : "   Full menu", :MyMenu
Try
	Menu, MyFilteredMenu, Icon,  % MatchList.settings.FullMenu ? "&" MatchList.settings.FullMenu " Full menu" : "   Full menu", res\f4.ico

Gosub, AddMenuProgramOptions



If (MenuCounter = 2) ; we haven't found any matches, so just show full menu
	MenuName:="MyMenu"

Return
