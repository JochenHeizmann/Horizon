
SuperStrict

Framework BRL.GLMax2D

Import "../../lib/Application.bmx"
Import "../../lib/FaderBrightness.bmx"
Import "../../lib/SystemDesktop.bmx"

' Scene Imports
Import "code/SceneLevelEditor.bmx"

Local debug:Int = 0
?Debug
	debug = 1
	TApplication.InitGraphics(800, 600, 0, 60)
?

If debug = 0 Then TApplication.InitGraphics(TSystemDesktop.GetWidth(), TSystemDesktop.GetHeight(), TSystemDesktop.GetDepth(), TSystemDesktop.GetHertz())

TApplication.SetName("Aiolos Level-Editor")

Local myApp:TApplication = TApplication.GetInstance()
myApp.AddFader(New TFaderBrightness)
myApp.AddScene(New TSceneLeveleditor, "levelEditor")
myApp.Run()

End
