SuperStrict

Import "Delegate.bmx"

Type TDelegateFunction Extends TDelegate
	Field functionPtr:Byte Ptr
	Field returnType:TTypeId
	Field argTypes:TTypeId[]

	Method Delete()
		functionPtr=Null
		returnType=Null
		argTypes=Null
	End Method

	Method Create:TDelegateFunction(functionPtr:Byte Ptr, returnType:TTypeId = Null, argTypes:TTypeId[] = Null)
		Self.functionPtr = functionPtr
		Self.returnType = returnType
		Self.argTypes = argTypes
		Return Self
	End Method
	
	Method Invoke:Object(args:Object[] = Null)
		Local q:Int[10]
		Local sp:Byte Ptr = q
		If (returnType = LongTypeId) Then sp:+8
		For Local i:Int=0 Until args.length
			If Int Ptr(sp) >= Int Ptr(q)+8 Then Throw "ERROR: To many arguments. Not supported by TDelegateFunction"
			sp = Push(sp, argTypes[i], args[i])
		Next
		If (Int Ptr(sp) > Int Ptr(q)+8) Then Throw "ERROR: To many arguments. Not supported by TDelegateFunction"
		Select returnType
			Case ByteTypeId, ShortTypeId, IntTypeId
				Local f:Int(p0:Int, p1:Int, p2:Int, p3:Int, p4:Int, p5:Int, p6:Int, p7:Int) = functionPtr
				Return String.FromInt(f(q[0] ,q[1] ,q[2] ,q[3] ,q[4] ,q[5] ,q[6] ,q[7]))
			Case LongTypeId
				Local f:Long(p0:Int, p1:Int, p2:Int, p3:Int, p4:Int, p5:Int, p6:Int, p7:Int) = functionPtr
				Return String.FromLong(f(q[0] ,q[1] ,q[2] ,q[3] ,q[4] ,q[5] ,q[6] ,q[7]))
			Case FloatTypeId
				Local f:Float(p0:Int, p1:Int, p2:Int, p3:Int, p4:Int, p5:Int, p6:Int, p7:Int) = functionPtr
				Return String.FromFloat(f(q[0], q[1], q[2], q[3], q[4], q[5], q[6], q[7]))
			Case DoubleTypeId
				Local f:Double(p0:Int, p1:Int, p2:Int, p3:Int, p4:Int, p5:Int, p6:Int, p7:Int) = functionPtr
				Return String.FromDouble(f(q[0], q[1], q[2], q[3], q[4], q[5], q[6], q[7]))
			Default
				Local f:Object(p0:Int, p1:Int, p2:Int, p3:Int, p4:Int, p5:Int, p6:Int, p7:Int) = functionPtr
				Return f(q[0], q[1], q[2], q[3], q[4], q[5], q[6], q[7])
		End Select
	End Method
End Type