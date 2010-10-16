
SuperStrict

Import "../../lib/Application.bmx"
Import "../../lib/FaderBrightness.bmx"

Import "code/SceneOval.bmx"
Import "code/SceneBitmapText.bmx"

TApplication.SetName("Test")
TApplication.InitGraphics(800, 600)
Local myApp:TApplication = TApplication.GetInstance()
myApp.AddFader(New TFaderBrightness)
myApp.AddScene(New TSceneBitmapText, "bitmapText")
myApp.AddScene(New TSceneOval, "oval")
myApp.Run()