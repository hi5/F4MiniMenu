; used in F4MiniMenu and F4TCIE

; try to get Commander_Path and Commander_Ini,
; these will be empty if TC is not running (yet) or F4MM was started _before_ TC
; we check for values in settings first, if not available, try to read from the
; environment, fall back to registry

If FileExist(MatchList.settings.TCPath)
	{
	 Commander_Path:=StrReplace(MatchList.settings.TCPath,"\TOTALCMD.EXE")
	 Commander_Path:=StrReplace(Commander_Path,"\TOTALCMD64.EXE")
	}
else
	{
	 EnvGet, Commander_Path, Commander_Path
	 If (Commander_Path = "") ; try to read registry
		Commander_Path:=TCRegistryCheck("InstallDir")
	 If FileExist(Commander_Path)
		MatchList.settings.TCPath:=Commander_Path "\TotalCmd.exe" ; assume 32bit, user can change this in settings
	}

; we only use Commander_Ini / MatchList.settings.TCIniPath for ListerWindowClose
If FileExist(MatchList.settings.TCIniPath)
	Commander_Ini:=MatchList.settings.TCIniPath
else
	{
	 EnvGet, Commander_Ini, Commander_Ini
	 If (Commander_Ini = "") ; try to read registry
		Commander_Ini:=TCRegistryCheck("IniFileName")
	 If (Commander_Ini = ".\wincmd.ini")
		Commander_Ini:=Commander_Path "\wincmd.ini"
	 If FileExist(Commander_Ini)
		MatchList.settings.TCIniPath:=Commander_Ini
	}

; TODO consider other method, also for non TC uers who now always get this warning
; Inform user just in case
If (Commander_Path = "")
	{
	 FileRead, check_for_path, %F4ConfigFile%
	 If RegExMatch(check_for_path,"iU)(<TCPath>.*exe</TCPath>|TCPath=.*exe)") 
		MsgBox, 16, F4MiniMenu: Not found, F4MiniMenu:`nThe Commander_Path environment variable can not be found.`nStarting applications may not work in some cases.`nStart TC first (and check the Settings).
	 check_for_path:=""
	}

ListerWindowClose()
	{
	 Global
	 IniRead, ListerWindowClose, % MatchList.settings.TCIniPath, Lister, F4Edit
	}

TCRegistryCheck(key)
	{
	 ; source: https://ghisler.ch/board/viewtopic.php?t=258
	 ; Search in this order, the 1st key that exist should be used:
	 ; 1. HKCU\Software\Ghisler\Total Commander
	 ; 2. HKLM\Software\Ghisler\Total Commander
	 ; 3. HKCU\Software\Ghisler\Windows Commander
	 ; 4. HKLM\Software\Ghisler\Windows Commander
	 ; Under each key there should be three values:
	 ; 1. "InstallDir"  - Path where TC/WC is installed
	 ; 2. "IniFileName" - Relative* path to the "WinCmd.ini"
	 ; 3. "FtpIniName"  - Relative* path to the "wcx_ftp.ini"
	 ; 
	 ; IniFileName=%AppData%\Ghisler\wincmd.ini (Option "Application Data")
	 ; IniFileName=%UserProfile%\wincmd.ini     (Option "Documents and Settings")
	 ; under older systems: Windows directory

	 Loop, parse, % "HKCU,HKLM", CSV
		{
		 main:=A_LoopField
		 Loop, parse, % "Total Commander,Windows Commander", CSV
			{
			 program:=A_LoopField
			 RegRead key, %main%, Software\Ghisler\%program%, %key%
			 if (key <> "")
				break 2
			}
		}
	 Return key
	}
