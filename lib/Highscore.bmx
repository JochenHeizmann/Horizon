
SuperStrict

Import "HighscoreEntry.bmx"

Type THighscore
	Field entries:TList
	
	Method New()
		entries = CreateList()
	End Method
	
	Method AddEntry:THighscoreEntry(name:String, score:Int)
		Local e:THighscoreEntry = New THighscoreEntry
		e.score = score
		e.name = name
		ListAddLast(entries, e)
		Return e
	End Method
	
	Method Sort()
		SortList(entries, True, THighscoreEntry.CompareEntries)
		Local id:Int = 1
		For Local e:THighscoreEntry = EachIn entries
			e.id = id
			id:+1
		Next
	End Method
	
	Method GetEntries:TList(cap:Int = 0)
		If (cap > 0)
			If (CountList(entries) > cap)
				Local tl:TList = CreateList()
				For Local i:Int = 0 To cap-1
					ListAddLast(tl, entries.ValueAtIndex(i))
				Next
				entries = tl
			End If
		End If
		Return entries
	End Method
End Type