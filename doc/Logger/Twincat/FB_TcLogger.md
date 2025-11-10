# FB_TcLogger

**Type:** FUNCTION_BLOCK

**Source File:** `Logger/Twincat/FB_TcLogger.TcPOU`

```iec
// Provide logging 
FUNCTION_BLOCK FB_TcLogger IMPLEMENTS I_Logger, I_LogLevel
VAR_INPUT
	eLogLevel:				E_LogLevel:= E_LogLevel.Info;
END_VAR
VAR
	fbSourceInfo:			FB_TcSourceInfo;
	aAlarm:					ARRAY[0..99] OF FB_TcAlarm; 	// Message store
    nAlarm:					UINT;                     		// Message count
	bAlarm:					ARRAY[0..99] OF BOOL; 	// Message store
	{attribute 'hide'} 
	nIndex: 				UINT;
	{attribute 'hide'} 
	nTimestamp:				LINT;
END_VAR

// --- Implementation ---
// https://peterzerlauth.com/

// @ToDo

// nIndex := 0;
// WHILE nIndex < nAlarm DO
//     IF bAlarm[nIndex] = TRUE THEN
// 		bAlarm[nIndex]:= FALSE;
//     END_IF
//     nIndex := nIndex + 1;
// END_WHILE
// M_Reset:= TRUE;
// // https://peterzerlauth.com/
// 
// IF nTimestamp < TwinCAT_SystemInfoVarList._TaskInfo[GETCURTASKINDEXEX()].DcTaskTime THEN // 1 second = 1e9 ns
// 	nTimestamp := TwinCAT_SystemInfoVarList._TaskInfo[GETCURTASKINDEXEX()].DcTaskTime + 1000000000;
// 	nIndex:= 0;
// 	WHILE nIndex < nAlarm DO
// 		IF bAlarm[nIndex] THEN
// 			IF aAlarm[nIndex].eSeverity <= LogLevel_To_TcEventSeverity(E_LogLevel.Warning) THEN
// 				bAlarm[nIndex]:= FALSE;
// 			END_IF
// 			nIndex := nIndex + 1;
// 		ELSE
// 			aAlarm[nIndex].Release
// 			nMessages := nMessages - 1;
// 			RETURN;
// 		END_IF
// 	END_WHILE
// END_IF

// --- Method: M_Log ---
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			FB_Message;
END_VAR
VAR
	sArgument:			STRING;
	nPosition: 			INT;
END_VAR
IF eLogLevel > fbMessage.eLogLevel THEN
	M_Log:= TRUE;
	RETURN;
END_IF

IF nAlarm > 99 THEN 
	RETURN;
END_IF

// Skip if same sMessage already exists
nIndex := 0;
WHILE nIndex < nAlarm DO
    IF aAlarm[nIndex].EqualsToEventEntry(TC_EVENT_CLASSES.Tc3_Event, fbMessage.nID, LogLevel_To_TcEventSeverity(fbMessage.eLogLevel))  THEN
		bAlarm[nIndex]:= TRUE;
        M_Log := TRUE;
        RETURN;
    END_IF
    nIndex := nIndex + 1;
END_WHILE

// prepare
fbSourceInfo.Clear();
fbSourceInfo.sName:= fbMessage.sSource;
aAlarm[nAlarm].Create(TC_EVENT_CLASSES.Tc3_Event,  fbMessage.nID, LogLevel_To_TcEventSeverity(fbMessage.eLogLevel), FALSE, fbSourceInfo);
aAlarm[nAlarm].ipArguments.Clear();

// Split and add arguments
nPosition := FIND('$R', fbMessage.sArguments);
WHILE nPosition > 0 DO
    sArgument := LEFT(fbMessage.sArguments, nPosition - 1);
    aAlarm[nAlarm].ipArguments.AddString(sArgument);
    fbMessage.sArguments:= RIGHT(fbMessage.sArguments, LEN(fbMessage.sArguments) - (nPosition + 1));
    nPosition := FIND('$R', fbMessage.sArguments);
END_WHILE;

// Raise alarm
aAlarm[nAlarm].Raise(fbMessage.nTimestamp);

nAlarm := nAlarm + 1;
M_Log := TRUE;
END_METHOD

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
nIndex := 0;
WHILE nIndex < nAlarm DO
    IF bAlarm[nIndex] = TRUE THEN
		bAlarm[nIndex]:= FALSE;
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
- [FB_TcLogger](Logger/Twincat/FB_TcLogger.md)
- [I_Logger](Logging/I_Logger.md)
- [I_LogLevel](Logger/FileLogger/I_LogLevel.md)
- [E_LogLevel](Logger/List/E_LogLevel.md)
- [FB_Message](Message/FB_Message.md)

