# I_Argument

**Type:** Interfaces (TcIO)
**Source File:** `Argument/I_Argument.TcIO`

## Details
**Declaration**
```st
INTERFACE I_Argument
```

### Properties

#### P_Value
```st
PROPERTY PUBLIC P_Value : string(255)
```
**Get**
N/A
---
### Methods

#### M_AddBOOL
```st
METHOD PUBLIC M_AddBOOL : I_Argument
VAR_INPUT
	bValue:				BOOL;
END_VAR
```
---
#### M_AddINT
```st
METHOD PUBLIC M_AddINT : I_Argument
VAR_INPUT
	nValue:				LINT;
END_VAR
```
---
#### M_AddREAL
```st
METHOD PUBLIC M_AddREAL : I_Argument
VAR_INPUT
	fValue:				LREAL;
	nDecimals:			USINT;
END_VAR
```
---
#### M_AddSTRING
```st
METHOD PUBLIC M_AddSTRING : I_Argument
VAR_INPUT
	sValue:				STRING(255);
END_VAR
```
---
#### M_AddTIME
```st
METHOD PUBLIC M_AddTIME : I_Argument
VAR_INPUT
	tValue:				TIME;
END_VAR
```
---
#### M_Clear
```st
METHOD PUBLIC M_Clear : I_Argument
VAR_INPUT
END_VAR
```
---

