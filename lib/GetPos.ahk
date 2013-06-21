
/*

GetPos() for Menu X,Y co-ordinates from Listbox position with alternatives
by hi5 - developed for F4MiniMenu - https://github.com/hi5/

Assumption:

CoordMode, Menu|ToolTip, Client

Returned position: 

1: At Mouse cursor
2: Centered in window
3: Right next of current file
4: Docked next of current file (Opposite panel)

*/

GetPos(Position="1", MenuSize="5", Offset=40)
	{
	 Pos:=[]
	 If (Position = 1) ; fastest method so deal with it first
		{
		 MouseGetPos, X, Y
		 Pos.Insert("x", X), Pos.Insert("y", Y-Offset) 
		 Return Pos
		}
	 
	 ; Get TC Window statistics
	 WinGetPos, WinX, WinY, WinWidth, WinHeight, A
	
	 If (Position = 2) ; second fastest method so deal with it first
		{
		 X:=WinWidth/2-100, Y:=WinHeight/2-(MenuSize*15)-50 ; Crude calculation
		 Pos.Insert("x", X), Pos.Insert("y", Y) 
		 Return Pos
		}
     	
	 ; Get focused control info + Listbox properties to calculate Y position of popup menu
	 ControlGetFocus, FocusCtrl, A
	 ControlGetPos, CtrlX, CtrlY, CtrlWidth, CtrlHeight, %FocusCtrl%, A
	 SendMessage, 0x1A1, 0, 0, %FocusCtrl%, A   ; 0x1A1 is LB_GETITEMHEIGHT
	 LB_GETITEMHEIGHT:=ErrorLevel               ;  
	 SendMessage, 0x188, 0, 0, %FocusCtrl%, A   ; 0x188 is LB_GETCURSEL
	 LB_GETCURSEL:=ErrorLevel + 1               ; Convert from zero-based to one-based.
	 SendMessage, 0x18E, 0, 0, %FocusCtrl%, A   ; 0x18E is LB_GETTOPINDEX Gets the index of the first visible item in a list box. Initially the item with index 0 is at the top of the list box, but if the list box contents have been scrolled another item may be at the top. The first visible item in a multiple-column list box is the top-left item.
	 LB_GETTOPINDEX:=ErrorLevel                 ; 
	 SendMessage, 0x18B, 0, 0, %FocusCtrl%, A   ; 0x18B is LB_GETCOUNT Gets the number of items in a list box.
	 LB_GETCOUNT:=ErrorLevel
	 
	 ; Start calculations
	 YMulti:=LB_GETCURSEL-LB_GETTOPINDEX
	 VisibleCount:=LB_GETCOUNT - LB_GETTOPINDEX ; Maximum number of visible rows

	 If (LB_GETCURSEL > VisibleCount)
		YMulti:=VisibleCount
	 If (LB_GETCURSEL < LB_GETTOPINDEX) or (YMulti < 1)
		YMulti:=1
	
	 Y:=CtrlY + (YMulti * LB_GETITEMHEIGHT)
	 If (Y > (CtrlHeight+CtrlY))
		Y:=CtrlHeight+CtrlY
	 Y-=Offset                                  ; We assume client mode for the menu so need some offset here
	
	 If (Position = 3)
		{ 
		 X:=CtrlX + 100
		 Pos.Insert("x", X), Pos.Insert("y", Y) 
		 Return Pos
		} 
	 Else If (Position = 4)
		{ 
		 X:= CtrlX + CtrlWidth - 5
		 Pos.Insert("x", X), Pos.Insert("y", Y) 
		 Return Pos
		}
	}

