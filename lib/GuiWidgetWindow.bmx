
SuperStrict

Import BRL.Max2D
Import BRL.PNGLoader

Import "Gui.bmx"
Import "GuiWidget.bmx"
Import "GuiWidgetImage.bmx"
Import "GuiWidgetImagebutton.bmx"
Import "UtilImage.bmx"

Type TGuiWidgetWindow Extends TGuiWidget
	Const STYLE_CLOSE:Int      = %00000001
	Const STYLE_RESIZE:Int     = %00000010
	Const STYLE_ZORDER:Int     = %00000100 'todo
	Const STYLE_HSCROLL:Int    = %00001000 'todo
	Const STYLE_VSCROLL:Int    = %00010000 'todo
	Const STYLE_DRAGABLE:Int   = %00100000
	Const STYLE_KEEPINSIDE:Int = %01000000

	Field closeButton:TGuiWidgetImageButton
	Field topBar:TImage
	Field rightBorder:TImage
	Field leftBorder:TImage
	Field bottomBorder:TImage
	Field resizeBottom:TImage
	Field resizeButton:TGuiWidgetImagebutton
	Field bg:TGuiWidgetImage
	Field minW:Int, minH:Int
	Field style:Int
	
	Field dragX:Int, dragY:Int
	Field title:String, status:String
	
	Field startDrag:Byte
	Field startResize:Byte
	
	Function Create:TGuiWidgetWindow(x:Int, y:Int, w:Int = 0, h:Int = 0,style:Int = STYLE_CLOSE|STYLE_ZORDER|STYLE_DRAGABLE|STYLE_KEEPINSIDE)
		Local instance:TGuiWidgetWindow = New TGuiWidgetWindow
		instance.x = x
		instance.y = y
		instance.w = w
		instance.h = h
		instance.style = style
		
		instance.Init()	
		Return instance
	End Function	
	
	Method Init()
		AutoMidHandle(False)
		closeButton = TGuiWidgetImagebutton.Create(TGui.SKIN_PATH + "window/close.png", 0, 0)
		AddChild(closeButton)
		topBar = LoadImage(TGui.SKIN_PATH + "window/topbar.png")
		rightBorder = LoadImage(TGui.SKIN_PATH + "window/rightborder.png")
		leftBorder = LoadImage(TGui.SKIN_PATH + "window/leftborder.png")
		bottomBorder = LoadImage(TGui.SKIN_PATH + "window/bottomborder.png")
		resizeBottom = LoadImage(TGui.SKIN_PATH + "window/bgresize.png")
		
		bg = TGuiWidgetImage.Create(0,0,0,0, TGui.SKIN_PATH + "window/bg.png")		
		AddChild(bg)

		resizeButton = TGuiWidgetImagebutton.Create(TGui.SKIN_PATH + "window/resize.png", 0, 0)
		resizeButton.x = w - ImageWidth(resizeButton.img) - ImageWidth(rightBorder)
		resizeButton.y = h - ImageHeight(resizeButton.img) - ImageHeight(bottomBorder)
		AddChild(resizeButton)

		If (Not (style & STYLE_RESIZE)) Then resizeButton.Hide()
		If (Not (style & STYLE_CLOSE)) Then closeButton.Hide()
		
		minW = 85
		minH = 42
		SetTitle("Unknown Window")
		SetStatus("Ok")
	End Method

	Method SetTitle(title:String)
		Self.title = title
	End Method
	
	Method SetStatus(status:String)
		Self.status = status
	End Method

	Method Draw()
		DrawTopBar()
		DrawBottomBorder()
		DrawRightBorder()
		DrawLeftBorder()
	End Method
	
	Method DoUpdate()
		Local topBarW:Int = ImageWidth(topBar)
		Local tx:Int = GetX() + w

		If (resizeButton.IsVisible())
			If (resizeButton.IsMouseOver() And startResize = False And TInputControllerMouse.GetInstance().IsMouseHit(TInputControllerMouse.BUTTON_LEFT))
				startResize = True
				dragX = MouseX() - (GetX() + w)
				dragY = MouseY() - (GetY() + h)
			End If
			If (Not MouseDown(1) And startResize = True)
				startResize = False
			End If
			
			If startResize
				w = MouseX() - dragX - GetX()
				h = MouseY() - dragY - GetY()
				If (w < minW) Then w = minW
				If (h < minH) Then h = minH	

				If (style & STYLE_KEEPINSIDE)
					If ((w + GetX()) > GraphicsWidth()) Then w = GraphicsWidth() - GetX()
					If ((h + GetY()) > GraphicsHeight()) Then h = GraphicsHeight() - GetY()
				End If
				
				resizeButton.x = w - ImageWidth(resizeButton.img) - ImageWidth(rightBorder)
				resizeButton.y = h - ImageHeight(resizeButton.img) - ImageHeight(bottomBorder)						
			End If		
		End If
		
		If ((style & STYLE_DRAGABLE) And IsMouseOver())
			If (MouseX()> (GetX()) And MouseX()<tx And MouseY()>GetY() And MouseY()<(GetY()+ImageHeight(topBar)))
				If (TInputControllerMouse.GetInstance().IsMouseHit(TInputControllerMouse.BUTTON_LEFT) And startDrag = False)
					startDrag = True
					dragX = MouseX() - GetX()
					dragY = MouseY() - GetY()
				End If
			End If
		End If
				
		If (Not MouseDown(1) And startDrag = True)
			startDrag = False
		End If
		
		If startDrag
			x = MouseX() - dragX
			y = MouseY() - dragY
		End If
		
		If (style & STYLE_KEEPINSIDE)
			Local x1:Int = 0, y1:Int = 0, x2:Int = GraphicsWidth() - w, y2:Int = GraphicsHeight() - h
			If (parent)
				x1 = parent.GetX()
				x2 = x1 + parent.w - w
				y1 = parent.GetY()
				y2 = y1 + parent.h - h										
			End If
			If (x < x1) Then x = x1
			If (x > x2) Then x = x2
			If (y < y1) Then y = y1
			If (y > y2) Then y = y2
		End If
		
		'update backgroundposition
		bg.x = ImageWidth(leftBorder)
		bg.y = ImageHeight(topBar)
		bg.w = w - ImageWidth(leftBorder) - ImageWidth(rightBorder)
		bg.h = h - ImageHeight(topBar) - ImageHeight(resizeBottom) - ImageHeight(bottomBorder)
	End Method
	
	Method DrawTopBar()
		TUtilImage.DrawRepeated(topBar, GetX(), GetY(), w, ImageHeight(topBar))		
		DrawText (title, GetX() + ((style & STYLE_CLOSE) * closeButton.w) + 2, GetY() + 6)
	End Method
	
	Method DrawRightBorder()
		TUtilImage.DrawRepeated(rightBorder, GetX() + w - ImageWidth(rightBorder), GetY() + ImageHeight(topBar), ImageWidth(rightBorder), h - ImageHeight(topBar))
	End Method
	
	Method DrawLeftBorder()
		TUtilImage.DrawRepeated(leftBorder, GetX(), GetY() + ImageHeight(topBar), ImageWidth(leftBorder), h - ImageHeight(topBar))
	End Method
	
	Method DrawBottomBorder()
		TUtilImage.DrawRepeated(resizeBottom, GetX(), GetY() + h - ImageHeight(resizeBottom) - ImageHeight(bottomBorder), w, ImageHeight(resizeBottom))
		SetColor($CC,$CC,$CC)
		DrawText (status, GetX() + ImageWidth(leftBorder), GetY() + h - ImageHeight(resizeBottom))
		SetColor($FF,$FF,$FF)
		TUtilImage.DrawRepeated(bottomBorder, GetX(), GetY() + h - ImageHeight(bottomBorder), w, ImageHeight(bottomBorder))		
	End Method	
EndType