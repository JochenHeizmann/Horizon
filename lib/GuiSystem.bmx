
SuperStrict

Import "InputControllerMouse.bmx"
Import "GuiBase.bmx"

Type TGuiSystem
	Global topElement : TGuiBase
	Global selectedElement : TGuiBase
	Global activeElement : TGuiBase
	Global modalElement : TGuiBase

	Global widgets : TList
	Global mouse : TInputControllerMouse

	Global SKIN_PATH:String = "data/gui/default/"

	Function Init()
		widgets = CreateList()
		mouse = TInputControllerMouse.GetInstance()
	End Function
	
	Function RenderAll(darkenBG:Byte = True)
		For Local w : TGuiBase = EachIn widgets
			If w.visible And w.autoRender
				If (darkenBG And w = modalElement)
					SetAlpha(0.7)
					SetColor(0,0,0)
					DrawRect 0,0,GraphicsWidth(), GraphicsHeight()
					SetColor(255,255,255)
					SetAlpha(1)
					w.Render()
				Else
					w.Render()
				End If
			End If
		Next
	End Function
	
	Function ClearWidgets()
		topElement = Null
		selectedElement = Null
		activeElement = Null
		modalElement = Null
		ClearList(widgets)
	End Function
	
	Function HideAllWidgets()
		For Local w:TGuiBase = EachIn widgets
			w.Hide()
		Next
	End Function
	
	Function RemoveWidget(w:TGuiBase)
		For Local w:TGuiBase = EachIn w.childs
			RemoveWidget(w)
		Next
		ListRemove(widgets, w)
	End Function
	
	Function GetModalElement:TGuiBase()
		Local m:TGuiBase
		For Local w : TGuiBase = EachIn widgets
			If w.visible And w.isModal
				m = w
			End If
		Next
		Return m
	End Function
	
	Function ProcessMessages()
		Local oldTopElement : TGuiBase = topElement
		modalElement = GetModalElement()
			
		If Not mouse.IsMouseDown(mouse.BUTTON_LEFT)
			topElement = Null
			For Local w : TGuiBase = EachIn widgets
				If w.visible And w.IsChildOf(modalElement)
					If (w.rect.IsInRect(mouse.GetX(), mouse.GetY()))
						topElement = w
					End If
				End If
			Next
		End If

		For Local w : TGuiBase = EachIn widgets
			If w.visible 'And w.IsChildOf(modalElement)
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

