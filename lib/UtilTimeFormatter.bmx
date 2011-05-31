
SuperStrict

Import Bah.format

Type TUtilTimeFormatter
	Field time:Int
	
	Function Create:TUtilTimeFormatter(time:Int)
		time:/1000
		Local t:TUtilTimeFormatter = New TUtilTimeFormatter
		t.time = time
		Return t
	End Function
	
	Method SetTime(t:Int)
		time = t / 1000
	End Method
	
	Method GetHours:Int()
		Return time / 60.0 / 60.0
	End Method
	
	Method GetMinutes:Int()
		Return (time / 60.0) Mod 60
	End Method
	
	Method GetSeconds:Int()
		Return time Mod 60
	End Method
End Type