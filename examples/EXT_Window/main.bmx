SuperStrict

Import "../../lib/Application.bmx"
Import "../../lib/InputControllerMouse.bmx"
Import "../../lib/GuiSystem.bmx"
Import "../../lib/GuiWidgetWindow.bmx"

Import "../../lib/GuiWidgetButton.bmx"
Import "../../lib/GuiWidgetTextbox.bmx"
Import "../../lib/GuiWidgetList.bmx"
Import "../../lib/GuiWidgetSliderHorizontal.bmx"

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
	Field button:TGuiWidgetButton
	Field text:TGuiWidgetTextbox
	Field list:TGuiWidgetList
	Field frame:TGuiWidgetFrame
	Field bgN:Int = 1
	Field bold:Int
	
	Method DrawBg(bold:Int)
		For Local row:Int = 0 To GraphicsHeight()
			SetColor(Rand(254),Rand(254),Rand(254))
			For Local chunk:Int = row To row + bold
				DrawLine 0, chunk, GraphicsWidth(), chunk
			Next
			row :+ bold
			If row > GraphicsHeight() Then row = GraphicsHeight()
		Next
		SetColor(255,255,255)
	End Method
	
	Method Update()
		TGuiSystem.ProcessMessages()
		
		If button.IsClicked()
			Local oldBgN:Int = bgN
			bold = Rand(10)
			win.SetStatus("Bold is: " + bold)
			Repeat
				bgN = Rand(3)
			Until bgN <> oldBgN
			text.hide
		EndIf
		
		If win
			'win.SetStatus("State = " + win.GetWidgetState())
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
		Select bgN		
			Case 1
				DrawImage bg, 0, 0
			Case 2
				Drawbg(bold)
			Case 3
				SetClsColor(50,50,100)
				Cls
		End Select
		TGuiSystem.RenderAll()
	End Method
	
	Method OnEnter()
		ShowMouse()
		
		win = New TGuiWidgetWindow
		win.rect.x = 20
		win.rect.y = 40
		win.rect.w = 330
		win.rect.h = 320
		win.title = "Title bar text is aligned at center."
		'IMPORTANT: if SetStyle call is omitted, window simply behaves as a frame.
		win.SetStyle(TGuiWidgetWindow.STYLE_STD)
		'win.clickToFront = False
		
		button = New TGuiWidgetButton
		win.AddChild(button)
		button.rect.x :+ 2
		button.rect.y :+ 100
		button.rect.w = 160
		button.text = "Change Background"
		text = New TGuiWidgetTextbox
		win.AddChild(text)
		text.rect.w = 300
		text.rect.h = 80
		text.text = "the quick brown fox jumps over the lazy dog the quick brown fox jumps over the lazy dog"
		list = New TGuiWidgetList
		win.AddChild(list)
		list.rect.x :+ 2
		list.rect.y :+ 130
		list.rect.w = 300
		list.rect.h = 80
		list.AddEntry("Item 1")
		list.AddEntry("Item 2")
		list.AddEntry("Item 3")
		list.AddEntry("Item 4")
		list.AddEntry("Item 5")
		
		win2 = New TGuiWidgetWindow
		win2.rect.x = 380
		win2.rect.y = 60
		win2.rect.w = 400
		win2.rect.h = 320
		win2.title = "Title bar text is right aligned -->"
		'IMPORTANT: if SetStyle call is omitted, window simply behaves as a frame.
		win2.SetStyle(TGuiWidgetWindow.STYLE_STD, TGuiWidgetWindow.TITLE_RIGHT)
		'win2.clickToFront = False
		frame = New TGuiWidgetFrame
		frame.rect.w = 200
		frame.rect.h = 160
		win2.AddChild(frame)
		
		win3 = TGuiWidgetWindow.Create(100, 400, 560, 140, TGuiWidgetWindow.STYLE_STD)
		win3.title = "Title bar text is on left and automatically clipped."
		'IMPORTANT: if SetStyle call is omitted, window simply behaves as a frame.
		'win.AddChild(win3)
		win3.SetStyle(,TGuiWidgetWindow.TITLE_LEFT)
		win3.showStatusBar = False
		'win3.clickToFront = False
		
		bg = LoadImage("data/bg.jpg")
	End Method
	
	Method OnLeave()
		win = Null
		If win2 Then win2 = Null
		If win3 Then win3 = Null
	End Method
End Type
