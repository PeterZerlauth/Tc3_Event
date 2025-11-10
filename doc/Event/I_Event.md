# I_Event

**Type:** INTERFACE

**Source File:** `Event/I_Event.TcIO`

```iec
INTERFACE I_Event
```

## Methods

### M_Critical
```iec
METHOD PUBLIC M_Critical : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```

### M_Error
```iec
METHOD PUBLIC M_Error : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```

### M_Info
```iec
METHOD PUBLIC M_Info : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```

### M_Verbose
```iec
METHOD PUBLIC M_Verbose : BOOL
VAR_INPUT
	sMessage:			STRING(255);
END_VAR
```

### M_Warning
```iec
METHOD PUBLIC M_Warning : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```

## Properties

### P_Argument
```iec
PROPERTY PUBLIC P_Argument : I_Argument
```

### P_Logger
```iec
PROPERTY PUBLIC P_Logger : I_Logger
```

