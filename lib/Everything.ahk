/*
Everything functions
- Note: deactivated Everything_DirectoryTree() for now
*/

Everything_Active()
	{
	 IfWinActive ahk_exe Everything.exe
		Return 1
	}

Everything_GetSelection(dir="0")
	{
	 ControlGet, OutputVar, List, Selected, SysListView321, ahk_exe Everything.exe
	 If (OutputVar = "")
		{
		 Send {Down}
		 ControlGet, OutputVar, List, Selected, SysListView321, ahk_exe Everything.exe
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
	 WinWaitActive, ahk_exe Everything.exe
	 ControlSend, Edit1, {space}, ahk_exe Everything.exe
	}

Everything_DirectoryTree:
Everything_DirectoryTree()
Return
*/
