
SuperStrict

Import "SavedGame.bmx"

Type TSavedGameDefaultUser Extends TSavedGame
	Field name:String
	Field score:Int
	Field musicVolume:Int
	Field sfxVolume:Int
	
	Function Create:TSavedGameDefaultUser(name:String, score:Int = 0)
		Local sg:TSavedGameDefaultUser = New TSavedGameDefaultUser
		sg.name = name
		sg.score = score
		Return sg
	End Function
End Type