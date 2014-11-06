/*

Script      : F4MiniMenu.ahk for Total Commander - AutoHotkey 1.1+ (Ansi and Unicode)
Version     : 0.8
Author      : hi5
Last update : 7 November 2014
Purpose     : Minimalistic clone of the F4 Menu program for Total Commander (open selected files in editor(s))
Source      : https://github.com/hi5/F4MiniMenu

Note        : ; % used to resolve syntax highlighting feature bug of N++

*/

#SingleInstance, Force
#UseHook
SetBatchlines, -1
SetWorkingDir, %A_ScriptDir%
; Setup variables, menu, hotkeys etc

global AllExtensions:=""
MatchList:=""
MenuPadding:="   "
DefaultShortName:=""
F4Version:="v0.8"
Error:=0
; http://en.wikipedia.org/wiki/List_of_archive_formats
ArchiveExtentions:="\.(a|ar|cpio|shar|iso|lbr|mar|tar|bz2|F|gz|lz|lzma|lzo|rz|sfark|xz|z|infl|7z|s7z|ace|afa|alz|apk|arc|arj|ba|bh|cab|cfs|cpt|dar|dd|dgc|dmg|gca|ha|hki|ice|j|kgb|lzh|lha|lzx|pak|partimg|paq6|paq7|paq8|pea|pim|pit|qda|rar|rk|sda|sea|sen|sfx|sit|sitx|sqx|tar\.gz|tgz|tar\.Z|tar\.bz2|tbz2|tar\.lzma|tlz|uc|uc0|uc2|ucn|ur2|ue2|uca|uha|wim|xar|xp3|yz1|zip|zipx|zoo|zz)\\"

GroupAdd, TCF4Windows, ahk_class TTOTAL_CMD
GroupAdd, TCF4Windows, ahk_class TLister
GroupAdd, TCF4Windows, ahk_class TFindFile

FileDelete, %A_ScriptDir%\$$f4mtmplist$$.m3u

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
Try
	{
	 XA_Load("F4MiniMenu.xml")
	}
Catch
	{
	 Error:=1
	}

If ((MatchList.MaxIndex() = 0) or (MatchList.MaxIndex() = ""))
	Error:=1

If (Error = 1)	
	{
	 ErrorText=
	 (Join`n LTRIM
	  There seems to be an error with the XML settings file.
	  F4MiniMenu will try to create default configuration and restart.
	  Be sure to check the last backup of your settings in "F4MiniMenu.xml.bak"
	  Be sure to exit F4MiniMenu before trying to restore any backup settings.
	 )	

	 MsgBox, 16, F4MiniMenu, %ErrorText%
	 Reload
	} 
	
	
; Create backup file
FileCopy, F4MiniMenu.xml, F4MiniMenu.xml.bak, 1

If (MatchList.settings.TCStart = 1) and !WinExist("ahk_class TTOTAL_CMD")
	{
 	 If FileExist(MatchList.settings.TCPath)
		Run % MatchList.settings.TCPath ; %
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
		 ; Loop % MatchList.MaxIndex() ; %
		 for k, v in MatchList
			{
			 Index:=A_Index
	 		 If CheckFile(done,open) ; safety check - otherwise each file would be processed for all editors
				Break
			 If (SelectedEditor < 0) ; Find out which editor to use, first come first serve
				{
				 If OutExtension not in %AllExtensions% ; Open in default program
					{
					 FileList1 .= open "`n"
					 Done.Insert(open)
					} 
				 Else If OutExtension in % v.ext ; Open in defined program %
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

	 ; Loop % MatchList.MaxIndex() ; %
	 for k, v in MatchList
		{
		 Index:=A_Index
		 list:=Trim(FileList%Index%,"`n")
		 If (list = "")
			Continue
		 If (v.Method = "FileList")
			{
			 FileDelete, %A_ScriptDir%\$$f4mtmplist$$.m3u
			 FileAppend, %list%, %A_ScriptDir%\$$f4mtmplist$$.m3u
			 OpenFile(v, A_ScriptDir "\$$f4mtmplist$$.m3u")
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
		Normal(Editor.Exe,open,Editor.Delay,Editor.Parameters,Editor.StartDir)
	 Else If IsFunc(func)
		%func%(Editor.Exe,open,Editor.Delay,Editor.Parameters,Editor.StartDir)
	 If (Editor.windowmode = 1) ; normal (activate)
		{
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
	 DropFiles(file, title)
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
Hotkey, IfWinActive, ahk_group TCF4Windows

; ~ native function will not be blocked 
; $ prefix forces the keyboard hook to be used to implement this hotkey

hk_prefix:="$"
If (RegExMatch(MatchList.settings.ForegroundHotkey,"[\^\+\!\# \&]"))
	hk_prefix:="~"
FGHKey:=MatchList.settings.ForegroundHotkey
StringReplace, FGHKey, FGHKey, &amp`;amp`;, & , All
StringReplace, FGHKey, FGHKey, &amp`;, &, All
	 	
Hotkey, % hk_prefix . FGHKey, ShowMenu,  %HotKeyState%  ; %
hk_prefix:="$"
If (RegExMatch(MatchList.settings.BackgroundHotkey,"[\^\+\!\# \&]")) ; for example if hotkey is Esc & F4 not adding the ~ would mean Esc is actually disabled in inplace rename (shift-f6) operations in a panel, or at least that is my experience.
	hk_prefix:="~"
BGHKey:=MatchList.settings.BackgroundHotkey
StringReplace, BGHKey, BGHKey, &amp`;amp`;, & , All
StringReplace, BGHKey, BGHKey, &amp`;, &, All
Hotkey, % hk_prefix . BGHKey, Process, %HotKeyState%  ; %
Hotkey, IfWinActive
Return	
	
SaveSettings:
If (A_ExitReason <> "Exit") ; to prevent saving it twice
	XA_Save("MatchList", "F4MiniMenu.xml")
FileDelete, %A_ScriptDir%\$$f4mtmplist$$.m3u	
If (Error = 1)
	{
FileDelete, F4MiniMenu.xml
FileAppend,
(
<?xml version="1.0" encoding="UTF-8"?>
<MatchList>
	<Invalid_Name  id="settings" ahk="True">
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
; Loop % MatchList.MaxIndex() ; %
for k, v in MatchList
	AllExtensions .= v.ext ","
AllExtensions:=Trim(AllExtensions,",")
Return

; Includes

#include %A_ScriptDir%\inc\Menu.ahk
#include %A_ScriptDir%\inc\Settings.ahk
#include %A_ScriptDir%\inc\Editors.ahk