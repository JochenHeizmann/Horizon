
SuperStrict

Import "SavedGameManager.bmx"
Import "SystemFullaccess.bmx"
Import "SavedGameDefaultUser.bmx"

Type TSavedGameManagerDefault Extends TSavedGameManager
	Const REVISION:Int = 0
	Const FILENAME:String = "userProfiles.cfg"
		
	Method Remove(name:String)		
		For Local user:TSavedGameDefaultUser = EachIn savedGames
			If (User.name = name)
				ListRemove(savedGames, user)
				Return
			End If
		Next
	End Method

	Method RemoveById(id:Int)
		Local count:Int=0
		For Local user:TSavedGameDefaultUser = EachIn savedGames
			If (count=id)
				ListRemove(savedGames, user)
				Return 
			End If
			count:+1
		Next
	End Method
	
	Method GetSavedGames:TList()
		Return savedGames
	End Method
	
	Method ClearAll()
		For Local user:TSavedGameDefaultUser = EachIn savedGames
			user = Null
		Next
		ClearList(savedGames)
		savedGames = Null
		savedGames = CreateList()
		globalData = Null
	End Method
	
	Method AddSavedGame(savedGame:TSavedGame)
		ListAddLast(savedGames, savedGame)
	End Method
		
	Method Write:Byte()
		DebugLog "Save Userdata..."
		Local stream:TStream = WriteFile(TSystemFullaccess.GetPath() + FILENAME)		
		
		If (stream)
			WriteInt(stream, REVISION)
			
			If (Not globalData)
				WriteByte(stream, False)
			Else
				WriteByte(stream, True)
				globalData.Serialize(stream)
			End If
			
			WriteInt(stream, CountList(savedGames))
			For Local user:TSavedGameDefaultUser = EachIn savedGames
				DebugLog "Write user..."
				user.Serialize(stream)
			Next

			CloseFile(stream)
			Return True
		Else
			Return False
		End If
	End Method
	
	Method Read:Byte()	
		Local stream:TStream = ReadFile(TSystemFullaccess.GetPath() + FILENAME)
	
		If (stream)
			ClearAll()
			
			Local rev:Int = ReadInt(stream)
			If (rev <> REVISION) Then RuntimeError("Wrong file format: " + rev)
			
			Local globalDataAvailable:Byte = ReadByte(stream)
			If (globalDataAvailable)
				globalData = TSavedGame(TSavedGame.Deserialize(stream))
			End If
			
			Local count:Int = ReadInt(stream)
			For Local i:Int = 0 To count-1
				Local user:TSavedGameDefaultUser = TSavedGameDefaultUser(TSavedGameDefaultUser.Deserialize(stream))
				AddSavedGame(user)
				DebugLog "Readuser..."
			Next
			Return True
		Else 
			Return False
		End If
	End Method
End Type
