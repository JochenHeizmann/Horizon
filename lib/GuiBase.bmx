SuperStrict

Import "Rect.bmx"

Type TGuiBase
	Field rect : TRect
	Field visible : Byte

	Field childs : TList
	
	Method Render() Abstract
	Method Update() Abstract
	
	Method OnMouseOver() Abstract
	Method OnMouseOut() Abstract
	Method OnMouseHit() Abstract
	Method OnMouseDown() Abstract
	Method OnRMouseDown() Abstract
	Method OnRMouseUp() Abstract
	Method OnRMouseHit() Abstract
	Method OnMouseUp() Abstract
	Method OnActivate() Abstract
	Method OnMouseMove(dx : Int, dy : Int) Abstract
	Method OnMouseClick() Abstract

	Method Hide()
		visible = False
	End Method
	
	Method Show()
		visible = True
	End Method		
End Type