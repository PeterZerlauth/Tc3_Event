# FB_LoggingProvider

**Type:** FUNCTION BLOCK

**Source File:** `Logging/FB_LoggingProvider.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
{attribute 'no_explicit_call' := 'do not call this POU directly'} 
// Provide the functionality to use more than one Logger target
FUNCTION_BLOCK [FB_LoggingProvider](Logging/FB_LoggingProvider.md) IMPLEMENTS [I_Logger](Logging/I_Logger.md)
VAR
	nLength:		INT;
	pList: 			POINTER TO [I_Logger](Logging/I_Logger.md);
	aList:			POINTER TO POINTER TO ARRAY [0..24] OF [I_Logger](Logging/I_Logger.md):=ADR(pList);
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
	iLogger: 	[I_Logger](Logging/I_Logger.md);
END_VAR
VAR
	pOldList: 	POINTER TO [I_Logger](Logging/I_Logger.md);
END_VAR

// --- Method: M_Clear ---
METHOD PUBLIC M_Clear : bool

// --- Method: M_Find ---
METHOD PUBLIC M_Find : DINT
VAR_INPUT
	iLogger: 	[I_Logger](Logging/I_Logger.md);
END_VAR
VAR
	nIndex: 	UINT;
END_VAR

// --- Method: M_Index ---
METHOD PUBLIC M_Index : [I_Logger](Logging/I_Logger.md)
VAR_INPUT
	nIndex: 	DINT;
END_VAR

// --- Method: M_Log ---
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			[FB_Message](Message/FB_Message.md);
END_VAR
VAR
	nIndex:		INT;
END_VAR

// --- Method: M_Remove ---
METHOD PUBLIC M_Remove : BOOL
VAR_INPUT
	iLogger: 	[I_Logger](Logging/I_Logger.md);
END_VAR
VAR
	pOldList:			POINTER TO [I_Logger](Logging/I_Logger.md);
	nPosition: 			DINT;
END_VAR

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
VAR
	nIndex: 				UINT;
END_VAR

// --- Property (read/write): P_Length ---
PROPERTY P_Length : UNKNOWN
```
</details>
