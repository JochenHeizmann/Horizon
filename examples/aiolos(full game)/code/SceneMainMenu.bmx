
SuperStrict

Import BRL.Max2D
Import BRL.PNGLoader

Import "../../../lib/Scene.bmx"
Import "../../../lib/Application.bmx"
Import "../../../lib/GuiWidgetFrame.bmx"
Import "../../../lib/GuiWidgetTextButton.bmx"
Import "../../../lib/BitmapFont.bmx"

Incbin "../data/fonts/font60"
Incbin "../data/fonts/font60.png"
Incbin "../data/fonts/font36"
Incbin "../data/fonts/font36.png"
Incbin "../data/img/button_big.png"
Incbin "../data/img/button_small.png"
Incbin "../data/img/bg_mainmenu.png"
Incbin "../data/img/aiolos.png"

Type TSceneMainMenu Extends TScene

	Field background:TImage
	Field aiolos:TImage
	Field frameCounter:Float = 0
	
	Const BTN_START:Int = 0
	Const BTN_EXIT:Int = 1
	Const BTN_URL:Int = 2
	Const BTN_NUM:Int = 3
	Field buttons:TGuiWidgetTextButton[BTN_NUM]
	
	Field fontBig:TBitmapFont
	Field fontSmall:TBitmapFont
	
	Method OnEnter()	
		SetAlpha(1)
		SetClsColor(10,0,0)
		ShowMouse()
		
		fontBig = New TBitmapFont
		fontBig.Load("incbin::../data/fonts/font60")

		fontSmall = New TBitmapFont
		fontSmall.Load("incbin::../data/fonts/font36")
		
		buttons[BTN_START] = TGuiWidgetTextButton.Create("incbin::../data/img/button_big.png", GraphicsWidth() / 2 - 200, GraphicsHeight() / 2 - 100, 400)
		buttons[BTN_START].SetText("New game")
'		buttons[BTN_START].SetFont(fontBig)

		buttons[BTN_EXIT] = TGuiWidgetTextButton.Create("incbin::../data/img/button_big.png", GraphicsWidth() / 2 - 200, GraphicsHeight() / 2 - 10, 400)
		buttons[BTN_EXIT].SetText("Exit")
'		buttons[BTN_EXIT].SetFont(fontBig)

		buttons[BTN_URL] = TGuiWidgetTextButton.Create("incbin::../data/img/button_small.png", GraphicsWidth() - 390, GraphicsHeight() - 70, 380)
		buttons[BTN_URL].SetText("intermediaware.com")
'		buttons[BTN_URL].SetFont(fontSmall)

		background = LoadImage("incbin::../data/img/bg_mainmenu.png")
		AutoMidHandle True
		aiolos = LoadImage("incbin::../data/img/aiolos.png")
	End Method	
	
	Method OnLeave()
		buttons[BTN_START] = Null
		buttons[BTN_EXIT] = Null
		buttons[BTN_URL]  = Null
		TGuiSystem.ClearWidgets()
		SetClsColor(0,0,0)
		Cls ; Flip
	EndMethod
	
	Method Update()
		TGuiSystem.ProcessMessages()
		frameCounter :+ .5
		If KeyDown(KEY_ESCAPE) Then TApplication.GetInstance().Leave()
		
		If buttons[BTN_URL].IsClicked() Then OpenURL("http://www.intermediaware.com") ; TApplication.GetInstance().Leave()
		If buttons[BTN_EXIT].IsClicked() Or KeyDown(KEY_ESCAPE) Then TApplication.GetInstance().Leave()
		If buttons[BTN_START].IsClicked() Then TApplication.GetInstance().SetNextScene("game")
			End Method

	Method Render()
		Cls
		SetAlpha(0.2)
		TileImage background, Sin(frameCounter) * 200, Cos(frameCounter) * 200
		SetAlpha(1)
		TGuiSystem.RenderAll()
		DrawImage aiolos, GraphicsWidth() / 2 - 10, 100
	End Method
End Type