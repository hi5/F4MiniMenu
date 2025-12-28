/*

Gui for managing Editors
Include for F4MiniMenu.ahk

*/

; This label is used when "Add new Editor" is selected in the foreground menu,
; we only need to set a variable and the proceed with the regular editor Gui

ConfigEditorsNew:
New:=1


ConfigEditors:

; Variables

; Backup Object so we can use this for CANCEL
Backup:=MatchList.Clone()

GetList:="Exe|Parameters|StartDir|WindowMode|Ext|Method|Delay|Open|Editor|Icon|Name"

infotext=
(join`n
Important:
1 - The first editor will be considered to the default editor.

Info:
1 - Delay (in miliseconds) D&&D = Drag && Drop, Open = startup.
2 - Sort using Ctrl+UP / Ctrl+DOWN or use Edit menu
     (multiple rows possible).
)

IfWinExist, F4MiniMenu - Editor Settings ahk_class AutoHotkeyGUI
	{
	 WinActivate, F4MiniMenu - Editor Settings ahk_class AutoHotkeyGUI
	 If New
		Gosub, NewEditor
	 Return
	}

Gui, Browse: +Resize +MinSize790x427

Menu, EditMenu, Add, Move Up`tCtrl+Up, MoveUp
Menu, EditMenu, Add, Move Down`tCtrl+Down, MoveDown
Menu, MenuBar, Add, %A_Space%Edit, :EditMenu
Gui, Browse:Menu, MenuBar

; INI Gui
Gui, Browse:font,          % dpi("s8"), MS Shell Dlg
Gui, Browse:Add, ListView, % dpi("x6 y5 w780 h285 grid hwndhLV vLV gLVLabel"), Program|Parameters|Start Dir.|Window|Extensions|Method|D&D|Open|Editor|Icon|Name
Gui, Browse:Add, GroupBox, % dpi("x6 yp+290 w390 h120 vGroupBoxInfo"), Comments
Gui, Browse:Add, Text,     % dpi("x16 yp+20 w340 vInfoText"), %infotext%
Gui, Browse:Add, Button,   % dpi("xp+445   yp w70 h24 gSettings vButtonSettings"), &Settings
Gui, Browse:Add, Button,   % dpi("xp+80    yp w70 h24 gAdd      vButtonAdd"), &Add
Gui, Browse:Add, Button,   % dpi("xp+80    yp w70 h24 gModify   vButtonModify"), &Modify
Gui, Browse:Add, Button,   % dpi("xp+80    yp w70 h24 gRemove   vButtonRemove"), &Remove
Gui, Browse:Add, Button,   % dpi("xp-240   yp+40 w150 h24 gOK   vButtonOK"), &OK
Gui, Browse:Add, Button,   % dpi("xp+160   yp w150 h24 gCancel  vButtonCancel"), &Cancel
Gui, Browse:Add, Link,     % dpi("xp-160   yp+40 w310 h16       vLinkText"), F4MiniMenu %F4Version% -- More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>
Gosub, UpdateListview
LvHandle := New LV_Rows(hLV)
Gui, Browse:Show,          % dpi("x261 y211 h427 w790 center"), F4MiniMenu - Editor Settings

Sleep 100

NewEditor:
If (New = 1) ; we choose "Add new Editor in foreground menu"
	{
	 Gosub, Add
	 ; get list of selected files so we can set the Extensions automatically
	 SelectedExtensions:=""
	 Files:=GetFiles()
	 Loop, parse, Files, `n, `r
		{
		 SplitPath, A_LoopField, , , OutExtension
		 If OutExtension not in %SelectedExtensions%
			SelectedExtensions .= OutExtension ","
		}
	 SelectedExtensions:=Rtrim(SelectedExtensions,",")
	 GuiControl,Modify: , Ext, %SelectedExtensions%
	 SelectedExtensions:=""
	 Files:=""
	}

New:=0
Return

BrowseGuiSize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	AutoXYWH("w h"   , "Lv")
	AutoXYWH("y"     , "GroupBoxInfo")
	AutoXYWH("y"     , "InfoText")
	AutoXYWH("x y"   , "ButtonSettings")
	AutoXYWH("x y"   , "ButtonAdd")
	AutoXYWH("x y"   , "ButtonModify")
	AutoXYWH("x y"   , "ButtonRemove")
	AutoXYWH("x y"   , "ButtonOK")
	AutoXYWH("x y"   , "ButtonCancel")
	AutoXYWH("x y"   , "LinkText")
	ControlGetPos, , , OutWidth, , Syslistview321, F4MiniMenu - Editor Settings
	LV_ModifyCol(1, (dpifactor*250) + (OutWidth-780))
Return

; Approved chances, read ListView to store new or changed data
Ok:
Backup:=[]
Backup:=MatchList.settings
MatchList:=[]
MatchList.settings:=Backup
Gui, Browse:Default
Gui +LastFound
Loop, % LV_GetCount() ; %
	{
	 Row:=A_Index
	 Loop, parse, GetList, |
		LV_GetText(%A_LoopField%, Row, A_Index)
	 MatchList[Row,"Exe"]:=Exe
	 MatchList[Row,"Parameters"]:=Parameters
	 MatchList[Row,"StartDir"]:=StartDir
	 MatchList[Row,"Method"]:=Method
	 MatchList[Row,"WindowMode"]:=WindowMode
	 MatchList[Row,"Ext"]:=Ext
	 MatchList[Row,"Delay"]:=Delay
	 MatchList[Row,"Open"]:=Open
	 MatchList[Row,"Icon"]:=Icon
	 MatchList[Row,"Name"]:=Name
	}

If (Trim(MatchList.1.Ext,"`n`r`t ") = "")
	MatchList.1.Ext:="txt" ; safety as we need at least one extension for the default editor

Backup:=""
%F4Save%("MatchList",F4ConfigFile)
Gui, Browse:Destroy
Gosub, BuildMenu
Gosub, GetAllExtensions
Return

BrowseGuiEscape:
Cancel:
MatchList:=[]
MatchList:=Backup
Backup:=""
Gosub, BuildMenu
Gosub, BrowseGuiClose
Return

Remove:
Ask:=""
Gui, Browse:Default
Gui, Browse:Submit, NoHide
SelItem := LV_GetNext()
If (SelItem = 0)
	SelItem = 1
LV_GetText(Ask, SelItem, 1)
MsgBox, 52, Remove editor (one entry),Do you want to remove:`n%Ask%?
IfMsgBox, Yes
	{
	 LV_Delete(SelItem)
	 MatchList.Remove(Editor)
	}
Gosub, BuildMenu
Return

; We can use the same Gui to ADD or MODIFY an editor we only need
; to set a variable and the proceed with the regular Modify Gui

Add:
New:=1

Modify:

Gui, Modify:Destroy ; https://www.ghisler.ch/board/viewtopic.php?p=423475#p423475

; Clear variables just to be sure
Loop, parse, GetList, |
	%A_LoopField%:=""

If New
	{
	 Delay:=0
	 Method:="Normal"
	 WindowMode:=1
	}

; We want to modify existing entry, get info from listview and set variables for use in Gui
If !New
	{
	 Gui, Browse:Default
	 Gui, Browse:Submit, NoHide
	 SelItem := LV_GetNext()
	 If (SelItem = 0)
		SelItem = 1
	 Loop, parse, GetList, |
		{
		 LV_GetText(%A_LoopField%, SelItem, A_Index)
		}
	}

Gui, Modify:+OwnerBrowse -SysMenu
Gui, Modify:font,              % dpi("s8"), MS Shell Dlg
Gui, Modify:Add, Text,         % dpi("x10  y10 w77  h18"), &Exe
Gui, Modify:Add, Edit,         % dpi("x89  y8  w290 h20 vExe"), %Exe%
Gui, Modify:Add, Button,       % dpi("x386 y8  w30  h20 gSelectExe"), >>
Gui, Modify:Add, Checkbox,     % dpi("x426 y8  w200 h20 vDefault"), Set as &Default

Gui, Modify:Add, Text,         % dpi("x10  yp+32 w77  h18"), &Icon
Gui, Modify:Add, Edit,         % dpi("x89  yp-2 w170 h20 vIcon"), %Icon%
Gui, Modify:Add, Button,       % dpi("x266 yp  w30  h20 gSelectIcon"), >>
Gui, Modify:Add, Text,         % dpi("xp+41 yp+2 w60  h18"), Menu &Name
Gui, Modify:Add, Edit,         % dpi("xp+70 yp-2 w150 h20 vName"), %Name%

Gui, Modify:Add, Text,         % dpi("x10 yp+32 w77 h16"), Para&meters
Gui, Modify:Add, Edit,         % dpi("x89 yp-2 w438 h20 vParameters"), %Parameters%

Gui, Modify:Add, Text,         % dpi("x10 yp+32 w77 h16"), &Start Dir
Gui, Modify:Add, Edit,         % dpi("x89 yp-2 w323 h20 vStartDir"), %StartDir%
Gui, Modify:Add, Button,       % dpi("xp+328 yp h20 w110 gCopyPath"), Copy path from Exe.

Gui, Modify:Add, Text,         % dpi("x10 yp+32 w78 h28"), &Method
If (Method = "Normal")
	Method:=1
Else If (Method = "DragDrop")
	Method:=2
Else If (Method = "FileList")
	Method:=3
Else If (Method = "cmdline")
	Method:=4
Gui, Modify:Add, DropDownList, % dpi("x89 yp-3 w238 h21 R4 Choose" Method " vMethod AltSubmit"), 1 - Normal|2 - Drag & Drop|3 - FileList|4 - cmdline

Gui, Modify:Add, Text,         % dpi("xp+250 yp+3 h16"), [Delays] D&&D:
Gui, Modify:Add, Edit,         % dpi("xp+70 yp-3  h20 w40 vDelay Number"), %Delay%
Gui, Modify:Add, Text,         % dpi("xp+45 yp+3  h16"), Open:
Gui, Modify:Add, Edit,         % dpi("xp+32 yp-3  h20 w40 vOpen Number"), %Open%

Gui, Modify:Add, Text,         % dpi("x10 yp+32 w78 h28"), &Window
Gui, Modify:Add, DropDownList, % dpi("x89 yp-3 w238 h21 R3 Choose" WindowMode " vWindowMode AltSubmit"), 1 - Normal|2 - Maximized|3 - Minimized

;Gui, Modify:Add, Text,         x10 y160 w78  h16, &Open Mode
;Gui, Modify:Add, DropDownList, x89 y158 w438 h21 Choose%Mode% vMode AltSubmit, (not yet implemented)|
;Gui, Modify:Default
;GuiControl, Disable, Mode

Gui, Modify:Add, Text,         % dpi("x10 yp+32 w77 h80"), Ex&tensions (Default editor must have at least one ext.`nTXT is set if not defined)
Gui, Modify:Add, Edit,         % dpi("x89 yp-2 w438 h80 vExt"), %Ext%

