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
