
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
	
	Field btnClose:TGuiWidgetImagebutton
	Field btnFold:TGuiWidgetImagebutton
	Field btnZOrder:TGuiWidgetImagebutton
	Field btnResize:TGuiWidgetImagebutton
	
	Const STYLE_RESIZE:Int	= %00000001
	Const STYLE_CLOSE:Int	= %00000010
	Const STYLE_DRAG:Int		= %00000100
	Const STYLE_FOLD:Int		= %00001000
	Const STYLE_ZORDER:Int	= %00010000
	Const STYLE_FULL:Int		= STYLE_CLOSE|STYLE_FOLD|STYLE_DRAG|STYLE_RESIZE|STYLE_ZORDER

	Function Create : TGuiWidgetWindow(x:Int, y:Int, w:Int = 0, h:Int = 0,style:Int = STYLE_FULL)
		Local instance : TGuiWidgetWindow = New TGuiWidgetWindow
		instance.rect.x = x
		instance.rect.y = y
		instance.rect.w = w
		instance.rect.h = h
		instance.style = style
		instance.SetStyle(style)		
		Return instance
	End Function
	
	Method New()
		style = STYLE_FULL
		InitWidget()
	End Method
	
	Method SetStyle(winStyle:Int = STYLE_FULL, align:Int = TITLE_CENTER )
		style = winStyle
		titleAlign = align
		If (style & STYLE_CLOSE) And Not btnClose
			btnClose = TGuiWidgetImagebutton.Create(TGuiSystem.SKIN_PATH + "window/close.png", 25, 25)
			AddChild(btnClose)
			btnClose.rect.y = GetY()
			btnClose.rect.x = GetX() + btnClose.rect.w * buttons
			buttons :+ 1
		EndIf
		If (style & STYLE_FOLD) And Not btnFold
			btnFold = TGuiWidgetImagebutton.Create(TGuiSystem.SKIN_PATH + "window/minimize.png", 25, 25)
			AddChild(btnFold)
			btnFold.rect.y = GetY()
			btnFold.rect.x = GetX() + 4 + btnFold.rect.w * buttons
			buttons :+ 1
		EndIf
		If (style & STYLE_ZORDER) And Not btnZOrder
			btnZOrder = TGuiWidgetImagebutton.Create(TGuiSystem.SKIN_PATH + "window/zorder.png", 25, 25)
			AddChild(btnZOrder)
			btnZOrder.rect.y = GetY()
			btnZOrder.rect.x = GetX() + 4 + btnZOrder.rect.w * buttons
			buttons :+ 1
		EndIf
		If (style & STYLE_RESIZE) And Not btnResize
			btnResize = TGuiWidgetImagebutton.Create(TGuiSystem.SKIN_PATH + "window/resize.png", 25, 25)
			AddChild(btnResize)
			btnResize.rect.y = GetY() + GetH() - btnResize.rect.h - 1
			btnResize.rect.x = GetX() + GetW() - btnResize.rect.w - 1
			buttons :+ 1
		EndIf
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
	
	Method Render()
		DrawTopBar()
		If Not isfolded
			DrawBottomBorder()
			DrawRightBorder()
			DrawLeftBorder()
			SetViewport(GetInnerWindowX(), GetInnerWindowY(), GetInnerWidth(), GetInnerHeight())
			SetOrigin(GetInnerWindowX(), GetInnerWindowY())
			SetClsColor(230,230,230)
			Cls
			SetColor(255,255,255)
			SetClsColor(0,0,0)
			SetViewport(0,0,GraphicsWidth(), GraphicsHeight())
			SetOrigin(0,0)
		EndIf
	End Method

	Method GetW : Int()
		Return rect.w
	End Method
	
	Method GetH : Int()
		Return rect.h
	End Method
	
	Method DrawTopBar()
		TUtilImage.DrawRepeated(topBar, GetX(), GetY(), rect.w, ImageHeight(topBar))		
		Local offset:Int = (buttons-1)*24
		SetViewport(GetX()+offset, GetY(), GetW()-offset-2, ImageHeight(topBar))
		Select titleAlign
			Case TITLE_CENTER
				DrawText (title, GetX()+offset+(GetW()-TextWidth(title)-offset)/2, GetY() + 6) 'Align Center
			Case TITLE_RIGHT
				DrawText (title, GetX()+GetW()-TextWidth(title), GetY() + 6) 'Align Right
			Case TITLE_LEFT
				DrawText (title, GetX()+offset, GetY() + 6) 'Align Left
		End Select
		SetViewport(0,0,GraphicsWidth(), GraphicsHeight())
		SetOrigin(0,0)
	End Method

	Method DrawBottomBorder()
		TUtilImage.DrawRepeated(resizeBottom, GetX(), GetY() + rect.h - ImageHeight(resizeBottom) - ImageHeight(bottomBorder), rect.w, ImageHeight(resizeBottom))
		SetColor($CC,$CC,$CC)
		SetViewport(GetX(), GetY() + rect.h - ImageHeight(resizeBottom), GetW()-2, ImageHeight(resizeBottom))
		DrawText (status, GetX() + ImageWidth(leftBorder), GetY() + rect.h - ImageHeight(resizeBottom))
		SetColor($FF,$FF,$FF)
		SetViewport(0,0,GraphicsWidth(), GraphicsHeight())
		SetOrigin(0,0)
		TUtilImage.DrawRepeated(bottomBorder, GetX(), GetY() + rect.h - ImageHeight(bottomBorder), rect.w, ImageHeight(bottomBorder))		
	End Method	

	Method Update()
		Super.Update()
		If btnResize And btnResize.WidgetState = TGUIWidget.DOWN
			rect.w = GetW() - TGuiSystem.mouse.GetDX()
			If rect.w < minW Then rect.w = minW
			rect.h = GetH() - TGuiSystem.mouse.GetDY()
			If rect.h < minH Then rect.h = minH
			btnResize.rect.y = GetY() + GetH() - btnResize.rect.h - 1
			btnResize.rect.x = GetX() + GetW() - btnResize.rect.w - 1
		EndIf
		If btnFold And btnFold.IsClicked() Then Fold()
	End Method
End Type