Gui, Modify:Add, Link,         % dpi("x10 yp+100 w310 h16"), F4MiniMenu %F4Version% --- More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>

Gui, Modify:Add, Button,       % dpi("x340 yp-5 w90 h24"), &OK
Gui, Modify:Add, Button,       % dpi("x437 yp   w90 h24"), &Cancel

Gui, Modify:Show,              % dpi("w542 center"), Editor configuration
Return

SelectIcon:
FileSelectFile, Icon, 3, , Select Icon, Icon (*.ico)
if (Icon = "")
	Return
GuiControl, Modify: ,Icon,%Icon%

Return

SelectExe:
Exe:=""
FileSelectFile, Exe, 3, , Select program, Executables (*.exe`;*.cmd`;*.bat`;*.com`;*.ahk)
if (Exe = "")
	Return

If WinActive("Editor configuration")
	{
	 ; New program so no doubt new StartDir and Parameters, clear Gui controls
	 GuiControl, Modify: ,Exe, %Exe%
	 GuiControl, Modify: ,Icon,%Icon%
	 GuiControl, Modify: ,Name,%Name%
	 GuiControl, Modify: ,StartDir,
	 GuiControl, Modify: ,Parameters,
	 GuiControl, Modify: ,Delay,0
	 GuiControl, Modify: ,Open,0
	}
