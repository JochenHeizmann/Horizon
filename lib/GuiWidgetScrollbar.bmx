
SuperStrict

Import "GuiWidget.bmx"
Import "GuiWidgetScrollbarInner.bmx"

Type TGuiWidgetScrollbar Extends TGuiWidget Abstract
	Field imgBorder:TImage
	Field innerBar:TGuiWidgetScrollbarInner
	
	Method Init() Abstract
	
	Method SetSize(size:Float)
		innerBar.SetSize(size)
	End Method
	
	Method GetPos:Float()
		Return innerBar.GetPos()
	End Method
End Type
