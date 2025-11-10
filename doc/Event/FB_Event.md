# FB_Event

**Type:** FUNCTION BLOCK

**Source File:** `Event/FB_Event.TcPOU`

### References

- [FB_Event](./Event/FB_Event.md)
- [I_Event](./Event/I_Event.md)
- [I_Logger](./Logging/I_Logger.md)
- FB_LocalSystemTime
- [FB_Argument](./Argument/FB_Argument.md)
- [FB_Message](./Message/FB_Message.md)

<details>
<summary>Raw IEC/ST</summary>

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

// --- Implementation code ---
fbSymbolInfo();
fbSystemTime();
```
</details>
