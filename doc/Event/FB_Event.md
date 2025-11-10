# FB_Event

**Type:** FUNCTION BLOCK

**Source File:** `Event/FB_Event.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
{attribute 'reflection'} 
// Providing the event logger
FUNCTION_BLOCK [FB_Event](Event/FB_Event.md) IMPLEMENTS [I_Event](Event/I_Event.md)
VAR_INPUT
	iLogger:					[I_Logger](Logging/I_Logger.md);		// Interface has to be attached to a Valid target
END_VAR
VAR
    {attribute 'hide'} 
    {attribute 'instance-path'} 
    {attribute 'noinit'} 
    sInstancePath:				STRING(255);
	fbSymbolInfo: 				PLC_ReadSymInfoByNameEx;
	fbSystemTime: 				FB_LocalSystemTime;
	fbArguments:				[FB_Argument](Argument/FB_Argument.md);
	fbVerbose:					[FB_Message](Message/FB_Message.md);
	fbInfo:						[FB_Message](Message/FB_Message.md);
	fbWarning:					[FB_Message](Message/FB_Message.md);
	fbError:					[FB_Message](Message/FB_Message.md);
	fbCritical:					[FB_Message](Message/FB_Message.md);
END_VAR

// --- Implementation code ---
fbSymbolInfo();
fbSystemTime();

// --- Method: FB_Init ---
//FB_Init is always available implicitly and it is used primarily for initialization.
//The return value is not evaluated. For a specific influence, you can also declare the
//methods explicitly and provide additional code there with the standard initialization
//code. You can evaluate the return value.
METHOD FB_Init: BOOL
VAR_INPUT
    bInitRetains: BOOL; // TRUE: the retain variables are initialized (reset warm / reset cold)
    bInCopyCode: BOOL:= TRUE;  // TRUE: the instance will be copied to the copy code afterward (online change)   
END_VAR

// --- Method: M_Critical ---
METHOD PUBLIC M_Critical : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR

// --- Method: M_Error ---
METHOD PUBLIC M_Error : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR

// --- Method: M_Info ---
METHOD PUBLIC M_Info : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR

// --- Method: M_Verbose ---
METHOD PUBLIC M_Verbose : BOOL
VAR_INPUT
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR

// --- Method: M_Warning ---
METHOD PUBLIC M_Warning : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR

// --- Property (read/write): P_Argument ---
PROPERTY P_Argument : UNKNOWN

// --- Property (read/write): P_Logger ---
PROPERTY P_Logger : UNKNOWN
```
</details>
