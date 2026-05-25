
/*
[ProgramName]
ProgramExe=Everything.exe
ProgramShortCut=!Ins
ProgramDelay=300
ProgramSendMethod=ControlSend
ProgramActive=1
OffsetX=0
OffsetY=0
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
	; "ProgramExe,ProgramShortCut,ProgramDelay,ProgramSendMethod,Active,Name,OffsetX,OffsetY"
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

	; Make it easier to get to Offset values by setting it for each executable
	; (ProgramExe can be a CSV list)
	; making it easier to call in GetPos()
	for k, v in F4MMOtherPrograms
		Loop, parse, % F4MMOtherPrograms[k].ProgramExe, CSV
			{
			 F4MMOtherPrograms[Trim(A_LoopField,"`r`n`t "),"OffsetX"]:=F4MMOtherPrograms[k].OffsetX
			 F4MMOtherPrograms[Trim(A_LoopField,"`r`n`t "),"OffsetY"]:=F4MMOtherPrograms[k].OffsetY
			}

	; MsgBox % F4MMOtherPrograms["settings"].group
}
