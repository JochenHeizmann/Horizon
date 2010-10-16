
SuperStrict

Import BRL.Max2D

Import "GuiWidget.bmx"
Import "InputControllerMouse.bmx"

Type TGuiWidgetImagebutton Extends TGuiWidget
	
	Field img:TImage
	
	Function Create:TGuiWidgetImagebutton(imageFilename:String, x:Int, y:Int)
		Local instance:TGuiWidgetImagebutton = New TGuiWidgetImagebutton
		instance.x = x
		instance.y = y
		
		Local tmpImg:TImage = LoadImage(imageFilename)
		If (Not tmpimg) Then RuntimeError("Image " + imageFilename + " couldn't be loaded!")
		Local frameWidth:Int = ImageWidth(tmpImg) / 3
		Local frameHeight:Int = ImageHeight(tmpImg)
		instance.w = frameWidth
		instance.h = frameHeight
		instance.img = LoadAnimImage(imageFilename, frameWidth, frameHeight, 0, 3)
		Return instance
	End Function
	
	Method Draw()
		Local frame:Int = 0
		Select (GetWidgetState())
			Case HOVER
				frame = 1
			Case DOWN
				frame = 2
			Default
				frame = 0
		End Select
		DrawImage img, GetX(), GetY(), frame
	End Method	
End Type