Else If WinActive("Settings") and (Exe)
	{
	 GuiControl, ,TCPath, %Exe%
	}
Return

SelectIni:
FileIni:=""
FileSelectFile, FileIni, 3, , Select TC INI location, INI (*.ini)
if (FileIni = "")
	Return

If WinActive("Settings") and (FileIni)
	{
	 GuiControl, ,TCIniPath, %FileIni%
	}
Return

; Note: deactivated Everything Directory Tree settings for now
/*
SelectEv:
FileSelectFile, EvPath, 3, c:\program files\everything\, Path to Everything, Executable (*.exe)
if (EvPath = "")
    Return

If WinActive("Settings")
	{
	 GuiControl, ,EvPath, %EvPath%
	}
Return
*/

CopyPath:
GuiControlGet, CopyPath, ,Exe
SplitPath, CopyPath, , StartDir
GuiControl, Modify: , StartDir, %StartDir%\
CopyPath:=""
Return

ModifyButtonOK:
Gui, Modify:Default
Gui, Submit, NoHide
If (Editor = "") ; we have a new editor
	Editor:=MatchList.MaxIndex() + 1

MatchList[Editor,"Exe"]:=Exe
MatchList[Editor,"Icon"]:=Icon
MatchList[Editor,"Name"]:=Name
MatchList[Editor,"Parameters"]:=Parameters
MatchList[Editor,"StartDir"]:=StartDir
If (Method = 1)
	Method:="Normal"
