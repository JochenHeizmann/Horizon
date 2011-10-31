
Type TSimpleTween
	Field steps:Float
	Field currentStep:Float
	Field speed:Float
	
	Field sourceVal:Float
	Field destVal:Float

	Field currentVal:Float
		
	Method New()
		steps = 100.0
		currentStep = 0
		
		sourceVal = 0
		destVal = 100
	End Method
	
	Function Create:TSimpleTween(sourceVal:Float, destVal:Float, speed:Float = 1.0)
		Local st:TSimpleTween = New TSimpleTween
		st.sourceVal = sourceVal
		st.destVal = destVal
		st.speed = speed
		Return st
	End Function
	
	Method Update()
		currentVal = currentStep / steps
		currentVal = ((currentVal) * (currentVal) * (3 - 2 * (currentVal)))
		currentVal = (destVal * currentVal) + (sourceVal * (1 - currentVal))
		currentStep :+ speed
		If (currentStep > steps) Then currentStep = steps
	End	Method
	
	Method IsFinished:Byte()
		Return (currentStep >= steps)
	End Method
	
	Method GetValue:Float()
		Return currentVal
	End Method
	
	Method Reset()
		currentStep = 0
	End Method
End Type