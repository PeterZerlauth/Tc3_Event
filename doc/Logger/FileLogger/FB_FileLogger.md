# FB_FileLogger

**Type:** FUNCTION_BLOCK

**Source File:** `Logger/FileLogger/FB_FileLogger.TcPOU`

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

// --- Implementation ---
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
// Log Level
IF eLogLevel > fbMessage.eLogLevel THEN
	M_Log:= TRUE;
	RETURN;
END_IF

nTimestamp:= fbMessage.nTimestamp;

// Remove expired messages (>1 s old)
nIndex := 0;
WHILE nIndex < nBuffer DO
    IF (nTimestamp - aBuffer[nIndex].nTimestamp) > 1_000_000 THEN // 1 s = 1e6 µs
        MEMMOVE(ADR(aBuffer[nIndex]), ADR(aBuffer[nIndex + 1]), SIZEOF(FB_Message) * (nBuffer - nIndex - 1));
        nBuffer := nBuffer - 1;
    ELSE
        nIndex := nIndex + 1;
    END_IF
END_WHILE

// Skip if message already in buffer
nIndex := 0;
WHILE nIndex < nBuffer DO
    IF (aBuffer[nIndex].nID = fbMessage.nID)
       AND (aBuffer[nIndex].sDefault = fbMessage.sDefault) THEN
	   aBuffer[nIndex].nTimestamp:= fbMessage.nTimestamp;
        M_Log := TRUE;
        RETURN;
    END_IF
	nIndex := nIndex + 1;
END_WHILE

// Add new message
IF nBuffer < 99 THEN
    aBuffer[nBuffer] := fbMessage;
    aBuffer[nBuffer].nTimestamp := nTimestamp;
    nBuffer := nBuffer + 1;
END_IF

// Format log line
sLogLine := CONCAT('[', FILETIME64_TO_ISO8601(nTimestamp, 0, FALSE, 3));
sLogLine := CONCAT(sLogLine, '] ');
sLogLine := CONCAT(sLogLine, TO_STRING(fbMessage.eLogLevel));
sLogLine := CONCAT(sLogLine, ' [');
sLogLine := CONCAT(sLogLine, UDINT_TO_STRING(fbMessage.nID));
sLogLine := CONCAT(sLogLine, '] ');
sLogLine := CONCAT(sLogLine, fbMessage.sDefault);
sLogLine := CONCAT(sLogLine, '$R$N');

// Write once per new message
fbFile.M_Open(sPathName);
fbFile.M_Write(ADR(sLogLine), INT_TO_UINT(LEN(sLogLine)));
fbFile.M_Close();

M_Log := TRUE;
END_METHOD

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
M_Reset:= true;
END_METHOD

// --- Property (read/write): P_LogLevel ---
PROPERTY P_LogLevel : UNKNOWN
END_PROPERTY
```

### References / Cross-links
- [FB_FileLogger](Logger/FileLogger/FB_FileLogger.md)
- [I_Logger](Logging/I_Logger.md)
- [I_LogLevel](Logger/FileLogger/I_LogLevel.md)
- [E_LogLevel](Logger/List/E_LogLevel.md)
- [FB_File](Helpers/File/FB_File.md)
- [FB_Message](Message/FB_Message.md)

