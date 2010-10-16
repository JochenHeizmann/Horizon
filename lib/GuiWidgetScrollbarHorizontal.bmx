
SuperStrict

Import "Gui.bmx"
Import "UtilImage.bmx"
Import "GuiWidgetScrollbar.bmx"
Import "GuiWidgetScrollbarHorizontalInner.bmx"

Type TGuiWidgetScrollbarHorizontal Extends TGuiWidgetScrollbar
	Function Create:TGuiWidgetScrollbarHorizontal(x:Int, y:Int, w:Int)
		Local instance:TGuiWidgetScrollbarHorizontal = New TGuiWidgetScrollbarHorizontal
		instance.x = x
		instance.y = y
		instance.w = w
		instance.Init()
		instance.innerBar = New TGuiWidgetScrollbarHorizontalInner.Create(4, 3, w - 8)
		instance.AddChild(instance.innerBar)
		Return instance
	End Function	
	
	Method Init()
		imgBorder = TUtilImage.LoadStrippedImage(TGui.SKIN_PATH + "scrollbar/horizontal/border.png", 3)		
		h = ImageHeight(imgBorder)
	End Method
	
	Method Draw()
		TUtilImage.DrawRepeated(imgBorder, GetX(), GetY(), w, h, 1)
		DrawImage imgBorder, GetX(), GetY(), 0
		DrawImage imgBorder, GetX() + w - ImageWidth(imgBorder), GetY(), 2
	End Method
	
	Method DoUpdate()		
		If (IsMouseOver() And TInputControllerMouse.GetInstance().IsMouseHit(TInputControllerMouse.BUTTON_LEFT))
			innerBar.x = (MouseX() - GetX()) - (innerBar.w / 2)
		End If
	End Method	
End Type