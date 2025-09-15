
/*
[ProgramName]
ProgramExe=Everything.exe
ProgramShortCut=!Ins
ProgramDelay=300
ProgramSendMethod=ControlSend
ProgramActive=1
*/

ReadSettingsF4MMOtherPrograms() {
	global F4MMOtherPrograms:=[]
	If !FileExist(A_ScriptDir "\F4MMOtherPrograms.ini")
		{
		 F4MMOtherPrograms.settings.active:=0
		 Return
		}
	F4MMOtherPrograms.settings.active:=1
	
	IniRead, F4MMOtherProgramsSectionNames, %A_ScriptDir%\F4MMOtherPrograms.ini
	; "ProgramExe,ProgramShortCut,ProgramDelay,ProgramSendMethod,Active,Name"
	Loop, parse, F4MMOtherProgramsSectionNames, `n, `r
		{
		 program:=A_LoopField
		 F4MMOtherPrograms[program,"name"]:=program
		 IniRead, OutputVarSection, %A_ScriptDir%\F4MMOtherPrograms.ini, %program%
		 Loop, parse, OutputVarSection, `n, `n
			{
			 splitData:=StrSplit(A_LoopField,"=")
			 F4MMOtherPrograms[program,Trim(splitData[1]," ")]:=Trim(splitData[2]," ")
			}
		}
	; MsgBox % F4MMOtherPrograms["Everything","ProgramExe"]

	; only add active programs to TCF4Windows hotkey group list later
	for k, v in F4MMOtherPrograms
		if F4MMOtherPrograms[k].Active
			csvlist .= F4MMOtherPrograms[k].ProgramExe ","
	F4MMOtherPrograms["settings","group"]:=trim(csvlist,",")

	; MsgBox % F4MMOtherPrograms["settings"].group
}
