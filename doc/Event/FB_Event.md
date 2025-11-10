# FB_Event

**Type:** FUNCTION BLOCK

**Source File:** `Event/FB_Event.TcPOU`

```iec
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

## Methods

### FB_Init
```iec
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

### M_Critical
```iec
METHOD PUBLIC M_Critical : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
```

### M_Error
```iec
METHOD PUBLIC M_Error : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
```

### M_Info
```iec
METHOD PUBLIC M_Info : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
```

### M_Reset
```iec
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
```

### M_Verbose
```iec
METHOD PUBLIC M_Verbose : BOOL
VAR_INPUT
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
```

### M_Warning
```iec
METHOD PUBLIC M_Warning : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
```

