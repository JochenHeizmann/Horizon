
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
	
	Function GetInstance:TInputControllerMouse()
		If Not Self.instance
			Self.instance = New Self
		End If
		Return Self.instance
	End Function
	
	Method Refresh()
		RefreshMouseHit()
		RefreshMouseUp()
		RefreshMouseWheel()
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
