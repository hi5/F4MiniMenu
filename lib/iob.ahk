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
	 Global MatchList:=[]
	 SectionKeys:=iob_getkeys(1)
	 Loop, parse, SectionKeys, CSV
		{
		 IniRead, OutputVar, %Filename%, Settings, %A_LoopField%
		 MatchList["Settings",A_LoopField]:=OutputVar
		}
	 SectionKeys:=iob_getkeys(2)
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
;	 Return MatchList
	}

iob_save(ObjectName,Filename="") { ; Object parameter isn't used but just added to allow same function call as XA_Save
	global MatchList
	FileCopy, %Filename%, %Filename%.bak, 1
	FileDelete, %Filename%
	SectionKeys:=iob_getkeys(1)
	Loop, parse, SectionKeys, CSV
		IniWrite, % MatchList["Settings",A_LoopField], %Filename%, Settings, %A_LoopField%
	SectionKeys:=iob_getkeys(2)
	Loop
		{
		 Index:=A_Index
		 If !MatchList.HasKey(Index)
			Break
		 Loop, parse, SectionKeys, CSV
			IniWrite, % MatchList[Index,A_LoopField], %Filename%, %Index%, %A_LoopField%
		}
	}

iob_getkeys(section)
	{
	 If (Section = 1)
	 	Return "BackgroundHotkey,ForegroundHotkey,MaxFiles,MenuPos,TCPath,TCStart,F4MMCloseAll,F4MMClosePID,FilteredHotkey,FullMenu,Explorer,Everything,DoubleCommander,XYPlorer" ; ,EvPath,EVDirTree
	 If (Section = 2)
	 	Return "Delay,Exe,Ext,Method,Open,Windowmode,StartDir,Parameters,Icon,Name"
	}
