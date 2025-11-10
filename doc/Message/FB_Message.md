# FB_Message

**Type:** FUNCTION BLOCK

**Source File:** `Message/FB_Message.TcPOU`

### References

- [FB_Message](./Message/FB_Message.md)
- [E_LogLevel](./Logger/List/E_LogLevel.md)

<details>
<summary>Raw IEC/ST</summary>

```iec
{attribute 'analysis' := '-33'}
// Payload for events
FUNCTION_BLOCK FB_Message
VAR_INPUT
	eLogLevel:			E_LogLevel;
	nID:				UDINT;
	nTimestamp:			Tc2_Utilities.T_FILETIME64;	
	sSource:			STRING(255);
	sType:				STRING(255);
	sMessage:			STRING(255);
	sDefault:			STRING(255);
	sArguments:			STRING(255);
	bActive:			BOOL;
END_VAR
VAR_OUTPUT
END_VAR
VAR
END_VAR
```
</details>
