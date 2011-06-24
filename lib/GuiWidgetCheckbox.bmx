
SuperStrict

Import "GuiWidget.bmx"
Import "InputControllerMouse.bmx"

Type TGuiWidgetCheckbox Extends TGuiWidget
	Field checked:Byte
	
	Field checkboxImage:TImage
	
	Method New()
		Local img:TImage = LoadImage(TGuiSystem.SKIN_PATH + "checkbox.png")
		If (img)
			img = LoadAnimImage(TGuiSystem.SKIN_PATH + "checkbox.png", ImageWidth(img) / 3, ImageHeight(img), 0, 3)
			SetCheckboxImage(img)
		End If
	End Method

	Method SetCheckboxImage(img:TImage)
		checkboxImage = img
		rect.w = ImageWidth(checkboxImage)
		rect.h = ImageHeight(checkboxImage)
	End Method
	
	Method Update()
		Super.Update()
	End Method
	
	Method Render()
		If (GetWidgetState() = NOTHING)
			DrawImage (checkboxImage, rect.x, rect.y)
		Else
			If (TInputControllerMouse.GetInstance().IsMouseDown(TInputControllerMouse.BUTTON_LEFT))
				SetColor(128, 128, 128)
				DrawImage (checkboxImage, rect.X, rect.Y, 1)
				SetColor(255, 255, 255)
			Else
				DrawImage (checkboxImage, rect.X, rect.Y, 1)
			End If
		End If
		If (checked)
			DrawImage (checkboxImage, rect.x, rect.y, 2)
		End If
	End Method	

	Method OnMouseUp()
		Super.OnMouseUp()
		If (clicked) Then checked = Not checked
	End Method
End Type

