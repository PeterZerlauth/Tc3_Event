# FB_ListLogger

**Type:** FUNCTION BLOCK

**Source File:** `Logger/List/FB_ListLogger.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
// Provide logging 
FUNCTION_BLOCK [FB_ListLogger](Logger/List/FB_ListLogger.md) IMPLEMENTS [I_Logger](Logging/I_Logger.md), [I_LogLevel](Logger/FileLogger/I_LogLevel.md)
VAR_INPUT
	eLogLevel:				[E_LogLevel](Logger/List/E_LogLevel.md):= [E_LogLevel](Logger/List/E_LogLevel.md).Verbose;
END_VAR
VAR
	{attribute 'OPC.UA.DA.Property' := '1'}
	aMessages:				ARRAY[0..99] OF [FB_Message](Message/FB_Message.md); 	// Message store
	{attribute 'OPC.UA.DA.Property' := '1'}
    nMessages:				UINT := 0;                     // Message count
	{attribute 'hide'} 
	nIndex: 				UINT;
	{attribute 'hide'} 
	nTimestamp:				LINT;
END_VAR

// --- Implementation code ---
// https://peterzerlauth.com/

IF nTimestamp < TwinCAT_SystemInfoVarList._TaskInfo[GETCURTASKINDEXEX()].DcTaskTime THEN // 1 second = 1e9 ns
	nTimestamp := TwinCAT_SystemInfoVarList._TaskInfo[GETCURTASKINDEXEX()].DcTaskTime + 1000000000;
	nIndex:= 0;
	WHILE nIndex < nMessages DO
		IF aMessages[nIndex].bActive THEN
			IF aMessages[nIndex].eLogLevel <= [E_LogLevel](Logger/List/E_LogLevel.md).Warning THEN
				aMessages[nIndex].bActive:= FALSE;
			END_IF
			nIndex := nIndex + 1;
		ELSE
			MEMMOVE(ADR(aMessages[nIndex]), ADR(aMessages[nIndex + 1]), SIZEOF([FB_Message](Message/FB_Message.md)) * (nMessages - nIndex));
			nMessages := nMessages - 1;
			RETURN;
		END_IF
	END_WHILE
END_IF

// --- Method: M_Log ---
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			[FB_Message](Message/FB_Message.md);
END_VAR
VAR
END_VAR

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR

// --- Property (read/write): P_LogLevel ---
PROPERTY P_LogLevel : UNKNOWN
```
</details>
