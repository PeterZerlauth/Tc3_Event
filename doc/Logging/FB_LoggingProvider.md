## FB_LoggingProvider

**Type:** FUNCTION BLOCK

**Source File:** `Logging/FB_LoggingProvider.TcPOU`

### References / Cross-links
- [P_Length](../P_Length/P_Length.md)
- [-](../Functions/- .md)
- [-](../Functions/- .md)
- [-](../Functions/- .md)
- [-](../Functions/- .md)
- [-](../Functions/- .md)
- [-](../Functions/- .md)
- [-](../Functions/- .md)
- [-](../Functions/- .md)

### IEC Code
```iec
{attribute 'no_explicit_call' := 'do not call this POU directly'} 
// Provide the functionality to use more than one Logger target
FUNCTION_BLOCK FB_LoggingProvider IMPLEMENTS I_Logger
VAR
	nLength:		INT;
	pList: 			POINTER TO I_Logger;
	aList:			POINTER TO POINTER TO ARRAY [0..24] OF I_Logger:=ADR(pList);
END_VAR

// --- Implementation code ---
// https://peterzerlauth.com/

// --- Method: FB_exit ---
METHOD FB_exit : BOOL
VAR_INPUT
	bInCopyCode : BOOL; // if TRUE, the exit method is called for exiting an instance that is copied afterwards (online change).
END_VAR

// --- Method: M_Add ---
METHOD PUBLIC M_Add : BOOL
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	pOldList: 	POINTER TO I_Logger;
END_VAR

// --- Method: M_Clear ---
METHOD PUBLIC M_Clear : bool

// --- Method: M_Find ---
METHOD PUBLIC M_Find : DINT
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	nIndex: 	UINT;
END_VAR

// --- Method: M_Index ---
METHOD PUBLIC M_Index : I_Logger
VAR_INPUT
	nIndex: 	DINT;
END_VAR

// --- Method: M_Log ---
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			FB_Message;
END_VAR
VAR
	nIndex:		INT;
END_VAR

// --- Method: M_Remove ---
METHOD PUBLIC M_Remove : BOOL
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	pOldList:			POINTER TO I_Logger;
	nPosition: 			DINT;
END_VAR

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
VAR
	nIndex: 				UINT;
END_VAR

// --- Property: P_Length ---
{attribute 'OPC.UA.DA.Property' := '1'}
{attribute 'monitoring' := 'variable'}
PROPERTY PUBLIC P_Length : DINT
```
