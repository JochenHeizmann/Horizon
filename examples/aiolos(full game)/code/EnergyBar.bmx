
SuperStrict

Import BRL.Max2D
Import BRL.PNGLoader

Type TEnergyBar
	Const DISPLAY_ENERGY_BAR:Byte = False
	
	Field energy:Float
	Field barImg:TImage
	
	Method New()
		AutoMidHandle False
		If DISPLAY_ENERGY_BAR
			barImg = LoadAnimImage("data/img/energybar.png", 183, 16, 0, 2)
		End If
		Reset()
	End Method
	
	Method Reset()
		energy = 100.0
	End Method

	Method Render()
		If DISPLAY_ENERGY_BAR
			SetAlpha(1)
			DrawImage (barImg, 30, 550, 1)
			SetViewport (30, 550, ImageWidth(barImg) * energy / 100, ImageHeight(barImg))
			DrawImage (barImg, 30, 550, 0)
			SetViewport (0,0, GraphicsWidth(), GraphicsHeight())
		End If
	End Method
End Type
