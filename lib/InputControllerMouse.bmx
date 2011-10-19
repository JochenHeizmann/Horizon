
SuperStrict

Type TInputControllerMouse
	Const NUM_BUTTONS:Int = 3
	
	Const BUTTON_LEFT:Int = 0
	Const BUTTON_RIGHT:Int = 1
	Const BUTTON_MIDDLE:Int = 2
	
	Const DBLCLICK_DELAY:Int = 250
	
	Global instance:TInputControllerMouse
	
	Field buttonHit:Int[NUM_BUTTONS]
	Field buttonUp:Int[NUM_BUTTONS]
	Field buttonDown:Int[NUM_BUTTONS]
	Field mouseWheel:Int, oldMouseWheel:Int 
	Field lastHit:Int[NUM_BUTTONS]
	
	Field mx:Float, my:Float
	Field oldMx:Float, oldMy:Float
	Field dx:Float, dy:Float
	
	Field time:Int
	
	Function GetInstance:TInputControllerMouse()
		If Not Self.instance
			Self.instance = New Self
		End If
		Return Self.instance
	End Function
	
	Method Refresh()
		RefreshLastHit()
		
		time = MilliSecs()
		RefreshMouseCoords()
		RefreshMouseHit()
		RefreshMouseUp()
		RefreshMouseWheel()
	End Method
	
	Method RefreshMouseCoords()
		oldMx = mx
		oldMy = my
		mx = VirtualMouseX()
		my = VirtualMouseY()		
		dx = oldMx - mx
		dy = oldMy - my
		If (dx <> 0 Or dy <> 0)
			For Local i:Int = 0 To NUM_BUTTONS-1
				lastHit[i] = 0
			Next
		End If
	End Method
	
	Method GetX:Float()
		Return mx
	End Method
	
	Method GetY:Float()
		Return my
	End Method
	
	Method GetDX:Float()
		Return dx
	End Method
	
	Method GetDY:Float()
		Return dy
	End Method
	
	Method RefreshMouseUp()
		For Local i:Int = 0 To NUM_BUTTONS-1
			Local bd:Byte = MouseDown(i + 1)
			If (buttonDown[i] And Not bd) Then buttonUp[i] = True Else buttonUp[i] = False
			buttonDown[i] = bd
		Next		
	End Method
	
	Method RefreshMouseHit()
		For Local i:Int = 0 To NUM_BUTTONS-1
			buttonHit[i] = MouseHit(i + 1)
		Next
	End Method	

	Method RefreshLastHit()
		For Local i:Int = 0 To NUM_BUTTONS-1
			If buttonHit[i] Then lastHit[i] = time
		Next
	End Method	
	
	Method RefreshMouseWheel()
		mouseWheel = MouseZ() - oldMouseWheel
		oldMouseWheel = MouseZ()
	End Method
	
	Method IsMouseDown:Int(btn:Int)
		Return buttonDown[btn]
	End Method
	
	Method IsMouseHit:Int(btn:Int)
		Return buttonHit[btn]
	End Method
	
	Method IsDoubleMouseHit:Int(btn:Int)
		Return (buttonHit[btn] And time > lastHit[btn] And lastHit[btn] + DBLCLICK_DELAY > MilliSecs())
	End Method
	
	Method IsMouseUp:Int(btn:Int)	
		Return buttonUp[btn]
	End Method
	
	Method GetMouseWheel:Int()
		Return mouseWheel
	End Method
End Type
