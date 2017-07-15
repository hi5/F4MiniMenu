/*

Script      : F4MiniMenu.ahk for Total Commander - AutoHotkey 1.1+ (Ansi and Unicode)
Version     : 0.95
Author      : hi5
Last update : 10 July 2017
Purpose     : Minimalistic clone of the F4 Menu program for Total Commander (open selected files in editor(s))
Source      : https://github.com/hi5/F4MiniMenu

Note        : ; % used to resolve syntax highlighting feature bug of N++

*/

#SingleInstance, Force
#UseHook
#NoEnv
SetBatchlines, -1
SetWorkingDir, %A_ScriptDir%
; Setup variables, menu, hotkeys etc

global AllExtensions:=""
global TmpFileList:=""
global Commander_Path:=""
MatchList:=""
MenuPadding:="   "
DefaultShortName:=""

EnvGet, TmpFileList, temp
EnvGet, MyComSpec, ComSpec
If (TmpFileList = "")
	TmpFileList:=A_ScriptDir

TmpFileList .= "\$$f4mtmplist$$.m3u"

F4Version:="v0.95"

; shared with F4TCIE
#Include %A_ScriptDir%\inc\LoadSettings1.ahk

GroupAdd, TCF4Windows, ahk_class TTOTAL_CMD
GroupAdd, TCF4Windows, ahk_class TLister
GroupAdd, TCF4Windows, ahk_class TFindFile
GroupAdd, TCF4Windows, ahk_class TQUICKSEARCH

FileDelete, % TmpFileList

Menu, tray, icon, res\f4.ico
Menu, tray, Tip , F4MiniMenu - %F4Version%
Menu, tray, NoStandard
Menu, tray, Add, F4MiniMenu - %F4Version%, DoubleTrayClick
Menu, tray, Default, F4MiniMenu - %F4Version%
Menu, tray, Add, 
Menu, tray, Add, &Reload this script,     MenuHandler
Menu, tray, Add, &Edit this script,       MenuHandler
Menu, tray, Add, 
Menu, tray, Add, &Suspend Hotkeys,        MenuHandler
Menu, tray, Add, &Pause Script,           MenuHandler
Menu, tray, Add, 
Menu, tray, Add, Settings,                Settings
Menu, tray, Add, Configure editors,       ConfigEditors
Menu, tray, Add, Scan Document Templates, DocumentTemplatesScan
Menu, tray, Add, 
Menu, tray, Add, Exit, 				        SaveSettings

If !FileExist(F4ConfigFile) and !FileExist(F4ConfigFile ".bak") ; most likely first run, no need to show error message
	Gosub, CreateNewConfig

; shared with F4TCIE
#Include %A_ScriptDir%\inc\LoadSettings2.ahk

