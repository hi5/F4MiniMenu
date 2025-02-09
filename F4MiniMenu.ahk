/*

Script      : F4MiniMenu.ahk for Total Commander - AutoHotkey 1.1+ (Ansi and Unicode)
Version     : v1.46
Author      : hi5
Last update : 09 February 2025
Purpose     : Minimalistic clone of the F4 Menu program for Total Commander (open selected files in editor(s))
Source      : https://github.com/hi5/F4MiniMenu

Note        : ; % used to resolve syntax highlighting feature bug of N++

*/

#Requires AutoHotkey v1.1.31+
#SingleInstance, Force
#UseHook
#NoEnv
SetBatchlines, -1
SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, 2
; Setup variables, menu, hotkeys etc

F4Version:="v1.46"

; <for compiled scripts>
;@Ahk2Exe-SetFileVersion 1.46
;@Ahk2Exe-SetProductName F4MiniMenu
;@Ahk2Exe-SetDescription F4MiniMenu: Open files from TC
;@Ahk2Exe-SetProductVersion Compiled with AutoHotkey v%A_AhkVersion%
;@Ahk2Exe-SetCopyright MIT License - (c) https://github.com/hi5
; </for compiled scripts>

; <for compiled scripts>
IfNotExist, %A_ScriptDir%\res
	FileCreateDir, %A_ScriptDir%\res
FileInstall, res\f4.ico, %A_ScriptDir%\res\f4.ico
; </for compiled scripts>

global AllExtensions:=""
global TmpFileList:=""
global Commander_Path:=""
global Commander_Ini:=""
MatchList:=""
MenuPadding:="   "
DefaultShortName:=""

EnvGet, TmpFileList, temp

If (TmpFileList = "")
	TmpFileList:=A_ScriptDir

TmpFileList .= "\$$f4mtmplist$$.m3u"

; shared with F4TCIE
#Include %A_ScriptDir%\inc\LoadSettings1.ahk

GroupAdd, TCOnly, ahk_class TTOTAL_CMD ahk_exe TOTALCMD.EXE
GroupAdd, TCOnly, ahk_class TTOTAL_CMD ahk_exe TOTALCMD64.EXE

FileDelete, % TmpFileList

Try
	Menu, tray, icon, res\f4.ico
Menu, tray, Tip , F4MiniMenu - %F4Version%
Menu, tray, NoStandard
Menu, tray, Add, F4MiniMenu - %F4Version%, DoubleTrayClick
Try
	Menu, tray, icon, F4MiniMenu - %F4Version%, res\f4.ico
Menu, tray, Default, F4MiniMenu - %F4Version%
Menu, tray, Click, 1 ; this will show the tray menu because we send {rbutton} at the DoubleTrayClick label
Menu, tray, Add,
Menu, tray, Add, &Open,                   MenuHandler
Menu, tray, Add, &Reload this script,     MenuHandler
Menu, tray, Icon,&Reload this script,     shell32.dll, 239

Menu, tray, Add, &Edit this script,       MenuHandler
Try
	Menu, tray, Icon,&Edit this script,   comres.dll, 7
If A_IsCompiled
	Menu, tray, Disable, &Edit this script

Menu, tray, Add,
Menu, tray, Add, &Suspend Hotkeys,        MenuHandler
Try
	Menu, tray, Icon,&Suspend Hotkeys,    %A_AhkPath%, 3
Menu, tray, Add, &Pause Script,           MenuHandler
Try
	Menu, tray, Icon,&Pause Script,       %A_AhkPath%, 4
Menu, tray, Add,
Menu, tray, Add, Settings,                Settings
Try
	Menu, tray, Icon, Settings,           shell32.dll, 170
Menu, tray, Add, Configure editors,       ConfigEditors
Try
	Menu, tray, Icon, Configure Editors,  shell32.dll, 70
Menu, tray, Add, Scan Document Templates, DocumentTemplatesScan
Try
	Menu, tray, Icon, Scan Document Templates, shell32.dll, 172
Menu, tray, Add,
Menu, tray, Add, Exit,                    ExitSettings
Try
	Menu, tray, Icon, Exit,               shell32.dll, 132

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

