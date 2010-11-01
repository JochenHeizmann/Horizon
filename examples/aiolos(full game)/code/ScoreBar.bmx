
SuperStrict

Import BRL.Max2D

Import "../../../lib/BitmapFont.bmx"

Type TScoreBar
	Field points:Int, pointsLastLevel:Int
	Field time:Int
	Field jewlesCount:Int = 0, jewlesCountStart:Int = 0
	Field tilemap:TImage
	
	Field font:TBitmapFont, smFont:TBitmapFont

	Field keySlot:Int Ptr
	
	Method New()
		points = 0
		pointsLastLevel = 0
	End Method
	
	Method SetKeySlot(k:Int Ptr)
		keySlot = k
	End Method
	
	Method SetTileMap(t:TImage)
		tilemap = t
	End Method
	
	Method SetBigFont(f:TBitmapFont)
		font = f
	End Method
	
	Method SetSmallFont(f:TBitmapFont)
		smFont = f
	End Method
	
	Method SetTime(t:Int)
		time = t
	End Method
	
	Method Render()
		SetAlpha(1)
		font.Draw(points, 40, 25)
		
		If time < 0 Then time = 0
		Local minutes:Int = time / 60
		Local seconds:Int = time Mod 60
		Local tstr:String = minutes + ":"
		If seconds < 10 Then tstr :+ "0"
		tstr :+ seconds
		font.Draw(tstr, GraphicsWidth() - 135 , 25)
		
		smFont.Draw(jewlesCount + "/" + jewlesCountStart, GraphicsWidth() - 20 - smFont.getWidth(jewlesCount + "/" + jewlesCountStart), GraphicsHeight() - 65)
		
		For Local i:Int = 0 To 3
			SetAlpha(0.3)
			SetColor(0,0,0)
			Local rectX:Int = 20 + (i * 60)
			Local rectY:Int = GraphicsHeight() - 65
			DrawRect(rectX, rectY, 50, 50)
			SetAlpha(1)
			SetColor(255,255,255)
			If (keySlot[i] > -1)
				DrawImage tilemap, rectX, rectY, 19 + keySlot[i]
			End If
		Next
	End Method
	
	Method AddScore(s:Int)
		points :+ s
	End Method
End Type

