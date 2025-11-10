# I_Event

**Type:** INTERFACE

**Source File:** `Event/I_Event.TcIO`

## Declaration

```iecst
INTERFACE I_Event
```

## Methods

### M_Critical
```iecst
METHOD PUBLIC M_Critical : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```

### M_Error
```iecst
METHOD PUBLIC M_Error : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```

### M_Info
```iecst
METHOD PUBLIC M_Info : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```

### M_Verbose
```iecst
METHOD PUBLIC M_Verbose : BOOL
VAR_INPUT
	sMessage:			STRING(255);
END_VAR
```

### M_Warning
```iecst
METHOD PUBLIC M_Warning : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```

## Properties

### P_Argument
```iecst
PROPERTY PUBLIC P_Argument : I_Argument
```

### P_Logger
```iecst
PROPERTY PUBLIC P_Logger : I_Logger
```