; Hotkey groups (menus)
GroupAdd, TCF4Windows, ahk_class TTOTAL_CMD ahk_exe TOTALCMD.EXE
GroupAdd, TCF4Windows, ahk_class TTOTAL_CMD ahk_exe TOTALCMD64.EXE
GroupAdd, TCF4Windows, ahk_class TQUICKSEARCH

If MatchList.settings.Lister
	GroupAdd, TCF4Windows, ahk_class TLister
If MatchList.settings.FindFiles
	GroupAdd, TCF4Windows, ahk_class TFindFile


; Add other file managers if any
If MatchList.settings.Explorer
	{
	 GroupAdd, TCF4Windows, ahk_class CabinetWClass
	 GroupAdd, TCF4Windows, ahk_class ExploreWClass
	}

If MatchList.settings.Everything
	{
	 GroupAdd, TCF4Windows, ahk_exe Everything.exe
	 GroupAdd, TCF4Windows, ahk_exe Everything64.exe
	}

If (MatchList.settings.DoubleCommander <> "") ; note that some versions of DC report ahk_class TTOTAL_CMD ahk_exe doublecmd.exe
	{
	 GroupAdd, TCF4Windows, ahk_class DClass ahk_exe doublecmd.exe     ; v0.9
	 GroupAdd, TCF4Windows, ahk_class TTOTAL_CMD ahk_exe doublecmd.exe ; v1.0
	}

If (MatchList.settings.XYPlorer <> "")
	{
	 GroupAdd, TCF4Windows, ahk_exe XYPlorer.exe
	 GroupAdd, TCF4Windows, ahk_exe XYPlorerFree.exe
	}

If (MatchList.settings.QDir <> "")
	{
	 GroupAdd, TCF4Windows, ahk_exe Q-Dir.exe
	 GroupAdd, TCF4Windows, ahk_exe Q-Dir_x64.exe
	}

; /Add other file managers if any

If (MatchList.settings.TCStart = 2) and !WinExist("ahk_class TTOTAL_CMD")
	{
	 If FileExist(MatchList.settings.TCPath)
		Run % MatchList.settings.TCPath,,UseErrorLevel,TCOutputVarPID ; %
	 WinWait, ahk_class TTOTAL_CMD
	}

If (MatchList.settings.TCStart = 3)
	{
	 If FileExist(MatchList.settings.TCPath)
		Run % MatchList.settings.TCPath,,UseErrorLevel,TCOutputVarPID ; %
	 WinWait, ahk_class TTOTAL_CMD
	}

#Include %A_ScriptDir%\inc\CLIParser.ahk


; shared with F4MM
#Include %A_ScriptDir%\inc\TotalCommanderPath.ahk

Gosub, DocumentTemplatesScan

Gosub, BuildMenu

; Build master list to quickly open in default program if not found
Gosub, GetAllExtensions

HotKeyState:="On"
Gosub, SetHotkeys

; Clear tmp file(s)
OnExit, ExitSettings

If CLI_Editors
	{
	 Gosub, ConfigEditors
	 WinWaitClose, F4MiniMenu - Editor Settings ahk_class AutoHotkeyGUI
	 Sleep 1000
	 ExitApp
	}

If CLI_Settings
	{
	 Gosub, Settings
	 WinWaitClose, F4MiniMenu - Settings ahk_class AutoHotkeyGUI
	 Sleep 1000
	 ExitApp
	}

If CLI_ShowMenu
	{
	 Gosub, ShowMenu
	 Sleep 1000
	 ExitApp
	}

If CLI_FilteredMenu
	{
	 Gosub, FilteredMenu
	 Sleep 1000
	 ExitApp
	}

If CLI_Exit and ((CLI_ShowMenu <> 1) and (CLI_FilteredMenu <> 1))
	{
	 Gosub, Process
	 Sleep 1000
	 MsgBox
	 ExitApp
	}

; End of Auto-execute section
If (Matchlist.settings.F4MMCloseAll = 1)
	{
	 WinWaitClose, ahk_class TTOTAL_CMD
	 ExitApp
	}
Else If (Matchlist.settings.F4MMClosePID = 1)
	{
	 Sleep 5000
	 WinWaitClose, ahk_pid %TCOutputVarPID%
	 ExitApp
	}
Return

Process:
ProcessFiles(MatchList)
MatchList.Temp.Files:="",MatchList.Temp.SelectedExtensions:="",MatchList.Delete("Temp")
If CLI_Exit
	ExitApp
