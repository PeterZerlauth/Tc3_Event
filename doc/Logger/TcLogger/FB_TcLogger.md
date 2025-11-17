# FB_TcLogger

**Type:** `FUNCTION BLOCK`
**Source File:** `Logger/TcLogger/FB_TcLogger.TcPOU`

Provide TwinCAT 3 Eventlogger

## Local Variables
| Name | Type | Description |
| --- | --- | --- |
| `eLogLevel` | `E_LogLevel` |  |
| `eventClass` | `GUID` |  |
| `fbSourceInfo` | `FB_TcSourceInfo` |  |
| `nAlarm` | `UINT` | Message count |
| `bAlarm` | `ARRAY` |  |
| `nIndex` | `UINT` |  |
| `nTimestamp` | `LINT` |  |

## Methods

### `M_Log` : `BOOL`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `fbMessage` | `FB_Message` |  |

**Implementation:**
```iec
// 555652537:= F_Hash('###Reset###');
IF fbMessage.nID = 555652537 THEN
	// handle reset
	M_Log:= M_Reset();
	RETURN;
END_IF

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
    IF aAlarm[nIndex].EqualsToEventEntry(eventClass, fbMessage.nID, LogLevel_To_Severity(fbMessage.eLogLevel))  THEN
		bAlarm[nIndex]:= TRUE;
        M_Log := TRUE;
        RETURN;
    END_IF
    nIndex := nIndex + 1;
END_WHILE

// prepare
fbSourceInfo.Clear();
fbSourceInfo.sName:= fbMessage.sSource;
aAlarm[nAlarm].Create(eventClass,  fbMessage.nID, LogLevel_To_Severity(fbMessage.eLogLevel), FALSE, fbSourceInfo);
aAlarm[nAlarm].ipArguments.Clear();

// Split and add arguments
nPosition := FIND(fbMessage.sArguments, '$R');
WHILE nPosition > 0 DO
    sArgument := LEFT(fbMessage.sArguments, nPosition - 1);
    aAlarm[nAlarm].ipArguments.AddString(sArgument);
    fbMessage.sArguments:= RIGHT(fbMessage.sArguments, LEN(fbMessage.sArguments) - (nPosition + 1));
    nPosition := FIND(fbMessage.sArguments, '$R');
END_WHILE;

// Raise alarm
aAlarm[nAlarm].Raise(fbMessage.nTimestamp);

nAlarm := nAlarm + 1;
M_Log := TRUE;
```

---
### `M_Reset` : `BOOL`
*No documentation found.*

**Implementation:**
```iec
nIndex := 0;
WHILE nIndex < nAlarm DO
    IF bAlarm[nIndex] = TRUE THEN
		bAlarm[nIndex]:= FALSE;
    END_IF
    nIndex := nIndex + 1;
END_WHILE
M_Reset:= TRUE;
```

---

## Properties

### `P_LogLevel`
*No documentation found.*

**Get Implementation:**
```iec
P_LogLevel:= eLogLevel;
```
**Set Implementation:**
```iec
eLogLevel:= P_LogLevel;
```

---

## Implementation
```iec
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
```
