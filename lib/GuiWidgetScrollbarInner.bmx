
SuperStrict

Import "UtilImage.bmx"
Import "GuiWidget.bmx"

Type TGuiWidgetScrollbarInner Extends TGuiWidget Abstract
	Field imgBarLeft:TImage, imgBarMiddle:TImage, imgBarRight:TImage
	Field imgBarSign:TImage
	
	Field dragX:Int, dragY:Int, startDrag:Byte
	
	Field minX:Int, maxX:Int, originalW:Int
	Field minY:Int, maxY:Int, originalH:Int

	Method GetPos:Float() Abstract
	Method Init() Abstract
	Method SetSize(size:Float) Abstract
End Type
