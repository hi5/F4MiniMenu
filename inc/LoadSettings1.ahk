; used in F4MiniMenu and F4TCIE

SplitPath, A_ScriptName, , , , OutNameNoExt
If (SubStr(OutNameNoExt,0) <> "i")
	{
	 F4ConfigFile:="F4MiniMenu.xml"
	 F4Load:="XA_Load"
	 F4Save:="XA_Save"
	}
else
	{
	 F4ConfigFile:="F4MiniMenu.ini"
	 F4Load:="iob"
	 F4Save:="iob_save"
	}

Error:=0
; http://en.wikipedia.org/wiki/List_of_archive_formats
ArchiveExtentions:="\.(a|ar|cpio|shar|iso|lbr|mar|tar|bz2|F|gz|lz|lzma|lzo|rz|sfark|xz|z|infl|7z|s7z|ace|afa|alz|apk|arc|arj|ba|bh|cab|cfs|cpt|dar|dd|dgc|dmg|gca|ha|hki|ice|j|kgb|lzh|lha|lzx|pak|partimg|paq6|paq7|paq8|pea|pim|pit|qda|rar|rk|sda|sea|sen|sfx|sit|sitx|sqx|tar\.gz|tgz|tar\.Z|tar\.bz2|tbz2|tar\.lzma|tlz|uc|uc0|uc2|ucn|ur2|ue2|uca|uha|wim|xar|xp3|yz1|zip|zipx|zoo|zz)\\"

; get Environment variables
EnvGet, MyComSpec, ComSpec
EnvGet, MyProgramFiles, ProgramFiles
EnvGet, MyProgramFilesx86, ProgramFiles(x86)
EnvGet, MyProgramW6432, ProgramW6432
EnvGet, A_UserProfile, UserProfile
