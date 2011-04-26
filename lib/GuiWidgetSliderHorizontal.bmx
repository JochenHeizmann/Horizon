
SuperStrict

Import "GuiWidget.bmx"

Type TGuiWidgetSliderHorizontal Extends TGuiWidget
	Field sliderPosX:Float
	Field startSlide:Byte
	
	Field barImage:TImage
	Field sliderImage:TImage
	
	Method New()
		SetBarImage(LoadImage(TGuiSystem.SKIN_PATH + "slider/slider.png"))
		SetSliderImage(LoadImage(TGuiSystem.SKIN_PATH + "slider/knob.png"))
	End Method

	Method SetBarImage(img:TImage)
		barImage = img
		rect.w = ImageWidth(barImage)
		rect.h = ImageHeight(barImage)
	End Method
	
	Method SetSliderImage(img:TImage)
		sliderImage = img
		MidHandleImage(sliderImage)
	End Method
	
	Method Update()
		Print GetPositionInPercent()
		If (startSlide)
			sliderPosX :- TInputControllerMouse.GetInstance().GetDX()
			If (sliderPosX < 0) Then sliderPosX = 0
			If (sliderPosX > rect.w) Then sliderPosX = rect.w
		End If
	End Method
	
	Method Render()
		If (barImage And sliderImage)
			DrawImage (barImage, rect.x, rect.y)
			DrawImage (sliderImage, rect.x + sliderPosX, rect.y + rect.h / 2)
		Else		
			SetColor(255,0,0)
			DrawRect(rect.x, rect.y, rect.w, rect.h)
			SetColor(0,255,0)
		
			DrawRect(rect.x + sliderPosX - 2, rect.y - 2, 4, rect.h + 4)		
		End If
	End Method	
	
	Method OnMouseDown()
		Super.OnMouseDown()
		startSlide = True
		sliderPosX = TInputControllerMouse.GetInstance().GetX() - rect.x
		If (sliderPosX < 0) Then sliderPosX = 0
		If (sliderPosX > rect.w) Then sliderPosX = rect.w
	End Method
	
	Method OnMouseUp()
		Super.OnMouseUp()
		startSlide = False
	End Method
	
	Method GetPositionInPercent:Float()
		Return sliderPosX / rect.w * 100.0
	End Method
	
	Method GetPositionInPixel:Int()
		Return sliderPosX
	End Method	
End Type
