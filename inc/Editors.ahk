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

GetList:="Exe|Parameters|StartDir|WindowMode|Ext|Method|Mode|Delay|Editor"

infotext=
(join`n
Important:
1 - The first editor will be considered to the default editor
2 - Sort using Ctrl+UP / Ctrl+DOWN (manual sort, see (1) below)
Known issues:
1 - During manual sort, the icon does not change which is confusing
2 - Delay (in miliseconds) is only applicable to Drag && Drop method
3 - Open Mode not implemented yet
)

; INI Gui
Gui, Browse:Add, ListView, x6 y5 w850 h285 grid , Exe|Parameters|Start Dir.|Window|Extensions|Method|Open|Delay|Editor
Gui, Browse:Add, GroupBox, x6 yp+290 w360 h120, Comments
Gui, Browse:Add, Text,   x16 yp+20 w340, %infotext%
Gui, Browse:Add, Button, xp+370   yp w70 h24 gSettings, &Settings
Gui, Browse:Add, Button, xp+80    yp w70 h24 gAdd, &Add
Gui, Browse:Add, Button, xp+80    yp w70 h24 gModify, &Modify
Gui, Browse:Add, Button, xp+80    yp w70 h24 gRemove, &Remove
Gui, Browse:Add, Button, xp-240   yp+40 w150 h24 gOK, &OK
Gui, Browse:Add, Button, xp+160   yp w150 h24 gCancel, &Cancel
Gui, Browse:Add, Link,   xp-160   yp+40 w300 h16, F4MiniMenu %F4Version% --- More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>
Gosub, UpdateListview
Gui, Browse:Show, x261 y211 h427 w760 center, F4MiniMenu - Editor Settings

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
Backup:=MatchList[0]
MatchList:=[]
MatchList[0]:=Backup
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
	 MatchList[Row,"Delay"]:=Delay
	 MatchList[Row,"WindowMode"]:=WindowMode
	 MatchList[Row,"Ext"]:=Ext
	 MatchList[Row,"Delay"]:=Delay
	}

Backup:=""
XA_Save("MatchList","F4MiniMenu.xml")
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
	 Delay:=750
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
Else
	Method:=2
Gui, Modify:Add, DropDownList, x89 y97 w238 h21 R2 Choose%Method% vMethod AltSubmit, 1 - Normal|2 - Drag & Drop

Gui, Modify:Add, Text,         xp+250 yp+3  h16, Delay for D&&D first run (ms)
Gui, Modify:Add, Edit,         xp+137 yp-3  h20 w50 vDelay Number, %Delay%

Gui, Modify:Add, Text,         x10 y130 w78 h28, &Window
Gui, Modify:Add, DropDownList, x89 y127 w438 h21 R3 Choose%WindowMode% vWindowMode AltSubmit, 1 - Normal|2 - Maximized|3 - Minimized

Gui, Modify:Add, Text,         x10 y160 w78  h16, &Open Mode
Gui, Modify:Add, DropDownList, x89 y158 w438 h21 Choose%Mode% vMode AltSubmit, (not yet implemented)|
Gui, Modify:Default
GuiControl, Disable, Mode

Gui, Modify:Add, Text,         x10 y190 w77  h16, Ex&tensions
Gui, Modify:Add, Edit,         x89 y188 w438 h46 vExt, %Ext% 

Gui, Modify:Add, Link,         x10 y250 w300 h16, F4MiniMenu %F4Version% --- More info at <a href="https://github.com/hi5/F4MiniMenu">Github.com/hi5/F4MiniMenu</a>


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
Else
	Method:="DragDrop"
MatchList[Editor,"Method"]:=Method
MatchList[Editor,"Delay"]:=Delay
MatchList[Editor,"WindowMode"]:=WindowMode

StringReplace, Ext, Ext, `r`n, , All
StringReplace, Ext, Ext, `n, , All
StringReplace, Ext, Ext, `r, , All
MatchList[Editor,"Ext"]:=Ext

MatchList[Editor,"Delay"]:=Delay
MatchList[Editor,"Editor"]:=Editor

Gui, Modify:Destroy
Gui, Browse:Default

If (Editor = Matchlist.MaxIndex())
	Gosub, UpdateListview
Else
	LV_Modify(SelItem, "",Exe,Parameters,StartDir,WindowMode,Ext,Method,Mode,Delay,Editor)
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
IL_Destroy(ImageListID1)
; Create an ImageList so that the ListView can display some icons:
ImageListID1 := IL_Create(10, 10, IconSize)
; Attach the ImageLists to the ListView so that it can later display the icons:
LV_SetImageList(ImageListID1)
LV_Delete()
Count=0
Loop % MatchList.MaxIndex() ; Exe|Parameters|StartDir|WindowMode|Ext|Method|Mode|Delay|Editor ; %
	{
	 Count++
	 hIcon := DllCall("Shell32\ExtractAssociatedIconA", UInt, 0, Str, MatchList[A_Index].exe, UShortP, iIndex)
	 DllCall("ImageList_ReplaceIcon", UInt, ImageListID1, Int, -1, UInt, hIcon)
	 DllCall("DestroyIcon", Uint, hIcon)
	 LV_Add("Icon" Count, MatchList[A_Index].Exe, MatchList[A_Index].Parameters, MatchList[A_Index].StartDir, MatchList[A_Index].WindowMode, MatchList[A_Index].ext, MatchList[A_Index].Method, MatchList[A_Index].Mode, MatchList[A_Index].Delay,A_Index)
	} 
LV_ModifyCol(1, 250), LV_ModifyCol(2, 70), LV_ModifyCol(3, 70)
LV_ModifyCol(4, 60), LV_ModifyCol(5, 130), LV_ModifyCol(6, 70)
LV_ModifyCol(7, 40), LV_ModifyCol(8, 40), LV_ModifyCol(9, 0)
Return

; Hotkeys & Functions to move a listview row
; TODO: Fix icon which does not move with the listview row

#IfWinActive F4MiniMenu - Editor Settings
$^Up::LV_MoveRow()
$^Down::LV_MoveRow(false)
#IfWinActive

LV_MoveRow(moveup = true) {
	; Original by diebagger (Guest) from:
	; http://de.autohotkey.com/forum/viewtopic.php?p=58526#58526
	; Slightly Modifyed by Obi-Wahn
	; http://www.autohotkey.com/board/topic/56396-techdemo-move-rows-in-a-listview/
	If moveup not in 1,0
		Return	; If direction not up or down (true or false)
	Gui, Browse:Default
	While x := LV_GetNext(x)	; Get selected lines
		i := A_Index, i%i% := x
	If (!i) || ((i1 < 2) && moveup) || ((i%i% = LV_GetCount()) && !moveup)
		Return	; Break Function if: nothing selected, (first selected < 2 AND moveup = true) [header bug]
				; OR (last selected = LV_GetCount() AND moveup = false) [delete bug]
	cc := LV_GetCount("Col"), fr := LV_GetNext(0, "Focused"), d := moveup ? -1 : 1
	; Count Columns, Query Line Number of next selected, set direction math.
	Loop, %i% {	; Loop selected lines
		r := moveup ? A_Index : i - A_Index + 1, ro := i%r%, rn := ro + d
		; Calculate row up or down, ro (current row), rn (target row)
		Loop, %cc% {	; Loop through header count
			LV_GetText(to, ro, A_Index), LV_GetText(tn, rn, A_Index)
			; Query Text from Current and Targetrow
			LV_Modify(rn, "Col" A_Index, to), LV_Modify(ro, "Col" A_Index, tn)
			; Modify Rows (switch text)
		}
		LV_Modify(ro, "-select -focus"), LV_Modify(rn, "select vis")
		If (ro = fr)
			LV_Modify(rn, "Focus")
	}
}

