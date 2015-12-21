
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

	Function ResetVP()
		TGuiVP.vpX = 0
		TGuiVP.vpY = 0
		TGuiVP.vpW = VirtualResolutionWidth()
		TGuiVP.vpH = VirtualResolutionHeight()
		SetViewport(TGuiVP.vpX, TGuiVP.vpY, TGuiVP.vpW, TGuiVP.vpH)
		SetOrigin(0,0)
	End Function
		
	Function Init()
		widgets = CreateList()
		mouse = TInputControllerMouse.GetInstance()
		ResetVP()
		TGuiVP.Add(0,0,VirtualResolutionWidth(),VirtualResolutionHeight())
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


Type TGuiVP
	Field x:Int, y:Int, w:Int, h:Int			'This viewport
	Global VPs:TList = New TList				'Viewports list
	Global vpX:Int, vpY:Int, vpW:Int, vpH:Int	'Current ViewPort
	
	Function Push()
		Local vp:TGuiVP = New TGuiVP
		vp.x = vpX;vp.y = vpY;vp.w = vpW;vp.h = vpH
		VPs.AddFirst(vp)
	End Function

	Function Pop()
		Local vp:TGuiVP = TGuiVP(VPs.RemoveFirst())
		vpX = vp.x;vpY = vp.y;vpW = vp.w;vpH = vp.h
		SetViewport(vpX,vpY,vpW,vpH)
	End Function

	Function Add(iX:Int, iY:Int, iW:Int, iH:Int)
		Local vp:TGuiVP = New TGuiVP
		vp.x = vpX;vp.y = vpY;vp.w = vpW;vp.h = vpH
		VPs.AddFirst(vp)
		If iX < vp.x
		 iW:-(vp.x - iX)
			iX = vp.X
		End If
		If iY < vp.y
			iH:-(vp.y - iY)
		 iY = vp.y
		End If
		If iX + iW > vp.x + vp.w iW:-((iX + iW) - (vp.x + vp.w))
		If iY + iH > vp.y + vp.h iH:-((iy + iH) - (vp.y + vp.h))
		vpX = iX;vpY = iY;vpW = iW;vpH = iH
		SetViewport(vpX,vpY,vpW,vpH)
	End Function
	
End Type
