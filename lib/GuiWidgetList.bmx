
SuperStrict
Import "GuiUtilImage.bmx"
Import "GuiWidgetImageButton.bmx"
Import "GuiWidget.bmx"
Import "GuiScrollbarVertical.bmx"

Type TGuiWidgetList Extends TGuiWidget
	Const PADDING:Int = 10
	
	Field entryHeight:Int
	
	Field hovered:Object
	Field selected:Object
	
	Field entries:TList
	
	Field offsetY:Int
	Field font:TImageFont
	
	Field scrollbar:TGuiScrollbarVertical
	
	Method New()
		selected = Null
		hovered = Null
		rect.w = 500
		rect.h = 340
		rect.x = 100
		rect.y = 100
		entries = CreateList()		

		entryHeight = TextHeight("W") + PADDING

		scrollbar = New TGuiScrollbarVertical
		AddChild(scrollbar)		
	End Method
	
	Method UpdateScrollbar()
		scrollbar.rect.x = rect.x + rect.w - scrollbar.rect.w
		scrollbar.rect.y = rect.y
		scrollbar.SetWidgetHeight(rect.h)
		scrollbar.minValue = 0
		scrollbar.currValue = scrollbar.minValue
		scrollbar.maxValue = Max(0, GetListHeight() - GetDisplayHeight()) / GetDisplayHeight()
		scrollbar.UpdateScrollbarButtons()
		If (GetDisplayHeight() >= GetListHeight())
			scrollbar.Hide()
		Else
			scrollbar.Show()
		End If
	End Method
	
	Method AddEntry(s:Object)
		ListAddLast(entries, s) 
	End Method
	
	Method ClearEntries()
		ClearList(entries)
	End Method
	
	Method Update()
		offsetY = GetDisplayHeight() * scrollbar.GetValue()
		
		If (TInputControllerMouse.GetInstance().GetMouseWheel() <> 0 And widgetState = HOVER)
			scrollbar.MoveBar(-TInputControllerMouse.GetInstance().GetMouseWheel() * scrollbar.GetBarHeight() / 150)
			OnMouseMove(0,0)
		End If
	End Method
	
	Method Render()
		Local oldViewportX:Int, oldViewportY:Int, oldViewportW:Int, oldViewportH:Int

		oldViewportX = TGuiVP.vpX
		oldViewportY = TGuiVP.vpY
		oldViewportW = TGuiVP.vpW
		oldViewportH = TGuiVP.vpH
		UpdateScrollbar()
		SetImageFont(font)
		Local y:Float = rect.y - offsetY + PADDING / 2
		Local w:Float = rect.w
		If (scrollbar.visible) Then w:-scrollbar.rect.w
		Local tx:Int,ty:Int,tw:Int,th:Int
		tx = rect.x
		ty = rect.y
		tw = w
		If tw > oldViewportW Then tw = oldViewportW
		th = rect.h
		If th + ty > oldViewportH Then th = oldViewportH - ty
		'SetViewport(tx, ty , tw, th)
		TGuiVP.Add(tx, ty , tw, th)
		SetColor(0, 0, 0)
		SetAlpha(0.4)
		DrawRect(rect.X, rect.Y, w, rect.h)
		SetAlpha(1)
		SetColor(255, 255, 255)
		Local bx:Int, by:Int, bw:Int, bh:Int
		
		entryHeight = TextHeight("W") + PADDING
		
		Local key:Int = 0
		For Local obj:Object = EachIn entries
			Local value:String = obj.toString()
			bx = rect.x
			by = y - PADDING / 2
			bw = w
			bh = entryHeight
			
			If (selected = obj)
				SetAlpha(0.5)
				DrawRect bx, by, bw, bh
			Else If (hovered = obj)
				SetAlpha(0.25)
				DrawRect bx, by, bw, bh
			End If
			SetAlpha(1)
			DrawText(value, bx + PADDING, by + PADDING / 2)
			y :+ entryHeight
			key :+ 1
		Next
		'SetViewport(0, 0, VirtualResolutionWidth(), VirtualResolutionHeight())
		'SetViewport(oldViewportX, oldViewportY, oldViewportW, oldViewportH)
		TGuiVP.Pop()
	End Method
	
	Method GetDisplayHeight:Float()
		Return rect.h
	End Method
	
	Method GetListHeight:Float()
		Return CountList(entries) * entryHeight
	End Method
	
	Method OnMouseOver()
		Super.OnMouseOver()
		OnMouseMove(0, 0)
	End Method
	
	Method OnMouseMove(dx:Int, dy:Int)
		Super.OnMouseMove(dx, dy)
		Local hoveredId:Int = (TInputControllerMouse.GetInstance().GetY() + offsetY - rect.Y) / entryHeight
		If (CountList(entries) > hoveredId And hoveredId >= 0)
			hovered = entries.ValueAtIndex(hoveredId)
		Else
			hovered = Null
		End If
	End Method
	
	Method OnMouseClick()
		Super.OnMouseClick()
		If hovered Then selected = hovered
	End Method
	
	Method OnMouseOut()
		Super.OnMouseOut()
		hovered = Null
	End Method
End Type