Else If (Method = 2)
	Method:="DragDrop"
Else If (Method = 3)
	Method:="FileList"
Else If (Method = 4)
	Method:="cmdline"
MatchList[Editor,"Method"]:=Method
MatchList[Editor,"WindowMode"]:=WindowMode

StringReplace, Ext, Ext, `r`n, , All
StringReplace, Ext, Ext, `n, , All
StringReplace, Ext, Ext, `r, , All
MatchList[Editor,"Ext"]:=Ext

If (Trim(MatchList.1.Ext,"`n`r`t ") = "")
	MatchList.1.Ext:="txt" ; safety as we need at least one extension for the default editor

MatchList[Editor,"Delay"]:=Delay
MatchList[Editor,"Open"]:=Open
MatchList[Editor,"Editor"]:=Editor

If Default
	{
	 DefaultMatchEditor:=[]
	 DefaultMatchEditor:=MatchList[Editor]
	 DefaultMatchEditor["Editor"]:=""
	 MatchList.Remove(Editor)
	 MatchList.InsertAt(1,DefaultMatchEditor)
	 DefaultMatchEditor:=""
	}

Gui, Modify:Destroy
Gui, Browse:Default

If (Editor = Matchlist.MaxIndex()) or (Default)
	Gosub, UpdateListview
Else
	LV_Modify(SelItem, "",Exe,Parameters,StartDir,WindowMode,Ext,Method,Delay,Open,Editor,Icon,Name)
New:=0,Default:=0
Gosub, BuildMenu
Return

ModifyGuiEscape:
ModifyButtonCancel:
ModifyGuiClose:
New:=0
Gui, Modify:Destroy
Return

BrowseGuiClose:
Gui, Browse:Destroy
Return

UpdateListview:
Gui, Browse:Default

; Icon wizardry comes directly from AutoHotkey Listview documentation
; It works with both Ansi & Unicode versions
; Calculate buffer size required for SHFILEINFO structure.
sfi_size := A_PtrSize + 8 + (A_IsUnicode ? 680 : 340)
VarSetCapacity(sfi, sfi_size)

