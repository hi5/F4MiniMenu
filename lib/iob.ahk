;[settings]
;BackgroundHotkey=F4
;ForegroundHotkey=Esc & F4
;MaxFiles=30
;MenuPos=3
;TCPath=c:\totalcmd\TotalCmd.exe
;TCStart=1
;[1]
;delay=0
;exe=c:\WINDOWS\notepad.exe
;ext=txt,xml
;method=Normal
;windowmode=1

iob(Filename="")
	{
	 MatchList:=[]
	 SectionKeys:="BackgroundHotkey,ForegroundHotkey,MaxFiles,MenuPos,TCPath,TCStart"
	 Loop, parse, SectionKeys, CSV
		{
		 IniRead, OutputVar, %Filename%, Settings, %A_LoopField%
		 MatchList["Settings",A_LoopField]:=OutputVar
		}
	 SectionKeys:="Delay,Exe,Ext,Method,Open,Windowmode,StartDir,Parameters"
	 IniRead, OutputVarSectionNames, %Filename%
	 StringReplace,OutputVarSectionNames,OutputVarSectionNames,Settings,,All
	 StringReplace,OutputVarSectionNames,OutputVarSectionNames,`n,`,,All
	 StringReplace,OutputVarSectionNames,OutputVarSectionNames,%A_Space%,,All
	 Loop, parse,OutputVarSectionNames, CSV
		{
		 Section:=A_LoopField
		 Loop, parse, SectionKeys, CSV
			{
			 IniRead, OutputVar, %Filename%, %section%, %A_LoopField%
			 if (OutputVar = "ERROR")
				Break
			 MatchList[section,A_LoopField]:=OutputVar
			}
		}
	 Return MatchList
	}

iob_save(Filename="") {
	global MatchList
	FileCopy, %Filename%, %Filename%.bak, 1
	FileDelete, %Filename%
	SectionKeys:="BackgroundHotkey,ForegroundHotkey,MaxFiles,MenuPos,TCPath,TCStart"
	Loop, parse, SectionKeys, CSV
		IniWrite, % MatchList["Settings",A_LoopField], %Filename%, Settings, %A_LoopField%
	SectionKeys:="Delay,Exe,Ext,Method,Open,Windowmode,StartDir,Parameters"
	Loop
		{
		 Index:=A_Index
		 If !MatchList.HasKey(Index)
			Break
		 Loop, parse, SectionKeys, CSV
			 IniWrite, % MatchList[Index,A_LoopField], %Filename%, %Index%, %A_LoopField%
		}
	}