Return

; Function executed by background hotkey (open directly)
ProcessFiles(MatchList, SelectedEditor = "-1")
	{
	 Global ArchiveExtentions
	 Done:=[]
	 Stop:=0
	 If (MatchList.Temp.Files = "")
		Files:=GetFiles() ; Get list of selected files in TC, one per line
	 else
		Files:=MatchList.Temp.Files
	 MatchList.Temp.Files:=""

		 ; Check if we possibly have selected file(s) from an archive
		 If RegExMatch(Files,"iUm)" ArchiveExtentions)
			{
			 Files:=StrReplace(Files,"`r","")
			 If InStr(Files,"`n")
				Check:=SubStr(Files,1,InStr(Files,"`n")-1)
			 Else
				Check:=Files

			 If WinActive("ahk_class TTOTAL_CMD ahk_exe TOTALCMD.EXE") or WinActive("ahk_class TTOTAL_CMD ahk_exe TOTALCMD64.EXE")
				{
				 IfNotExist, %check% ; additional check, if the file is from an archive it won't exist
					{                ; therefore we resort to the internal TC Edit command - added for v0.51
					 SendMessage 1075, 904, 0, , ahk_class TTOTAL_CMD ; Edit (Notepad)
					 Return
					}
				}

			 If MatchList.settings.DoubleCommander and DoubleCommander_Active()
				{
				 IfNotExist, %check% ; additional check, if the file is from an archive it won't exist
					{                ; therefore we resort to sending enter, now user can choose what to do (close or edit using default program)
					 Send {enter}
					 Return
					}
				}

			 If MatchList.settings.Explorer and Explorer_Active()
				{
				 IfNotExist, %check% ; additional check, if the file is from an archive it won't exist
					{                ; don't allow it and return for Explorer
					 MsgBox, 16, F4MiniMenu, You can not edit files from Archives when using Explorer.
					 Return
					}
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

		 ; TODO: check for "checked" (= active) editor from settings
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
				cmdfiles .= """" A_LoopField """" A_Space                ; " fix highlighting
			 OpenFile(v, cmdfiles, MatchList.Settings.MaxWinWaitSec)
			 If MatchList.Settings.log
				Log(A_Now " : cmdline -> " v.exe "|" cmdfiles "|" MatchList.Settings.MaxWinWaitSec,MatchList.Settings.logFile)
			 cmdfiles:=""
			}
		 else If (v.Method = "FileList")
			{
			 FileDelete, % TmpFileList
			 FileAppend, %list%, %TmpFileList%, UTF-8-RAW
			 OpenFile(v, TmpFileList, MatchList.Settings.MaxWinWaitSec)
			 If MatchList.Settings.log
				Log(A_Now " :  FileList -> " v.exe "|" TmpFileList "|" MatchList.Settings.MaxWinWaitSec,MatchList.Settings.logFile)
			}
		 Else If (v.Method <> "Files")
			{
			 Loop, parse, list, `n
				{
				 If (A_LoopField = "")
					Continue
				 OpenFile(v, A_LoopField, MatchList.Settings.MaxWinWaitSec)
				 If MatchList.Settings.log
					Log("`n" A_Now " : Files  -> " v.exe "|" A_LoopField "|" MatchList.Settings.MaxWinWaitSec,MatchList.Settings.logFile)
				}
			}
		}
	 PostMessage 1075, 524, 0, , ahk_class TTOTAL_CMD  ; Unselect all (files+folders)
	}

; Get a list of extensions from selected files we can use to build filtered menu
GetExt(Files)
	{
	 Global MatchList
	 Loop, parse, files, `n, `r
		{
		 SplitPath, A_LoopField,,, OutExtension
		 Ext .= OutExtension "|"
		}
	 MatchList.Temp["SelectedExtensions"]:=Trim(Ext,"|")
	}

