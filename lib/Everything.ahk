/*
Everything functions
- Note: deactivated Everything_DirectoryTree() for now
- 20250209 If there are no selected rows, get entire list and grab first one
- 20250208 Added Everything64.exe; for 1.5 alpha the F4MM shortcut F4 overrides "F4 = Focus Next Selected"
*/

Everything_Active()
	{
	 WinGet, EverythingExe, ProcessName, A
	 if EverythingExe in Everything.exe,Everything64.exe
		Return 1
	}

Everything_GetSelection(dir="0")
	{
	 WinGet, EverythingExe, ProcessName, Everything
	 ControlGet, OutputVar, List, Selected, SysListView321, ahk_exe %EverythingExe%
	 If (OutputVar = "") ; there was no selection so just grab the first result only
		{
		 ControlGet, OutputVar, List, , SysListView321, ahk_exe %EverythingExe%
		 OutputVar:=StrSplit(OutputVar,"`n").1
		}
	 Loop, parse, OutputVar, `n, `r
		{
		 filepath:=StrSplit(A_LoopField,A_Tab)
		 result .= filepath[2] "\" filepath[1] "`n"
		}
;	 If dir
;		Return % Trim(StrSplit(result,"`n").1,"`n") "\"
;	 else
	 	Return % Trim(result,"`n")
	}

/*
Everything_DirectoryTree()
	{
	 global MatchList
	 count:=0
	 AutoTrim, Off
	 SendMessage, 1074, 17, , , ahk_class TTOTAL_CMD
	 WinGetText, PathInTC, ahk_id %ErrorLevel%
	 drive:=SubStr(PathInTC,1,1) ":"
	 dir:=Trim(PathInTC,"<>`r`n")
	 StartSearch:=MatchList.settings.EvPath
	 if InStr(StartSearch,"/dir")
		StartSearch:=StrReplace(StartSearch,"/drive")
	 StartSearch:=StrReplace(StartSearch,"/drive",drive)
	 StartSearch:=StrReplace(StartSearch,"/dir",dir)
	 Run, % StartSearch
	 WinWaitActive, ahk_exe Everything.exe ; note 20250209 everything64.exe v1.5 alpha
	 ControlSend, Edit1, {space}, ahk_exe Everything.exe
	}

Everything_DirectoryTree:
Everything_DirectoryTree()
Return
*/
