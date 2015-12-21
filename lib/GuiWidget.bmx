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
	
	Field parent : TGuiWidget

	Field color : TColor
	
	Field clicked : Byte
	Field entered:Byte
	
	Method IsChildOf:Byte(element:TGuiBase)
		If (Not element) Then Return True
		If (parent) 
			If (parent = element) Then Return True
			Return parent.IsChildOf(element)
		End If
		Return False		
	End Method

	'dirty helper method because of time pressure, sorry
	Method IsMouseEntered:Byte()
		Local ret:Byte = entered
		entered = False
		Return (ret)
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

	Method ToFront()
		Local root:TGuiBase = GetRootParent(Self.parent)
		If root
			TGuiWidget(root).ChildsToFront()
		Else
			ChildsToFront()
		EndIf
	End Method
	
	Function GetRootParent:TGuiBase(widget:TGuiBase)
		If widget
			Local root:TGuiBase
			While widget
				root = widget
				widget = TGuiWidget(root).parent
			Wend
			Return root
		EndIf
		Return Null
	End Function

	Method ChildsToFront()
			ListRemove(TGuiSystem.widgets, Self)
			ListAddLast(TGuiSystem.widgets, Self)
			For Local c : TGuiWidget = EachIn childs
				c.ChildsToFront()
			Next
	End Method
	
	Method ToBack()
		ListRemove(TGuiSystem.widgets, Self)
		For Local c : TGuiBase = EachIn childs
			c.ToBack()
		Next
		ListAddFirst(TGuiSystem.widgets, Self)
	End Method
	
	Method OnActivate()
		ToFront()
	End Method

	Method Render()
	End Method
	
	Method AddChild(w : TGuiWidget)
		If (w.parent) Then w.parent.RemoveChild(w)
		ListAddLast(childs, w)
		w.parent = Self
	End Method
	
	Method RemoveChild(w : TGuiWidget)
		ListRemove(childs, w)
		w.parent = Null
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
		entered = False
	End Method

	Method OnMouseOver()
		If (widgetState = NOTHING) Then widgetState = HOVER
		entered = True
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
	
	Method OnRMouseHit()
	End Method
	
	Method OnRMouseUp()
	End Method
	
	Method Hide()
		Super.Hide()
		clicked = False
	End Method
End Type

