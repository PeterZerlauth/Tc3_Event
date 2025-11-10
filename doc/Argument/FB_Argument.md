# FB_Argument

**Type:** Program Organization Units (POUs)
**Source File:** `Argument/FB_Argument.TcPOU`

## Details
**Declaration**
```st
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
```

### Properties

#### P_Value
```st
// Returns the list with arguments
PROPERTY PUBLIC P_Value : STRING(255)
```
**Get**
```st
VAR
END_VAR
```
---
### Methods

#### M_AddBOOL
```st
// add boolean value to arguments
METHOD PUBLIC M_AddBOOL : I_Argument
VAR_INPUT
	bValue:				BOOL;		// Boolean input value
END_VAR
```
---
#### M_AddINT
```st
// add int value to arguments
METHOD PUBLIC M_AddINT : I_Argument
VAR_INPUT
	nValue:				LINT;		// Integer input value
END_VAR
VAR
	sTemp: 			STRING;
END_VAR
```
---
#### M_AddREAL
```st
// add real value to arguments
METHOD PUBLIC M_AddREAL : I_Argument
VAR_INPUT
	fValue:				LREAL;		// Real input value
	nDecimals:			USINT;		// Decimals afer .
END_VAR
VAR
	sTemp: 			STRING;
END_VAR
```
---
#### M_AddSTRING
```st
// add string value to arguments
METHOD PUBLIC M_AddSTRING : I_Argument
VAR_INPUT
	sValue:				STRING(255);		// String input value
END_VAR
```
---
#### M_AddTIME
```st
// add time value to arguments
METHOD PUBLIC M_AddTIME : I_Argument
VAR_INPUT
	tValue:				TIME;		// Time input value
END_VAR
```
---
#### M_Clear
```st
// Clear arguments
METHOD PUBLIC M_Clear : I_Argument
VAR_INPUT
END_VAR
```
---

