# FB_TcLogger

**Type:** FUNCTION BLOCK

**Source File:** `Logger/Twincat/FB_TcLogger.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
// Provide logging 
FUNCTION_BLOCK [FB_TcLogger](Logger/Twincat/FB_TcLogger.md) IMPLEMENTS [I_Logger](Logging/I_Logger.md), [I_LogLevel](Logger/FileLogger/I_LogLevel.md)
VAR_INPUT
	eLogLevel:				[E_LogLevel](Logger/List/E_LogLevel.md):= [E_LogLevel](Logger/List/E_LogLevel.md).Info;
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

// --- Implementation code ---
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
// 			IF aAlarm[nIndex].eSeverity <= [LogLevel_To_TcEventSeverity](Helpers/LogLevel_To_TcEventSeverity.md)([E_LogLevel](Logger/List/E_LogLevel.md).Warning) THEN
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
	fbMessage:			[FB_Message](Message/FB_Message.md);
END_VAR
VAR
	sArgument:			STRING;
	nPosition: 			INT;
END_VAR

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR

// --- Property (read/write): P_LogLevel ---
PROPERTY P_LogLevel : UNKNOWN
```
</details>
