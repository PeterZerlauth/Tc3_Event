# FB_Argument

```iecst
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

### VAR

| Name | Type | Description |
| :--- | :--- | :--- |
| `sValue` | `STRING(255)` | storage for arguments |

## Properties

| Name | Declaration |
| :--- | :--- |
| `P_Value` | ```iecst
// Returns the list with arguments
PROPERTY PUBLIC P_Value : STRING(255)
``` |

## Methods

### M_AddBOOL

```iecst
// add boolean value to arguments
METHOD PUBLIC M_AddBOOL : I_Argument
VAR_INPUT
	bValue:				BOOL;		// Boolean input value
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
sValue:= CONCAT(sValue, BOOL_TO_STRING(bValue));			// convert
sValue:= CONCAT(sValue, '$R');								// add separator
M_AddBOOL:= THIS^;
```

</details>

### M_AddINT

```iecst
// add int value to arguments
METHOD PUBLIC M_AddINT : I_Argument
VAR_INPUT
	nValue:				LINT;		// Integer input value
END_VAR
VAR
	sTemp: 			STRING;
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
sValue:= CONCAT(sValue, CONCAT(LINT_TO_STRING(nValue), '$R'));	// add new arg
M_AddINT:= THIS^;
```

</details>

### M_AddREAL

```iecst
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

<details>
<summary>Implementation</summary>

```iecst
sValue:= CONCAT(sValue, CONCAT(LREAL_TO_FMTSTR(fValue, nDecimals, TRUE), '$R'));				// add new arg
M_AddREAL:= THIS^;
```

</details>

### M_AddSTRING

```iecst
// add string value to arguments
METHOD PUBLIC M_AddSTRING : I_Argument
VAR_INPUT
	sValue:				STRING(255);		// String input value
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
THIS^.sValue:= CONCAT(THIS^.sValue, CONCAT(sValue, '$R'));				// add separator 
M_AddSTRING:= THIS^;
```

</details>

### M_AddTIME

```iecst
// add time value to arguments
METHOD PUBLIC M_AddTIME : I_Argument
VAR_INPUT
	tValue:				TIME;		// Time input value
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
sValue:= CONCAT(sValue, CONCAT(TIME_TO_STRING(tValue), '$R'));				// add separator
M_AddTIME:= THIS^;
```

</details>

### M_Clear

```iecst
// Clear arguments
METHOD PUBLIC M_Clear : I_Argument
VAR_INPUT
END_VAR
```

<details>
<summary>Implementation</summary>

```iecst
sValue:= '';
M_Clear:= THIS^;
```

</details>