IL_Destroy(ImageListID1)
; Create an ImageList so that the ListView can display some icons:
ImageListID1 := IL_Create(65, 10, IconSize)
; Attach the ImageLists to the ListView so that it can later display the icons:
LV_SetImageList(ImageListID1)
LV_Delete()
Count=0
; Loop % MatchList.MaxIndex() ; Exe|Parameters|StartDir|WindowMode|Ext|Method|Delay|Editor|Icon|Name ; %
for k, v in MatchList
  {
   If (k = "settings") or (k = "temp")
      Continue
   FileName := v.Exe  ; Must save it to a writable variable for use below.
   If (FileName = "")
      Continue
   If (v.Icon <> "")
      ; FileName := StrReplace(v.Icon,"%Commander_Path%",Commander_Path)
      FileName := GetPath(v.Icon)

   If InStr(FileName,"%Commander_Path%")
;      FileName := StrReplace(FileName,"%Commander_Path%",Commander_Path)
      FileName := GetPath(FileName)

    ; Build a unique extension ID to avoid characters that are illegal in variable names,
    ; such as dashes.  This unique ID method also performs better because finding an item
    ; in the array does not require search-loop.
    SplitPath, FileName,,, FileExt  ; Get the file's extension.
    FileName:=GetPath(FileName)
    if FileExt in EXE,ICO,ANI,CUR
      {
       ExtID := FileExt  ; Special ID as a placeholder.
       IconNumber = 0  ; Flag it as not found so that these types can each have a unique icon.
      }
    else  ; Some other extension/file-type, so calculate its unique ID.
      {
       ExtID = 0  ; Initialize to handle extensions that are shorter than others.
       Loop 7     ; Limit the extension to 7 characters so that it fits in a 64-bit value.
           {
            StringMid, ExtChar, FileExt, A_Index, 1
            if not ExtChar  ; No more characters.
               break
            ; Derive a Unique ID by assigning a different bit position to each character:
            ExtID := ExtID | (Asc(ExtChar) << (8 * (A_Index - 1)))
           }
       ; Check if this file extension already has an icon in the ImageLists. If it does,
       ; several calls can be avoided and loading performance is greatly improved,
       ; especially for a folder containing hundreds of files:
       IconNumber := IconArray%ExtID%
      }
    if not IconNumber  ; There is not yet any icon for this extension, so load it.
      {
       ; Get the high-quality small-icon associated with this file extension:
       if not DllCall("Shell32\SHGetFileInfo" . (A_IsUnicode ? "W":"A"), "str", FileName
           , "uint", 0, "ptr", &sfi, "uint", sfi_size, "uint", 0x101)  ; 0x101 is SHGFI_ICON+SHGFI_SMALLICON
           IconNumber = 9999999  ; Set it out of bounds to display a blank icon.
       else ; Icon successfully loaded.
          {
           ; Extract the hIcon member from the structure:
           hIcon := NumGet(sfi, 0)
           ; Add the HICON directly to the small-icon and large-icon lists.
           ; Below uses +1 to convert the returned index from zero-based to one-based:
           IconNumber := DllCall("ImageList_ReplaceIcon", "ptr", ImageListID1, "int", -1, "ptr", hIcon) + 1
           DllCall("ImageList_ReplaceIcon", "ptr", ImageListID2, "int", -1, "ptr", hIcon)
           ; Now that it's been copied into the ImageLists, the original should be destroyed:
           DllCall("DestroyIcon", "ptr", hIcon)
           ; Cache the icon to save memory and improve loading performance:
           IconArray%ExtID% := IconNumber
          }
      }

    ; Create the new row in the ListView and assign it the icon number determined above:
      LV_Add("Icon" IconNumber , v.Exe, v.Parameters, v.StartDir, v.WindowMode, v.ext, v.Method, v.Delay, v.Open, A_Index, v.Icon, v.Name)
	}
dpifactor:=dpi()
LV_ModifyCol(1, dpifactor*250), LV_ModifyCol(2, dpifactor*70), LV_ModifyCol(3, dpifactor*70)
LV_ModifyCol(4, dpifactor*50), LV_ModifyCol(5, dpifactor*165), LV_ModifyCol(6, dpifactor*70)
LV_ModifyCol(7, dpifactor*40), LV_ModifyCol(8, dpifactor*40), LV_ModifyCol(9, 0)
LV_ModifyCol(10, 0), LV_ModifyCol(11, 0) ; icon, name
Return

; Hotkeys & Functions to move a listview row
; TODO: Fix icon which does not move with the listview row

; ListViews G-Label.
LVLabel:
; Detect Drag event.
If A_GuiEvent = D
	LvHandle.Drag() ; Call Drag function using the Handle.
If A_GuiEvent = DoubleClick
	Gosub, Modify
return

MoveUp:
LvHandle.Move(1) ; Move selected rows up.
return

MoveDown:
LvHandle.Move() ; Move selected rows down.
return

#include <class_lv_rows>
