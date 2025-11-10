# FB_FileLogger

**Type:** `FUNCTION BLOCK`
**Source File:** `Logger/FileLogger/FB_FileLogger.TcPOU`

Provide logging

## Inputs
| Name | Type | Description |
| --- | --- | --- |
| `eLogLevel` | `E_LogLevel` |  |
| `sPathName` | `STRING` |  |

## Local Variables
| Name | Type | Description |
| --- | --- | --- |
| `eLogLevel` | `E_LogLevel` |  |
| `sPathName` | `STRING` |  |

## Methods

### `M_Log` : `BOOL`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `fbMessage` | `FB_Message` |  |

**Implementation:**
```iec
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
```

---
### `M_Reset` : `BOOL`
*No documentation found.*

**Implementation:**
```iec
M_Reset:= true;
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
```
