# FB_ListLogger

```iecst
// Provide logging 
FUNCTION_BLOCK FB_ListLogger IMPLEMENTS I_Logger, I_LogLevel
VAR_INPUT
	eLogLevel:				E_LogLevel:= E_LogLevel.Verbose;
END_VAR
VAR
	{attribute 'OPC.UA.DA.Property' := '1'}
	aMessages:				ARRAY[0..99] OF FB_Message; 	// Message store
	{attribute 'OPC.UA.DA.Property' := '1'}
    nMessages:				UINT := 0;                     // Message count
	{attribute 'hide'} 
	nIndex: 				UINT;
	{attribute 'hide'} 
	nTimestamp:				LINT;
END_VAR
```

### VAR_INPUT

| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `eLogLevel` | [E_LogLevel](../../../Types/Logger/List/E_LogLevel.md) | `= E_LogLevel.Verbose` | Provide logging |

### VAR

| Name | Type | Description |
| :--- | :--- | :--- |
| `aMessages` | `ARRAY[0..99]` |  |
| `nMessages` | `UINT` | Message count |
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
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF eLogLevel > fbMessage.eLogLevel THEN
	M_Log:= TRUE;
	RETURN;
END_IF

IF nMessages > 99 THEN 
	RETURN;
END_IF

// Skip if same sMessage already exists
nIndex := 0;
WHILE nIndex < nMessages DO
    IF aMessages[nIndex].sDefault = fbMessage.sDefault THEN
		aMessages[nIndex].bActive:= TRUE;
        M_Log := TRUE;
        RETURN; // message already in buffer
    END_IF
    nIndex := nIndex + 1;
END_WHILE

aMessages[nMessages]:= fbMessage;;
nMessages := nMessages + 1;
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
WHILE nIndex < nMessages DO
    IF aMessages[nIndex].bActive = TRUE THEN
		aMessages[nIndex].bActive:= FALSE;
    END_IF
    nIndex := nIndex + 1;
END_WHILE
M_Reset:= TRUE;
```

</details>

