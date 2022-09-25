/*
DoubleCommander functions
*/

DoubleCommander_Active()
	{
	 IfWinActive ahk_exe doublecmd.exe
		Return 1
	}

DoubleCommander_GetSelection() 
	{
	 global matchlist
	 ClipboardSave:=ClipboardAll
	 Clipboard:=""
	 Send % MatchList.settings.DoubleCommander
	 Result:=Clipboard
	 Sleep 100
	 Clipboard:=ClipboardSave
	 Return Result
	}
