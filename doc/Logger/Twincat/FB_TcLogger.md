# FB_TcLogger

**Type:** `FUNCTION BLOCK`
**Source File:** `Logger/Twincat/FB_TcLogger.TcPOU`

*No documentation found.*

## Inputs
| Name | Type | Description |
| --- | --- | --- |
| `eLogLevel` | `E_LogLevel` |  |

## Local Variables
| Name | Type | Description |
| --- | --- | --- |
| `eLogLevel` | `E_LogLevel` |  |

## Methods

### `M_Log`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `fbMessage` | `FB_Message` |  |

**Implementation:**
```iec
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
```
### `M_Reset`
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

## Properties

### `P_LogLevel`
*No documentation found.*

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
