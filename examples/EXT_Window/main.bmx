SuperStrict

Import "../../lib/Application.bmx"
Import "../../lib/InputControllerMouse.bmx"
Import "../../lib/GuiSystem.bmx"
Import "../../lib/GuiWidgetWindow.bmx"

TGuiSystem.SKIN_PATH = "../../data/gui/default/"

TApplication.SetName("Test")
'TApplication.InitGraphics(DesktopWidth(), DesktopHeight(), DesktopDepth())
TApplication.InitGraphics(800, 600)
TGuiSystem.Init()

Local myApp:TApplication = TApplication.GetInstance()
myApp.AddScene(New TSceneWindow, "foo")
myApp.Run()

' WindowScene
Type TSceneWindow Extends TScene
	Field win:TGuiWidgetWindow
	Field win2:TGuiWidgetWindow
	Field win3:TGuiWidgetWindow
	Field bg:TImage
	
	Method Update()
		TGuiSystem.ProcessMessages()
		If KeyDown(KEY_ESCAPE) Then TApplication.GetInstance().Leave()
		If win.btnClose And win.btnClose.IsClicked() Then TApplication.GetInstance().Leave()
	End Method
	
	Method Render()
		DrawImage bg, 0, 0	
		TGuiSystem.RenderAll()
	End Method
	
	Method OnEnter()
		ShowMouse()
		
		win = New TGuiWidgetWindow
		win.rect.x = 20
		win.rect.y = 40
		win.rect.w = 300
		win.rect.h = 220
		win.title = "Title bar text is aligned at center."
		'IMPORTANT: if SetStyle call is omitted, window simply behaves as a frame.
		win.SetStyle(TGuiWidgetWindow.STYLE_FULL)
		
		win2 = New TGuiWidgetWindow
		win2.rect.x = 380
		win2.rect.y = 40
		win2.rect.w = 400
		win2.rect.h = 220
		win2.title = "Title bar text is right aligned -->"
		'IMPORTANT: if SetStyle call is omitted, window simply behaves as a frame.
		win2.SetStyle(TGuiWidgetWindow.STYLE_FULL, TGuiWidgetWindow.TITLE_RIGHT)
		
		win3 = New TGuiWidgetWindow
		win3.rect.x = 200
		win3.rect.y = 340
		win3.rect.w = 500
		win3.rect.h = 120
		win3.title = "Title bar text is on left and automatically clipped."
		'IMPORTANT: if SetStyle call is omitted, window simply behaves as a frame.
		win3.SetStyle(TGuiWidgetWindow.STYLE_FULL, TGuiWidgetWindow.TITLE_LEFT)
		
		bg = LoadImage("data/bg.jpg")
	End Method
	
	Method OnLeave()
		win = Null
		win2 = Null
		win3 = Null
	End Method
End Type
