# FB_LoggingProvider

**Type:** Program Organization Units (POUs)
**Source File:** `Logging/FB_LoggingProvider.TcPOU`

## Details
**Declaration**
```st
{attribute 'no_explicit_call' := 'do not call this POU directly'} 
// Provide the functionality to use more than one Logger target
FUNCTION_BLOCK FB_LoggingProvider IMPLEMENTS I_Logger
VAR
	nLength:		INT;
	pList: 			POINTER TO I_Logger;
	aList:			POINTER TO POINTER TO ARRAY [0..24] OF I_Logger:=ADR(pList);
END_VAR
```

### Properties

#### P_Length
```st
{attribute 'OPC.UA.DA.Property' := '1'}
{attribute 'monitoring' := 'variable'}
PROPERTY PUBLIC P_Length : DINT
```
**Get**
```st
VAR
END_VAR
```
---
### Methods

#### FB_exit
```st
METHOD FB_exit : BOOL
VAR_INPUT
	bInCopyCode : BOOL; // if TRUE, the exit method is called for exiting an instance that is copied afterwards (online change).
END_VAR
```
---
#### M_Add
```st
METHOD PUBLIC M_Add : BOOL
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	pOldList: 	POINTER TO I_Logger;
END_VAR
```
---
#### M_Clear
```st
METHOD PUBLIC M_Clear : bool
```
---
#### M_Find
```st
METHOD PUBLIC M_Find : DINT
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	nIndex: 	UINT;
END_VAR
```
---
#### M_Index
```st
METHOD PUBLIC M_Index : I_Logger
VAR_INPUT
	nIndex: 	DINT;
END_VAR
```
---
#### M_Log
```st
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			FB_Message;
END_VAR
VAR
	nIndex:		INT;
END_VAR
```
---
#### M_Remove
```st
METHOD PUBLIC M_Remove : BOOL
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	pOldList:			POINTER TO I_Logger;
	nPosition: 			DINT;
END_VAR
```
---
#### M_Reset
```st
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
VAR
	nIndex: 				UINT;
END_VAR
```
---

