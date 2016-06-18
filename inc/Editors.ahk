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
Backup:=MatchList

GetList:="Exe|Parameters|StartDir|WindowMode|Ext|Method|Delay|Open|Editor"

infotext=
(join`n
Important:
1 - The first editor will be considered to the default editor.

Info:
1 - Delay (in miliseconds) D&&D = Drag && Drop, Open = between files.
2 - Sort using Ctrl+UP / Ctrl+DOWN or use Edit menu.
)

Menu, EditMenu, Add, Move Up`tCtrl+Up, MoveUp
Menu, EditMenu, Add, Move Down`tCtrl+Down, MoveDown
Menu, MenuBar, Add, %A_Space%Edit, :EditMenu
Gui, Browse:Menu, MenuBar

; INI Gui
Gui, Browse:Add, ListView, x6 y5 w780 h285 grid hwndhLV vLV gLVLabel, Program|Parameters|Start Dir.|Window|Extensions|Method|D&D|Open|Editor
Gui, Browse:Add, GroupBox, x6 yp+290 w360 h120, Comments
Gui, Browse:Add, Text,   x16 yp+20 w340, %infotext%
Gui, Browse:Add, Button, xp+370   yp w70 h24 gSettings, &Settings
Gui, Browse:Add, Button, xp+80    yp w70 h24 gAdd, &Add
Gui, Browse:Add, Button, xp+80    yp w70 h24 gModify, &Modify
Gui, Browse:Add, Button, xp+80    yp w70 h24 gRemove, &Remove
Gui, Browse:Add, Button, xp-240   yp+40 w150 h24 gOK, &OK
Gui, Browse:Add, Button, xp+160   yp w150 h24 gCancel, &Cancel
Gui, Browse:Add, Link,   xp-160   yp+40 w310 h16, F4MiniMenu %F4Version% -- More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>
Gosub, UpdateListview
LvHandle := New LV_Rows(hLV)
Gui, Browse:Show, x261 y211 h427 w790 center, F4MiniMenu - Editor Settings

Sleep 100

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

; Approved chances, read ListView to store new or changed data
Ok:
Backup:=[]
Backup:=MatchList.settings
MatchList:=[]
MatchList.settings:=Backup
Gui, Browse:Default
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
	}

Backup:=""
%F4Save%("MatchList",F4ConfigFile)
Gui, Browse:Destroy
Gosub, GetAllExtensions
Return

Cancel:
MatchList:=Backup
Backup:=""
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
MsgBox, 52, Remove editor, Do you want to remove:`n%Ask%?
IfMsgBox, Yes
	{
	 LV_Delete(SelItem)	
	 MatchList.Remove(Editor)
	}
Return

; We can use the same Gui to ADD or MODIFY an editor we only need 
; to set a variable and the proceed with the regular Modify Gui

Add:
New:=1

Modify:

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


Gui, Modify:+Owner
Gui, Modify:Add, Text,         x10  y10 w77  h18, &Exe
Gui, Modify:Add, Edit,         x89  y8  w290 h20 vExe, %Exe% 
Gui, Modify:Add, Button,       x386 y8  w30  h20 gSelectExe, >>
Gui, Modify:Add, Checkbox,     x426 y8  w200 h20 vDefault, Set as &Default
                        
Gui, Modify:Add, Text,         x10 y40 w77  h16, Para&meters
Gui, Modify:Add, Edit,         x89 y38 w438 h20 vParameters, %Parameters% 
                        
Gui, Modify:Add, Text,         x10 y70 w77  h16, &Start Dir
Gui, Modify:Add, Edit,         x89 y68 w323 h20 vStartDir, %StartDir% 
Gui, Modify:Add, Button,       xp+328 yp h20 w110  gCopyPath, Copy path from Exe.

Gui, Modify:Add, Text,         x10 y100 w78 h28, &Method
If (Method = "Normal")
	Method:=1
Else If (Method = "DragDrop")
	Method:=2
Else If (Method = "FileList")
	Method:=3
Gui, Modify:Add, DropDownList, x89 y97 w238 h21 R3 Choose%Method% vMethod AltSubmit, 1 - Normal|2 - Drag & Drop|3 - FileList

Gui, Modify:Add, Text,         xp+250 yp+3  h16, [Delays] D&&D:
Gui, Modify:Add, Edit,         xp+70 yp-3  h20 w40 vDelay Number, %Delay%
Gui, Modify:Add, Text,         xp+45 yp+3  h16, Open:
Gui, Modify:Add, Edit,         xp+32 yp-3  h20 w40 vOpen Number, %Open%

Gui, Modify:Add, Text,         x10 y130 w78 h28, &Window
Gui, Modify:Add, DropDownList, x89 y127 w438 h21 R3 Choose%WindowMode% vWindowMode AltSubmit, 1 - Normal|2 - Maximized|3 - Minimized

;Gui, Modify:Add, Text,         x10 y160 w78  h16, &Open Mode
;Gui, Modify:Add, DropDownList, x89 y158 w438 h21 Choose%Mode% vMode AltSubmit, (not yet implemented)|
;Gui, Modify:Default
;GuiControl, Disable, Mode

Gui, Modify:Add, Text,         x10 y160 w77  h16, Ex&tensions
Gui, Modify:Add, Edit,         x89 y158 w438 h76 vExt, %Ext% 

Gui, Modify:Add, Link,         x10 y250 w310 h16, F4MiniMenu %F4Version% --- More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>


Gui, Modify:Add, Button,       x340 y245 w90 h24, &OK
Gui, Modify:Add, Button,       x437 y245 w90 h24, &Cancel

Gui, Modify:Show,              x239 y179 h280 w542, Editor configuration
Return

SelectExe:
FileSelectFile, Exe, 3, , Select program, Executables (*.exe`;*.cmd`;*.bat`;*.com`;*.ahk)
if (Exe = "")
    Return

If WinActive("Editor configuration")
	{
	; New program so no doubt new StartDir and Parameters, clear Gui controls
	GuiControl, Modify: ,Exe, %Exe%
	GuiControl, Modify: ,StartDir,
	GuiControl, Modify: ,Parameters,
	GuiControl, Modify: ,Delay,0
	GuiControl, Modify: ,Open,0
	}
Else If WinActive("Settings")	
	{
	 GuiControl, ,TCPath, %Exe%
	}
Return

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
MatchList[Editor,"Parameters"]:=Parameters
MatchList[Editor,"StartDir"]:=StartDir
If (Method = 1)
	Method:="Normal"
Else If (Method = 2)
	Method:="DragDrop"
Else If (Method = 3)
	Method:="FileList"
MatchList[Editor,"Method"]:=Method
MatchList[Editor,"WindowMode"]:=WindowMode

StringReplace, Ext, Ext, `r`n, , All
StringReplace, Ext, Ext, `n, , All
StringReplace, Ext, Ext, `r, , All
MatchList[Editor,"Ext"]:=Ext

MatchList[Editor,"Delay"]:=Delay
MatchList[Editor,"Open"]:=Open
MatchList[Editor,"Editor"]:=Editor

Gui, Modify:Destroy
Gui, Browse:Default

If (Editor = Matchlist.MaxIndex())
	Gosub, UpdateListview
Else
	LV_Modify(SelItem, "",Exe,Parameters,StartDir,WindowMode,Ext,Method,Delay,Open,Editor)
New:=0
Return

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
; Loop % MatchList.MaxIndex() ; Exe|Parameters|StartDir|WindowMode|Ext|Method|Delay|Editor ; %
for k, v in MatchList
	{
	If (k = "settings")
		continue
    FileName := v.Exe  ; Must save it to a writable variable for use below.

    ; Build a unique extension ID to avoid characters that are illegal in variable names,
    ; such as dashes.  This unique ID method also performs better because finding an item
    ; in the array does not require search-loop.
    SplitPath, FileName,,, FileExt  ; Get the file's extension.
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
	 LV_Add("Icon" IconNumber, v.Exe, v.Parameters, v.StartDir, v.WindowMode, v.ext, v.Method, v.Delay, v.Open, A_Index)
	} 
LV_ModifyCol(1, 250), LV_ModifyCol(2, 70), LV_ModifyCol(3, 70)
LV_ModifyCol(4, 50), LV_ModifyCol(5, 165), LV_ModifyCol(6, 70)
LV_ModifyCol(7, 40), LV_ModifyCol(8, 40), LV_ModifyCol(9, 0)
Return

; Hotkeys & Functions to move a listview row
; TODO: Fix icon which does not move with the listview row

; ListViews G-Label.
LVLabel:
; Detect Drag event.
If A_GuiEvent = D
LvHandle.Drag() ; Call Drag function using the Handle.
return

MoveUp:
LvHandle.Move(1) ; Move selected rows up.
return
 
MoveDown:
LvHandle.Move() ; Move selected rows down.
return

#include <class_lv_rows>

