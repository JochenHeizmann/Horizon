
SuperStrict

?Win32
	Import "external/SystemFullaccess.cpp"
	Import "-ladvapi32"

	Const PATH_SEPERATOR:String = "\"
	
	Extern "Win32"
	Function SHGetSpecialFolderLocation(hwndOwner, nFolder, pIdl:Byte Ptr)
	Function SHGetPathFromIDList(pidList, lpBuffer:Byte Ptr)
	
	Function CreateFile(lpString:Byte Ptr,dwDesiredAccess:Int,dwShareMode:Int,..
		lpSecurityAttributes:Byte Ptr,dwCreationDisposition:Int,dwFlagsAndAttributes:Int,hWnd:Int)
	End Extern
	
	Extern
		Function GiveDirectoryUserFullAccess:Int(lpPath$z)
	EndExtern
	
	Const CSIDL_DESKTOP = $0
	Const CSIDL_INTERNET = $1
	Const CSIDL_PROGRAMS = $2
	Const CSIDL_CONTROLS = $3
	Const CSIDL_PRINTERS = $4
	Const CSIDL_PERSONAL = $5
	Const CSIDL_FAVORITES = $6
	Const CSIDL_STARTUP = $7
	Const CSIDL_RECENT = $8
	Const CSIDL_SENDTO = $9
	Const CSIDL_BITBUCKET = $A
	Const CSIDL_STARTMENU = $B
	Const CSIDL_DESKTOPDIRECTORY = $10
	Const CSIDL_DRIVES = $11
	Const CSIDL_NETWORK = $12
	Const CSIDL_NETHOOD = $13
	Const CSIDL_FONTS = $14
	Const CSIDL_TEMPLATES = $15
	Const CSIDL_COMMON_STARTMENU = $16
	Const CSIDL_COMMON_PROGRAMS = $17
	Const CSIDL_COMMON_STARTUP = $18
	Const CSIDL_COMMON_DESKTOPDIRECTORY = $19
	Const CSIDL_APPDATA = $1A
	Const CSIDL_PRINTHOOD = $1B
	Const CSIDL_LOCAL_APPDATA = $1C
	Const CSIDL_ALTSTARTUP = $1D
	Const CSIDL_COMMON_ALTSTARTUP = $1E
	Const CSIDL_COMMON_FAVORITES = $1F
	Const CSIDL_INTERNET_CACHE = $20
	Const CSIDL_COOKIES = $21
	Const CSIDL_HISTORY = $22
	Const CSIDL_COMMON_APPDATA = $23
?

?MacOs
	Const PATH_SEPERATOR:String = "/"
	Const kUserDomain:Int=-32763
	Const kVolumeRootFolderType:Int=Asc("r") Shl 24 | Asc("o") Shl 16 | Asc( "o") Shl 8 | Asc("t")
	
	Extern
		Function FSFindFolder( vRefNum:Int,folderType:Int,createFolder:Byte,foundRef:Byte Ptr )
		Function FSRefMakePath( ref:Byte Ptr,path:Byte Ptr,maxPathsize:Int )
	End Extern
?

Type TSystemFullaccess	
	Global Path:String

	Function GetSpecialFolder:String(folder_id:Int)		
		?Win32 
			Local  idl:TBank = CreateBank (8) 
			Local  pathbank:TBank = CreateBank (260) 
			If SHGetSpecialFolderLocation(0,folder_id,BankBuf(idl)) = 0		
				SHGetPathFromIDList PeekInt( idl,0), BankBuf(pathbank)
				Return String.FromCString(pathbank.Buf()) + PATH_SEPERATOR
			EndIf
		?
		?MacOs
			Local buf:Byte[1024],ref:Byte[80]
		
			If FSFindFolder( kUserDomain,kVolumeRootFolderType,False,ref ) Then Return PATH_SEPERATOR + "Library" + PATH_SEPERATOR + "Preferences" + PATH_SEPERATOR
			If FSRefMakePath( ref,buf,1024 ) Then Return PATH_SEPERATOR + "Library" + PATH_SEPERATOR + "Preferences" + PATH_SEPERATOR
		
			Return String.FromCString( buf ) + PATH_SEPERATOR + "Library" + PATH_SEPERATOR + "Preferences" + PATH_SEPERATOR
		?
	End Function
	
	Function SetPath(mypath:String)
		?Win32
			Path = GetSpecialFolder(CSIDL_COMMON_APPDATA)+mypath
		?
		?MacOs
			Path = GetSpecialFolder(0)+mypath
		?
		If ReadDir(Path) = 0 Then
			DebugLog "Creating New Folder: "+Path
			DebugLog "CreateDir="+CreateDir(Path,True) 'create subfolders
			?Win32
				DebugLog "FullAccess="+GiveDirectoryUserFullAccess(Path)
			?
		Else
			DebugLog "Folder already exists: "+Path
		EndIf		
	End Function

	Function GetPath:String()
		If (Path = "") Then SetPath(AppTitle + PATH_SEPERATOR)
		Return Path
	End Function	
End Type