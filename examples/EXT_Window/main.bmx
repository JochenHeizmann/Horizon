SuperStrict

Import "../../lib/Application.bmx"
Import "../../lib/InputControllerMouse.bmx"
Import "../../lib/GuiSystem.bmx"
Import "../../lib/GuiWidgetWindow.bmx"

TGuiSystem.SKIN_PATH = "../../data/gui/default/"

TApplication.SetName("Test")
TApplication.InitGraphics(DesktopWidth(), DesktopHeight(), DesktopDepth())
'TApplication.InitGraphics(800, 600)
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
	
	Method DrawBg()
		Const bold:Int = 6
		For Local row:Int = 0 To GraphicsHeight() Step bold
			SetColor(Rand(254),Rand(254),Rand(254))
			For Local chunk:Int = row To row + bold
				DrawLine 0, chunk, GraphicsWidth(), chunk
			Next
		Next
		SetColor(255,255,255)
	End Method
	
	Method Update()
		TGuiSystem.ProcessMessages()
		
		If win
			win.SetStatus("State = " + win.GetWidgetState())
			If win.btnClose And win.btnClose.IsClicked() Then TGuiSystem.RemoveWidget(win)
		EndIf
		
		If win2
			win2.SetStatus("State = " + win2.GetWidgetState())
			If win2.btnClose And win2.btnClose.IsClicked() Then TGuiSystem.RemoveWidget(win2)
		EndIf
		
		If win3
			win3.SetStatus("State = " + win3.GetWidgetState())
			If win3.btnClose And win3.btnClose.IsClicked() Then TGuiSystem.RemoveWidget(win3)
		EndIf
		
		If TGuiSystem.widgets.IsEmpty() Then TApplication.GetInstance().Leave()
		If KeyDown(KEY_ESCAPE) Then TApplication.GetInstance().Leave()
	End Method
	
	Method Render()
		'DrawImage bg, 0, 0
		'Drawbg()
		SetClsColor(50,50,100)
		Cls
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
		
		win3 = TGuiWidgetWindow.Create(200, 340, 500, 120, TGuiWidgetWindow.STYLE_FULL)
		win3.title = "Title bar text is on left and automatically clipped."
		'IMPORTANT: if SetStyle call is omitted, window simply behaves as a frame.
		win3.SetStyle(TGuiWidgetWindow.STYLE_FULL, TGuiWidgetWindow.TITLE_LEFT)
		
		bg = LoadImage("data/bg.jpg")
	End Method
	
	Method OnLeave()
		win = Null
		If win2 Then win2 = Null
		If win3 Then win3 = Null
	End Method
End Type
