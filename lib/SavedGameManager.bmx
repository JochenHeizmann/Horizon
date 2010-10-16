
SuperStrict

Import "SavedGame.bmx"

Type TSavedGameManager
	Field savedGames:TList
	Field globalData:TSavedGame
	
	Method New()
		savedGames = CreateList()
	End Method
	
	Method Write:Byte() Abstract
	Method Read:Byte() Abstract
	Method ClearAll() Abstract
End Type
