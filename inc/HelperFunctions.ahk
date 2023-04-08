; used in F4MiniMenu and F4TCIE

GetPath(editor)
	{
	 global MyComSpec,Commander_Path,MyProgramFiles,MyProgramFilesx86,MyProgramW6432
	 if !InStr(editor,"%")
		Return GetFullPathName(editor)
	 Loop, parse, % "Commander_Path,A_ScriptDir,A_ComputerName,A_UserName,A_WinDir,A_ProgramFiles,ProgramFiles,A_AppData,A_AppDataCommon,A_Desktop,A_DesktopCommon,A_StartMenu,A_StartMenuCommon,A_Programs,A_ProgramsCommon,A_Startup,A_StartupCommon,A_MyDocuments", CSV
		editor:=StrReplace(editor,"%" A_LoopField "%",%A_LoopField%)
   ; special cases
	 editor:=StrReplace(editor,"%WinDir%",A_WinDir) 
	 editor:=StrReplace(editor,"%ComSpec%",MyComSpec)
	 editor:=StrReplace(editor,"%ProgramFiles%",MyProgramFiles)
	 editor:=StrReplace(editor,"%ProgramFiles(x86)%",MyProgramFilesx86)
	 editor:=StrReplace(editor,"%ProgramW6432%",MyProgramW6432)
	 Return GetFullPathName(editor)
	}

; get absolute path from relative path
; https://www.autohotkey.com/boards/viewtopic.php?p=289536#p289536
GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}

xGetTCCommander_Path(editor)
	{
	 global MyComSpec
	 editor:=StrReplace(editor,"%Commander_Path%",Commander_Path)
	 editor:=StrReplace(editor,"%ComSpec%",MyComSpec)
	 Return editor
	}

RegExExtensions(in)
	{
	 out:="iU)\b(" StrReplace(StrReplace(StrReplace(in,",","|"),"?",".?"),"*",".*") ")\b" ; v0.9 allow for wildcards
	 Return out
	}

