
SuperStrict

Import "Gui.bmx"
Import "UtilImage.bmx"
Import "GuiWidgetScrollbar.bmx"
Import "GuiWidgetScrollbarVerticalInner.bmx"

Type TGuiWidgetScrollbarVertical Extends TGuiWidgetScrollbar
	Function Create:TGuiWidgetScrollbarVertical(x:Int, y:Int, h:Int)
		Local instance:TGuiWidgetScrollbarVertical = New TGuiWidgetScrollbarVertical
		instance.x = x
		instance.y = y
		instance.h = h
		instance.Init()
		instance.innerBar = New TGuiWidgetScrollbarVerticalInner.Create(3, 4, h - 8)
		instance.AddChild(instance.innerBar)
		Return instance
	End Function	
	
	Method Init()
		imgBorder = TUtilImage.LoadStrippedImage(TGui.SKIN_PATH + "scrollbar/vertical/border.png", 3)		
		w = ImageWidth(imgBorder)
	End Method
	
	Method Draw()
		TUtilImage.DrawRepeated(imgBorder, GetX(), GetY(), w, h, 1)
		DrawImage imgBorder, GetX(), GetY(), 0
		DrawImage imgBorder, GetX(), GetY() + h - ImageHeight(imgBorder), 2
	End Method
	
	Method DoUpdate()		
		If (IsMouseOver() And TInputControllerMouse.GetInstance().IsMouseHit(TInputControllerMouse.BUTTON_LEFT))
			innerBar.y = (MouseY() - GetY()) - (innerBar.h / 2)
		End If
	End Method	
	
End Type