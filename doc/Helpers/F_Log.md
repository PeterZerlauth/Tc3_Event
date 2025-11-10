[[ _TOC_ ]]

## F_Log

**Type:** FUNCTION

#### Description  
Backup logger, if no logger is attached to FB_Event

#### Inputs  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| fbMessage | `REFERENCE TO FB_Message` |  |  |

#### Outputs  
-

#### Locals  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sMessage | `STRING(255)` | `= 'Logger null | '` |  |
| nIndex | `UINT` |  |  |
| nNow | `ULINT` | `= F_GetSystemTime()` |  |

<details>
<summary>Raw IEC/ST</summary>

```iec
// Backup logger, if no logger is attached to FB_Event
FUNCTION F_Log : BOOL
VAR_INPUT
	fbMessage:			REFERENCE TO FB_Message;
END_VAR
VAR
	sMessage:			STRING(255):= 'Logger null | ';
    nIndex:				UINT;
    nNow:				ULINT:= F_GetSystemTime();
END_VAR

// --- Implementation ---

// --- Build log line
sMessage := CONCAT('Logger null | ', fbMessage.sSource);
sMessage := CONCAT(sMessage, ': ');
sMessage := CONCAT(sMessage, fbMessage.sDefault);

// --- Keep active
nIndex := 0;
WHILE nIndex < nBuffer DO
    IF aBuffer[nIndex].sDefault = fbMessage.sDefault THEN
		aBuffer[nIndex].bActive:= TRUE;
        F_Log := TRUE;
        RETURN;
    END_IF
    nIndex := nIndex + 1;
END_WHILE

// --- Add to buffer ---
IF nBuffer < UPPER_BOUND(aBuffer, 1) THEN
    aBuffer[nBuffer] := fbMessage;
	// @ToDo
    aBuffer[nBuffer].nTimestamp := nNow;
    nBuffer := nBuffer + 1;
END_IF

// --- Log message ---
CASE fbMessage.eLogLevel OF
    E_LogLevel.Verbose, E_LogLevel.Info:
        ADSLOGSTR(ADSLOG_MSGTYPE_HINT, '%s', sMessage);
    E_LogLevel.Warning:
        ADSLOGSTR(ADSLOG_MSGTYPE_WARN, '%s', sMessage);
    E_LogLevel.Error, E_LogLevel.Critical:
        ADSLOGSTR(ADSLOG_MSGTYPE_ERROR, '%s', sMessage);
END_CASE

// --- Remove outdated messages (>1 s old) ---
nIndex := 0;
WHILE nIndex < nBuffer DO
    IF (nNow - aBuffer[nIndex].nTimestamp) > 1_000_000_000 THEN // 1 s = 1e9 ns
        MEMMOVE(ADR(aBuffer[nIndex]), ADR(aBuffer[nIndex + 1]), SIZEOF(FB_Message) * (nBuffer - nIndex - 1));
        nBuffer := nBuffer - 1;
    ELSE
        nIndex := nIndex + 1;
    END_IF
END_WHILE


F_Log := TRUE;
```

</details>

