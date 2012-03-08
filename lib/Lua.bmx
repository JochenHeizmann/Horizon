SuperStrict

Import "external/lua_object.c"
Import "DelegateFunction.bmx"
Import "LuaArgument.bmx"

Extern
	Function lua_boxobject(L:Byte Ptr, obj:Object)
	Function lua_unboxobject:Object(L:Byte Ptr, index%)
	Function lua_pushlightobject(L:Byte Ptr, obj:Object)
	Function lua_tolightobject:Object(L:Byte Ptr, index%)
	Function lua_gcobject(L:Byte Ptr)
	Function lua_upvalue(i%)
End Extern

Type TLua
	Global luaState:Byte Ptr = Null
	Global metaTable:Int
	Global functions:TMap = CreateMap()
	
	Method New()
		luaState = GetLuaState()
		metaTable = Null
	End Method
	
	Function Invoke:Int(L:Byte Ptr)
		Local params% = lua_gettop(L)
		
		Local fname$ = lua_tostring(luaState, lua_upvalue(3))
		Local f:TDelegateFunction = TDelegateFunction(MapValueForKey(functions, fname))
		If (Not f)
			Throw ("Function " + fname + " not found!")
		End If
				
		If (params <> f.argTypes.Length)
			Throw (f.argTypes.Length + " Arguments expected. (" + params + " given)")
		End If
		
		Local args:Object[params]
		For Local i:Int = 0 To params-1
			Select f.argTypes[i]
				Case IntTypeId, ShortTypeId, ByteTypeId, LongTypeId
					args[i]=String.FromInt(lua_tointeger(L, i+1))
				
				Case FloatTypeId
					args[i] = String.FromFloat(lua_tonumber(L, i+1))

				Case DoubleTypeId
					args[i] = String.FromDouble(lua_tonumber(L, i+1))
		
				Case StringTypeId
					args[i] = lua_tostring(L,i+1)
					
				Case ArrayTypeId
					luaL_checktype(L, i+1, LUA_TTABLE)
					Local size% = lua_objlen(L, i+1)
					Local arr:String[size]
					For Local j% = 1 To size
						lua_rawgeti(L, i+1, j)
						Local top% = lua_gettop(L)
						arr[j-1] = lua_tostring(L, top)
					Next
					args[i] = arr
					
				Default
					args[i] = lua_unboxobject(L, i+1)
			End Select
		Next

		If (Not f.returnType)
			f.Invoke(args)
			Return 0
		Else
			Select f.returnType
				Case IntTypeId, ShortTypeId, ByteTypeId, LongTypeId
					lua_pushinteger(luaState, String(f.Invoke(args)).ToInt())
				
				Case FloatTypeId
					lua_pushnumber(luaState, String(f.Invoke(args)).ToFloat())
	
				Case DoubleTypeId
					lua_pushnumber(luaState, String(f.Invoke(args)).ToDouble())
		
				Case StringTypeId
					lua_pushstring(luaState, String(f.Invoke(args)))
				
				Case ArrayTypeId
					PushArray(luaState, f.Invoke(args))
	
				Default
					PushObject(luaState, Object(f.Invoke(args)))
					
			End Select
							
			Return 1
		End If
	End Function
	
	Function PushArray(L:Byte Ptr, obj:Object)
		Local typeId:TTypeId = TTypeId.ForObject(obj)
		Local size:Int = typeId.ArrayLength(obj)
		
		lua_createtable(L, size, 0)
		
		For Local i:Int = 0 To size-1
			' the index
			lua_pushinteger(L, i)
			
			Select typeId.ElementType()
				Case IntTypeId, ShortTypeId, ByteTypeId, LongTypeId
					lua_pushinteger(L, typeId.GetArrayElement(obj, i).ToString().ToInt())
				
				Case FloatTypeId
					lua_pushnumber(L, typeId.GetArrayElement(obj, i).ToString().ToFloat())
				
				Case DoubleTypeId
					lua_pushnumber(L, typeId.GetArrayElement(obj, i).ToString().ToDouble())
				
				Case StringTypeId
					Local s:String = typeId.GetArrayElement(obj, i).ToString()
					lua_pushlstring(L, s, s.length)
					
				Case ArrayTypeId
					PushArray(L, typeId.GetArrayElement(obj, i))
					
				Default
					PushObject(L, typeId.GetArrayElement(obj, i))
			End Select
			
			lua_settable(L, -3)
		Next
	End Function

	Function PushObject( L:Byte Ptr,obj:Object )
		lua_boxobject(L, obj)
		lua_rawgeti(L, LUA_REGISTRYINDEX, GetMetaTable(L))
		lua_setmetatable(L, -2)
	End Function
	
	Function GetMetaTable:Int(L:Byte Ptr)
		If Not metaTable
			lua_newtable(L)
			lua_pushcfunction(L, lua_gcobject)
			lua_setfield(L, -2, "__gc")
			lua_pushcfunction(L, IndexObject)
			lua_setfield(L, -2, "__index")
			lua_pushcfunction(L, NewIndexObject)
			lua_setfield(L, -2, "__newindex")
			metaTable = luaL_ref(L, LUA_REGISTRYINDEX)
		End If
		Return metaTable
	End Function
	
	Function IndexObject:Int(L:Byte Ptr)
		If Index(L) Then Return 1
	End Function
	
	Function NewIndexObject(L:Byte Ptr)
		If NewIndex(L) Then Return
		Throw "ERROR"
	End Function

	Function Index:Int(L:Byte Ptr)
		Local obj:Object = lua_unboxobject(L, 1)
		Local typeId:TTypeId = TTypeId.ForObject(obj)
		Local ident$=lua_tostring(L, 2)
		Local mth:TMethod = typeId.FindMethod(ident)
		If mth
			lua_pushvalue(L, 1)
			lua_pushlightobject(L, mth)
			lua_pushcclosure(L, InvokeObjMethod, 2)
			Return True
		End If
		
		Local fld:TField = typeId.FindField(ident)
		If fld
			Select fld.TypeId()
				Case IntTypeId, ShortTypeId, ByteTypeId, LongTypeId
					lua_pushinteger(L, fld.GetInt(obj))
				Case FloatTypeId
					lua_pushnumber(L, fld.GetFloat(obj))
				Case DoubleTypeId
					lua_pushnumber(L, fld.GetDouble(obj))
				Case StringTypeId
					Local t$ = fld.GetString(obj)
					lua_pushlstring(L, t, t.length)
				Default
					PushObject(L, fld.Get(obj))
			End Select
			Return True
		End If
	End Function
	
	Function NewIndex:Int(L:Byte Ptr)
		Local obj:Object = lua_unboxobject(L, 1)
		Local typeId:TTypeId = TTypeId.ForObject(obj)
		Local ident$ = lua_tostring(L, 2)
		Local mth:TMethod = typeId.FindMethod(ident)
		If mth Throw "ERROR"
		
		Local fld:TField = typeId.FindField(ident)
		If fld
			Select fld.TypeId()
				Case IntTypeId, ShortTypeId, ByteTypeId, LongTypeId
					fld.SetInt(obj, lua_tointeger(L, 3))
				Case FloatTypeId
					fld.SetFloat(obj, lua_tonumber(L, 3))
				Case DoubleTypeId
					fld.SetDouble(obj, lua_tonumber(L, 3))
				Case StringTypeId
					fld.SetString(obj, lua_tostring(L, 3))
				Default
					fld.Set(obj, lua_unboxobject(L, 3))
			End Select
			Return True
		End If
	End Function

	Function InvokeObjMethod%( L:Byte Ptr )
		Local obj:Object=lua_unboxobject( L,LUA_GLOBALSINDEX-1 )
		Local meth:TMethod=TMethod( lua_tolightobject( L,LUA_GLOBALSINDEX-2 ) )
		Local tys:TTypeId[]=meth.ArgTypes(),args:Object[tys.length]
		For Local i%=0 Until args.length
			Select tys[i]
			Case IntTypeId, ShortTypeId, ByteTypeId, LongTypeId
				args[i]=String.FromInt( lua_tointeger( L,i+1 ) )
			Case FloatTypeId
				args[i]=String.FromFloat( lua_tonumber( L,i+1 ) )
			Case DoubleTypeId
				args[i]=String.FromDouble( lua_tonumber( L,i+1 ) )
			Case StringTypeId
				args[i]=lua_tostring( L,i+1 )
			Default
				args[i]=lua_unboxobject( L,i+1 )
			End Select
		Next
		Local t:Object=meth.Invoke( obj,args )
		Select meth.TypeId()
		Case IntTypeId, ShortTypeId, ByteTypeId, LongTypeId
			lua_pushinteger L,t.ToString().ToInt()
		Case FloatTypeId
			lua_pushnumber L,t.ToString().ToFloat()
		Case DoubleTypeId
			lua_pushnumber L,t.ToString().ToDouble()
		Case StringTypeId
			Local s$=t.ToString()
			lua_pushlstring L,s,s.length
		Default
			PushObject L,t
		End Select
		Return 1
	End Function
	
	Method GetLuaState:Byte Ptr()
		If Not luaState
			luaState  = luaL_newstate()
			luaL_openlibs(luaState)
		End If
		Return luaState	
	End Method

	Method GetInt%(name$)
		lua_getfield(luaState, LUA_GLOBALSINDEX, name)
		Return lua_tointeger(luaState, -1)
	End Method

	Method GetFloat:Float(name$)
		lua_getfield(luaState, LUA_GLOBALSINDEX, name)
		Return lua_tonumber(luaState, -1)
	End Method

	Method GetDouble:Float(name$)
		lua_getfield(luaState, LUA_GLOBALSINDEX, name)
		Return lua_tonumber(luaState, -1)
	End Method
	
	Method GetString$(name$)
		lua_getfield(luaState, LUA_GLOBALSINDEX, name)
		Return lua_tostring(luaState, -1)
	End Method
	
	Method RegisterInt(name$, value%)
		lua_pushinteger(luaState, value)
		lua_setfield(luaState, LUA_GLOBALSINDEX, name)
	End Method
	
	Method RegisterString(name$, value$)
		lua_pushstring(luaState, value)
		lua_setfield(luaState, LUA_GLOBALSINDEX, name)
	End Method
	
	Method RegisterDouble(name$, value:Double)
		lua_pushnumber(luaState, value)
		lua_setfield(luaState, LUA_GLOBALSINDEX, name)
	End Method
	
	Method RegisterFloat(name$, value:Float)
		RegisterDouble(name, value)
	End Method
	
	Method RegisterBoolean(name$, value:Byte)
		lua_pushboolean(luaState, value)
		lua_setfield(luastate, LUA_GLOBALSINDEX, name)
	End Method

	Method RegisterFunction(name$, func:TDelegateFunction)
		functions.Insert(name, func)
		lua_pushstring(luaState, name)
		lua_pushcclosure(luaState, Self.Invoke, 1)
		lua_setfield(luaState, LUA_GLOBALSINDEX, name)
	End Method	

	Method LoadAndRun(luaFilename:String)
		If (luaL_dofile(luaState, luaFilename))
			Local error$ = lua_tostring(luaState, -1)
			lua_pop(luaState, 1)
			Throw error
		End If
	End Method
	
	Method Execute(script:String)
		If (luaL_dostring(luaState, script))
			Local error$ = lua_tostring(luaState, -1)
			lua_pop(luaState, 1)
			Throw error
		End If
	End Method
	
	Method Call:Object[](functionName$, args:TLuaArgument[] = Null)
		lua_getglobal(luaState, functionName)
		If (lua_type(luaState, -1) = LUA_TFUNCTION)
			If (args)
				For Local i:Int = 1 To args.Length
					args[i-1].Push(luaState)
				Next
			End If
			If (lua_pcall(luaState, args.Length, 0, 0))
				DumpError()
			End If
		End If
		lua_pop(luaState, -1)
	End Method
	
	Method DumpError()
		Throw "ERROR: " + lua_tostring(luaState, -1 )
	End Method
End Type