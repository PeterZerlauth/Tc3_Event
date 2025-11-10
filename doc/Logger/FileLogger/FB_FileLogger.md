## FB_FileLogger

**Type:** FUNCTION BLOCK

**Source File:** `Logger/FileLogger/FB_FileLogger.TcPOU`

### References / Cross-links
- [P_LogLevel](../P_LogLevel/P_LogLevel.md)
- [-](../Functions/- .md)
- [-](../Functions/- .md)

### IEC Code
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

// --- Method: M_Log ---
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			FB_Message;
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

// --- Property: P_LogLevel ---
{attribute 'OPC.UA.DA.Property' := '1'}
{attribute 'monitoring' := 'variable'}
PROPERTY PUBLIC P_LogLevel : E_LogLevel
```
