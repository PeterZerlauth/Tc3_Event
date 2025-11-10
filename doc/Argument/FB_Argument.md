## FB_Argument

**Type:** FUNCTION_BLOCK

**Source File:** `Argument/FB_Argument.TcPOU`

#### Declaration & Implementation
<details><summary>Raw IEC/ST</summary>

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
```
</details>

### Methods

#### M_AddBOOL
<details><summary>Raw IEC/ST</summary>

```iec
// add boolean value to arguments
METHOD PUBLIC M_AddBOOL : I_Argument
VAR_INPUT
	bValue:				BOOL;		// Boolean input value
END_VAR
sValue:= CONCAT(sValue, BOOL_TO_STRING(bValue));			// convert
sValue:= CONCAT(sValue, '$R');								// add separator
M_AddBOOL:= THIS^;
```
</details>

#### M_AddINT
<details><summary>Raw IEC/ST</summary>

```iec
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
```
</details>

#### M_AddREAL
<details><summary>Raw IEC/ST</summary>

```iec
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
```
</details>

#### M_AddSTRING
<details><summary>Raw IEC/ST</summary>

```iec
// add string value to arguments
METHOD PUBLIC M_AddSTRING : I_Argument
VAR_INPUT
	sValue:				STRING(255);		// String input value
END_VAR
THIS^.sValue:= CONCAT(THIS^.sValue, CONCAT(sValue, '$R'));				// add separator 
M_AddSTRING:= THIS^;
```
</details>

#### M_AddTIME
<details><summary>Raw IEC/ST</summary>

```iec
// add time value to arguments
METHOD PUBLIC M_AddTIME : I_Argument
VAR_INPUT
	tValue:				TIME;		// Time input value
END_VAR
sValue:= CONCAT(sValue, CONCAT(TIME_TO_STRING(tValue), '$R'));				// add separator
M_AddTIME:= THIS^;
```
</details>

#### M_Clear
<details><summary>Raw IEC/ST</summary>

```iec
// Clear arguments
METHOD PUBLIC M_Clear : I_Argument
VAR_INPUT
END_VAR
sValue:= '';
M_Clear:= THIS^;
```
</details>

### Properties

#### P_Value (read/write)
<details><summary>Raw IEC/ST</summary>

```iec
// Returns the list with arguments
PROPERTY PUBLIC P_Value : STRING(255)
```
</details>

