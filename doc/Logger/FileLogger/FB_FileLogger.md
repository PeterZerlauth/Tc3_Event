# FB_FileLogger

**Type:** FUNCTION BLOCK

**Source File:** `Logger/FileLogger/FB_FileLogger.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
// Provide logging 
FUNCTION_BLOCK [FB_FileLogger](Logger/FileLogger/FB_FileLogger.md) IMPLEMENTS [I_Logger](Logging/I_Logger.md), [I_LogLevel](Logger/FileLogger/I_LogLevel.md)
VAR_INPUT
	eLogLevel:				[E_LogLevel](Logger/List/E_LogLevel.md):= [E_LogLevel](Logger/List/E_LogLevel.md).Verbose;
	sPathName:				STRING(255):= 'C:\tempx\logger.txt';
END_VAR
VAR
	fbFile:					[FB_File](Helpers/File/FB_File.md);
	aBuffer:				ARRAY[0..99] OF [FB_Message](Message/FB_Message.md);
    nBuffer:				UINT := 0;                     // Message count
END_VAR

// --- Implementation code ---
// https://peterzerlauth.com/

// --- Method: M_Log ---
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			[FB_Message](Message/FB_Message.md);
END_VAR
VAR
	nTimestamp: 	Tc2_Utilities.T_FILETIME64;
	nIndex: 		uINT;
	sLogLine:		STRING(255);
END_VAR

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR

// --- Property (read/write): P_LogLevel ---
PROPERTY P_LogLevel : UNKNOWN
```
</details>
