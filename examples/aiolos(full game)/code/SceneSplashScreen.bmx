
SuperStrict

Import BRL.Max2D
Import BRL.PNGLoader

Import "../../../lib/Scene.bmx"
Import "../../../lib/Application.bmx"

Incbin "../data/img/logo.png"

Type TSceneSplashScreen Extends TScene
	Field count:Float = 90
	Field alphatierLogo:TImage
	
	Method OnEnter()	
		SetClsColor(255,255,255)
		AutoMidHandle True
		alphatierLogo = LoadImage("incbin::../data/img/logo.png")
	End Method	
	
	Method OnLeave()
		alphatierLogo = Null
		SetClsColor(0,0,0)
		'Dirty hack for strange bug (image in following screen will be white block)
		DrawText "-",-100,-100
	EndMethod
	
	Method Update()
		count :- 5
		If TApplication.GetInstance().GetState() = TApplication.SCENE_ACTIVE
			If count < -500 Then TApplication.GetInstance().SetNextScene("mainMenu")
		End If
	End Method

	Method Render()
		Cls
		SetAlpha(1)
		DrawImage alphatierLogo, GraphicsWidth() / 2, GraphicsHeight() / 2
	End Method
End Type