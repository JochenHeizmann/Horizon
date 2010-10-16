
SuperStrict

Import "../../lib/Application.bmx"
Import "../../lib/InputControllerMouse.bmx"
Import "../../lib/GuiWidgetWindow.bmx"

TGui.SKIN_PATH = "../../data/gui/default/"

TApplication.SetName("Test")
TApplication.InitGraphics(800, 600)
Local myApp:TApplication = TApplication.GetInstance()
myApp.AddScene(New TSceneWindow, "foo")
myApp.Run()

' WindowScene

Type TSceneWindow Extends TScene
	Field win:TGuiWidgetWindow
	Field bg:TImage
	
	Method Update()
		win.Update()
		If win.closeButton.IsVisible() And win.closeButton.IsMouseUp() Then TApplication.GetInstance().Leave()
	End Method
	
	Method Render()
		DrawImage bg, 0, 0		
		win.Render()		
	End Method
	
	Method OnEnter()
		ShowMouse()
		win = TGuiWidgetWindow.Create(200,60,200,200,TGuiWidgetWindow.STYLE_RESIZE|TGuiWidgetWindow.STYLE_CLOSE|TGuiWidgetWindow.STYLE_DRAGABLE|TGuiWidgetWindow.STYLE_KEEPINSIDE)
		bg = LoadImage("data/bg.jpg")		
	End Method
	
	Method OnLeave()
		win = Null
	End Method
End Type