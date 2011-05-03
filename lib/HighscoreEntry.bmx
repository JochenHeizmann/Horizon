
SuperStrict

Type THighscoreEntry
	Field id:Int
	Field score:Int
	Field name:String
	Field obj:Object
	
	Function CompareEntries:Int(o1:Object, o2:Object)
		Return (THighscoreEntry(o1).score < THighscoreEntry(o2).score)
	End Function
End Type

