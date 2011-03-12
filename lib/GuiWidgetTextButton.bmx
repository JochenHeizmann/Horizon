
SuperStrict

Import BRL.Max2D

Import "GuiWidget.bmx"
Import "InputControllerMouse.bmx"
Import "UtilImage.bmx"

Type TGuiWidgetTextButton Extends TGuiWidget
	
	Field img:TImage
	Field text:String
	
	Function Create:TGuiWidgetTextButton(imageFilename:String, x:Int, y:Int, w:Int)
		Local instance: TGuiWidgetTextButton = New TGuiWidgetTextButton
		instance.rect.x = x
		instance.rect.y = y
		AutoMidHandle False
		Local tmpImg:TImage = LoadImage(imageFilename)
		If (Not tmpimg) Then RuntimeError("Image " + imageFilename + " couldn't be loaded!")
		Local frameWidth:Int = ImageWidth(tmpImg) / 3
		Local frameHeight:Int = ImageHeight(tmpImg)
		instance.rect.w = w
		instance.rect.h = frameHeight
		instance.img = LoadAnimImage(imageFilename, frameWidth, frameHeight, 0, 3)
		Return instance
	End Function	
	
	Method SetText(text:String)
		Self.text = text
	End Method
	
	Method Render()
		Local frame:Int = 0
		Select (GetWidgetState())
			Case HOVER
				SetAlpha(1)
				SetColor(255,255,255)
				
			Case DOWN
				SetAlpha(1)
				SetColor(100,100,100)
				
			Default
				SetAlpha(1)
				SetColor(200,200,200)
		End Select
		
		DrawImage img, rect.x, rect.y, 0
		TUtilImage.DrawRepeated(img, rect.x + ImageWidth(img), rect.y, rect.w - ImageWidth(img) * 2, rect.h, 1)
		DrawImage img, rect.x + rect.w - ImageWidth(img), rect.y , 2
		
		SetColor(255,0,0)
		DrawText(text, rect.x + rect.w / 2 - TextWidth(text) / 2, rect.y + rect.h / 2 - TextHeight(text) / 2)
		
		SetAlpha(1)
		SetColor(255,255,255)	
	End Method	
End Type
