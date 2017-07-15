; used in F4MiniMenu and F4TCIE

GetTCCommander_Path(editor)
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
