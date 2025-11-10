[[ _TOC_ ]]

## FB_ListLogger

**Type:** FUNCTION BLOCK

#### Description  
Provide logging

#### Inputs  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| eLogLevel | `E_LogLevel` | `= E_LogLevel.Verbose` |  |

#### Outputs  
-

#### Locals  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| aMessages | `ARRAY[0..99] OF FB_Message` |  | Message store |
| nMessages | `UINT` | `= 0` | Message count |
| nIndex | `UINT` |  |  |
| nTimestamp | `LINT` |  |  |

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

// --- Implementation ---

// https://peterzerlauth.com/

IF nTimestamp < TwinCAT_SystemInfoVarList._TaskInfo[GETCURTASKINDEXEX()].DcTaskTime THEN // 1 second = 1e9 ns
	nTimestamp := TwinCAT_SystemInfoVarList._TaskInfo[GETCURTASKINDEXEX()].DcTaskTime + 1000000000;
	nIndex:= 0;
	WHILE nIndex < nMessages DO
		IF aMessages[nIndex].bActive THEN
			IF aMessages[nIndex].eLogLevel <= E_LogLevel.Warning THEN
				aMessages[nIndex].bActive:= FALSE;
			END_IF
			nIndex := nIndex + 1;
		ELSE
			MEMMOVE(ADR(aMessages[nIndex]), ADR(aMessages[nIndex + 1]), SIZEOF(FB_Message) * (nMessages - nIndex));
			nMessages := nMessages - 1;
			RETURN;
		END_IF
	END_WHILE
END_IF
```

</details>