; Process other applications and windows first (find files, lister)
; Get a list of selected files using internal TC commands (see totalcmd.inc for references)
GetFiles()
	{
	 Global MatchList, CLI_Exit, CLI_File, ListerWindowClose

	 If CLI_Exit
		{
		 FileRead, Files, %CLI_File%
		 MatchList.Temp["Files"]:=Files
		 Return Files
		}

	 If MatchList.settings.Explorer and Explorer_Active()
		{
		 Files:=Explorer_GetSelection()
		 MatchList.Temp["Files"]:=Files
		 Return Files
		}

	 If MatchList.settings.Everything and Everything_Active()
		{
		 Files:=Everything_GetSelection()
		 MatchList.Temp["Files"]:=Files
		 Return Files
		}

	 If MatchList.settings.DoubleCommander and DoubleCommander_Active()
		{
		 Files:=DoubleCommander_GetSelection()
		 MatchList.Temp["Files"]:=Files
		 Return Files
		}

	 If MatchList.settings.XYPlorer and XYPlorer_Active()
		{
		 Files:=XYPlorer_GetSelection()
		 MatchList.Temp["Files"]:=Files
		 Return Files
		}

	 If MatchList.settings.QDir and QDir_Active()
		{
		 Files:=QDir_GetSelection()
		 MatchList.Temp["Files"]:=Files
		 Return Files
		}

	 If WinActive("ahk_class TLister")
		{
		 WinGetActiveTitle, Files
		 ; check once if ListerWindowClose was already read in case F4MM was started before TC
		 ; to obtain environment variable Commander_Ini_Path) and read value from wincmd.ini
		 If (ListerWindowClose = "") or (ListerWindowClose = "ERROR")
			ListerWindowClose()
		 Files:=RegExReplace(Files,"U)^.*\[(.*).$","$1")
		 If ListerWindowClose in 2,3
			WinClose, A
		 Return Files
		}

	 If MatchList.settings.QuickView
		{
		 WinGetText, Files, ahk_class TTOTAL_CMD, Lister
		 If (Files <> "")
			{
			 RegExMatch(Files,"U) - \K\[(.*)\]`r?`n",Files)
			 Return Files1
			}
		}

	 If WinActive("ahk_class TFindFile") ; class names may change between versions, below for TC11
		{
		 ; ControlGet, Files, Choice,, TWidthListBox1, ahk_class TFindFile;  for TC10
		 ControlGet, Files, Choice,, TMyListBox2, ahk_class TFindFile
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
;	 PostMessage 1075, 524, 0, , ahk_class TTOTAL_CMD  ; Unselect all (files+folders)
	 MatchList.Temp["Files"]:=Files
	 Return Files
	}

; Function to determine which method to use to open a file
; normal:    filepath\file1.ext
; cmdline:   "filepath\file1.ext" "filepath\file2.ext" "filepath\file3.ext"
; filelist:  %temp%\$$f4mtmplist$$.m3u OR %A_ScriptDir%\$$f4mtmplist$$.m3u
; drag&drop: filepath\file1.ext
OpenFile(Editor,open,MaxWinWaitSec=2)
	{
	 If (MaxWinWaitSec = "") or (MaxWinWaitSec < 2) or (MaxWinWaitSec = "ERROR")
		MaxWinWaitSec:=2
	 func:=Editor.Method
	 title:="ahk_exe " Editor.Exe
	 If (func = "FileList")
		{
		 ; if GetInput() was cancelled don't process windowmode below
		 result:=Normal(Editor.Exe,open,Editor.Delay,Editor.Parameters,Editor.StartDir)
		}
	 Else If IsFunc(func) ; takes care of normal, drag & drop, and cmdline
		{
		 ; if GetInput() was cancelled don't process windowmode below
		 result:=%func%(Editor.Exe,open,Editor.Delay,Editor.Parameters,Editor.StartDir)
		}

	 ; Moved above window actions in v1.1
	 ; Added WinExist check to give program some time to start first
	 ; before proceeding - similar to Delay
	 If !WinExist(title)
		Sleep % Editor.open

	 ; Program was started so we can continue.
	 ; Result can be > 1 if defined program was not found
	 ; and we resorted to default editor as a fall back, see normal()
	 if (result = 1)
		{
		 If (Editor.windowmode = 1) ; normal (activate)
			{
			 WinWait, %title%,, % MaxWinWaitSec
			 WinActivate, %title%
			}
		 Else If (Editor.windowmode = 2) ; maximize
			{
			 WinWait, %title%,, % MaxWinWaitSec
			 WinMaximize, %title%
			}
		 Else If (Editor.windowmode = 3) ; minimize
			{
			 WinWait, %title%,, % MaxWinWaitSec
			 WinMinimize, %title%
			}
		}

;@Ahk2Exe-IgnoreBegin
	 #include *i %A_ScriptDir%\inc\WinActivatePrivateRules.ahk
;@Ahk2Exe-IgnoreEnd

	 Return open
	}

