SuperStrict

?Win32
Import MaxGUI.Win32MaxGUIEx
?
Import BaH.MathToolkit

Import brl.standardio
Import brl.pixmap
Import brl.linkedlist
Import brl.bank

?Win32 

	Import pub.win32

	Private 

		Const SM_CXVIRTUALSCREEN:Int = 78
		Const SM_CYVIRTUALSCREEN:Int = 79
		Const SM_CMONITORS:Int = 80
		Const SM_SAMEDISPLAYFORMAT:Int = 81
		Const SPI_GETDESKWALLPAPER:Int = $73

		Type TDisplay
			Global List:TList = New TList
			Field id:Int
			Field handle:Int
			Field x:Int
			Field y:Int
			Field width:Int
			Field height:Int
		End Type

		Type TRectSys
		   Field rLeft:Int
		   Field rTop:Int
		   Field rRight:Int
		   Field rBottom:Int
		End Type
		
		Extern "Win32"
			Function GetSystemMetrics:Int (nIndex:Int)"Win32"
			Function EnumDisplayMonitors:Int (hdc:Int, lprcClip:Byte Ptr, lpfnEnum:Byte Ptr, dwData:Byte Ptr)"Win32"
			Function GetCursorPos(lpPoint:Byte Ptr)"Win32" = "GetCursorPos@4"
			Function GetDIBits(hdc:Int, bitmap:Int, Start:Int, Num:Int, bits:Byte Ptr, lpbi:Byte Ptr, usage:Int)"Win32"
			Function GetWindowDC(hwnd:Int)"Win32"
			Function ReleaseDC(hwnd:Int, hdc:Int)"Win32"
			Function SystemParametersInfo (uiAction:Int, uiParam:Int, pvParam:Byte Ptr, fWinIni:Int)"Win32" = "SystemParametersInfoA@16"
		End Extern

		Function MonitorEnumProc:Byte (hMonitor:Int,hdcMonitor:Int,lprcMonitor:Byte Ptr,dwData:Int)
			Local tempRect:TRectSys = New TRectSys
			MemCopy(tempRect, lprcMonitor, SizeOf(tempRect))
			Local display:TDisplay = New TDisplay
			TDisplay.List.AddLast(display)
			display.id = TDisplay.List.Count()
			display.handle = hMonitor
			display.x = tempRect.rLeft
			display.y = tempRect.rTop
			display.width = tempRect.rRight - display.x
			display.height = tempRect.rBottom - display.y
			Return True
		End Function
		EnumDisplayMonitors (Null , Null , MonitorEnumProc , Null)
	
	Public 
?MacOS
	Import "external/SystemDesktopMacscreen.c"
	Private
		Extern
			Function CGDisplayCurrentMode:Byte Ptr(displayID:Byte Ptr)"MacOS"
			Function CGGetActiveDisplayList:Byte Ptr(kMaxDisplays:Int, display:Byte Ptr, numDisplays:Int Var)"MacOS"
			Function MACOS_GetWidth:Int(Mode:Byte Ptr)"C"
			Function MACOS_GetHeight:Int(Mode:Byte Ptr)"C"
			Function MACOS_GetBPP:Int(Mode:Byte Ptr)"C"
			Function MACOS_GetHertz:Int(Mode:Byte Ptr)"C"
		End Extern 
	Public
?

Type TSystemDesktop
	Function GetCount:Int () 
		?Win32
			Return GetSystemMetrics (SM_CMONITORS)
		?MacOS
			Local display:Byte Ptr[] = New Byte Ptr[1]
			Local iMode:Byte Ptr = Null
			Local iCount:Int
			CGGetActiveDisplayList 1, display, iCount
			Return iCount
		?
	End Function 

	Function GetWidth:Int (screen:Int=0) 
		Local width:Int,height:Int,depth:Int,hertz:Int
		Self.GetMode (width, height, depth, hertz, screen)
		Return width
	End Function 

	Function GetHeight:Int (screen:Int=0) 
		Local width:Int,height:Int,depth:Int,hertz:Int
		Self.GetMode (width, height, depth, hertz, screen)
		Return height
	End Function 

	Function GetDepth:Int (screen:Int=0) 
		Local width:Int,height:Int,depth:Int,hertz:Int
		Self.GetMode (width, height, depth, hertz, screen)
		Return depth
	End Function 

	Function GetHertz:Int (screen:Int=0) 
		Local width:Int,height:Int,depth:Int,hertz:Int
		Self.GetMode (width, height, depth, hertz, screen)
		Return hertz
	End Function 

	Function GetMode:Int (width:Int Var, height:Int Var, depth:Int Var, hertz:Int Var, screen:Int=0) 
		?Win32
			Local hwnd:Int = GetDesktopWindow()
			Local hdc:Int = GetDC(hwnd)
			If hdc = Null Then Return -1
			depth  = GetDeviceCaps(hdc, BITSPIXEL)
			hertz  = GetDeviceCaps(hdc, VREFRESH)
			ReleaseDC(hwnd,hdc)
			If screen = -1
				width = GetSystemMetrics (SM_CXVIRTUALSCREEN)
				height = GetSystemMetrics (SM_CYVIRTUALSCREEN)
			Else
				Local valid:Byte = True
				For Local display:TDisplay = EachIn TDisplay.List
					If display.id = screen+1
						width = display.width
						height = display.height
						Exit
					EndIf
				Next
			EndIf	
		?MacOS
			Local display:Byte Ptr[] = New Byte Ptr[screen+1]
			Local iMode:Byte Ptr = Null
			Local iCount:Int
			CGGetActiveDisplayList screen+1, display, iCount
			If (screen < iCount)
				iMode  = CGDisplayCurrentMode(display[screen])
			Else
				Throw " [DesktopExt] Screen '"+screen+"' does not exist!"
			End If
			width  = MACOS_GetWidth(iMode)
			height = MACOS_GetHeight(iMode)
			depth  = MACOS_GetBPP(iMode)
			hertz  = MACOS_GetHertz(iMode)
		?
	End Function 
End Type