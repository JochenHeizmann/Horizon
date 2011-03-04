
SuperStrict

Import "GuiSystem.bmx"
Import "GuiBase.bmx"
Import "Rect.bmx"
Import "Color.bmx"

Type TGuiWidget Extends TGuiBase

	Global idCounter : Int

	Const NOTHING : Int = 0
	Const HOVER : Int = 1
	Const DOWN : Int = 2
	
	Field widgetState : Int	

	Field id : Int
	
	Field childs : TList
	Field parent : TGuiWidget

	Field color : TColor
	
	Field clicked : Byte

	Method ToFront()
		ListRemove(TGuiSystem.widgets, Self)
		ListAddLast(TGuiSystem.widgets, Self)
		For Local c : TGuiWidget = EachIn childs
			c.ToFront()
		Next
	End Method	
	
	Method New()
		idCounter :+ 1
		id = idCounter
		visible = True
		childs = CreateList()
		rect = TRect.Create(0, 0, 100, 100)
		color = TColor.Create(255, 255, 255)
		ListAddLast(TGuiSystem.widgets, Self)
	End Method
	
	Method OnActivate()
		ToFront()
	End Method

	Method Render()
		color.Set()
		DrawRect(rect.GetX(), rect.GetY(), rect.GetW(), rect.GetH())
	End Method
	
	Method AddChild(w : TGuiWidget)
		If (w.parent) Then w.parent.RemoveChild(w)
		ListAddLast(childs, w)
		w.parent = Self
	End Method
	
	Method RemoveChild(w : TGuiWidget)
		ListRemove(childs, w)
	End Method

	Method Update()
		clicked = False
		If (Not MouseDown(1))
			If TGuiSystem.topElement <> Self Then widgetState = NOTHING Else widgetState = HOVER
		End If
	End Method
	
	Method GetWidgetState : Int()
		Return widgetState
	End Method
	
	Method OnMouseHit()
		widgetState = DOWN
	End Method
	
	Method OnMouseUp()
		widgetState = NOTHING
		If (TGuiSystem.topElement = Self) Then clicked = True ; widgetState = HOVER
	End Method
	
	Method IsClicked : Byte()
		Return clicked
	End Method
	
	Method OnMouseOut()
		If (widgetState = HOVER) Then widgetState = NOTHING
	End Method

	Method OnMouseOver()
			If (widgetState = NOTHING) Then widgetState = HOVER
	End Method
		
	Method OnMouseMove(dx : Int, dy : Int)
	End Method
	
	Method OnMouseDown()
	End Method
	
	Method OnRMouseDown()
	End Method
	
	Method OnMouseClick()
	End Method
	
	Method OnMove()
		rect.Move(-TInputControllerMouse.GetInstance().GetDX(), -TInputControllerMouse.GetInstance().GetDY())
	End Method
		
End Type