Normal(program,file,delay,parameters,startdir)
	{
	 ; Run, Target, WorkingDir, Max|Min|Hide
	 Global MatchList
	 ;program:=GetTCCommander_Path(program)
	 program:=GetPath(program)
	 execute:=1
	 GetInput(parameters,file,startdir,execute,program)
	 if !execute
		Return execute
	 startdir:=GetPath(startdir)
	 if (file = "")
		Try
		 {
			Run, %program% %parameters%, %startdir%
		 }
		Catch
			{
			 ;program:=GetTCCommander_Path(MatchList[1].Exe)
			 program:=GetPath(MatchList[1].Exe)
			 startdir:=GetPath(startdir)
			 Run, %program% %parameters%, %startdir%
			 execute++
			}
	 else
		Try
			{
			 if (file <> "")
				Run, %program% %parameters% "%file%", %startdir%
			 else
				Run, %program% %parameters%, %startdir%
			}
		Catch
			{
			 ;program:=GetTCCommander_Path(MatchList[1].Exe)
			 program:=GetPath(MatchList[1].Exe)
			 startdir:=GetPath(startdir)
			 Run, %program% %parameters% "%file%", %startdir%
			 ; OSDTIP_Pop(MainText, SubText, TimeOut, Options, FontName, Transparency)
			 OSDTIP_Pop("F4MiniMenu", "Defined editor/program not found`nReverting to default editor", -750,"W230 H80 U1")
			 execute++
			}
	 Return execute
	}

cmdline(program,file,delay,parameters,startdir)
	{
	 ; Run, Target, WorkingDir, Max|Min|Hide
	 ;program:=GetTCCommander_Path(program)
	 program:=GetPath(program)
	 execute:=1
	 GetInput(parameters,file,startdir,execute,program)
	 if !execute
		Return execute
	 startdir:=GetPath(startdir)
	 Run, %program% %parameters% %file%, %startdir%
	 Return execute
	}

DragDrop(program,file,delay,parameters,startdir)
	{
	 ; Run, Target, WorkingDir, Max|Min|Hide
	 ;program:=GetTCCommander_Path(program)
	 program:=GetPath(program)
	 title:="ahk_exe " program
	 IfWinNotExist, %title%
		{
		 startdir:=GetPath(startdir)
		 Run, %program% %parameters% "%file%", %startdir%
		 ; in case there are more files to be processed we need the extra time after
		 ; first startup as some programs are sloooooow and we have to make sure it
		 ; can accept drag & drop files. It is is only for the first file in the list
		 Sleep %delay%
		 Return 1
		}

;@Ahk2Exe-IgnoreBegin
	 #include *i %A_ScriptDir%\inc\DragDropPrivateRules.ahk
;@Ahk2Exe-IgnoreEnd

	 Return 1
	}

; Helper functions & Labels

