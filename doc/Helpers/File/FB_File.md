# FB_File

**Type:** FUNCTION BLOCK

**Source File:** `Helpers/File/FB_File.TcPOU`

### References

- [FB_File](./Helpers/File/FB_File.md)
- [I_File](./Helpers/File/I_File.md)

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

// --- Implementation code ---
// https://peterzerlauth.com/
```
</details>
