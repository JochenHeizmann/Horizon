
SuperStrict

Import BRL.Max2D

Import "GuiWidget.bmx"
Import "InputControllerMouse.bmx"
Import "UtilImage.bmx"
Import "BitmapFont.bmx"

Type TGuiWidgetTextButton Extends TGuiWidget
	
	Field img:TImage
	Field text:String
	Field font:TBitmapFont
	
	Function Create: TGuiWidgetTextButton(imageFilename:String, x:Int, y:Int, w:Int)
		Local instance: TGuiWidgetTextButton = New TGuiWidgetTextButton
		instance.x = x
		instance.y = y
		
		Local tmpImg:TImage = LoadImage(imageFilename)
		If (Not tmpimg) Then RuntimeError("Image " + imageFilename + " couldn't be loaded!")
		Local frameWidth:Int = ImageWidth(tmpImg) / 3
		Local frameHeight:Int = ImageHeight(tmpImg)
		instance.w = w
		instance.h = frameHeight
		instance.img = LoadAnimImage(imageFilename, frameWidth, frameHeight, 0, 3)
		Return instance
	End Function	
	
	Method SetText(text:String)
		Self.text = text
	End Method
	
	Method SetFont(font:TBitmapFont)
		Self.font = font
	End Method
	
	Method Draw()
	
		Local frame:Int = 0
		Select (GetWidgetState())
			Case HOVER
				SetAlpha(1)
			Case DOWN
				SetAlpha(1)
				SetColor(100,100,100)
			Default
				SetAlpha(1)
				SetColor(200,200,200)
		End Select
		
		DrawImage img, GetX(), GetY(), 0
		TUtilImage.DrawRepeated(img, GetX() + ImageWidth(img), GetY(), w - ImageWidth(img) * 2, h, 1)
		DrawImage img, GetX() + w - ImageWidth(img), GetY() , 2
		font.Draw(text, GetX() + w / 2, GetY() + h / 2, True)
		SetAlpha(1)
		SetColor(255,255,255)
		
	End Method	
End Type
