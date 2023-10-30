; used in F4MiniMenu and F4TCIE

GetPath(path)
	{
	 global MyComSpec,Commander_Path,MyProgramFiles,MyProgramFilesx86,MyProgramW6432
	 ; path:=StrReplace(path,"%ComSpec%",MyComSpec)
	 if !InStr(path,"\") ; for programs in path environment e.g. wordpad, write
	 	Return path 
	 if !InStr(path,"%") ; no special treatment required
		Return GetFullPathName(path)
	 Loop, parse, % "Commander_Path,A_ScriptDir,A_ComputerName,A_UserName,A_WinDir,A_ProgramFiles,ProgramFiles,A_AppData,A_AppDataCommon,A_Desktop,A_DesktopCommon,A_StartMenu,A_StartMenuCommon,A_Programs,A_ProgramsCommon,A_Startup,A_StartupCommon,A_MyDocuments", CSV
		path:=StrReplace(path,"%" A_LoopField "%",%A_LoopField%)
  	 ; special cases
	 path:=StrReplace(path,"%WinDir%",A_WinDir) 
	 path:=StrReplace(path,"%ProgramFiles%",MyProgramFiles)
	 path:=StrReplace(path,"%ProgramFiles(x86)%",MyProgramFilesx86)
	 path:=StrReplace(path,"%ProgramW6432%",MyProgramW6432)
	 Return GetFullPathName(path)
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

