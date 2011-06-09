
SuperStrict

Import "MusicChannel.bmx"

Rem
TSoundManager.GetInstance().FreeAll()
TSoundManager.GetInstance().SetMusicVolume()
TSoundManager.GetInstance().SetSFXVolume()
TSoundManager.GetInstance().PlayMusic(file:String, fadeSpeed:Float = 0)
TSoundManager.GetInstance().FadeOutAll(exceptList:TList = Null)
TSoundManager.GetInstance().FreeMusic(file:String)
TSoundManager.GetInstance().PreloadSoundeffects(sfxStringList:TList)
TSoundManager.GetInstance().PlaySFX(soundeffect:String, volume:Float, panorama:Float, channel = FREE_CHANNEL)
TSoundManager.GetInstance().FreeAllSFX()
TSoundManager.GetInstance().Update()
EndRem

Type TSoundManager
	Global instance:TSoundManager
	
	Const SFX_CHANNELS:Int = 8
	
	Field musicChannels:TMap
	Field sfxChannel:TMap
	Field globalVolume:Float
	
	Function GetInstance:TSoundManager()
		If (Not instance)
			instance = New TSoundManager
		End If
		Return instance
	End Function
	
	Method New()
		musicChannels = CreateMap()
		sfxChannel = CreateMap()
	End Method
	
	Method Update()
		For Local mc:TMusicChannel = EachIn musicChannels.Values()
			mc.Update()
		Next
	End Method
	
	Method UpdateVolume()
		For Local mc:TMusicChannel = EachIn musicChannels.Values()
			mc.volumeFactor = globalVolume
			mc.UpdateVolume()
		Next
	End Method

	Method StopMusic()
		For Local mc:TMusicChannel = EachIn musicChannels.Values()
			mc.FadeOut()
		Next
	End Method
	
	Method PauseMusic()
		For Local mc:TMusicChannel = EachIn musicChannels.Values()
			mc.FadeOut(True)
		Next
	End Method
	
	Method LoadAndPlayMusic:TMusicChannel(name:String, maxVol:Float = 1.0)
		DebugLog "LoadAndPlayMusic " + name
		Local newMusicCh:TMusicChannel = TMusicChannel(musicChannels.ValueForKey(name))
		If (Not newMusicCh)
			DebugLog "New Channel created: " + name
			newMusicCh = TMusicChannel.Load(name, maxVol)
			musicChannels.Insert(name, newMusicCh)
		End If
		
		newMusicCh.Play(True)
		newMusicCh.State = TMusicChannel.FADE_IN

		UpdateVolume()
		
		Return newMusicCh
	End Method
End Type
