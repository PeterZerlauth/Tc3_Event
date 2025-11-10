# FB_LoggingProvider

**Type:** FUNCTION BLOCK

**Source File:** `Logging/FB_LoggingProvider.TcPOU`

```iec
{attribute 'no_explicit_call' := 'do not call this POU directly'} 
// Provide the functionality to use more than one Logger target
FUNCTION_BLOCK FB_LoggingProvider IMPLEMENTS I_Logger
VAR
	nLength:		INT;
	pList: 			POINTER TO I_Logger;
	aList:			POINTER TO POINTER TO ARRAY [0..24] OF I_Logger:=ADR(pList);
END_VAR
```

## Methods

### FB_exit
```iec
METHOD FB_exit : BOOL
VAR_INPUT
	bInCopyCode : BOOL; // if TRUE, the exit method is called for exiting an instance that is copied afterwards (online change).
END_VAR
```

### M_Add
```iec
METHOD PUBLIC M_Add : BOOL
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	pOldList: 	POINTER TO I_Logger;
END_VAR
```

### M_Clear
```iec
METHOD PUBLIC M_Clear : bool
```

### M_Find
```iec
METHOD PUBLIC M_Find : DINT
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	nIndex: 	UINT;
END_VAR
```

### M_Index
```iec
METHOD PUBLIC M_Index : I_Logger
VAR_INPUT
	nIndex: 	DINT;
END_VAR
```

### M_Log
```iec
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			FB_Message;
END_VAR
VAR
	nIndex:		INT;
END_VAR
```

### M_Remove
```iec
METHOD PUBLIC M_Remove : BOOL
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	pOldList:			POINTER TO I_Logger;
	nPosition: 			DINT;
END_VAR
```

### M_Reset
```iec
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
VAR
	nIndex: 				UINT;
END_VAR
```

