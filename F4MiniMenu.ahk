/*

Script      : F4MiniMenu.ahk for Total Commander - AutoHotkey 1.1+ (Ansi)
Version     : 0.4
Author      : hi5
Last update : 17 Nov 2012
Purpose     : Minimalistic clone of the F4 Menu program for Total Commander (open selected files in editor(s))
Source      : https://github.com/hi5/F4MiniMenu

Note        : ; % used to resolve syntax highlighting feature bug of N++

*/

#SingleInstance, Force
#UseHook
SetBatchlines, -1

; Setup variables, menu, hotkeys etc

global AllExtensions:=""
MatchList:=""
MenuPadding:="   "
DefaultShortName:=""
F4Version:="v0.4"

Menu, tray, icon, res\f4.ico
Menu, tray, Tip , F4MiniMenu - %F4Version%
Menu, tray, NoStandard
Menu, tray, Add, F4MiniMenu - %F4Version%, DoubleTrayClick
Menu, tray, Default, F4MiniMenu - %F4Version%
Menu, tray, Add, 
Menu, tray, Add, &Reload this script, MenuHandler
Menu, tray, Add, &Edit this script,   MenuHandler
Menu, tray, Add, 
Menu, tray, Add, &Suspend Hotkeys,    MenuHandler
Menu, tray, Add, &Pause Script, 	  MenuHandler
Menu, tray, Add, 
Menu, tray, Add, Settings,            Settings
Menu, tray, Add, Configure editors,   ConfigEditors
Menu, tray, Add, 
Menu, tray, Add, Exit, 				  SaveSettings

; Load settings on MatchList Object
XA_Load("F4MiniMenu.xml")

If (MatchList[0].TCStart = 1) and !WinExist("ahk_class TTOTAL_CMD")
	{
 	 If FileExist(MatchList[0].TCPath)
		Run % MatchList[0].TCPath ; %
	}

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

; Function excetued by background hotkey (open directly)
ProcessFiles(MatchList, SelectedEditor = "-1")
	{
	 Done:=[]
	 Stop:=0
     Files:=GetFiles() ; Get list of selected files in TC, one per line
	 SelectedFiles:=CountFiles(Files)
	 If (SelectedFiles > MatchList[0].MaxFiles)
		{
		 ; Technique from http://www.autohotkey.com/docs/scripts/MsgBoxButtonNames.htm	
		 SetTimer, ChangeButtonNames, 10
		 MsgBox, 4150, Maximum files, % "Number of selected files: [" SelectedFiles "]`nDo wish to process them all`nor stop at the maximum?: [" MatchList[0].MaxFiles "]" ; %
		 IfMsgBox, Cancel
			Return
		 else IfMsgBox, Continue
			Stop:=1
		}
	 Loop, parse, Files, `n, `r
		{
		 If (Stop = 1) and (A_Index > Matchlist[0].MaxFiles)
			Break
		 open:=A_LoopField
		 SplitPath, A_LoopField, , , OutExtension
		 Loop % MatchList.MaxIndex() ; %
			{
	 		 If CheckFile(done,open) ; safety check - otherwise each file would be processed for all editors
				Break
			 If (SelectedEditor < 0) ; Find out which editor to use, first come first serve
				{
				 If OutExtension not in %AllExtensions% ; Open in default program
					{
					 Done.Insert(OpenFile(MatchList[1], open))
					} 
				 Else If OutExtension in % MatchList[A_Index].ext ; Open in defined program %
					{
					 Done.Insert(OpenFile(MatchList[A_Index], open))
					} 
				}
 			 Else If (SelectedEditor > 0) ; Use selected editor from the Menu (Foreground option)
				{
				 Done.Insert(OpenFile(MatchList[SelectedEditor], open))
				} 
			}
		}
	}

; Get a list of selected files using internal TC commands (see totalcmd.inc for references)
GetFiles()
	{
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
	 If IsFunc(func)
		%func%(Editor.Exe,open,Editor.Delay,Editor.Parameters,Editor.StartDir)
	 If (Editor.windowmode = 2) ; maximize
		{
		 WinWait, %title%
		 WinMaximize, %title%
		}
	 Else If (Editor.windowmode = 3) ; minimize
		{
		 WinWait, %title%
		 WinMinimize, %title%
		}	
	 Return open	
 	}
	
Normal(program,file,delay,parameters,startdir)
	{
	 ; Run, Target, WorkingDir, Max|Min|Hide
	 Run, %program% %parameters% "%file%", %startdir%
	}

DragDrop(program,file,delay,parameters,startdir)
	{
 	 ; Run, Target, WorkingDir, Max|Min|Hide
	 title:="ahk_exe " program
	 IfWinNotExist, %title%
	   {
		 Run, %program% %parameters% "%file%", %startdir%
		 ; in case there are more files to be processed we need the extra time after 
		 ; first startup as some programs are sloooooow and we have to make sure it 
		 ; can it can accept drag & drop files. It is is only for the first file in the list
		 Sleep %delay% 
		 Return
	   }
	 If InStr(title,"Paint Shop Pro.exe") ; Annoying hack but seems to be required for PSP
		title=Jasc Paint Shop Pro 
	 DropFilesA(file, title)
	}

; Helper functions & Labels

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

SetHotkeys:
Hotkey, IfWinActive, ahk_class TTOTAL_CMD 

; ~ native function will not be blocked 
; $ prefix forces the keyboard hook to be used to implement this hotkey

hk_prefix:="$"
If (RegExMatch(MatchList[0].ForegroundHotkey,"[\^\+\!\# \&]"))
	hk_prefix:="~"
Hotkey, % hk_prefix . MatchList[0].ForegroundHotkey, Process,  %HotKeyState%  ; %
hk_prefix:="$"
If (RegExMatch(MatchList[0].BackgroundHotkey,"[\^\+\!\# \&]")) ; for example if hotkey is Esc & F4 not adding the ~ would mean Esc is actually disabled in inplace rename (shift-f6) operations in a panel, or at least that is my experience.
	hk_prefix:="~"
Hotkey, % hk_prefix . MatchList[0].BackgroundHotkey, ShowMenu, %HotKeyState%  ; %
Hotkey, IfWinActive
Return	
	
SaveSettings:
If (A_ExitReason <> "Exit") ; to prevent saving it twice
	XA_Save("MatchList", "F4MiniMenu.xml")
ExitApp	
Return	

; Used in ProcessFiles() - Technique from http://www.autohotkey.com/docs/scripts/MsgBoxButtonNames.htm	
ChangeButtonNames: 
IfWinNotExist, Maximum files ahk_class #32770
    Return  ; Keep waiting...
SetTimer, ChangeButtonNames, off 
; WinActivate 
ControlSetText, Button2, Process All, Maximum files ahk_class #32770
ControlSetText, Button3, Stop at Max., Maximum files ahk_class #32770
Return

GetAllExtensions:
AllExtensions:=""
Loop % MatchList.MaxIndex() ; %
	AllExtensions .= MatchList[A_Index].ext ","
AllExtensions:=Trim(AllExtensions,",")
Return

; Includes

#include inc\Menu.ahk
#include inc\Settings.ahk
#include inc\Editors.ahk