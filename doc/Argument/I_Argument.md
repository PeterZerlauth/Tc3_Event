# I_Argument

**Type:** INTERFACE

**Source File:** `Argument/I_Argument.TcIO`

```iec
INTERFACE I_Argument
```

## Methods

### M_AddBOOL
```iec
METHOD PUBLIC M_AddBOOL : I_Argument
VAR_INPUT
	bValue:				BOOL;
END_VAR
```

### M_AddINT
```iec
METHOD PUBLIC M_AddINT : I_Argument
VAR_INPUT
	nValue:				LINT;
END_VAR
```

### M_AddREAL
```iec
METHOD PUBLIC M_AddREAL : I_Argument
VAR_INPUT
	fValue:				LREAL;
	nDecimals:			USINT;
END_VAR
```

### M_AddSTRING
```iec
METHOD PUBLIC M_AddSTRING : I_Argument
VAR_INPUT
	sValue:				STRING(255);
END_VAR
```

### M_AddTIME
```iec
METHOD PUBLIC M_AddTIME : I_Argument
VAR_INPUT
	tValue:				TIME;
END_VAR
```

### M_Clear
```iec
METHOD PUBLIC M_Clear : I_Argument
VAR_INPUT
END_VAR
```

## Properties

### P_Value
```iec
PROPERTY PUBLIC P_Value : string(255)
```

