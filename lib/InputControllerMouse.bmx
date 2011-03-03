
SuperStrict

Type TInputControllerMouse
	Const NUM_BUTTONS:Int = 3
	
	Const BUTTON_LEFT:Int = 0
	Const BUTTON_RIGHT:Int = 1
	Const BUTTON_MIDDLE:Int = 2
	
	Global instance:TInputControllerMouse
	
	Field buttonHit:Int[NUM_BUTTONS]
	Field buttonUp:Int[NUM_BUTTONS]
	Field buttonDown:Int[NUM_BUTTONS]
	Field mouseWheel:Int, oldMouseWheel:Int 
	
	Field mx : Int, my : Int
	Field oldMx : Int, oldMy : Int
	Field dx : Int, dy : Int
	
	Function GetInstance:TInputControllerMouse()
		If Not Self.instance
			Self.instance = New Self
		End If
		Return Self.instance
	End Function
	
	Method Refresh()
		RefreshMouseCoords()
		RefreshMouseHit()
		RefreshMouseUp()
		RefreshMouseWheel()
	End Method
	
	Method RefreshMouseCoords()
		oldMx = mx
		oldMy = my
		mx = MouseX()
		my = MouseY()
		dx = oldMx - mx
		dy = oldMy - my
	End Method
	
	Method GetX : Int()
		Return mx
	End Method
	
	Method GetY : Int()
		Return my
	End Method
	
	Method GetDX : Int()
		Return dx
	End Method
	
	Method GetDY : Int()
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
	
	Method RefreshMouseWheel()

	End Method
	
	Method IsMouseDown:Int(btn:Int)
		Return buttonDown[btn]
	End Method
	
	Method IsMouseHit:Int(btn:Int)
		Return buttonHit[btn]
	End Method
	
	Method IsMouseUp:Int(btn:Int)	
		Return buttonUp[btn]
	End Method
	
	Method GetMouseWheel:Int()
		Local ret:Int = MouseZ() - oldMouseWheel
		oldMouseWheel = MouseZ()
		Return ret
	End Method
End Type
