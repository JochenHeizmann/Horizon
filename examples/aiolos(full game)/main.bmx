
SuperStrict

'levels too big
'lowering diamonds needed
'powerups


Framework BRL.GLMax2D

Import "../../lib/Application.bmx"
Import "../../lib/FaderBrightness.bmx"
Import "../../lib/SystemDesktop.bmx"

' Scene Imports
Import "code/SceneSplashScreen.bmx"
Import "code/SceneMainMenu.bmx"
Import "code/SceneGame.bmx"

Local debug:Int = 0
?Debug
	debug = 1
	TApplication.InitGraphics(800, 600, 0, 60)
?

If debug = 0 Then TApplication.InitGraphics(TSystemDesktop.GetWidth(), TSystemDesktop.GetHeight(), TSystemDesktop.GetDepth(), TSystemDesktop.GetHertz())

TApplication.SetName("Aiolos")

Local myApp:TApplication = TApplication.GetInstance()
myApp.AddFader(New TFaderBrightness)
myApp.AddScene(New TSceneSplashScreen, "splashScreen")
myApp.AddScene(New TSceneGame, "game")
myApp.AddScene(New TSceneMainMenu, "mainMenu")
myApp.Run()

End