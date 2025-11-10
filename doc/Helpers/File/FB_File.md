# FB_File

**Type:** FUNCTION BLOCK

**Source File:** `Helpers/File/FB_File.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
// SysFile from codesys
{attribute 'no_explicit_call' := 'do not call this POU directly'} 
FUNCTION_BLOCK [FB_File](Helpers/File/FB_File.md) IMPLEMENTS [I_File](Helpers/File/I_File.md)
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

// --- Implementation code ---
// https://peterzerlauth.com/

// --- Method: FB_Exit ---
//FB_Exit must be implemented explicitly. If there is an implementation, then the
//method is called before the controller removes the code of the function block instance
//(implicit call). The return value is not evaluated.
// Try to close and reset on exit
METHOD FB_Exit: BOOL
VAR_INPUT
    bInCopyCode: BOOL;  // TRUE: the exit method is called in order to leave the instance which will be copied afterwards (online change).  
END_VAR

// --- Method: M_Close ---
// Closes the file if opened
METHOD PUBLIC M_Close : BOOL
VAR_INPUT
END_VAR

// --- Method: M_Delete ---
// Delete file
METHOD PUBLIC M_Delete : BOOL
VAR_INPUT
    sFileName : STRING(255);
END_VAR

// --- Method: M_GetSize ---
// Get file size
METHOD PUBLIC M_GetSize : UDINT
VAR_INPUT
END_VAR

// --- Method: M_Open ---
// Open file
METHOD PUBLIC M_Open : BOOL
VAR_INPUT
    sFileName:				STRING(255);					// file path
	eMode: 					SysFile.ACCESS_MODE := SysFile.AM_APPEND_PLUS;	// file mode
END_VAR

// --- Method: M_Read ---
// Read file
METHOD PUBLIC M_Read : BOOL
VAR_INPUT
END_VAR

// --- Method: M_Reset ---
// Reset all 
METHOD PUBLIC M_Reset : BOOL
VAR_INPUT
END_VAR

// --- Method: M_Status ---
// File status
METHOD PUBLIC M_Status : [E_FileState](Helpers/File/E_FileState.md)
VAR_INPUT
END_VAR
VAR 
	nState:				SysFile.SYS_FILE_STATUS;
END_VAR

// --- Method: M_Write ---
// Writes content to a file
METHOD PUBLIC M_Write : BOOL
VAR_INPUT
	pBuffer:	POINTER TO BYTE;
    nSize:     	UDINT;
END_VAR
```
</details>
