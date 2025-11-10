# FB_File

**Type:** Program Organization Units (POUs)
**Source File:** `Helpers/File/FB_File.TcPOU`

## Details
**Declaration**
```st
// SysFile from codesys
{attribute 'no_explicit_call' := 'do not call this POU directly'} 
FUNCTION_BLOCK FB_File IMPLEMENTS I_File
VAR_INPUT
END_VAR
VAR_OUTPUT
    pBuffer:				POINTER TO BYTE;
    nBuffer:				UDINT;	
	bError:					BOOL;
END_VAR
VAR
	sFileName:				STRING(255);
	eMode: 					SysFile.ACCESS_MODE := SysFile.AM_APPEND_PLUS;
    hFile: 					SysFile.SysTypes.RTS_IEC_HANDLE;
	nResult:				SysFile.SysTypes.RTS_IEC_RESULT;
	{attribute 'hide'} 
	pResult:				POINTER TO SysFile.SysTypes.RTS_IEC_RESULT:= ADR(nResult);
END_VAR
```

### Methods

#### FB_Exit
```st
//FB_Exit must be implemented explicitly. If there is an implementation, then the
//method is called before the controller removes the code of the function block instance
//(implicit call). The return value is not evaluated.
// Try to close and reset on exit
METHOD FB_Exit: BOOL
VAR_INPUT
    bInCopyCode: BOOL;  // TRUE: the exit method is called in order to leave the instance which will be copied afterwards (online change).  
END_VAR
```
---
#### M_Close
```st
// Closes the file if opened
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
// Get file size
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
    sFileName:				STRING(255);					// file path
	eMode: 					SysFile.ACCESS_MODE := SysFile.AM_APPEND_PLUS;	// file mode
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
#### M_Reset
```st
// Reset all 
METHOD PUBLIC M_Reset : BOOL
VAR_INPUT
END_VAR
```
---
#### M_Status
```st
// File status
METHOD PUBLIC M_Status : E_FileState
VAR_INPUT
END_VAR
VAR 
	nState:				SysFile.SYS_FILE_STATUS;
END_VAR
```
---
#### M_Write
```st
// Writes content to a file
METHOD PUBLIC M_Write : BOOL
VAR_INPUT
	pBuffer:	POINTER TO BYTE;
    nSize:     	UDINT;
END_VAR
```
---

