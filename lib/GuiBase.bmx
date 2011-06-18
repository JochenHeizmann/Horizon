SuperStrict

Import "Rect.bmx"

Type TGuiBase
	Field rect : TRect
	Field visible : Byte
	Field autoRender : Byte
	Field isModal:Byte

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
	Method ToFront() Abstract
	Method ToBack() Abstract

	Method New()
		autoRender = True
		isModal = False
	End Method
	
	Method IsChildOf:Byte(element:TGuiBase) Abstract

	Method Hide()
		visible = False
		For Local t:TGuiBase = EachIn childs
			t.Hide()
		Next
	End Method
	
	Method Show()
		visible = True
		For Local t:TGuiBase = EachIn childs
			t.Show()
		Next
	End Method		
	
	Method SetAutoRender(aRender:Byte)
		autoRender = aRender
		For Local t:TGuiBase = EachIn childs
			t.SetAutoRender(aRender)
		Next
	End Method
End Type
