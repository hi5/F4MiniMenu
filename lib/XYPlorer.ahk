/*
XYPlorer functions
*/

XYPlorer_Active()
	{
	 IfWinActive ahk_exe XYPLorer.exe
		Return 1
	 IfWinActive ahk_exe XYPLorerFree.exe
		Return 1
	}

XYPlorer_GetSelection() 
	{
	 global matchlist
	 ClipboardSave:=ClipboardAll
	 Clipboard:=""
	 Send % MatchList.settings.XYPlorer
	 Result:=Clipboard
	 Sleep 100
	 Clipboard:=ClipboardSave
	 Return Result
	}
