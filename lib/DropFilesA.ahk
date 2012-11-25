/*

DropFilesA - SKAN - http://www.autohotkey.com/board/topic/41467-make-ahk-drop-files-into-other-applications/#entry258810

Example:

DropFilesA( "C:\SomeName.txt", "ahk_class Notepad" ) 

*/

DropFilesA( FileList, wTitle="", Ctrl="", X=0, Y=0, NCA=0 ) {
	 StringReplace, FileList, FileList, `r`n, `n , All
	 VarSetCapacity( DROPFILES, 20, 32 ),  DROPFILES .= FileList "`n`n",  nSize:=StrLen(DROPFILES)
	 StringReplace, DROPFILES, DROPFILES, `n, `n, UseErrorLevel
	 Loop %ErrorLevel%
	 NumPut( 0, DROPFILES, InStr(DROPFILES,"`n",0,0)-1, "Char" )
	 pDP:=&DROPFILES,  NumPut(20,pDP+0), NumPut(X,pDP+4), NumPut(Y,pDP+8), NumPut(NCA,pDP+12)
	 NumPut(0,pDP+16), hDrop := DllCall( "GlobalAlloc", UInt, 0x42, UInt, nSize )
	 pData := DllCall( "GlobalLock", UInt, hDrop )
	 DllCall( "RtlMoveMemory", UInt, pData, UInt, pDP, UInt, nSize )
	 DllCall( "GlobalUnlock", UInt, hDrop )
	 PostMessage, 0x233, hDrop, 0, %Ctrl%, %wTitle%
	}
