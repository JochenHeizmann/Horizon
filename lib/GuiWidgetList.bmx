
SuperStrict
Import "UtilImage.bmx"
Import "GuiWidgetImageButton.bmx"
Import "GuiWidget.bmx"
Import "GuiScrollbarVertical.bmx"

Type TGuiWidgetList Extends TGuiWidget
	Const PADDING:Int = 10
	
	Field entryHeight:Int
	
	Field hoveredId:Int
	Field selectedId:Int
	
	Field entries:TList
	
	Field offsetY:Int
	Field font:TImageFont
	
	Field scrollbar:TGuiScrollbarVertical
	
	Method New()
		selectedId = 0
		hoveredId = -1
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
	
	Method AddEntry(s:String)
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
		UpdateScrollbar()
		SetImageFont(font)
		Local y:Float = rect.y - offsetY + PADDING / 2
		Local w:Float = rect.w
		If (scrollbar.visible) Then w :- scrollbar.rect.w
		SetViewport(rect.x, rect.y, w, rect.h)
		SetColor(0,0,0)
		Cls
		SetColor(255,255,255)
		Local bx:Int, by:Int, bw:Int, bh:Int
		
		entryHeight = TextHeight("W") + PADDING
		
		Local key:Int = 0
		For Local value:String = EachIn entries
			bx = rect.x
			by = y - PADDING / 2
			bw = w
			bh = entryHeight
			
			If (selectedId = key)
				SetAlpha(0.5)
				DrawRect bx, by, bw, bh
			Else If (hoveredId = key)
				SetAlpha(0.25)
				DrawRect bx, by, bw, bh
			End If
			SetAlpha(1)
			DrawText(value, bx + PADDING, by + PADDING / 2)
			y :+ entryHeight
			key :+ 1
		Next
		SetViewport(0, 0, GraphicsWidth(), GraphicsHeight())
	End Method
	
	Method GetDisplayHeight:Float()
		Return rect.h
	End Method
	
	Method GetListHeight:Float()
		Return CountList(entries) * entryHeight
	End Method
	
	Method OnMouseOver()
		DebugLog "GuiWidgetList OnMouseOver"
		Super.OnMouseOver()
		OnMouseMove(0,0)
		DebugLog "GuiWidgetList OnMouseOver END END"
	End Method
	
	Method OnMouseMove(dx:Int, dy:Int)
		DebugLog "Call Super.OnMouseMove (TGuiWidgetList)"
		Super.OnMouseMove(dx, dy)
		DebugLog "Called...." + entryHeight
		hoveredId = (TInputControllerMouse.GetInstance().GetY() + offsetY - rect.y) / entryHeight
		DebugLog "hoverId set"
		If (hoveredId < 0 Or hoveredId >= CountList(entries)) Then hoveredId = -1
		DebugLog "End Method"
	End Method
	
	Method OnMouseClick()
		Super.OnMouseClick()
		If hoveredId >= 0 Then selectedId = hoveredId
	End Method
	
	Method OnMouseOut()
		Super.OnMouseOut()
		hoveredId = -1
	End Method
End Type

