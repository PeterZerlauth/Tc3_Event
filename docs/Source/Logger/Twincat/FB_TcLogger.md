# FB_TcLogger

```iecst
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
```

### VAR_INPUT

| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `eLogLevel` | [E_LogLevel](../../../Types/Logger/List/E_LogLevel.md) | `= E_LogLevel.Info` | Provide logging |

### VAR

| Name | Type | Description |
| :--- | :--- | :--- |
| `fbSourceInfo` | `FB_TcSourceInfo` |  |
| `aAlarm` | `ARRAY[0..99]` |  |
| `nAlarm` | `UINT` | Message count |
| `bAlarm` | `ARRAY[0..99]` |  |
| `nIndex` | `UINT` |  |
| `nTimestamp` | `LINT` |  |

## Properties

| Name | Declaration |
| :--- | :--- |
| `P_LogLevel` | ```iecst
{attribute 'OPC.UA.DA.Property' := '1'}
{attribute 'monitoring' := 'variable'}
PROPERTY PUBLIC P_LogLevel : E_LogLevel
``` |

## Methods

### M_Log

```iecst
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			FB_Message;
END_VAR
VAR
	sArgument:			STRING;
	nPosition: 			INT;
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
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

</details>

### M_Reset

```iecst
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
```

**Returns:** `BOOL`

<details>
<summary>Implementation</summary>

```iecst
nIndex := 0;
WHILE nIndex < nAlarm DO
    IF bAlarm[nIndex] = TRUE THEN
		bAlarm[nIndex]:= FALSE;
    END_IF
    nIndex := nIndex + 1;
END_WHILE
M_Reset:= TRUE;
```

</details>

