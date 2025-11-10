[[ _TOC_ ]]

## FB_File

**Type:** FUNCTION BLOCK

#### Description  
SysFile from codesys

#### Inputs  
-

#### Outputs  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| pBuffer | `POINTER TO BYTE` |  |  |
| nBuffer | `UDINT` |  |  |
| bError | `BOOL` |  |  |

#### Locals  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sFileName | `STRING(255)` |  |  |
| eMode | `SysFile.ACCESS_MODE` | `= SysFile.AM_APPEND_PLUS` |  |
| hFile | `SysFile.SysTypes.RTS_IEC_HANDLE` |  |  |
| nResult | `SysFile.SysTypes.RTS_IEC_RESULT` |  |  |
| pResult | `POINTER TO SysFile.SysTypes.RTS_IEC_RESULT` | `= ADR(nResult)` |  |

### Methods

#### FB_Exit

returns : `BOOL`  

**Description**  
FB_Exit must be implemented explicitly. If there is an implementation, then the method is called before the controller removes the code of the function block instance (implicit call). The return value is not evaluated. Try to close and reset on exit

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| bInCopyCode | `BOOL` |  | TRUE: the exit method is called in order to leave the instance which will be copied afterwards (online change). |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
M_Reset();
```

</details>

#### M_Close

returns : `-`  

**Description**  
Closes the file if opened

**Input**  
-

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
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

#### M_Delete

returns : `-`  

**Description**  
Delete file

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sFileName | `STRING(255)` |  |  |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
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

#### M_GetSize

returns : `-`  

**Description**  
Get file size

**Input**  
-

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
M_GetSize:= LWORD_TO_UDINT(SysFile.SysFileGetSize(sFileName, pResult));

IF nResult <> 0 THEN
	bError := TRUE;
END_IF
```

</details>

#### M_Open

returns : `-`  

**Description**  
Open file

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sFileName | `STRING(255)` |  | file path |
| eMode | `SysFile.ACCESS_MODE` | `= SysFile.AM_APPEND_PLUS` | file mode |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
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

#### M_Read

returns : `-`  

**Description**  
Read file

**Input**  
-

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
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

#### M_Reset

returns : `-`  

**Description**  
Reset all

**Input**  
-

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
IF pBuffer <> 0 THEN
	__DELETE(pBuffer);
	nBuffer:= 0;
END_IF

M_Close();

bError:= FALSE;
M_Reset:= TRUE;
```

</details>

#### M_Status

returns : `-`  

**Description**  
File status

**Input**  
-

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
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

#### M_Write

returns : `-`  

**Description**  
Writes content to a file

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| pBuffer | `POINTER TO BYTE` |  |  |
| nSize | `UDINT` |  |  |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
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

<details>
<summary>Raw IEC/ST</summary>

```iec
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

// --- Implementation ---

// https://peterzerlauth.com/
```

</details>

