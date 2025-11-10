# FB_Argument

**Type:** FUNCTION_BLOCK

**Source File:** `Argument/FB_Argument.TcPOU`

```iec
{attribute 'no_explicit_call' := 'do not call this POU directly'}
// Store arguments in a single string seperated by $R
FUNCTION_BLOCK FB_Argument IMPLEMENTS I_Argument
VAR_INPUT
END_VAR
VAR_OUTPUT
END_VAR
VAR
	sValue:					STRING(255);		// storage for arguments
END_VAR

// --- Method: M_AddBOOL ---
// add boolean value to arguments
METHOD PUBLIC M_AddBOOL : I_Argument
VAR_INPUT
	bValue:				BOOL;		// Boolean input value
END_VAR
sValue:= CONCAT(sValue, BOOL_TO_STRING(bValue));			// convert
sValue:= CONCAT(sValue, '$R');								// add separator
M_AddBOOL:= THIS^;
END_METHOD

// --- Method: M_AddINT ---
// add int value to arguments
METHOD PUBLIC M_AddINT : I_Argument
VAR_INPUT
	nValue:				LINT;		// Integer input value
END_VAR
VAR
	sTemp: 			STRING;
END_VAR
sValue:= CONCAT(sValue, CONCAT(LINT_TO_STRING(nValue), '$R'));	// add new arg
M_AddINT:= THIS^;
END_METHOD

// --- Method: M_AddREAL ---
// add real value to arguments
METHOD PUBLIC M_AddREAL : I_Argument
VAR_INPUT
	fValue:				LREAL;		// Real input value
	nDecimals:			USINT;		// Decimals afer .
END_VAR
VAR
	sTemp: 			STRING;
END_VAR
sValue:= CONCAT(sValue, CONCAT(LREAL_TO_FMTSTR(fValue, nDecimals, TRUE), '$R'));				// add new arg
M_AddREAL:= THIS^;
END_METHOD

// --- Method: M_AddSTRING ---
// add string value to arguments
METHOD PUBLIC M_AddSTRING : I_Argument
VAR_INPUT
	sValue:				STRING(255);		// String input value
END_VAR
THIS^.sValue:= CONCAT(THIS^.sValue, CONCAT(sValue, '$R'));				// add separator 
M_AddSTRING:= THIS^;
END_METHOD

// --- Method: M_AddTIME ---
// add time value to arguments
METHOD PUBLIC M_AddTIME : I_Argument
VAR_INPUT
	tValue:				TIME;		// Time input value
END_VAR
sValue:= CONCAT(sValue, CONCAT(TIME_TO_STRING(tValue), '$R'));				// add separator
M_AddTIME:= THIS^;
END_METHOD

// --- Method: M_Clear ---
// Clear arguments
METHOD PUBLIC M_Clear : I_Argument
VAR_INPUT
END_VAR
sValue:= '';
M_Clear:= THIS^;
END_METHOD

// --- Property (read/write): P_Value ---
PROPERTY P_Value : UNKNOWN
END_PROPERTY
```

### References / Cross-links
- [FB_Argument](Argument/FB_Argument.md)
- [I_Argument](Argument/I_Argument.md)

