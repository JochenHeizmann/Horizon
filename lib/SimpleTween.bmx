
Type SimpleTween
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
	End
	
	Function Create(sourceVal:Float, destVal:Float, speed:Float = 1.0)
		Local st:SimpleTween = New SimpleTween
		st.sourceVal = sourceVal
		st.destVal = destVal
		st.speed = speed
		Return st
	End Function
	
	Method Update()
		currentVal = currentStep / steps
		currentVal = ((currentVal) * (currentVal) * (3 - 2 * (currentVal)))
		currentVal = (destVal * currentVal) + (sourceVal * (1 - currentVal))
		currentStep += speed
		If (currentStep > steps) Then currentStep = steps
	End		
	
	Method IsFinished:Bool()
		Return (currentStep >= steps)
	End Method
End