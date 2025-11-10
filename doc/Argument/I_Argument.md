# I_Argument

**Type:** INTERFACE

**Source File:** `Argument/I_Argument.TcIO`

## Declaration

```iecst
INTERFACE I_Argument
```

## Methods

### M_AddBOOL
```iecst
METHOD PUBLIC M_AddBOOL : I_Argument
VAR_INPUT
	bValue:				BOOL;
END_VAR
```

### M_AddINT
```iecst
METHOD PUBLIC M_AddINT : I_Argument
VAR_INPUT
	nValue:				LINT;
END_VAR
```

### M_AddREAL
```iecst
METHOD PUBLIC M_AddREAL : I_Argument
VAR_INPUT
	fValue:				LREAL;
	nDecimals:			USINT;
END_VAR
```

### M_AddSTRING
```iecst
METHOD PUBLIC M_AddSTRING : I_Argument
VAR_INPUT
	sValue:				STRING(255);
END_VAR
```

### M_AddTIME
```iecst
METHOD PUBLIC M_AddTIME : I_Argument
VAR_INPUT
	tValue:				TIME;
END_VAR
```

### M_Clear
```iecst
METHOD PUBLIC M_Clear : I_Argument
VAR_INPUT
END_VAR
```

## Properties

### P_Value
```iecst
PROPERTY PUBLIC P_Value : string(255)
```

