
Import "../../../lib/Scene.bmx"
Import "../../../lib/BitmapFont.bmx"
Import "../../../lib/InputControllerMouse.bmx"
Import "../../../lib/Application.bmx"

Type TSceneBitmapText Extends TScene
	Field bg:TImage
	Field c:Float = 0
	Field font:TImageFont
	
	Method Update()
		c :+ (1)
		If TInputControllerMouse.GetInstance().IsMouseHit(0) Then TApplication.GetInstance().SetNextScene("oval")
		If KeyHit(KEY_ESCAPE) Then TApplication.GetInstance().Leave()
	End Method
	
	Method Render()
		Cls
		SetColor 255,255,255
		SetAlpha(1)
		
		Local x:Float = (-400 + Sin(c)*400) + ((-400 + Sin(c+1)*400) - (-400 + Sin(c)*400))
		Local y:Float = (-300 + Cos(c)*300) + ((-300 + Cos(c+1)*300) - (-300 + Cos(c)*300))
		
		DrawImage bg, x, y
		SetRotation(c)

		SetColor(Sin(c) * 255, 255, Cos(c) * 255)
		SetRotation(0)
		SetImageFont(font)
		DrawText("This is bitmap text", 10, 50)

		SetColor(255,0,0)
		DrawOval(MouseX(), MouseY(), 50, 50)
	End Method
	
	Method OnEnter()
		HideMouse
		bg = LoadImage("data/bg.jpg")
		font = TBitmapFont.Load("data/font_blood.png")
		If (Not font) DebugLog "no font"
	End Method
	
	Method OnLeave()
		bg = Null
		font = Null	
	End Method
End Type
