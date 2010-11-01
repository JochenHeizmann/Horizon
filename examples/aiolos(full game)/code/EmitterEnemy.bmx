
SuperStrict
Import BRL.Stream
Import BRL.LinkedList
Import BaH.Persistence

Import "Emitter.bmx"

Type TEmitterEnemy Extends TEmitter
	Method Init()
		SetStartColor(255,0,0)
	End Method
	
	Method Serialize(stream:TStream)
		Local oldParticleList:TList = particleList
		particleList = Null
		Local persistance:TPersist = New TPersist
		Local str:String = persistance.SerializeToString(Self)
		WriteInt(stream, str.length)
		WriteString(stream, str)
		particleList = oldParticleList
	End Method
	
	Function Deserialize: TEmitterEnemy(stream:TStream)
		Local persistance:TPersist = New TPersist
		Local l:Int = ReadInt(stream)
		Local str:String = ReadString(stream, l)
		DebugLog str
		Local em:TEmitterEnemy = TEmitterEnemy(persistance.DeSerializeObject(str))
		em.particleList = CreateList()
		Return em
	End Function
	
End Type

