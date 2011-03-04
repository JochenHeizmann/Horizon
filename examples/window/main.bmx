
SuperStrict

Import "../../lib/Application.bmx"
Import "../../lib/InputControllerMouse.bmx"
Import "../../lib/GuiSystem.bmx"
Import "../../lib/GuiWidgetFrame.bmx"
Import "../../lib/GuiWidgetButton.bmx"

TGuiSystem.SKIN_PATH = "../../data/gui/default/"

TApplication.SetName("Test")
TApplication.InitGraphics(800, 600)
TGuiSystem.Init()

Local myApp:TApplication = TApplication.GetInstance()
myApp.AddScene(New TSceneWindow, "foo")
myApp.Run()

' WindowScene
Type TSceneWindow Extends TScene
	Field win:TMyWindow
	Field win2:TMyWindow
	Field bg:TImage
	
	Method Update()
		TGuiSystem.ProcessMessages()
		If KeyDown(KEY_ESCAPE) Then TApplication.GetInstance().Leave()
	End Method
	
	Method Render()
		DrawImage bg, 0, 0		
		TGuiSystem.RenderAll()
	End Method
	
	Method OnEnter()
		ShowMouse()
		win = New TMyWindow
		
		win2 = New TMyWindow
		win2.rect.x = 300
		win2.rect.y = 40
		
		bg = LoadImage("data/bg.jpg")
	End Method
	
	Method OnLeave()
		win = Null
		win2 = Null
	End Method
End Type

' Some derieved classes
Type TMyButton Extends TGuiWidgetButton
	Method OnMouseOver()
		Super.OnMouseOver()	
		DebugLog "MouseOver"
	End Method
	
	Method OnMouseClick()
		Super.OnMouseClick()
		DebugLog "MouseClick"
	End Method
End Type

Type TMyWindow Extends TGuiWidgetFrame
	Field btn: TMyButton
	
	Method New()
		rect.x = 100
		rect.y = 100
		rect.w = 400
		rect.h = 200
		
		btn = New TMyButton
		btn.rect.x = GetInnerWindowX() + 250
		btn.rect.y = GetInnerWindowY() + 20
		btn.rect.w = 100
		btn.rect.h = 22
		btn.text = "MyButton"
		AddChild(btn)
	End Method
	
	Method Render()
		SetViewport(GetInnerWindowX(), GetInnerWindowY(), GetInnerWidth(), GetInnerHeight())
		SetOrigin(GetInnerWindowX(), GetInnerWindowY())
		Cls
		SetColor(255,0,0)
		DrawRect 20,20,40,40
		SetColor(0,255,255)
		DrawOval 100,20,30,30
		SetColor(255,255,255)
		SetViewport(0,0,GraphicsWidth(), GraphicsHeight())
		SetOrigin(0,0)
		Super.Render()
	End Method
End Type