/*
CLIParser to start F4MiniMenu via F4 (editor), Buttonbar or Startmenu

F4MiniMenu %L /P? /M?

/P1 = Menu position at Mouse cursor
/P2 = Menu position Centered in window
(see GetPos.ahk)

/M1 = Full menu
/M2 = Filtered menu

/SET = open settings

/ED  = open editors

*/

If (A_Args.Length() <> 0)
	{
	 CLI_Exit:=1
	 CLI_File:=A_Args[1]
	 for k, v in A_Args
		{
		 if (v = "/P1")
			{
			 CLI_MenuPos:=MatchList.settings.MenuPos
			 MatchList.settings.MenuPos:=1
			}
		 if (v = "/P2")
			{
			 CLI_MenuPos:=MatchList.settings.MenuPos
			 MatchList.settings.MenuPos:=2
			}
		 if (v = "/M1")
			CLI_ShowMenu:=1
		 if (v = "/M2")
			CLI_FilteredMenu:=1
		 if (v = "/SET")
			CLI_Settings:=1
		 if (v = "/ED")
			CLI_Editors:=1
		}	
	}
