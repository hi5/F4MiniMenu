; used in F4MiniMenu and F4TCIE

; Load settings on MatchList Object
Try
	{
	 %F4Load%(F4ConfigFile)
	}
Catch
	{
	 Error:=1
	}

If ((MatchList.MaxIndex() = 0) or (MatchList.MaxIndex() = ""))
	Error:=1

; safety for upgrading to v1.50 with existing settings
If (MatchList.settings.TCDelay = "")
	MatchList.settings.TCDelay:=100
