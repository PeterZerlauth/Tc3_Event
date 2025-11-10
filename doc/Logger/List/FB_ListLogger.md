# FB_ListLogger

**Type:** FUNCTION_BLOCK

**Source File:** `Logger/List/FB_ListLogger.TcPOU`

```iec
// Provide logging 
FUNCTION_BLOCK FB_ListLogger IMPLEMENTS I_Logger, I_LogLevel
VAR_INPUT
	eLogLevel:				E_LogLevel:= E_LogLevel.Verbose;
END_VAR
VAR
	{attribute 'OPC.UA.DA.Property' := '1'}
	aMessages:				ARRAY[0..99] OF FB_Message; 	// Message store
	{attribute 'OPC.UA.DA.Property' := '1'}
    nMessages:				UINT := 0;                     // Message count
	{attribute 'hide'} 
	nIndex: 				UINT;
	{attribute 'hide'} 
	nTimestamp:				LINT;
END_VAR

// --- Implementation ---
// https://peterzerlauth.com/

IF nTimestamp < TwinCAT_SystemInfoVarList._TaskInfo[GETCURTASKINDEXEX()].DcTaskTime THEN // 1 second = 1e9 ns
	nTimestamp := TwinCAT_SystemInfoVarList._TaskInfo[GETCURTASKINDEXEX()].DcTaskTime + 1000000000;
	nIndex:= 0;
	WHILE nIndex < nMessages DO
		IF aMessages[nIndex].bActive THEN
			IF aMessages[nIndex].eLogLevel <= E_LogLevel.Warning THEN
				aMessages[nIndex].bActive:= FALSE;
			END_IF
			nIndex := nIndex + 1;
		ELSE
			MEMMOVE(ADR(aMessages[nIndex]), ADR(aMessages[nIndex + 1]), SIZEOF(FB_Message) * (nMessages - nIndex));
			nMessages := nMessages - 1;
			RETURN;
		END_IF
	END_WHILE
END_IF

// --- Method: M_Log ---
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			FB_Message;
END_VAR
VAR
END_VAR
IF eLogLevel > fbMessage.eLogLevel THEN
	M_Log:= TRUE;
	RETURN;
END_IF

IF nMessages > 99 THEN 
	RETURN;
END_IF

// Skip if same sMessage already exists
nIndex := 0;
WHILE nIndex < nMessages DO
    IF aMessages[nIndex].sDefault = fbMessage.sDefault THEN
		aMessages[nIndex].bActive:= TRUE;
        M_Log := TRUE;
        RETURN; // message already in buffer
    END_IF
    nIndex := nIndex + 1;
END_WHILE

aMessages[nMessages]:= fbMessage;;
nMessages := nMessages + 1;
M_Log := TRUE;
END_METHOD

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
nIndex := 0;
WHILE nIndex < nMessages DO
    IF aMessages[nIndex].bActive = TRUE THEN
		aMessages[nIndex].bActive:= FALSE;
    END_IF
    nIndex := nIndex + 1;
END_WHILE
M_Reset:= TRUE;
END_METHOD

// --- Property (read/write): P_LogLevel ---
PROPERTY P_LogLevel : UNKNOWN
END_PROPERTY
```

### References / Cross-links
- [FB_ListLogger](Logger/List/FB_ListLogger.md)
- [I_Logger](Logging/I_Logger.md)
- [I_LogLevel](Logger/FileLogger/I_LogLevel.md)
- [E_LogLevel](Logger/List/E_LogLevel.md)
- [FB_Message](Message/FB_Message.md)

