ModuleInfo "Version: 1.00"
ModuleInfo "Author: Bruce A Henderson"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: 2008-2010 Bruce A Henderson"
ModuleInfo "History: 1.00"
ModuleInfo "History: Initial Release"
import brl.blitz
import bah.libxml
import brl.reflection
import brl.stream
TPersist^brl.blitz.Object{
BMO_VERSION%=5
format%&=mem("_bah_persistence_TPersist_format")
compressed%&=mem("_bah_persistence_TPersist_compressed")
xmlParserMaxDepth%&=mem("_bah_persistence_TPersist_xmlParserMaxDepth")
maxDepth%&=mem("_bah_persistence_TPersist_maxDepth")
.doc:bah.libxml.TxmlDoc&
.objectMap:brl.map.TMap&
.lastNode:bah.libxml.TxmlNode&
.fileVersion%&
-New%()="_bah_persistence_TPersist_New"
-Delete%()="_bah_persistence_TPersist_Delete"
+Serialize$(obj:Object)="_bah_persistence_TPersist_Serialize"
-Free%()="_bah_persistence_TPersist_Free"
-SerializeToString$(obj:Object)="_bah_persistence_TPersist_SerializeToString"
-SerializeToFile%(obj:Object,filename$)="_bah_persistence_TPersist_SerializeToFile"
-SerializeToDoc:bah.libxml.TxmlDoc(obj:Object)="_bah_persistence_TPersist_SerializeToDoc"
-SerializeToStream%(obj:Object,stream:brl.stream.TStream)="_bah_persistence_TPersist_SerializeToStream"
-ToString$()="_bah_persistence_TPersist_ToString"
-ProcessArray%(arrayObject:Object,size%,node:bah.libxml.TxmlNode,typeId:brl.reflection.TTypeId)="_bah_persistence_TPersist_ProcessArray"
-SerializeObject%(obj:Object,parent:bah.libxml.TxmlNode="bbNullObject")="_bah_persistence_TPersist_SerializeObject"
+DeSerialize:Object(data:Object)="_bah_persistence_TPersist_DeSerialize"
-DeSerializeFromDoc:Object(xmlDoc:bah.libxml.TxmlDoc)="_bah_persistence_TPersist_DeSerializeFromDoc"
-DeSerializeFromFile:Object(filename$)="_bah_persistence_TPersist_DeSerializeFromFile"
-DeSerializeFromStream:Object(stream:brl.stream.TStream)="_bah_persistence_TPersist_DeSerializeFromStream"
-DeSerializeObject:Object(text$,parent:bah.libxml.TxmlNode="bbNullObject")="_bah_persistence_TPersist_DeSerializeObject"
+GetObjRef$(obj:Object)="_bah_persistence_TPersist_GetObjRef"
+Base36$(val%)="_bah_persistence_TPersist_Base36"
}="bah_persistence_TPersist"
