# FB_File

```iecst
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

### VAR_OUTPUT

| Name | Type | Description |
| :--- | :--- | :--- |
| `pBuffer` | `POINTER` |  |
| `nBuffer` | `UDINT` |  |
| `bError` | `BOOL` |  |

### VAR

| Name | Type | Description |
| :--- | :--- | :--- |
| `sFileName` | `STRING(255)` |  |
| `eMode` | `SysFile.ACCESS_MODE` |  |
| `hFile` | `SysFile.SysTypes.RTS_IEC_HANDLE` |  |
| `nResult` | `SysFile.SysTypes.RTS_IEC_RESULT` |  |
| `pResult` | `POINTER` |  |

## Methods

### FB_Exit

```iecst
//FB_Exit must be implemented explicitly. If there is an implementation, then the
//method is called before the controller removes the code of the function block instance
//(implicit call). The return value is not evaluated.
// Try to close and reset on exit
METHOD FB_Exit: BOOL
VAR_INPUT
    bInCopyCode: BOOL;  // TRUE: the exit method is called in order to leave the instance which will be copied afterwards (online change).  
END_VAR
```

**Returns:** `BOOL`

<details>
<summary>Implementation</summary>

```iecst
M_Reset();
```

</details>

### M_Close

```iecst
// Closes the file if opened
METHOD PUBLIC M_Close : BOOL
VAR_INPUT
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF hFile > 0 THEN
   nResult:= SysFile.SysFileClose(hFile);
   IF nResult = 0 THEN
	   hFile:= 0;
	   M_Close:= TRUE;
   ELSE
	    bError := TRUE;
   END_IF
END_IF
```

</details>

### M_Delete

```iecst
// Delete file
METHOD PUBLIC M_Delete : BOOL
VAR_INPUT
    sFileName : STRING(255);
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF hFile > 0 THEN
	M_Close();
END_IF

nResult:= SysFile.SysFileDelete(sFileName);
IF nResult = 0 THEN
	M_Delete:= TRUE;
ELSE
    bError := TRUE;
END_IF
```

</details>

### M_GetSize

```iecst
// Get file size
METHOD PUBLIC M_GetSize : UDINT
VAR_INPUT
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
M_GetSize:= LWORD_TO_UDINT(SysFile.SysFileGetSize(sFileName, pResult));

IF nResult <> 0 THEN
	bError := TRUE;
END_IF
```

</details>

### M_Open

```iecst
// Open file
METHOD PUBLIC M_Open : BOOL
VAR_INPUT
    sFileName:				STRING(255);					// file path
	eMode: 					SysFile.ACCESS_MODE := SysFile.AM_APPEND_PLUS;	// file mode
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF hFile = 0 THEN
	THIS^.eMode:= eMode;
	hFile := SysFile.SysFileOpen(sFileName, eMode, pResult);
	IF hFile = SysFile.SysTypes.RTS_INVALID_HANDLE  THEN
		bError := TRUE;
		RETURN;
	END_IF

   IF nResult = 0 THEN
	   THIS^.sFileName:= sFileName;
	   M_Open:= TRUE;
   ELSE
	    bError := TRUE;
   END_IF
ELSE 
	IF THIS^.sFileName = sFileName THEN
		M_Open:= TRUE;
	END_IF
END_IF
```

</details>

### M_Read

```iecst
// Read file
METHOD PUBLIC M_Read : BOOL
VAR_INPUT
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF pBuffer <> 0 THEN
	__DELETE(pBuffer);
	nBuffer:= 0;
END_IF

nBuffer:= M_GetSize();

IF nBuffer > 0 THEN
    pBuffer:= __NEW(BYTE, nBuffer);
	IF pBuffer = 0 THEN
		RETURN;
	END_IF
END_IF

IF M_Read = 0 THEN
	M_Read := TRUE;
ELSE
	bError:= TRUE;
END_IF
```

</details>

### M_Reset

```iecst
// Reset all 
METHOD PUBLIC M_Reset : BOOL
VAR_INPUT
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF pBuffer <> 0 THEN
	__DELETE(pBuffer);
	nBuffer:= 0;
END_IF

M_Close();

bError:= FALSE;
M_Reset:= TRUE;
```

</details>

### M_Status

```iecst
// File status
METHOD PUBLIC M_Status : E_FileState
VAR_INPUT
END_VAR
VAR 
	nState:				SysFile.SYS_FILE_STATUS;
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
bError := FALSE;
nResult := 0; // This function does not use pResult

IF hFile < 0 THEN
   nState := SysFile.SysFileGetStatus(hFile);
   CASE nState OF
	   SysFile.SYS_FILE_STATUS.FS_OK:
   			M_Status:= E_FileState.OK;
			
	   SysFile.SYS_FILE_STATUS.FS_NO_FILE:
			M_Status:= E_FileState.NO_FILE;
			
	   SysFile.SYS_FILE_STATUS.FS_ILLEGAL_POS:
			M_Status:= E_FileState.ILLEGAL_POS;   
			
	   SysFile.SYS_FILE_STATUS.FS_FULL:
			M_Status:= E_FileState.FULL; 
			
	   SysFile.SYS_FILE_STATUS.FS_EOF:   
			M_Status:= E_FileState.EOF;
 
   END_CASE
   
END_IF
```

</details>

### M_Write

```iecst
// Writes content to a file
METHOD PUBLIC M_Write : BOOL
VAR_INPUT
	pBuffer:	POINTER TO BYTE;
    nSize:     	UDINT;
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF pBuffer = 0 OR nSize = 0 THEN
    RETURN;
END_IF

IF hFile > 0 THEN
	SysFile.SysFileWrite(hFile := hFile, pbyBuffer := pBuffer, ulSize := nSize, pResult := pResult);
END_IF

IF nResult = 0 THEN
	M_Write := TRUE;
ELSE
	bError:= TRUE;
END_IF
```

</details>

