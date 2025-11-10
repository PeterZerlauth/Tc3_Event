# FB_TcLogger

**Type:** Program Organization Units (POUs)
**Source File:** `Logger/Twincat/FB_TcLogger.TcPOU`

## Details
**Declaration**
```st
// Provide logging 
FUNCTION_BLOCK FB_TcLogger IMPLEMENTS I_Logger, I_LogLevel
VAR_INPUT
	eLogLevel:				E_LogLevel:= E_LogLevel.Info;
END_VAR
VAR
	fbSourceInfo:			FB_TcSourceInfo;
	aAlarm:					ARRAY[0..99] OF FB_TcAlarm; 	// Message store
    nAlarm:					UINT;                     		// Message count
	bAlarm:					ARRAY[0..99] OF BOOL; 	// Message store
	{attribute 'hide'} 
	nIndex: 				UINT;
	{attribute 'hide'} 
	nTimestamp:				LINT;
END_VAR
```

### Properties

#### P_LogLevel
```st
{attribute 'OPC.UA.DA.Property' := '1'}
{attribute 'monitoring' := 'variable'}
PROPERTY PUBLIC P_LogLevel : E_LogLevel
```
**Get**
```st
VAR
END_VAR
```
**Set**
```st
VAR
END_VAR
```
---
### Methods

#### M_Log
```st
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			FB_Message;
END_VAR
VAR
	sArgument:			STRING;
	nPosition: 			INT;
END_VAR
```
---
#### M_Reset
```st
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
```
---

