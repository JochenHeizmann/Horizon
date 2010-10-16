
SuperStrict

Type TFader
	Const FADE_OUT:Int = 0
	Const FADE_OFF:Int = 1
	Const FADE_IN:Int = 2
	
	Const DEFAULT_SPEED:Float = 0.05
	
	Field fadeState:Int
	Field speed:Float
	Field position:Float
	
	Method New()
		speed = DEFAULT_SPEED
		fadeState = FADE_IN 
		position = 1
	End Method
	
	Method Render() Abstract
	
	Method Update()
		Select (fadeState)
			Case FADE_OUT
				position :+ speed
				If (position >= 1)
					position = 1
					fadeState = FADE_OFF
				End If
				
			Case FADE_IN
				position :- speed
				If (position <= 0)
					position = 0
					fadeState = FADE_OFF
				End If
		End Select
	End Method

	Method SetFadingSpeed(speed:Float)
		Self.speed = speed
	End Method
	
	Method IsFading:Byte()
		Return (fadeState <> FADE_OFF)
	End Method
	
	Method FadeIn()
		fadeState = FADE_IN
	End Method
	
	Method FadeOut()
		fadeState = FADE_OUT
	End Method
End Type
