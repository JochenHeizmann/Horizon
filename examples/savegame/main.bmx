
SuperStrict

Import "../../lib/SavedGameManagerDefault.bmx"

Local mgr:TSavedGameManagerDefault = New TSavedGameManagerDefault

'Reading everything
mgr.Read()
Local games:TList = mgr.GetSavedGames()
Print "Highscore"
For Local user:TSavedGameDefaultUser = EachIn games
	Print user.name
	Print user.score
Next

mgr.ClearAll()

'And Writing...
mgr.AddSavedGame(TSavedGameDefaultUser.Create("joe", 100))
mgr.AddSavedGame(TSavedGameDefaultUser.Create("tina", 500))
mgr.AddSavedGame(TSavedGameDefaultUser.Create("mario", 5000))
mgr.Write()

End