
SuperStrict

Import BRL.Max2D

Import "GuiWidget.bmx"
Import "UtilImage.bmx"

Type TGuiWidgetImage Extends TGuiWidget
	Field image:TImage
	
	Function Create:TGuiWidgetImage(x:Int, y:Int, w:Int, h:Int, img:String)
		Local instance:TGuiWidgetImage = New TGuiWidgetImage
		instance.x = x
		instance.y = y
		instance.w = w
		instance.h = h
		instance.image = LoadImage(img)
		Return instance
	End Function
	
	Method Draw()
		TUtilImage.DrawRepeated(image, GetX(), GetY(), w, h)
	End Method
End Type
