# I_Event

**Type:** Interfaces (TcIO)
**Source File:** `Event/I_Event.TcIO`

## Details
**Declaration**
```st
INTERFACE I_Event
```

### Properties

#### P_Argument
```st
PROPERTY PUBLIC P_Argument : I_Argument
```
**Get**
N/A
---
#### P_Logger
```st
PROPERTY PUBLIC P_Logger : I_Logger
```
**Get**
N/A
**Set**
N/A
---
### Methods

#### M_Critical
```st
METHOD PUBLIC M_Critical : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```
---
#### M_Error
```st
METHOD PUBLIC M_Error : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```
---
#### M_Info
```st
METHOD PUBLIC M_Info : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```
---
#### M_Verbose
```st
METHOD PUBLIC M_Verbose : BOOL
VAR_INPUT
	sMessage:			STRING(255);
END_VAR
```
---
#### M_Warning
```st
METHOD PUBLIC M_Warning : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);
END_VAR
```
---

