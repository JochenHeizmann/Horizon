SuperStrict

Import "GuiWidgetButton.bmx"

Type TGuiWidgetButtonImage Extends TGuiWidgetButton
	Global img:TImage
	
	Method New()
		If (img = Null) Then img = LoadAnimImage(TGuiSystem.SKIN_PATH + "requester/button.png", 43, 43, 0, 3)
		If (img = Null) Then RuntimeError("Image not foudn: " + TGuiSystem.SKIN_PATH + "requester/button.png")
		rect.h = ImageHeight(img)
	End Method
	
	Method Render()
		Local frame:Int = 0
		Local off : Int = 0		
		Select (GetWidgetState())
			Case HOVER				
				SetColor(255,255,255)
			Case DOWN
				SetColor(168,168,168)
				off = 2
			Default
				SetColor(200,200,200)
		End Select
		

		DrawImage (img, rect.x, rect.y, 0)
		TUtilImage.DrawRepeated(img, rect.x + ImageWidth(img), rect.y, rect.w - ImageWidth(img) * 2, ImageHeight(img), 1)
		DrawImage (img, rect.x + rect.w - ImageWidth(img), rect.y, 2)	

		SetScale(1,1)
		If (GetWidgetState() = HOVER) Then SetColor(255,255,255) Else SetColor(192,192,192)		
		If (font) Then SetImageFont(font)
		DrawText text, off + rect.x + (rect.w / 2) - TextWidth(text) / 2, off + rect.y + (rect.h / 2) - TextHeight(text) / 2
		SetColor(255,255,255)
	End Method	
End Type
