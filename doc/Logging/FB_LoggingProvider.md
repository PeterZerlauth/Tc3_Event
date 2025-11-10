# FB_LoggingProvider

**Type:** FUNCTION BLOCK

**Source File:** `Logging/FB_LoggingProvider.TcPOU`

## Declaration

```iecst
{attribute 'no_explicit_call' := 'do not call this POU directly'} 
// Provide the functionality to use more than one Logger target
FUNCTION_BLOCK FB_LoggingProvider IMPLEMENTS I_Logger
VAR
	nLength:		INT;
	pList: 			POINTER TO I_Logger;
	aList:			POINTER TO POINTER TO ARRAY [0..24] OF I_Logger:=ADR(pList);
END_VAR
```

