[[ _TOC_ ]]

## FB_FileLogger

**Type:** FUNCTION BLOCK

#### Description  
Provide logging

#### Inputs  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| eLogLevel | `E_LogLevel` | `= E_LogLevel.Verbose` |  |
| sPathName | `STRING(255)` | `= 'C:\tempx\logger.txt'` |  |

#### Outputs  
-

#### Locals  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| fbFile | `FB_File` |  |  |
| aBuffer | `ARRAY[0..99] OF FB_Message` |  |  |
| nBuffer | `UINT` | `= 0` | Message count |

### Methods

#### M_Log

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| fbMessage | `FB_Message` |  |  |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

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

</details>

#### M_Reset

returns : `BOOL`  

**Description**  
-

**Input**  
-

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
M_Reset:= true;
```

</details>

### Properties

#### P_LogLevel

```iec
{attribute 'OPC.UA.DA.Property' := '1'}
{attribute 'monitoring' := 'variable'}
PROPERTY PUBLIC P_LogLevel : E_LogLevel
```

<details>
<summary>Raw IEC/ST</summary>

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
```

</details>

