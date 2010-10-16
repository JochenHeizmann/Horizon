
SuperStrict

Import BRL.LinkedList
Import BRL.Max2D

Import "InputControllerMouse.bmx"

Type TGuiWidget
	Global focus:Byte
	
	Field x:Int, y:Int
	Field w:Int, h:Int
	Field parent:TGuiWidget
	Field childs:TList
	Field visible:Byte

	Const NORMAL:Int = 0
	Const HOVER:Int = 1
	Const DOWN:Int = 2

	Field widgetState:Int, movedIn:Byte = False
	Field previousState:Int[TInputControllerMouse.NUM_BUTTONS]
	
	Method IsMouseDown:Byte(button:Int = TInputControllerMouse.BUTTON_LEFT)
		If (IsMouseOver() And TInputControllerMouse.GetInstance().IsMouseDown(button))			
			Return True
		End If
	End Method
	
	Method IsMouseUp:Byte(button:Int = TInputControllerMouse.BUTTON_LEFT)
		If (IsMouseOver() And TInputControllerMouse.GetInstance().IsMouseUp(button))
			DebugLog "up"
			Return True
		End If		
	End Method
	
	Method IsClicked:Byte(button:Int = TInputControllerMouse.BUTTON_LEFT)
		If previousState[button] And IsMouseUp() Then Return True
		previousState[button] = IsMouseDown(button)
		Return False
	End Method
	
	'this method doesnt work with childs on the same hierarchy
	Method IsMouseOver:Byte(start:Int = 0)		
		If (Not IsVisible()) Then Return False
		If (IsMouseOverWidgetPosition())
			Local response:Byte = True
			For Local child:TGUiWidget = EachIn childs
				If (child.IsMouseOver()) Then Return False
			Next
			Return True
		Else
			Return False
		End If
	End Method
	
	Method IsMouseHit:Byte(button:Int = TInputControllerMouse.BUTTON_LEFT)
		Return (IsMouseOver() And TInputControllerMouse.GetInstance().IsMouseHit(button))
	End Method
	
	Method IsMouseOverWidgetPosition:Byte()	
		Return (MouseX() >= GetX() And MouseX() <= (GetX() + w) And MouseY() >= GetY() And MouseY() <= (GetY() + h))
	End Method
	
	Method DestroyChilds()
		For Local child:TGUiWidget = EachIn childs
			child.DestroyChilds()
			child = Null
		Next
	End Method

	Method New()
		visible = True
		childs = CreateList()
	End Method
	
	Method Hide()
		visible = False
	End Method
	
	Method Show()
		visible = True
	End Method
	
	Method IsVisible:Byte()
		Return visible
	End Method
	
	Method Draw()
	End Method
		
	Method Update() Final
		If (IsVisible())
			UpdateWidgetState()
			DoUpdate()
			UpdateChilds()
		End If
	End Method
	
	Method UpdateWidgetState()		
		If (IsMouseOver()) And TInputControllerMouse.GetInstance().IsMouseHit(TInputControllerMouse.BUTTON_LEFT)
			widgetState = DOWN
		Else If (IsMouseOver() And widgetState <> DOWN And Not TInputControllerMouse.GetInstance().IsMouseDown(TInputControllerMouse.BUTTON_LEFT))
 			widgetState = HOVER
		Else If (Not TInputControllerMouse.GetInstance().IsMouseDown(TInputControllerMouse.BUTTON_LEFT))
			widgetState = NORMAL
		End If
	End Method
	
	Method GetWidgetState:Int()
		Return widgetState
	End Method
	
	Method DoUpdate()
	End Method
	
	Method UpdateChilds()
		For Local child:TGuiWidget = EachIn childs
			child.Update()
		Next
	End Method
	
	Method GetX:Int()
		Local _x:Int = x
		If (parent)
			_x :+ parent.GetX()
		End If
		Return _x
	End Method

	Method GetY:Int()
		Local _y:Int = y
		If (parent)
			_y :+ parent.GetY()
		End If
		Return _y:Int
	End Method
		
	Method Render() Final
		If (Not visible) Then Return
		Local oldViewportX:Int, oldViewportY:Int, oldViewportW:Int, oldViewportH:Int
		Local viewportX:Int, viewportY:Int, viewportW:Int, viewportH:Int		
		GetViewport(oldViewportX, oldViewportY, oldViewportW, oldViewportH)
		
		If (GetX() > oldViewportX) Then viewportX = GetX() Else viewportX = oldViewportX
		If (GetY() > oldViewportY) Then viewportY = GetY() Else viewportY = oldViewportY

		If (w < oldViewportW) Then viewportW = w Else viewportW = oldViewportW
		If (h < oldViewportH) Then viewportH = h Else viewportH = oldViewportH
		
		If GetX() < 0 Then viewportW :+ GetX()
		If GetY() < 0 Then viewportH :+ GetY()
		
		Local difX:Int = (oldViewportX + oldViewportW) - (viewportX + viewportW)	
		Local x2:Int = viewportX + viewportW
		Local oldX2:Int = oldViewportX + oldViewportW
		If (difX < 0) Then viewportW :+ difX
		
		Local difY:Int = (oldViewportY + oldViewportH) - (viewportY + viewportH)	
		Local y2:Int = viewportY + viewportH
		Local oldY2:Int = oldViewportY + oldViewportH
		If (difY < 0) Then viewportH :+ difY		
		
		SetViewport(viewportX, viewportY, viewportW, viewportH)
		Draw()
		RenderChilds()

		SetViewport(oldViewportX, oldViewportY, oldViewportW, oldViewportH)
	End Method
	
	Method RenderChilds()
		For Local child:TGuiWidget = EachIn childs
			child.Render()
		Next
	End Method
	
	Method AddChild(child:TGuiWidget)
		child.parent = Self
		ListAddLast(childs, child)		
	End Method	
End Type