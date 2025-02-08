/*
Loging function for debugging purposes, hidden settings (manual editing of settings file)
*/

Log(logstring,logfile)
	{
	 logfile:=StrReplace(logfile,"%A_ScriptDir%",A_ScriptDir)
	 if (logfile = "")
		logfile:=A_ScriptDir "\logfile.txt"
	 FileAppend, `n%logstring%, %logfile%, UTF-8-RAW
	}