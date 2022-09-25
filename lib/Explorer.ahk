/*
Explorer functions
*/

Explorer_Active()
	{
	 WinGetClass, winClass, % "ahk_id" . hWnd := WinExist("A")
	 if winClass in CabinetWClass,ExploreWClass
		Return 1
	}

Explorer_GetSelection() ; https://www.autohotkey.com/boards/viewtopic.php?t=60403#p255169
	{
	 WinGetClass, winClass, % "ahk_id" . hWnd := WinExist("A")
	 if winClass not in CabinetWClass,ExploreWClass
		Return
	 for window in ComObjCreate("Shell.Application").Windows
	 if (hWnd = window.HWND) && (oShellFolderView := window.document)
		break
	 for item in oShellFolderView.SelectedItems
		result .= (result = "" ? "" : "`n") . item.path
	 if !result
		result := oShellFolderView.Folder.Self.Path
	 Return result
	}

/*
; better? https://www.autohotkey.com/boards/viewtopic.php?p=462887#p462887
Explorer_GetSelection() {
   WinGetClass, winClass, % "ahk_id" . hWnd := WinExist("A")
   if !(winClass ~= "^(Progman|WorkerW|(Cabinet|Explore)WClass)$")
      Return
   
   shellWindows := ComObjCreate("Shell.Application").Windows
   if (winClass ~= "Progman|WorkerW")  ; IShellWindows::Item:    https://goo.gl/ihW9Gm
                                       ; IShellFolderViewDual:   https://goo.gl/gnntq3
      shellFolderView := shellWindows.Item( ComObject(VT_UI4 := 0x13, SWC_DESKTOP := 0x8) ).Document
   else {
      for window in shellWindows       ; ShellFolderView object: https://is.gd/eyZ4zG
         if (hWnd = window.HWND) && (shellFolderView := window.Document)
            break
   }
   for item in shellFolderView.SelectedItems
      result .= (result = "" ? "" : "`n") . item.Path
   ;~ if !result
      ;~ result := shellFolderView.Folder.Self.Path
   Return result
}