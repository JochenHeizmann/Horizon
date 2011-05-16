SuperStrict

Type TProfileNode
	Global completeTime:Float = 0

	Field startTime:Int
	Field name:String
	Field parent:TProfileNode
	Field childs:TList
	
	Field dMin:Float
	Field dMax:Float
	Field dSum:Float
	Field dCount:Int
	
	Method WriteOutput(strs:TList, level:Int = 0)		
		Local ll:String 
		For Local i:Int = 0 To level
			ll = ll + "--"
		Next
		Local ave:String = GetAve()
		Local pos:Int = Instr(ave, ".")
		If (pos > 0)
			ave = Mid(ave, 0, pos + 4)
		End If
		
		Local percentage:Float = dSum / completeTime * 100.0
		
		strs.AddLast(dCount + " | " + ave + " | " + Int(dMin) + " | " + Int(dMax) + " | " + Int(percentage) + "% | " + ll + "> " + name)
		For Local p:TProfileNode = EachIn childs
			p.WriteOutput(strs, level + 1)
		Next
	End Method
	
	Method New()
		childs = CreateList()
	End Method
	
	Method Init()
		startTime = MilliSecs()		
	End Method
	
	Method Stop()
		Local duration:Int = MilliSecs() - startTime
		dSum :+ duration
		dCount :+ 1
		If (duration < dMin) Then dMin = duration
		If (duration > dMax) Then dMax = duration
	End Method
	
	Method GetAve:Float()
		Return (dSum/dCount)
	End Method
End Type
