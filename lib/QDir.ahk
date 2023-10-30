/*
Q-Dir functions
*/

QDir_Active()
	{
	 IfWinActive ahk_exe Q-Dir.exe
		Return 1
	 IfWinActive ahk_exe Q-Dir_x64.exe
		Return 1
	}

QDir_GetSelection() 
	{
	 global matchlist
	 ClipboardSave:=ClipboardAll
	 Clipboard:=""
	 Send % MatchList.settings.QDir
	 Result:=Clipboard
	 Sleep 100
	 Clipboard:=ClipboardSave
	 Return Result
	}
