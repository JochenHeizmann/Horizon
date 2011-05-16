SuperStrict 

Type TProfile
	Global samples:TMap = CreateMap()
	Global currentNode:TProfileNode

	Function Start(name:String)
		Local p:TProfileNode = TProfileNode(MapValueForKey(samples, name))
		If (p)
			p.Init()			
			currentNode = p
			Return
		End If

		p = New TProfileNode
		p.Init()
		p.name = name		
		MapInsert(samples, name, p)	
		If (currentNode)	
			p.parent = currentNode
			currentNode.childs.AddLast(p)
		End If
		currentNode = p
		Return
	End Function
		
	Function Done()
		currentNode.Stop()
		If (currentNode.parent)
			currentNode = currentNode.parent
		Else 
			currentNode = Null
		End If
	End Function
		
	Function GetOutput:TList()
		Local strs:TList = CreateList()
		strs.AddLast("Count | Ave | Min | Max | CPU | Name")
		
		TProfileNode.completeTime = 0
		For Local p:TProfileNode = EachIn MapValues(samples)
			If (p.parent = Null) Then TProfileNode.completeTime :+ p.dSum
		Next
		
		For Local p:TProfileNode = EachIn MapValues(samples)
			If (p.parent = Null) Then p.WriteOutput(strs)
		Next
		Return strs
	End Function
End Type