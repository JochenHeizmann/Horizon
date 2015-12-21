
SuperStrict

Import "GuiWidgetFrame.bmx"
Import "GuiWidgetImageButton.bmx"

Type TGuiWidgetWindow Extends TGuiWidgetFrame
	
	Field buttons:Int = 0
	Field minW:Int = 80
	Field minH:Int = 50
	
	Field isFolded:Byte = False
	Field unfoldedH:Int
	
	Const TITLE_CENTER:Int = 0
	Const TITLE_LEFT:Int	= 1
	Const TITLE_RIGHT:Int = 2
	Field titleAlign:Int
	
	Field clickToFront:Byte = True
	Field showStatusBar:Byte = True
	
	Field btnClose:TGuiWidgetWindowButton
	Field btnFold:TGuiWidgetWindowButton
	Field btnZOrder:TGuiWidgetWindowButton
	Field btnResize:TGuiWidgetWindowButton
	
	Const STYLE_RESIZE:Int	= %00000001
	Const STYLE_CLOSE:Int	= %00000010
	Const STYLE_DRAG:Int		= %00000100
	Const STYLE_FOLD:Int		= %00001000
	Const STYLE_ZORDER:Int	= %00010000
	Const STYLE_FULL:Int		= STYLE_CLOSE|STYLE_FOLD|STYLE_DRAG|STYLE_RESIZE|STYLE_ZORDER
	Const STYLE_STD:Int		= STYLE_CLOSE|STYLE_FOLD|STYLE_DRAG|STYLE_RESIZE

	Function Create : TGuiWidgetWindow(x:Int, y:Int, w:Int = 0, h:Int = 0,style:Int = STYLE_STD)
		Local instance : TGuiWidgetWindow = New TGuiWidgetWindow
		instance.rect.x = x
		instance.rect.y = y
		instance.rect.w = w
		instance.rect.h = h
		instance.style = style
		instance.SetStyle(style)		
		Return instance
	End Function
	
	Method AddChild(w:TGuiWidget)
		If (w.parent) Then w.parent.RemoveChild(w)
		ListAddLast(childs, w)
		AutoRenderOff(w)
		w.parent = Self
		w.rect.x = GetInnerWindowX() + 2
		w.rect.y = GetInnerWindowY() + 2
	End Method
	
	Method AutoRenderOff(w:TGuiWidget)
		If Not TGuiWidgetWindowButton(w) Then w.SetAutoRender(False) 'w.autoRender = False
		For Local c:TGuiWidget = EachIn w.childs
			AutoRenderOff(c)
		Next
	End Method
	
	Method SetStyle(winStyle:Int = STYLE_STD, align:Int = TITLE_CENTER )
		style = winStyle
		titleAlign = align
		If (style & STYLE_CLOSE) And Not btnClose
			btnClose = TGuiWidgetWindowButton.Create(TGuiSystem.SKIN_PATH + "window/close.png", 25, 25)
			AddChild(btnClose)
			btnClose.rect.y = GetY()
			btnClose.rect.x = GetX() + btnClose.rect.w * buttons
			buttons :+ 1
		EndIf
		If (style & STYLE_FOLD) And Not btnFold
			btnFold = TGuiWidgetWindowButton.Create(TGuiSystem.SKIN_PATH + "window/minimize.png", 25, 25)
			AddChild(btnFold)
			btnFold.rect.y = GetY()
			btnFold.rect.x = GetX() + 4 + btnFold.rect.w * buttons
			buttons :+ 1
		EndIf
		If (style & STYLE_ZORDER) And Not btnZOrder
			btnZOrder = TGuiWidgetWindowButton.Create(TGuiSystem.SKIN_PATH + "window/zorder.png", 25, 25)
			AddChild(btnZOrder)
			btnZOrder.rect.y = GetY()
			btnZOrder.rect.x = GetX() + 4 + btnZOrder.rect.w * buttons
			buttons :+ 1
		EndIf
		If (style & STYLE_RESIZE) And Not btnResize
			btnResize = TGuiWidgetWindowButton.Create(TGuiSystem.SKIN_PATH + "window/resize.png", 25, 25)
			AddChild(btnResize)
			btnResize.rect.y = GetY() + GetH() - btnResize.rect.h - 1
			btnResize.rect.x = GetX() + GetW() - btnResize.rect.w - 3
		EndIf
	End Method
	
	Method ToFront()
		If clickToFront Then Super.ToFront()
	End Method
	
	Method Fold()
		If isFolded
			rect.h = unfoldedH
			If btnResize Then btnResize.Show()
		Else
			unfoldedH = GetH()
			If btnResize Then btnResize.Hide()
			rect.h = ImageHeight(topBar)
		EndIf
		isfolded =~ isfolded
	End Method
	
	Method ChangeZOrder()
		Local lastWindow:Int
		Local myPosition:Int
			
		For Local w : TGuiWidget = EachIn TGuiSystem.widgets
			If TGuiWidgetWindow(w)
				lastWindow :+ 1
				If TGuiWidgetWindow(w) = Self Then myPosition = lastWindow
			EndIf
		Next
		If lastWindow > myPosition Then Super.ToFront() Else Super.ToBack()
		btnZOrder.clicked = False 	'Not so fair, but without this call the button stays clicked forever...
										'... and the Gui library enters an endless loop.
	End Method
	
	Method Render()
		DrawTopBar()
		If Not isfolded
			DrawBottomBorder()
			DrawRightBorder()
			DrawLeftBorder()
			If showStatusBar
				TGuiVP.Add(GetInnerWindowX(), GetInnerWindowY(), GetInnerWidth(), GetInnerHeight())
			Else
				TGuiVP.Add(GetInnerWindowX(), GetInnerWindowY(), GetInnerWidth(), GetInnerHeight()+ImageHeight(resizeBottom)-1)
			EndIf
			SetClsColor(230,230,230)
			Cls
			'Render widgets inside window's frame
			For Local c : TGuiWidget = EachIn childs
				RenderChilds(c)
			Next
			SetColor(255,255,255)
			SetClsColor(0,0,0)
			TGuiVP.Pop()
		EndIf
	End Method
	
	Method RenderChilds(w:TGuiWidget)
		TGuiVP.Add(GetInnerWindowX(), GetInnerWindowY(), GetInnerWidth(), GetInnerHeight())
		w.Render()
		For Local c : TGuiWidget = EachIn w.childs
			RenderChilds(c)
		Next
		TGuiVP.Pop()
	End Method
	
	Method GetW : Int()
		Return rect.w
	End Method
	
	Method GetH : Int()
		Return rect.h
	End Method
	
	Method DrawTopBar()
		TGuiUtilImage.DrawRepeated(topBar, GetX(), GetY(), rect.w, ImageHeight(topBar))		
		Local offset:Int = (buttons)*24
		'SetViewport(GetX()+offset, GetY(), GetW()-offset-2, ImageHeight(topBar))
		TGuiVP.Add(GetX()+offset, GetY(), GetW()-offset-2, ImageHeight(topBar))
		Select titleAlign
			Case TITLE_CENTER
				DrawText (title, GetX()+offset+(GetW()-TextWidth(title)-offset)/2, GetY() + 6) 'Align Center
			Case TITLE_RIGHT
				DrawText (title, GetX()+GetW()-TextWidth(title), GetY() + 6) 'Align Right
			Case TITLE_LEFT
				DrawText (title, GetX()+offset, GetY() + 6) 'Align Left
		End Select
		'SetViewport(0,0,GraphicsWidth(), GraphicsHeight())
		TGuiVP.Pop()
		'SetOrigin(0,0)
	End Method

	Method DrawBottomBorder()
		If showStatusBar
			TGuiUtilImage.DrawRepeated(resizeBottom, GetX(), GetY() + rect.h - ImageHeight(resizeBottom) - ImageHeight(bottomBorder), rect.w, ImageHeight(resizeBottom))
			SetColor($CC,$CC,$CC)
			'SetViewport(GetX(), GetY() + rect.h - ImageHeight(resizeBottom), GetW()-2, ImageHeight(resizeBottom))
			TGuiVP.Add(GetX(), GetY() + rect.h - ImageHeight(resizeBottom), GetW()-2, ImageHeight(resizeBottom))
			DrawText (status, GetX() + ImageWidth(leftBorder), GetY() + rect.h - ImageHeight(resizeBottom))
			SetColor($FF,$FF,$FF)
			'SetViewport(0,0,GraphicsWidth(), GraphicsHeight())
			TGuiVP.Pop()
			'SetOrigin(0,0)
		EndIf
		TGuiUtilImage.DrawRepeated(bottomBorder, GetX(), GetY() + rect.h - ImageHeight(bottomBorder), rect.w, ImageHeight(bottomBorder))		
	End Method	

	Method Update()
		Super.Update()
		If btnResize And btnResize.WidgetState = TGUIWidget.DOWN
			rect.w = GetW() - TGuiSystem.mouse.GetDX()
			If rect.w < minW Then rect.w = minW
			rect.h = GetH() - TGuiSystem.mouse.GetDY()
			If rect.h < minH Then rect.h = minH
			btnResize.rect.y = GetY() + GetH() - btnResize.rect.h - 1
			btnResize.rect.x = GetX() + GetW() - btnResize.rect.w - 3
		EndIf
		If btnFold And btnFold.IsClicked() Then Fold()
		If btnZOrder And btnZOrder.IsClicked() Then ChangeZOrder()
	End Method
End Type

Type TGuiWidgetWindowButton Extends TGuiWidgetImageButton
	
	Function Create:TGuiWidgetWindowButton(imageFilename:String, x:Int, y:Int, noDownImage:Int = False)
		Local instance:TGuiWidgetWindowbutton = New TGuiWidgetWindowbutton
		instance.rect.SetXY(x, y)
		AutoMidHandle False
		Local tmpImg:TImage = LoadImage(imageFilename)
		If (Not tmpimg) Then RuntimeError("Image " + imageFilename + " couldn't be loaded!")
		Local numImages : Int = 3
		If noDownImage Then numImages = 2
		Local frameWidth:Int = ImageWidth(tmpImg) / numImages
		Local frameHeight:Int = ImageHeight(tmpImg)
		instance.rect.SetWidth(frameWidth)
		instance.rect.SetHeight(frameHeight)
		instance.noDownImage = noDownImage
		instance.img = LoadAnimImage(imageFilename, frameWidth, frameHeight, 0, numImages)
		Return instance
	End Function

	Method ToFront()
		If parent And TGuiWidgetWindow(parent).clickToFront Then Super.ToFront()
	End Method
End Type
