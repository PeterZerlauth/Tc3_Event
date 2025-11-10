# FB_Event

```iecst
{attribute 'reflection'} 
// Providing the event logger
FUNCTION_BLOCK FB_Event IMPLEMENTS I_Event
VAR_INPUT
	iLogger:					I_Logger;		// Interface has to be attached to a Valid target
END_VAR
VAR
    {attribute 'hide'} 
    {attribute 'instance-path'} 
    {attribute 'noinit'} 
    sInstancePath:				STRING(255);
	fbSymbolInfo: 				PLC_ReadSymInfoByNameEx;
	fbSystemTime: 				FB_LocalSystemTime;
	fbArguments:				FB_Argument;
	fbVerbose:					FB_Message;
	fbInfo:						FB_Message;
	fbWarning:					FB_Message;
	fbError:					FB_Message;
	fbCritical:					FB_Message;
END_VAR
```

### VAR_INPUT

| Name | Type | Description |
| :--- | :--- | :--- |
| `iLogger` | `I_Logger` | Interface has to be attached to a Valid target |

### VAR

| Name | Type | Description |
| :--- | :--- | :--- |
| `sInstancePath` | `STRING(255)` |  |
| `fbSymbolInfo` | `PLC_ReadSymInfoByNameEx` |  |
| `fbSystemTime` | `FB_LocalSystemTime` |  |
| `fbArguments` | [FB_Argument](../Argument/FB_Argument.md) |  |
| `fbVerbose` | [FB_Message](../Message/FB_Message.md) |  |
| `fbInfo` | [FB_Message](../Message/FB_Message.md) |  |
| `fbWarning` | [FB_Message](../Message/FB_Message.md) |  |
| `fbError` | [FB_Message](../Message/FB_Message.md) |  |
| `fbCritical` | [FB_Message](../Message/FB_Message.md) |  |

## Properties

| Name | Declaration |
| :--- | :--- |
| `P_Argument` | ```iecst
PROPERTY PUBLIC P_Argument : I_Argument
``` |
| `P_Logger` | ```iecst
PROPERTY PUBLIC P_Logger : I_Logger
``` |

## Methods

### FB_Init

```iecst
//FB_Init is always available implicitly and it is used primarily for initialization.
//The return value is not evaluated. For a specific influence, you can also declare the
//methods explicitly and provide additional code there with the standard initialization
//code. You can evaluate the return value.
METHOD FB_Init: BOOL
VAR_INPUT
    bInitRetains: BOOL; // TRUE: the retain variables are initialized (reset warm / reset cold)
    bInCopyCode: BOOL:= TRUE;  // TRUE: the instance will be copied to the copy code afterward (online change)   
END_VAR
```

**Returns:** `BOOL`

<details>
<summary>Implementation</summary>

```iecst
fbSymbolInfo.SYMNAME:= F_InstancePath(sInstancePath);
fbSymbolInfo.PORT:= TwinCAT_SystemInfoVarList._AppInfo.AdsPort;
fbSymbolInfo.START:= TRUE;
fbSystemTime.bEnable:= TRUE;
```

</details>

### M_Critical

```iecst
METHOD PUBLIC M_Critical : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF sMessage = '' THEN
	RETURN;
END_IF

fbCritical.bActive:= TRUE;
fbCritical.sMessage:= sMessage;
fbCritical.eLogLevel:= E_LogLevel.Critical;
fbCritical.nID:= nID;
fbCritical.nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
fbCritical.sArguments:= fbArguments.P_Value;
fbCritical.sDefault:= F_Print(sMessage, fbArguments.P_Value);
fbCritical.sSource:= fbSymbolInfo.SYMNAME;
fbCritical.sType:= fbSymbolInfo.SYMINFO.symDataType;

IF iLogger = 0 THEN
	F_Log(fbCritical);
ELSE
	iLogger.M_Log(fbCritical);
END_IF
	
fbArguments.M_Clear();
```

</details>

### M_Error

```iecst
METHOD PUBLIC M_Error : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF sMessage = '' THEN
	RETURN;
END_IF

fbError.bActive:= TRUE;
fbError.sMessage:= sMessage;
fbError.eLogLevel:= E_LogLevel.Error;
fbError.nID:= nID;
fbError.nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
fbError.sArguments:= fbArguments.P_Value;
fbError.sDefault:= F_Print(sMessage, fbArguments.P_Value);
fbError.sSource:= fbSymbolInfo.SYMNAME;
fbError.sType:= fbSymbolInfo.SYMINFO.symDataType;

IF iLogger = 0 THEN
	F_Log(fbError);
ELSE
	iLogger.M_Log(fbError);
END_IF

fbArguments.M_Clear();
```

</details>

### M_Info

```iecst
METHOD PUBLIC M_Info : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF sMessage = '' THEN
	RETURN;
END_IF

fbInfo.bActive:= TRUE;
fbInfo.sMessage:= sMessage;
fbInfo.eLogLevel:= E_LogLevel.Info;
fbInfo.nID:= nID;
fbInfo.nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
fbInfo.sArguments:= fbArguments.P_Value;
fbInfo.sDefault:= F_Print(sMessage, fbArguments.P_Value);
fbInfo.sSource:= fbSymbolInfo.SYMNAME;
fbInfo.sType:= fbSymbolInfo.SYMINFO.symDataType;

IF iLogger = 0 THEN
	F_Log(fbInfo);
ELSE
	iLogger.M_Log(fbInfo);
END_IF

fbArguments.M_Clear();
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
IF iLogger <> 0 THEN
	M_Reset:= iLogger.M_Reset();
END_IF
```

</details>

### M_Verbose

```iecst
METHOD PUBLIC M_Verbose : BOOL
VAR_INPUT
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF sMessage = '' THEN
	RETURN;
END_IF

fbVerbose.bActive:= TRUE;
fbVerbose.sMessage:= sMessage;
fbVerbose.eLogLevel:= E_LogLevel.Verbose;
fbVerbose.nID:= 0;
fbVerbose.nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
fbVerbose.sArguments:= fbArguments.P_Value;
fbVerbose.sDefault:= F_Print(sMessage, fbArguments.P_Value);
fbVerbose.sSource:= fbSymbolInfo.SYMNAME;
fbVerbose.sType:= fbSymbolInfo.SYMINFO.symDataType;

IF iLogger = 0 THEN
	F_Log(fbVerbose);
ELSE
	iLogger.M_Log(fbVerbose);
END_IF

fbArguments.M_Clear();
```

</details>

### M_Warning

```iecst
METHOD PUBLIC M_Warning : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
IF sMessage = '' THEN
	RETURN;
END_IF

fbWarning.bActive:= TRUE;
fbWarning.sMessage:= sMessage;
fbWarning.eLogLevel:= E_LogLevel.Warning;
fbWarning.nID:= nID;
fbWarning.nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
fbWarning.sArguments:= fbArguments.P_Value;
fbWarning.sDefault:= F_Print(sMessage, fbArguments.P_Value);
fbWarning.sSource:= fbSymbolInfo.SYMNAME;
fbWarning.sType:= fbSymbolInfo.SYMINFO.symDataType;

IF iLogger = 0 THEN
	F_Log(fbWarning);
ELSE
	iLogger.M_Log(fbWarning);
END_IF

fbArguments.M_Clear();
```

</details>