If (Error = 1)
	{
	 ErrorText=
	 (Join`n LTRIM
	  There seems to be an error with the settings file.
	  F4MiniMenu will try to create default configuration and restart.
	  Be sure to check the last backup of your settings in "%F4ConfigFile%"
	  Be sure to exit F4MiniMenu before trying to restore any backup settings.
	 )

	 MsgBox, 16, F4MiniMenu, %ErrorText%
	 Reload
	}

; Create backup file
FileCopy, %F4ConfigFile%, %F4ConfigFile%.bak, 1

If (MatchList.settings.TCStart = 1) and !WinExist("ahk_class TTOTAL_CMD")
	{
	 If FileExist(MatchList.settings.TCPath)
		Run % MatchList.settings.TCPath ; %
	}

; shared with F4MM
#Include %A_ScriptDir%\inc\TotalCommanderPath.ahk

Gosub, DocumentTemplatesScan

Gosub, BuildMenu

; Build master list to quickly open in default program if not found
Gosub, GetAllExtensions

HotKeyState:="On"
Gosub, SetHotkeys

; Save Matchlist Object to XML
OnExit, SaveSettings

; End of Auto-execute section
Return

Process:
ProcessFiles(MatchList)
Return

; Function executed by background hotkey (open directly)
ProcessFiles(MatchList, SelectedEditor = "-1")
	{
	 Done:=[]
	 Stop:=0
	 Files:=GetFiles() ; Get list of selected files in TC, one per line
	 ; Check if we possibly have selected file(s) from an archive
	 If RegExMatch(Files,"iUm)" ArchiveExtentions )
		{
		 If InStr(Files,"`n")
			Check:=SubStr(Files,1,InStr(Files,"`n")-2)
		 Else
			Check:=Files
		 IfNotExist, %check% ; additional check, if the file is from an archive it won't exist
			{                ; therefore we resort to the internal TC Edit command - added for v0.51
			 SendMessage 1075, 904, 0, , ahk_class TTOTAL_CMD
			 Return
			}
		}
	 SelectedFiles:=CountFiles(Files)

	 If (SelectedFiles > MatchList.settings.MaxFiles)
		{
		 ; Technique from http://www.autohotkey.com/docs/scripts/MsgBoxButtonNames.htm	
		 SetTimer, ChangeButtonNames, 10
		 MsgBox, 4150, Maximum files, % "Number of selected files: [" SelectedFiles "]`nDo wish to process them all`nor stop at the maximum?: [" MatchList.settings.MaxFiles "]" ; %
		 IfMsgBox, Cancel
			Return
		 else IfMsgBox, Continue
			Stop:=1
		}

	 Loop, parse, Files, `n, `r
		{
		 If (Stop = 1) and (A_Index > Matchlist.settings.MaxFiles)
			Break
		 open:=A_LoopField
		 SplitPath, A_LoopField, , , OutExtension

		 for k, v in MatchList
			{
			 Index:=A_Index
			 CheckFileExt:=RegExExtensions(v.ext)
			 If CheckFile(done,open) ; safety check - otherwise each file would be processed for all editors
				Break
			 If (SelectedEditor < 0) ; Find out which editor to use, first come first serve
				{
				 ;If OutExtension not in %AllExtensions% ; Open in default program
				 If !RegExMatch(OutExtension,AllExtensions) ; Open in default program - v0.9 allow for wildcards
					{
					 FileList1 .= open "`n"
					 Done.Insert(open)
					}
				 ;Else If OutExtension in % v.ext ; Open in defined program %
				 Else If RegExMatch(OutExtension,CheckFileExt) ; Open in defined program  - v0.9 allow for wildcards
					{
					 FileList%Index% .= open "`n"
					 Done.Insert(open)
					}
				}
			 Else If (SelectedEditor > 0) ; Use selected editor from the Menu (Foreground option)
				{
				 FileList%SelectedEditor% .= open "`n"
				 Done.Insert(open)
				}
			}
		}

	 for k, v in MatchList
		{
		 Index:=A_Index
		 list:=Trim(FileList%Index%,"`n")
		 If (list = "")
			Continue
		 If (v.Method = "cmdline")
			{
			 cmdfiles:=""	
			 Loop, parse, list, `n, `r
			 	cmdfiles .= """" A_LoopField """" A_Space
			 OpenFile(v, cmdfiles)
			 cmdfiles:=""
			}
		 else If (v.Method = "FileList")
			{
			 FileDelete, % TmpFileList
			 FileAppend, %list%, %TmpFileList%, UTF-8-RAW
			 OpenFile(v, TmpFileList)
			}
		 Else If (v.Method <> "Files")
			{
			 Loop, parse, list, `n
				{
				 If (A_LoopField = "")
					Continue
				 OpenFile(v,A_LoopField)
				}
			}
		}
	}

; Get a list of selected files using internal TC commands (see totalcmd.inc for references)
GetFiles()
	{
	 If WinActive("ahk_class TLister")
		{
		 WinGetActiveTitle, Files
		 Files:=RegExReplace(Files,"^.*\[(.*)\]","$1")
		 Return Files
		}
	 If WinActive("ahk_class TFindFile")
		{
		 ControlGet, Files, Choice,, TWidthListBox1, ahk_class TFindFile
		 If (ErrorLevel = 1) or (Files = "")
			ControlGet, Files, Choice,, LCLListbox2, ahk_class TFindFile
		 IfNotInString, Files,[ ; make sure you haven't selected a directory or the first line
			Return Files
		}
	 ClipboardSave:=ClipboardAll
	 Clipboard:=""
	 PostMessage 1075, 2018, 0, , ahk_class TTOTAL_CMD ; Copy names with full path to clipboard
	 Sleep 100
	 Files:=Clipboard
	 Clipboard:=ClipboardSave
	 ClipboardSave:=""
	 PostMessage 1075, 524, 0, , ahk_class TTOTAL_CMD  ; Unselect all (files+folders)
	 Return Files
	}

; Function to determine which method to use to open a file	
OpenFile(Editor,open)	
	{
	 func:=Editor.Method
	 title:="ahk_exe " Editor.Exe
	 If (func = "FileList")
		{
		 if !Normal(Editor.Exe,open,Editor.Delay,Editor.Parameters,Editor.StartDir) ; if GetInput() was cancelled don't process windowmode below
			Return open
		}
	 Else If IsFunc(func) ; takes care of drag & drop; cmdline
		{
		if !%func%(Editor.Exe,open,Editor.Delay,Editor.Parameters,Editor.StartDir)  ; if GetInput() was cancelled don't process windowmode below
			Return open
		}
	 If (Editor.windowmode = 1) ; normal (activate)
		{
		 WinWait, %title%
		 WinActivate, %title%
		}
	 Else If (Editor.windowmode = 2) ; maximize
		{
		 WinWait, %title%
		 WinMaximize, %title%
		}
	 Else If (Editor.windowmode = 3) ; minimize
		{
		 WinWait, %title%
		 WinMinimize, %title%
		}
	 Sleep % editor.open
	 Return open
	}

Normal(program,file,delay,parameters,startdir)
	{
	 ; Run, Target, WorkingDir, Max|Min|Hide
	 program:=GetTCCommander_Path(program)
	 execute:=1
	 GetInput(parameters,file,startdir,execute,program)
	 if !execute
	 	Return execute
	 if (file = "")
		Run, %program% %parameters%, %startdir%
	 else
		 Run, %program% %parameters% "%file%", %startdir%
	}

cmdline(program,file,delay,parameters,startdir)
	{
	 ; Run, Target, WorkingDir, Max|Min|Hide
	 program:=GetTCCommander_Path(program)
	 execute:=1
	 GetInput(parameters,file,startdir,execute,program)
	 if !execute
		Return
	 Run, %program% %parameters% %file%, %startdir%
	}

DragDrop(program,file,delay,parameters,startdir)
	{
	 ; Run, Target, WorkingDir, Max|Min|Hide
	 program:=GetTCCommander_Path(program)
	 title:="ahk_exe " program
	 IfWinNotExist, %title%
		{
		 Run, %program% %parameters% "%file%", %startdir%
		 ; in case there are more files to be processed we need the extra time after
		 ; first startup as some programs are sloooooow and we have to make sure it
		 ; can accept drag & drop files. It is is only for the first file in the list
		 Sleep %delay% 
		 Return 1
		}
	
	 If InStr(title,"Paint Shop Pro.exe") ; Annoying hack but seems to be required for PSP
		title=Jasc Paint Shop Pro 
	 DropFiles(file, title)
	 If (title = "Jasc Paint Shop Pro")
		WinActivate, % title
	 Return 1
	}

; Helper functions & Labels

GetInput(byref parameters, byref file, byref startdir, byref execute, program)
	{
	 WinGetActiveStats, A, W, H, X, Y 
	 X:=X+(W/2)-205
	 Y:=Y+(H/2)-110
	 if InStr(parameters,"?")
		{
		 AskParameters:=1
		 StringReplace, parameters, parameters, ?,, All
		}
	 if InStr(startdir,"?")
		{
		 AskStartDir:=1
		 StringReplace, startdir, startdir, ?,, All
		}
	 if InStr(parameters,"%p")
		parameters:=StrReplace(parameters,"%p",GetTCFields("%p"))
	 if InStr(parameters,"%t")
		parameters:=StrReplace(parameters,"%t",GetTCFields("%t"))
	 if InStr(parameters,"%o")
		parameters:=StrReplace(parameters,"%o",GetTCFields("%o",file))
	 if InStr(parameters,"%e")
		parameters:=StrReplace(parameters,"%e",GetTCFields("%e",file))
	 ; %f4? placeholders for optional parameters:
	 ; %f41 placeholder to alter position of filenames on the command line.
	 ; 
	 if InStr(parameters,"%f41")
	 	{
		 parameters:=StrReplace(parameters, "%f41", file)
		 file:=""
		}
	 if InStr(startdir,"%p")
		startdir:=StrReplace(startdir,"%p",GetTCFields("%p"))
	 if InStr(startdir,"%t")
		startdir:=StrReplace(startdir,"%t",GetTCFields("%t"))

	 if (AskParameters = 1) or (AskStartDir = 1)
		{
		 Gui, AskInput: +AlwaysOnTop +ToolWindow
		 Gui, AskInput: Margin, 5, 5
		 if (AskParameters = 1)
			{
			 Gui, AskInput:Add, Text, xp y5                       , Command line parameters:
			 Gui, AskInput:Add, Edit, xp yp+20 w400 h20           , %parameters%
		 	}
		 if (AskParameters <> 1) and (parameters <> "")
		 	{
			 Gui, AskInput:Add, Text, xp y58                       , Command line parameters:
			 Gui, AskInput:Add, Edit, xp yp+20 w400 h20 ReadOnly  , %parameters%
			}

;		 if (file <> "")
;			{
;			 Gui, AskInput:Add, Text, x5 yp+30                       , File(s):
;			 Gui, AskInput:Add, Edit, x5 yp+20 w400 h20              , %file%
;			}

		 if (AskStartDir = 1)
			{
			 Gui, AskInput:Add, Text, xp yp+30                    , Start directory:
			 Gui, AskInput:Add, Edit, xp yp+20 w400 h20           , %startdir%
			}
		 if (AskStartDir <> 1)  and (startdir <> "")
			{
			 Gui, AskInput:Add, Text, xp yp+30                    , Start directory:
			 Gui, AskInput:Add, Edit, xp yp+20 w400 h20 ReadOnly  , %startdir%
			}

;		 Gui, AskInput:Add, Text, x5 yp+30 w400 h20, Will run as:
;		 Gui, AskInput:Add, Edit, x5 yp+20 w400 h50 ReadOnly, %program% %parameters% %file%, %startdir%

		 Gui, AskInput:Add, Button, xp+110 yp+60 w100 h25 gAskInputOK Default, &OK
		 Gui, AskInput:Add, Button, xp+110 yp    w100 h25 gAskInputCancel, &Cancel
		 Gui, AskInput:Show, w410 x%X% y%Y%,F4MiniMenu Input
		}
		While (WinExist("F4MiniMenu Input ahk_class AutoHotkeyGUI"))
			{
			 Sleep 100
			}
		Return

		AskInputGuiEscape:
		AskInputGuiClose:
		AskInputCancel:
		Gui, AskInput:Destroy
		execute:=0
		Return

		AskInputOK:
		Gui, AskInput:Default
		GuiControlGet, parameters, , Edit1
;		GuiControlGet, file      , , Edit2
		GuiControlGet, startdir  , , Edit2 ; edit3 if file is uncommented above
		StringReplace, startdir, startdir,",,All ; remove quotes just to be sure
		Gui, AskInput:Destroy
		execute:=1
		Return

	}

CheckFile(list,file)
{
	 For k, v in list
		If (v = file)
			Return 1
	 Return 0
	} 
	
CountFiles(Files)
	{
	 StringReplace, Files, Files, `n, `n, UseErrorLevel
	 Return ErrorLevel+1
	}

GetTCFields(opt,file="")
	{
	 ; %P causes the source path to be inserted into the command line, including a backslash (\) at the end.
	 ; %T inserts the current target path. Especially useful for packers.
	 if (opt = "%p") or (opt = "%t")
		{
		 ; cm_CopySrcPathToClip=2029 ; Copy source path to clipboard
		 ; cm_CopyTrgPathToClip=2030 ; Copy target path to clipboard
		 ; % (panel = "%p") ? "source" : "target"
		 ClipSaveAll:=ClipboardAll
		 Clipboard:=""
		 SendMessage 1075, % (opt = "%p") ? 2029 : 2030, 0, , ahk_class TTOTAL_CMD
		 panel:=Clipboard "\"
		 Clipboard:=ClipSaveAll
		 Return panel
		}

	 ; %O places the current filename without extension into the command line.
	 ; %E places the current extension (without leading period) into the command line.
	 if (opt = "%o") or (opt = "%e")
		{
		 if InStr(file,""" """) ; we have multiple files so we need to parse them to get all names + ext
			{
			 StringReplace, file, file, " ",|, All
			 Loop, parse, % Trim(file,""""), |
				{
				 SplitPath, A_LoopField, , , OutExtension, OutNameNoExt
				 filenames .= """" OutNameNoExt """" A_Space
				 fileext .= """" OutExtension """" A_Space
				}
			}
		 else
			{
			 SplitPath, file, , , OutExtension, OutNameNoExt
			 filenames .= OutNameNoExt
			 fileext .= OutExtension
			}
		 Return % (opt = "%o") ? filenames : fileext
		}

	}

SetHotkeys:
Hotkey, IfWinActive, ahk_group TCF4Windows

; ~ native function will not be blocked 
; $ prefix forces the keyboard hook to be used to implement this hotkey

hk_prefix:="$"
;If (RegExMatch(MatchList.settings.ForegroundHotkey,"[\^\+\!\# \&]"))
;	hk_prefix:="~"
FGHKey:=MatchList.settings.ForegroundHotkey
StringReplace, FGHKey, FGHKey, &amp`;amp`;, & , All
StringReplace, FGHKey, FGHKey, &amp`;, &, All
If (InStr(FGHKey,"ESC"))
	hk_prefix:="~"

Hotkey, % hk_prefix FGHKey, ShowMenu, %HotKeyState%  ; %
; MsgBox % "Show Menu: " hk_prefix . FGHKey ; debug

hk_prefix:="$"
;If (RegExMatch(MatchList.settings.BackgroundHotkey,"[\^\+\!\# \&]")) ; for example if hotkey is Esc & F4 not adding the ~ would mean Esc is actually disabled in inplace rename (shift-f6) operations in a panel, or at least that is my experience.
;	hk_prefix:="~"
BGHKey:=MatchList.settings.BackgroundHotkey
StringReplace, BGHKey, BGHKey, &amp`;amp`;, & , All
StringReplace, BGHKey, BGHKey, &amp`;, &, All
If (InStr(BGHKey,"ESC"))
	hk_prefix:="~"

Hotkey, % hk_prefix . BGHKey, Process, %HotKeyState%  ; %
; MsgBox % "OpenItDirectly: " hk_prefix . BGHKey ; debug

Hotkey, IfWinActive
Return

SaveSettings:
If (A_ExitReason <> "Exit") ; to prevent saving it twice
	%F4Save%("MatchList", F4ConfigFile)
FileDelete, % TmpFileList
If (Error = 1)
	{
	 FileDelete, %F4ConfigFile%
	 Gosub, CreateNewConfig
	}

ExitApp
Return

; Used in ProcessFiles() - Technique from http://www.autohotkey.com/docs/scripts/MsgBoxButtonNames.htm	
ChangeButtonNames:
IfWinNotExist, Maximum files ahk_class #32770
	Return ; Keep waiting...
SetTimer, ChangeButtonNames, off
; WinActivate 
ControlSetText, Button2, Process All, Maximum files ahk_class #32770
ControlSetText, Button3, Stop at Max., Maximum files ahk_class #32770
Return

GetAllExtensions:
AllExtensions:=""
; Loop % MatchList.MaxIndex() ; %
for k, v in MatchList
	AllExtensions .= v.ext ","
AllExtensions:=Trim(AllExtensions,",")
AllExtensions:=RegExExtensions(AllExtensions)
Return

CreateNewConfig:
if InStr(F4ConfigFile,"xml")
{
FileDelete, F4MiniMenu.xml
FileAppend,
(
<?xml version="1.0" encoding="UTF-8"?>
<MatchList>
	<Invalid_Name id="settings" ahk="True">
		<BackgroundHotkey>F4</BackgroundHotkey>
		<ForegroundHotkey>Esc & F4</ForegroundHotkey>
		<MaxFiles>30</MaxFiles>
		<MenuPos>3</MenuPos>
		<TCPath>c:\totalcmd\TotalCmd.exe</TCPath>
		<TCStart>1</TCStart>
	</Invalid_Name>
	<Invalid_Name id="1" ahk="True">
		<Exe>c:\WINDOWS\notepad.exe</Exe>
		<Ext>txt,xml</Ext>
		<Method>Normal</Method>
		<WindowMode>1</WindowMode>
	</Invalid_Name>
</MatchList>
), F4MiniMenu.xml, UTF-8
}
else ; INI
{
FileDelete, F4MiniMenu.ini
FileAppend,
(
[settings]
BackgroundHotkey=F4
ForegroundHotkey=Esc & F4
MaxFiles=30
MenuPos=3
TCPath=c:\totalcmd\TotalCmd.exe
TCStart=1
[1]
delay=0
exe=c:\WINDOWS\notepad.exe
ext=txt,xml
method=Normal
windowmode=1
), F4MiniMenu.ini
}
Return


; Check DocumentTemplates\ - this setting can be used in F4TCIE.ahk (not required)
DocumentTemplatesScan:
If (FileExist(A_ScriptDir "\DocumentTemplates\") = "D")
	{
	 Loop, %A_ScriptDir%\DocumentTemplates\template.*
		{
		 SplitPath, A_LoopFileName, , , TemplatesOutExtension
		 templatesExt .= TemplatesOutExtension ","
		}
	 MatchList.Settings["templatesExt"]:=Trim(templatesExt,",")
	 TemplatesOutExtension:=""
	 templatesExt:=""
	 %F4Save%("MatchList", F4ConfigFile)
	}
Return

; Includes

#include %A_ScriptDir%\inc\Menu.ahk
#include %A_ScriptDir%\inc\Settings.ahk
#include %A_ScriptDir%\inc\Editors.ahk
#include %A_ScriptDir%\inc\HelperFunctions.ahk ; shared with F4TCIE
#include %A_ScriptDir%\lib\XA.ahk              ; shared with F4TCIE
#include %A_ScriptDir%\lib\iob.ahk             ; shared with F4TCIE
#include %A_ScriptDir%\lib\class_lv_rows.ahk
#include %A_ScriptDir%\lib\DropFiles.ahk
#include %A_ScriptDir%\lib\GetPos.ahk
