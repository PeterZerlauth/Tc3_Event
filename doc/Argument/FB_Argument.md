# FB_Argument

**Type:** FUNCTION BLOCK

**Source File:** `Argument/FB_Argument.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
{attribute 'no_explicit_call' := 'do not call this POU directly'}
// Store arguments in a single string seperated by $R
FUNCTION_BLOCK [FB_Argument](Argument/FB_Argument.md) IMPLEMENTS [I_Argument](Argument/I_Argument.md)
VAR_INPUT
END_VAR
VAR_OUTPUT
END_VAR
VAR
	sValue:					STRING(255);		// storage for arguments
END_VAR

// --- Method: M_AddBOOL ---
// add boolean value to arguments
METHOD PUBLIC M_AddBOOL : [I_Argument](Argument/I_Argument.md)
VAR_INPUT
	bValue:				BOOL;		// Boolean input value
END_VAR

// --- Method: M_AddINT ---
// add int value to arguments
METHOD PUBLIC M_AddINT : [I_Argument](Argument/I_Argument.md)
VAR_INPUT
	nValue:				LINT;		// Integer input value
END_VAR
VAR
	sTemp: 			STRING;
END_VAR

// --- Method: M_AddREAL ---
// add real value to arguments
METHOD PUBLIC M_AddREAL : [I_Argument](Argument/I_Argument.md)
VAR_INPUT
	fValue:				LREAL;		// Real input value
	nDecimals:			USINT;		// Decimals afer .
END_VAR
VAR
	sTemp: 			STRING;
END_VAR

// --- Method: M_AddSTRING ---
// add string value to arguments
METHOD PUBLIC M_AddSTRING : [I_Argument](Argument/I_Argument.md)
VAR_INPUT
	sValue:				STRING(255);		// String input value
END_VAR

// --- Method: M_AddTIME ---
// add time value to arguments
METHOD PUBLIC M_AddTIME : [I_Argument](Argument/I_Argument.md)
VAR_INPUT
	tValue:				TIME;		// Time input value
END_VAR

// --- Method: M_Clear ---
// Clear arguments
METHOD PUBLIC M_Clear : [I_Argument](Argument/I_Argument.md)
VAR_INPUT
END_VAR

// --- Property (read/write): P_Value ---
PROPERTY P_Value : UNKNOWN
```
</details>
