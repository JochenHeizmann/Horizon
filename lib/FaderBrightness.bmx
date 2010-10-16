
SuperStrict

Import BRL.Max2D
Import "Fader.bmx"

Type TFaderBrightness Extends TFader
	Method Render()
		Local alpha:Float = GetAlpha()
		Local r:Int, g:Int, b:Int
		Local rot:Int = GetRotation()
		Local xScale:Float, yScale:Float
		GetScale(xScale, yScale)
		GetColor(r,g,b)
		
		SetScale(1,1)
		SetAlpha(position)
		SetColor(0,0,0)
		SetRotation(0)
		
		DrawRect(0,0, GraphicsWidth(), GraphicsHeight())
		
		SetColor(r,g,b)
		SetAlpha(alpha)
		SetRotation(rot)
		SetScale(xScale, yScale)
	End Method
End Type
