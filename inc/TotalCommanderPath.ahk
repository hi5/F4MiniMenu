; used in F4MiniMenu and F4TCIE

; try to get Commander_Path, it will be empty if TC is not running (yet)
EnvGet, Commander_Path, Commander_Path

If (Commander_Path = "") ; try to read registry
	 RegRead Commander_Path, HKEY_CURRENT_USER, Software\Ghisler\Total Commander, InstallDir

; Inform user just in case
If (Commander_Path = "")
	{
	 FileRead, check_for_path, %F4ConfigFile%
	 If InStr(check_for_path,"%Commander_Path%")
	 	MsgBox, 16, F4MiniMenu: Not found, F4MiniMenu:`nThe Commander_Path environment variable can not be found.`nStarting applications may not work in some cases.`nStart TC first.
	 check_for_path:=""
	}
