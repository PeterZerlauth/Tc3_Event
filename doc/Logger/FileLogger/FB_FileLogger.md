# FB_FileLogger

**Type:** FUNCTION BLOCK

**Source File:** `Logger/FileLogger/FB_FileLogger.TcPOU`

### References

- [FB_FileLogger](./Logger/FileLogger/FB_FileLogger.md)
- [I_Logger](./Logging/I_Logger.md)
- [I_LogLevel](./Logger/FileLogger/I_LogLevel.md)
- [E_LogLevel](./Logger/List/E_LogLevel.md)
- [FB_File](./Helpers/File/FB_File.md)
- [FB_Message](./Message/FB_Message.md)

<details>
<summary>Raw IEC/ST</summary>

```iec
// Provide logging 
FUNCTION_BLOCK FB_FileLogger IMPLEMENTS I_Logger, I_LogLevel
VAR_INPUT
	eLogLevel:				E_LogLevel:= E_LogLevel.Verbose;
	sPathName:				STRING(255):= 'C:\tempx\logger.txt';
END_VAR
VAR
	fbFile:					FB_File;
	aBuffer:				ARRAY[0..99] OF FB_Message;
    nBuffer:				UINT := 0;                     // Message count
END_VAR

// --- Implementation code ---
// https://peterzerlauth.com/
```
</details>
