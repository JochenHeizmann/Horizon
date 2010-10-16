
SuperStrict
Import "UtilImage.bmx"
Import "Gui.bmx"
Import "GuiWidget.bmx"
Import "GuiWidgetScrollbarInner.bmx"

Type TGuiWidgetScrollbarVerticalInner Extends TGuiWidgetScrollbarInner
	Function Create:TGuiWidgetScrollbarVerticalInner(x:Int, y:Int, h:Int)
		Local instance:TGuiWidgetScrollbarVerticalInner = New TGuiWidgetScrollbarVerticalInner
		instance.x = x
		instance.y = y
		instance.h = h
		instance.Init()
		Return instance
	End Function	
	
	Method GetPos:Float()
		Return (Float(y) - minY) / Float(originalH - h)
	End Method

	Method Init()
		imgBarLeft = TUtilImage.LoadStrippedImage(TGui.SKIN_PATH + "scrollbar/vertical/bartop.png", 3)
		imgBarMiddle = TUtilImage.LoadStrippedImage(TGui.SKIN_PATH + "scrollbar/vertical/barmiddle.png", 3)
		imgBarRight = TUtilImage.LoadStrippedImage(TGui.SKIN_PATH + "scrollbar/vertical/barbottom.png", 3)
		imgBarSign = TUtilImage.LoadStrippedImage(TGui.SKIN_PATH + "scrollbar/vertical/barsign.png", 3)
		minY = y
		maxY = y + h
		originalH = h
		w = ImageWidth(imgBarMiddle)
		SetSize(1)
	End Method	
	
	Method SetSize(size:Float)
		h = originalH * size
		maxY = (y + originalH) - h
	End Method
	
	Method Draw()
		Local frame:Int = 0
		Select (GetWidgetState())
			Case HOVER
				frame = 1
			Case DOWN
				frame = 2
			Default
				frame = 0
		End Select
		TUtilImage.DrawRepeated(imgBarMiddle, GetX(), GetY(), ImageWidth(imgBarMiddle), h, frame)
		DrawImage imgBarLeft, GetX(), GetY(), frame
		DrawImage imgBarSign, GetX(), GetY() + (h / 2) - (ImageHeight(imgBarSign) / 2), frame
		DrawImage imgBarRight, GetX(), GetY() + h - ImageHeight(imgBarRight), frame
	End Method
	
	Method DoUpdate()		
		If (IsMouseOver() And startDrag = False And TInputControllerMouse.GetInstance().IsMouseHit(TInputControllerMouse.BUTTON_LEFT))
			startDrag = True
			dragY = MouseY() - GetY()
		End If
		If (Not MouseDown(1) And startDrag = True)
			startDrag = False
		End If	
		If startDrag
			y = MouseY() - dragY - parent.GetY()
		End If
		If y > maxY Then y = maxY
		If y < minY Then y = minY
	End Method
End Type
