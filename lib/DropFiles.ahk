
/*

DropFiles:
combined from two functions - ideally they should be merged into one "smarter" 
function but this will do for now.
 
- SKAN - http://www.autohotkey.com/board/topic/41467-make-ahk-drop-files-into-other-applications/#entry258810
- nimda - http://www.autohotkey.com/board/topic/79145-help-converting-ahk-ahk-l/#entry502676

Example:

DropFiles( "C:\SomeName.txt", "ahk_class Notepad" ) 

*/

DropFiles( FileList, wTitle="", Ctrl="", X=0, Y=0, NCA=0 ) {
	If (A_IsUnicode = 1)
		{ ; from nimda - http://www.autohotkey.com/board/topic/79145-help-converting-ahk-ahk-l/#entry502676
		   fns:=RegExReplace(FileList,"\n$") 
		   fns:=RegExReplace(fns,"^\n") 
		   hDrop:=DllCall("GlobalAlloc","UInt",0x42,"UPtr",20+StrLen(fns)+2) 
		   p:=DllCall("GlobalLock","UPtr",hDrop) 
		   NumPut(20, p+0)  ;offset 
		   NumPut(x,  p+4)  ;pt.x 
		   NumPut(y,  p+8)  ;pt.y 
		   NumPut(0,  p+12) ;fNC 
		   NumPut(0,  p+16) ;fWide 
		   p2:=p+20 
		   Loop,Parse,fns,`n,`r 
		   { 
			  DllCall("RtlMoveMemory","UPtr",p2,"AStr",A_LoopField,"UPtr",StrLen(A_LoopField)) 
			  p2+=StrLen(A_LoopField)+1 
		   } 
		   DllCall("GlobalUnlock","UPtr",hDrop) 
		   PostMessage, 0x233, hDrop, 0, %Ctrl%, %wTitle%
		   }
	 Else If (A_IsUnicode <> 1)
		{ ; from DropFilesA - SKAN - http://www.autohotkey.com/board/topic/41467-make-ahk-drop-files-into-other-applications/#entry258810
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
	}
