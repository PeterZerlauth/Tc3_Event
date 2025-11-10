# FB_Event

**Type:** FUNCTION BLOCK

**Source File:** `Event/FB_Event.TcPOU`

## Declaration

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

