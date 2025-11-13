# F_Log

**Type:** `FUNCTION`
**Source File:** `Helpers/F_Log.TcPOU`

Standalone logger, if no logger is attached to FB_Event, nice for tessting

**Returns:** `BOOL`

## Inputs
| Name | Type | Description |
| --- | --- | --- |
| `fbMessage` | `REFERENCE` |  |

## Local Variables
| Name | Type | Description |
| --- | --- | --- |
| `fbMessage` | `REFERENCE` |  |

## Implementation
```iec
// --- Build log line
sMessage := CONCAT('Logger null | ', fbMessage.sSource);
sMessage := CONCAT(sMessage, ': ');
sMessage := CONCAT(sMessage, fbMessage.sDefault);

// --- Keep active
nIndex := 0;
WHILE nIndex < GVL.nBuffer DO
    IF GVL.aBuffer[nIndex].sDefault = fbMessage.sDefault THEN
		GVL.aBuffer[nIndex].bActive:= TRUE;
        F_Log := TRUE;
        RETURN;
    END_IF
    nIndex := nIndex + 1;
END_WHILE

// --- Add to buffer ---
IF GVL.nBuffer < 99 THEN
    GVL.aBuffer[GVL.nBuffer] := fbMessage;
    GVL.aBuffer[GVL.nBuffer].nTimestamp := GVL.nTimestamp;
    GVL.nBuffer := GVL.nBuffer + 1;
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
WHILE nIndex < GVL.nBuffer DO
    IF (GVL.nTimestamp - GVL.aBuffer[nIndex].nTimestamp) > 1_000_000_000 THEN // 1 s = 1e9 ns
        MEMMOVE(ADR(GVL.aBuffer[nIndex]), ADR(GVL.aBuffer[nIndex + 1]), SIZEOF(FB_Message) * (GVL.nBuffer - nIndex - 1));
        GVL.nBuffer := GVL.nBuffer - 1;
    ELSE
        nIndex := nIndex + 1;
    END_IF
END_WHILE


F_Log := TRUE;
```
