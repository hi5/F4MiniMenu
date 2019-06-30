/*

Script      : F4TCIE.ahk for Total Commander - AutoHotkey 1.1+ (Ansi and Unicode)
Version     : 0.41
Author      : hi5
Last update : 1 October 2017
Purpose     : Helper script for F4MiniMenu program to allow internal editor to function
              now you can edit files from within Archives and FTP (and have TC update/upload them)
Notes       : It will always use the "normal" method to open programs, so the "drag & drop", "filelist" 
              and "cmdline" methods will not be used (TC doesn't see file changes when using these methods)
              If you are using INI make sure to rename "F4TCIE" to end with an "i" (same method as F4MiniMenu)
Source      : https://github.com/hi5/F4MiniMenu

Setup       : TC, Configuration, Edit/View, Editor:
              drive:\path-to\F4TCIE.ahk "%1"

Templates   : Create a DocumentTemplates\ folder and place files for each template you'd like to use for
              the Shift-F4 'enter file name to edit' function of TC. File names are template.ext 
              This will copy the template.ext to the panel with the new name so you can work on it the
              defined editor. Not all programs allow empty files at start up so this will resolve that
              problem for say Office applications or Graphics programs. 
              See DocumentTemplates\readme.md for more info.

*/

#NoTrayIcon
#NoEnv

; <for compiled scripts>
;@Ahk2Exe-SetDescription F4MiniMenu: Open files from TC
;@Ahk2Exe-SetVersion 0.97.0.0
;@Ahk2Exe-SetCopyright MIT License - Copyright (c) https://github.com/hi5
; </for compiled scripts>

SetWorkingDir, %A_ScriptDir%

File=%1% ; cmd line parameter "%1" it receives from TC
SplitPath, File, , , OutExtension
StringUpper, OutExtension, OutExtension

If !File ; if empty
	ExitApp

; shared with F4MM
#Include %A_ScriptDir%\inc\LoadSettings1.ahk
#Include %A_ScriptDir%\inc\LoadSettings2.ahk

If Error
	{
	 MsgBox, 16, F4MiniMenu/F4TCIE, Couldn't load configuration file, closing script and starting default Windows editor.`n`nMay not work if there is no "Edit" defined for this filetype:`n`n%OutExtension%
	 Try
		Run edit %file% ; run Windows editor for this filetype
	 Catch
		Run notepad %file% ; alas no type defined so run notepad as a last resort
	 ExitApp
	}

templateExt:=MatchList.Settings.templatesExt

; shared with F4MM
#Include %A_ScriptDir%\inc\TotalCommanderPath.ahk

for k, v in MatchList
	{
	 if (k = "settings")
		continue
	 if (v.ext = "") ; reported by Ovg if EXT is empty it would not launch the default editor
		continue
	 If RegExMatch(OutExtension,RegExExtensions(v.ext)) ; Open in defined program  - v0.9 allow for wildcards
		{
		 editor:=GetTCCommander_Path(v.exe)
		 If OutExtension in %templateExt%
			{
			 IfExist, %file% ; file is already present, this could be that TC created it just now (0 bytes) or that is already existed.
				{
				 FileGetSize, NewFileSize, %file%
				 If (NewFileSize = 0) ; TC created it, so overwrite with our template, otherwise don't. This to avoid overwriting existing documents.
					FileCopy, %A_ScriptDir%\DocumentTemplates\template.%OutExtension%, %file%, 1
				}
			}
		If editor
			{
			 Sleep % v.delay
			 Run %editor% %file%
			}
		 ExitApp ; we only have one file to proces so we're done
		}
	}

; We couldn't find a defined Editor so launch the default Editor [1]
Run % matchlist[1].exe A_Space file

; shared with F4MM
#include %A_ScriptDir%\inc\HelperFunctions.ahk

; just for loading the Matchlist object, we don't need all the rest
#include %A_ScriptDir%\lib\xa.ahk
#include %A_ScriptDir%\lib\iob.ahk

