
SuperStrict
Import "UtilImage.bmx"
Import "Gui.bmx"
Import "GuiWidget.bmx"
Import "GuiWidgetScrollbarInner.bmx"

Type TGuiWidgetScrollbarHorizontalInner Extends TGuiWidgetScrollbarInner
	Function Create:TGuiWidgetScrollbarHorizontalInner(x:Int, y:Int, w:Int)
		Local instance:TGuiWidgetScrollbarHorizontalInner = New TGuiWidgetScrollbarHorizontalInner
		instance.x = x
		instance.y = y
		instance.w = w
		instance.Init()
		Return instance
	End Function	
	
	Method GetPos:Float()
		Return (Float(x) - minX) / Float(originalW - w)
	End Method

	Method Init()
		imgBarLeft = TUtilImage.LoadStrippedImage(TGui.SKIN_PATH + "scrollbar/horizontal/barleft.png", 3)
		imgBarMiddle = TUtilImage.LoadStrippedImage(TGui.SKIN_PATH + "scrollbar/horizontal/barmiddle.png", 3)
		imgBarRight = TUtilImage.LoadStrippedImage(TGui.SKIN_PATH + "scrollbar/horizontal/barright.png", 3)
		imgBarSign = TUtilImage.LoadStrippedImage(TGui.SKIN_PATH + "scrollbar/horizontal/barsign.png", 3)
		minX = x
		maxX = x + w
		originalW = w
		h = ImageHeight(imgBarMiddle)
		SetSize(1)
	End Method	
	
	Method SetSize(size:Float)
		w = originalW * size
		maxX = (x + originalW) - w
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
		TUtilImage.DrawRepeated(imgBarMiddle, GetX(), GetY(), w, ImageHeight(imgBarMiddle), frame)
		DrawImage imgBarLeft, GetX(), GetY(), frame
		DrawImage imgBarSign, GetX() + (w / 2) - (ImageWidth(imgBarSign) / 2), GetY(), frame
		DrawImage imgBarRight, GetX() + w - ImageWidth(imgBarRight), GetY(), frame
	End Method
	
	Method DoUpdate()		
		If (IsMouseOver() And startDrag = False And TInputControllerMouse.GetInstance().IsMouseHit(TInputControllerMouse.BUTTON_LEFT))
			startDrag = True
			dragX = MouseX() - GetX()
		End If
		If (Not MouseDown(1) And startDrag = True)
			startDrag = False
		End If	
		If startDrag
			x = MouseX() - dragX - parent.GetX()
		End If
		If x > maxX Then x = maxX
		If x < minX Then x = minX
	End Method
End Type
