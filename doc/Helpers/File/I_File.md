# I_File

**Type:** Interfaces (TcIO)
**Source File:** `Helpers/File/I_File.TcIO`

## Details
**Declaration**
```st
INTERFACE I_File
```

### Methods

#### M_Close
```st
// close file
METHOD PUBLIC M_Close : BOOL
VAR_INPUT
END_VAR
```
---
#### M_Delete
```st
// Delete file
METHOD PUBLIC M_Delete : BOOL
VAR_INPUT
    sFileName : STRING(255);
END_VAR
```
---
#### M_GetSize
```st
// get file size
METHOD PUBLIC M_GetSize : UDINT
VAR_INPUT
END_VAR
```
---
#### M_Open
```st
// Open file
METHOD PUBLIC M_Open : BOOL
VAR_INPUT
    sFileName:				STRING(255);
	eMode: 					SysFile.ACCESS_MODE := SysFile.AM_APPEND_PLUS;
END_VAR
```
---
#### M_Read
```st
// Read file
METHOD PUBLIC M_Read : BOOL
VAR_INPUT
END_VAR
```
---
#### M_Status
```st
// state of file
METHOD PUBLIC M_Status : E_FileState
VAR_INPUT
END_VAR
```
---
#### M_Write
```st
// Write file
METHOD PUBLIC M_Write : BOOL
VAR_INPUT
	pBuffer:	POINTER TO BYTE;
    nSize:     	UDINT;
END_VAR
```
---

