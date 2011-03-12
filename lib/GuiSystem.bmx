
SuperStrict

Import "InputControllerMouse.bmx"
Import "GuiBase.bmx"

Type TGuiSystem
	Global topElement : TGuiBase
	Global selectedElement : TGuiBase
	Global activeElement : TGuiBase

	Global widgets : TList
	Global mouse : TInputControllerMouse

	Global SKIN_PATH:String = "data/gui/default/"

	Function Init()
		widgets = CreateList()
		mouse = TInputControllerMouse.GetInstance()
	End Function
	
	Function RenderAll()
		For Local w : TGuiBase = EachIn widgets
			If w.visible Then w.Render()
		Next
	End Function
	
	Function ClearWidgets()
		ClearList(widgets)
	End Function
	
	Function HideAllWidgets()
		For Local w:TGuiBase = EachIn widgets
			w.Hide()
		Next
	End Function

	Function ProcessMessages()
		Local oldTopElement : TGuiBase = topElement
		If Not mouse.IsMouseDown(mouse.BUTTON_LEFT)
			topElement = Null
		
			For Local w : TGuiBase = EachIn widgets
				If w.visible
					If (w.rect.IsInRect(mouse.GetX(), mouse.GetY()))
						topElement = w
					End If
				End If
			Next
		End If
		
		For Local w : TGuiBase = EachIn widgets
			If w.visible
				w.Update()
			End If
		Next
		
		' send onMouseOver / onMouseOut
		If (topElement <> oldTopElement)
			If (topElement) Then topElement.OnMouseOver()
			If (oldTopElement) Then oldTopElement.OnMouseOut()
		End If
		
		If (mouse.IsMouseHit(mouse.BUTTON_LEFT))
			activeElement = Null
		End If
		
		If (topElement)
			If (mouse.IsMouseHit(mouse.BUTTON_LEFT))
				topElement.OnMouseHit()
				selectedElement = topElement
				activeElement = topElement
				activeElement.OnActivate()
			End If
		
			If (mouse.IsMouseHit(mouse.BUTTON_RIGHT))
				topElement.OnRMouseHit()
				selectedElement = topElement
				activeElement = topElement
				activeElement.OnActivate()
			End If
		
			If (mouse.IsMouseDown(mouse.BUTTON_LEFT))
				topElement.OnMouseDown()
			End If
			
			If (mouse.IsMouseDown(mouse.BUTTON_RIGHT))
				topElement.OnRMouseDown()
			End If
		
			If (mouse.GetDX() <> 0 Or mouse.GetDY() <> 0)
				topElement.OnMouseMove(mouse.GetDX(), mouse.GetDY())
			End If
		End If				
		
		If (mouse.IsMouseUp(mouse.BUTTON_RIGHT))
			If topElement Then topElement.OnRMouseUp()
		End If

		If (selectedElement And mouse.IsMouseUp(mouse.BUTTON_LEFT))
			selectedElement.OnMouseUp()
			If (topElement = selectedElement) Then selectedElement.OnMouseClick()
			selectedElement = Null
		End If			
		
		If (activeElement And Not activeElement.visible) Then activeElement = Null
	End Function
End Type

