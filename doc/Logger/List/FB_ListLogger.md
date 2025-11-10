# FB_ListLogger

**Type:** Program Organization Units (POUs)
**Source File:** `Logger/List/FB_ListLogger.TcPOU`

## Details
**Declaration**
```st
// Provide logging 
FUNCTION_BLOCK FB_ListLogger IMPLEMENTS I_Logger, I_LogLevel
VAR_INPUT
	eLogLevel:				E_LogLevel:= E_LogLevel.Verbose;
END_VAR
VAR
	{attribute 'OPC.UA.DA.Property' := '1'}
	aMessages:				ARRAY[0..99] OF FB_Message; 	// Message store
	{attribute 'OPC.UA.DA.Property' := '1'}
    nMessages:				UINT := 0;                     // Message count
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

