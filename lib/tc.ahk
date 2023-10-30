; TC_SendData() using WM_CopyData  
; https://www.ghisler.ch/board/viewtopic.php?p=363391#p363391 

/*
TESTED AND WORKING ON: AHK_L v 1.1.31.01 unicode & ansi version, Win 10 64bit and TC9.22
modified by dindog
-------------------------------------------------------------------------
TC_SendData("em_FOO"         	     , "EM") ; User Command
TC_SendData("em_APPENDTABS C:\my.tab", "EM") ; User Command with parameters (usercmd.ini as following)
															;				[em_APPENDTABS]
															;				cmd=APPENDTABS
															;				param=%A
TC_SendData("em_CD C:", "EM") ; User Command with parameters (usercmd.ini as following)
															;				[em_cd]
															;				cmd=cd
															;				param=%A
TC_SendData("em_命令 *.exe", "EM") ; User Command with parameters (usercmd.ini as following) test for command name non-ASCII
															;				[em_命令]
															;				cmd=cd
															;				param=%A

TC_SendData("cmd") 								  ; Ask TC :     (cmd one of the following varues:)
															; A  = Active Side
						
															; LP = Left Path            RP = Right Path
															; LC = Left List Count      RC = Right List Count
															; LI = Left Caret Index     RI = Right Caret Index
															; LN = Left Name Caret      RN = Right Name Caret

															; SP = Source Path          TP = Target Path
															; SC = Source List Count    TC = Target List Count
															; SI = Source Caret Index   TI = Target Caret Index
															; SN = Source Name Caret    TN = Target Name Caret

TC_SendData("C:\tc" "`r" "D:\data", "CD")	 ; CD   Command: (LeftDir - RightDir)
TC_SendData("C:\tc" "`r"          , "R")	 ; CD   Command: (LeftDir) and activate Right panel
TC_SendData(        "`r" "D:\data", "LT")	 ; CD   Command: (          RightDir) in new tab and activate left panel

TC_SendData("C:\tc" "`r" "D:\data", "S")	 ; CD   Command: (SourceDir - TargetDir)
TC_SendData("C:\tc" "`r"          , "SBT")	 ; CD   Command: (SourceDir) in new background tab
TC_SendData(        "`r" "D:\data", "ST")	 ; CD   Command: (            TargetDir) in new background tab
S: Interpret the paths as source/target instead of left/right
T: Open path(s) in new tabs
B: Open tabs in background (do not activate them)
L: Activate the left panel
R: Activate the right panel
A: Do not open archives as directories. Instead, open parent directory and place cursor on it.
TC accepts more then 2 parameters here, so sending e.g. STBL is legitimate.
*/

TC_SendData(Cmd, CmdType="", msg="", hwnd="") {
   Critical   ; Define "OnMessage" as STATIC it is registered at Script startup.
   STATIC om:=OnMessage(0x4a, "TC_SendData"), TC_ReceiveDataValue:="", TC_DataReceived:=""	; 0x4a is WM_COPYDATA

   IF ((msg=0x4A) AND (hwnd=A_ScriptHwnd)) ; EnSure is trigered by this Script.
      EXIT (TC_ReceiveDataValue:=StrGet(NumGet(CmdType + A_PtrSize * 2)), TC_DataReceived:="1")

   VarSetCapacity(CopyDataStruct, A_PtrSize * 3), TC_ReceiveDataValue:=1, TC_DataReceived:=""
   if (CmdType="") ; Ask TC
      CmdType:=(A_IsUnicode ? "GW" : "GA"), TC_ReceiveDataValue:=""
   else if (CmdType="EM") or (CmdType="em") ; em command
      CmdType:="EM"
   else  ; CD command STBALR
      DirType:=(CmdType="CD")?"":CmdType, CmdType:="CD"

      ;;;;;;VarSetCapacity need to request at least 5 more byte to allow 4 CD params
      VarSetCapacity(cmdA, StrPut(cmd, (A_IsUnicode ?"UTF-8":"CP0")) + (CmdType="CD" ? 5 : 0) * (A_IsUnicode ? 2 : 1), 0)	,	Len:=StrPut(cmd, &cmdA, (A_IsUnicode ?"UTF-8":"CP0"))

   		

   NumPut( Asc(SubStr(CmdType,1,1)) + 256 * Asc(SubStr(CmdType,2,1)), CopyDataStruct,0 )
   NumPut( Len + (CmdType="CD" ? 5 : 0) * (A_IsUnicode ? 2 : 1) , CopyDataStruct, A_PtrSize )
   NumPut( &cmdA , CopyDataStruct, A_PtrSize * 2)
   Loop, % strlen(DirType) ;(CmdType=="CD" ? 2 : 0)
   {  
      NumPut(Asc(SubStr(DirType,A_Index,1)), cmdA ,Len+A_Index-1, "Char")
      }
   SendMessage, 0x4A,%A_ScriptHwnd%, &CopyDataStruct,, ahk_class TTOTAL_CMD
   
   While (TC_ReceiveDataValue="") {
      IfEqual, TC_DataReceived,    1, Break
      IfGreaterOrEqual, A_Index, 500, Break
      Sleep,10
   }
   Return TC_ReceiveDataValue
}

