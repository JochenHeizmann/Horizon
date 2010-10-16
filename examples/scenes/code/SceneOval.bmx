
Import "../../../lib/Scene.bmx"
Import "../../../lib/Application.bmx"

Type TSceneOval Extends TScene
	Method Render()
		Cls
		SetColor(255,0,0)
		DrawOval(100,100,30,30)
	End Method
	
	Method OnEnter()
		SetAlpha(1)
		SetColor(255,255,255)
		SetRotation(0)
		SetScale(1,1)
	End Method
	
	Method OnLeave()
	End Method

	Method Update()
		If KeyHit(KEY_ESCAPE) Then TApplication.GetInstance().Leave()
		If TInputControllerMouse.GetInstance().IsMouseHit(0) Then TApplication.GetInstance().SetNextScene("bitmapText")
	End Method
End Type