CheckCmdLine(Method,CountFiles)
	{
	 If (Method <> "cmdline")
		Return 1
	 StrReplace(CountFiles, Chr(34) A_Space Chr(34), , OutputVarCount)
	 If (OutputVarCount > 1)
		Return 0
	 Return 1
	}

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
	 if InStr(parameters,"%n")
		parameters:=StrReplace(parameters,"%n",GetTCFields("%n",file))
	 if InStr(parameters,"%m")
		parameters:=StrReplace(parameters,"%m",GetTCFields("%m",file))
	 if InStr(parameters,"%$date")
		{
		 DateTimeObject:=GetTCFields(parameters)
		 parameters:=StrReplace(parameters,DateTimeObject[1],DateTimeObject[2])
		 DateTimeObject:=""
		}

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
		StringReplace, startdir, startdir,",,All ; remove quotes just to be sure ;"
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

	 ; first we deal with non TC

	 if MatchList.settings.Explorer or MatchList.settings.XYPlorer or MatchList.settings.QDir or MatchList.settings.Everything
		{
		 if (opt = "%p") or (opt = "%t")
			{
			 SplitPath, file, , OutDir ; panel
			 Return OutDir
			}
		}

	 ; SP = Source Path, TP = Target Path
	 if (opt = "%p") or (opt = "%t")
		{
		 /*
		 ; cm_CopySrcPathToClip=2029 ; Copy source path to clipboard
		 ; cm_CopyTrgPathToClip=2030 ; Copy target path to clipboard
		 ; % (panel = "%p") ? "source" : "target"
		 ClipSaveAll:=ClipboardAll
		 Clipboard:=""
		 SendMessage 1075, % (opt = "%p") ? 2029 : 2030, 0, , ahk_class TTOTAL_CMD
		 panel:=Clipboard "\"
		 Clipboard:=ClipSaveAll
		 */
		 panel:=TC_SendData((opt = "%p") ? "SP" : "TP")
		 Return panel
		}

	 ; SN = Source Name Caret, TN = Target Name Caret
	 if (opt = "%n") or (opt = "%m")
		{
		 NameCaret:=TC_SendData((opt = "%n") ? "SN" : "TN")
		 Return NameCaret
		}


	 ; %O places the current filename without extension into the command line.
	 ; %E places the current extension (without leading period) into the command line.
	 if (opt = "%o") or (opt = "%e")
		{
		 if InStr(file,""" """) ; we have multiple files so we need to parse them to get all names + ext
			{
			 StringReplace, file, file, " ",|, All
			 Loop, parse, % Trim(file,""""), |             ; """ fix for highlighting issue in editor
				{
				 SplitPath, A_LoopField, , , OutExtension, OutNameNoExt
				 filenames .= """" OutNameNoExt """" A_Space ; " fix for highlighting issue in editor
				 fileext .= """" OutExtension """" A_Space   ; " fix for highlighting issue in editor
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

	 if InStr(opt, "%$date")
		{

		 /* TC HELP

		 %$DATE% Inserts the 24 hour date and time in the form YYYYMMDDhhmmss -> A_Now in AutoHotkey

		 %$DATE:placeholders%
		 Inserts the date in the form specified by placeholders.
		 Same as in multi-rename tool:                           -> AHK
		 y Paste year in 2 digit form                            -> yy
		 Y Paste year in 4 digit form                            -> yyyy
		 M Paste month, always 2 digit                           -> MM
		 D Paste day, always 2 digit                             -> dd
		 h Paste hours, always in 24 hour 2 digit format (0-23)  -> H
		 H Paste hours, always in 12 hour 2 digit format (1-12)  -> hh
		 i1 same but 1 character a/p only                        -> t
		 i am/pm indicator in English                            -> tt
		 m Paste minutes, always in 2 digit format               -> mm
		 s Paste seconds, always in 2 digit format               -> ss
		 any non-alpha character like a dot or dash will be added directly

		 F4MM addition: |value|timeunit

		 */

		 DateTimeObject:=[]

		 ; output entire string, output1 time formatting options
		 RegExMatch(opt,"Ui)%\$date:*([^%]*)%",output)

		 if (output = "%$DATE%")
			{
			 FormatTime, DateTime, , %A_Now%
			 DateTimeObject[1]:="%$DATE%"
			 DateTimeObject[2]:=DateTime
			 return % DateTimeObject
			}
		 else ; output1 -> we have placeholders
			{
			 OutputData:=StrSplit(output1,"|")
			 ; 1 placeholder, 2 value, 3 time units
			 ; the order in which we process the format is important (y before Y, h-zzzzz-H, i1 before i)
			 OutputData[1]:=RegExReplace(OutputData[1],"y","yy")
			 OutputData[1]:=RegExReplace(OutputData[1],"Y","yyyy")
			 OutputData[1]:=RegExReplace(OutputData[1],"M","MM")
			 OutputData[1]:=RegExReplace(OutputData[1],"D","dd")
			 OutputData[1]:=RegExReplace(OutputData[1],"h","zzzzz")  ; we need to swap lower case h for temp char z
			 OutputData[1]:=RegExReplace(OutputData[1],"H","hh")     ; we we can safely process H hh conversion
			 OutputData[1]:=RegExReplace(OutputData[1],"zzzzz","H")  ; and now use char z for h->H conversion
			 OutputData[1]:=RegExReplace(OutputData[1],"i1","t")
			 OutputData[1]:=RegExReplace(OutputData[1],"i","tt")
			 OutputData[1]:=RegExReplace(OutputData[1],"m","mm")
			 OutputData[1]:=RegExReplace(OutputData[1],"s","ss")
			 DateTimeFormat:=OutputData[1]

			 FormatTime, DateTime,, yyyyMMddHHmmss
			 EnvAdd, DateTime, % OutputData[2], % OutputData[3] ; do math if any
			 FormatTime, DateTime, %DateTime%, %DateTimeFormat% ; format the time
			 DateTimeObject[1]:=output
			 DateTimeObject[2]:=DateTime
			 return % DateTimeObject
			}
	 }
	}

SetHotkeys:

Hotkey, IfWinActive, ahk_group TCONLY

;If MatchList.settings.EVDirTree
;	Hotkey, % MatchList.settings.EVDirTree, Everything_DirectoryTree, %HotKeyState%  ; %

Hotkey, IfWinActive,

Hotkey, IfWinActive, ahk_group TCF4Windows

; ~ native function will not be blocked
; $ prefix forces the keyboard hook to be used to implement this hotkey

If (MatchList.settings.ForegroundHotkey <> "ERROR") and (MatchList.settings.ForegroundHotkey <> "")
	{
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
	}

If (MatchList.settings.BackgroundHotkey <> "ERROR") and (MatchList.settings.BackgroundHotkey <> "")
	{
	 hk_prefix:="$"
	 ;If (RegExMatch(MatchList.settings.BackgroundHotkey,"[\^\+\!\# \&]")) ; for example if hotkey is Esc & F4 not adding the ~ would mean Esc is actually disabled in "in place rename" (shift-f6) operations in a panel, or at least that is my experience.
	 ;	hk_prefix:="~"
	 BGHKey:=MatchList.settings.BackgroundHotkey
	 StringReplace, BGHKey, BGHKey, &amp`;amp`;, & , All
	 StringReplace, BGHKey, BGHKey, &amp`;, &, All
	 If (InStr(BGHKey,"ESC"))
		hk_prefix:="~"

	 Hotkey, % hk_prefix BGHKey, Process, %HotKeyState%  ; %
	 ; MsgBox % "OpenItDirectly: " hk_prefix . BGHKey ; debug
	}

If (MatchList.settings.FilteredHotkey <> "ERROR") and (MatchList.settings.FilteredHotkey <> "")
	{
	 hk_prefix:="$"
	 TMHKey:=MatchList.settings.FilteredHotkey
	 StringReplace, TMHKey, TMHKey, &amp`;amp`;, & , All
	 StringReplace, TMHKey, TMHKey, &amp`;, &, All
	 If (InStr(TMHKey,"ESC"))
		hk_prefix:="~"

	 Hotkey, % hk_prefix . TMHKey, FilteredMenu, %HotKeyState%  ; %
	}

If (InStr(FGHKey BGHKey TMHKey,"Esc"))
	EscHotkeys:=1

Hotkey, IfWinActive
Return

#If EscHotkeys and MatchList.settings.Everything and Everything_Active()
$Esc::
if (A_PriorHotkey <> "$Esc" or A_TimeSincePriorHotkey > 400)
	{
	 Keywait Esc
	 Return
	}
Else
	WinClose ahk_exe everything.exe
Return
#If

#If MatchList.settings.Everything and Everything_Active()

Enter:: ; open in source panel/tab
TCCD(MatchList.settings.TCPath," /O /S ",Everything_GetSelection(dir="1"))
Return

^Enter:: ; open in source panel, new tab foreground
TCCD(MatchList.settings.TCPath," /O /S /T ",Everything_GetSelection(dir="1"))
Return

^+Enter:: ; open in source panel, new tab background
TCCD(MatchList.settings.TCPath," /O /S /B",Everything_GetSelection(dir="1"))
Return

!Enter:: ; open in target panel/tab
TCCD(MatchList.settings.TCPath," /O /S /R=",Everything_GetSelection(dir="1"))
Return

!^Enter:: ; open in target panel, new tab foreground
TCCD(MatchList.settings.TCPath," /O /S /T /R=",Everything_GetSelection(dir="1"))
Return

!+Enter:: ; open in target panel, new tab background
TCCD(MatchList.settings.TCPath," /O /S /B /R=",Everything_GetSelection(dir="1"))
Return

#If

TCCD(tc,par,dir)
	{
	 WinClose ahk_exe everything.exe
	 If !InStr(par,"/R=")
		Run, %tc% %par% "%dir%\"
	 Else
		Run, %tc% %par%"%dir%\"
	}

SaveSettings:
MatchList.Temp.Files:="",MatchList.Temp.SelectedExtensions:="",MatchList.Delete("Temp")
%F4Save%("MatchList", F4ConfigFile)
FileDelete, % TmpFileList
Return

ExitSettings:
FileDelete, % TmpFileList
If CLI_MenuPos
	MatchList.settings.MenuPos:=CLI_MenuPos

If (Error = 1) ; we can't read settings so create a new clean version
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
		<FilteredHotkey></FilteredHotkey>
		<FilteredMenuAutoEdit>1</FilteredMenuAutoEdit>
		<MaxFiles>30</MaxFiles>
		<MenuPos>3</MenuPos>
		<TCPath>c:\totalcmd\TotalCmd.exe</TCPath>
		<TCIniPath></TCIniPath>
		<TCStart>1</TCStart>
		<F4MMCloseAll>0</F4MMCloseAll>
		<F4MMClosePID>0</F4MMClosePID>
		<FullMenu>z</FullMenu>
		<Explorer>0</Explorer>
		<Everything>0</Everything>
		<MaxWinWaitSec>2</MaxWinWaitSec>
		<Lister>1</Lister>
		<FindFiles>1</FindFiles>
		<QuickView>1</QuickView>
		<log>0</log>
		<logfile>%A_ScriptDir%\logfile.txt</logfile>
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
FilteredHotkey=
MaxFiles=30
MenuPos=3
FilteredMenuAutoEdit=1
TCPath=c:\totalcmd\TotalCmd.exe
TCStart=1
TCIniPath=
F4MMCloseAll=0
F4MMClosePID=0
FullMenu=z
Explorer=0
Everything=0
MaxWinWaitSec=2
Lister=1
FindFiles=1
QuickView=1
log=0
logfile=%A_ScriptDir%\logfile.txt
[1]
delay=0
exe=c:\WINDOWS\notepad.exe
ext=txt,xml
method=Normal
windowmode=1
), F4MiniMenu.ini, UTF-16
}
Return


; Check DocumentTemplates\ - this setting can be used in F4TCIE.ahk (not required)
DocumentTemplatesScan:
If (FileExist(A_ScriptDir "\DocumentTemplates\") = "D") ;               " fix highlighting
	{
	 templatesExtBeforeScan:=MatchList.Settings["templatesExt"]
	 Loop, %A_ScriptDir%\DocumentTemplates\template.*
		{
		 SplitPath, A_LoopFileName, , , TemplatesOutExtension
		 templatesExt .= TemplatesOutExtension ","
		}
	 ; only update when its has been changed
	 If (templatesExtBeforeScan <> Trim(templatesExt,","))
		{
		 MatchList.Settings["templatesExt"]:=Trim(templatesExt,",")
		 %F4Save%("MatchList", F4ConfigFile)
		}
	 templatesExt:="",TemplatesOutExtension:="",templatesExtBeforeScan:=""
	}
Return

; Includes

#include %A_ScriptDir%\inc\Menu.ahk
#include %A_ScriptDir%\inc\FilteredMenu.ahk
#include %A_ScriptDir%\inc\Settings.ahk
#include %A_ScriptDir%\inc\Editors.ahk
#include %A_ScriptDir%\inc\HelperFunctions.ahk ; shared with F4TCIE
#include %A_ScriptDir%\lib\XA.ahk              ; shared with F4TCIE
#include %A_ScriptDir%\lib\iob.ahk             ; shared with F4TCIE
#include %A_ScriptDir%\lib\class_lv_rows.ahk
#include %A_ScriptDir%\lib\DropFiles.ahk
#include %A_ScriptDir%\lib\GetPos.ahk
#include %A_ScriptDir%\lib\dpi.ahk
#include %A_ScriptDir%\lib\tc.ahk              ; wm_copydata
#include %A_ScriptDir%\lib\log.ahk

;@Ahk2Exe-IgnoreBegin
	#include *i %A_ScriptDir%\..\ButtonBarKeyboard\ButtonBarKeyboard.ahk
;@Ahk2Exe-IgnoreEnd
