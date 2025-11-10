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


// --- Implementation code ---
// https://peterzerlauth.com/

// --- Method: FB_exit ---
METHOD FB_exit : BOOL
VAR_INPUT
	bInCopyCode : BOOL; // if TRUE, the exit method is called for exiting an instance that is copied afterwards (online change).
END_VAR
M_Clear();
END_METHOD

// --- Method: M_Add ---
METHOD PUBLIC M_Add : BOOL
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	pOldList: 	POINTER TO I_Logger;
END_VAR
IF iLogger <> 0 THEN
	// First Item
	IF pList = 0 THEN
		nLength:= nLength + 1;
		pList:= __NEW(POINTER TO I_Logger, DINT_TO_UDINT(nLength));
	ELSE
		// Item already in List
		IF M_Find(iLogger) = -1 THEN
			// backup 
			pOldList:= pList;
			// new Length
			nLength:= nLength + 1;
			// new pointer
			pList:= __NEW(POINTER TO I_Logger, DINT_TO_UDINT(nLength));
			// restore
			Memcpy(pList, pOldList, SIZEOF(pList) * DINT_TO_UDINT(nLength -1));
			// delete old
			__DELETE(pOldList);
		ELSE
			M_Add:= FALSE;	
			RETURN;
		END_IF
	END_IF
	IF pList = 0 THEN
		RETURN;
	END_IF
	// add new Object
	pList[nLength-1]:= iLogger;
	M_Add:= TRUE;
ELSE
	M_Add:= FALSE;	
END_IF
END_METHOD

// --- Method: M_Clear ---
METHOD PUBLIC M_Clear : bool
IF pList <> 0 THEN
	nLength:= 0;
	__DELETE(pList);
END_IF
M_Clear:= TRUE;
END_METHOD

// --- Method: M_Find ---
METHOD PUBLIC M_Find : DINT
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	nIndex: 	UINT;
END_VAR
// Object already in List
M_Find := -1;
WHILE nIndex < nLength DO
    IF (pList[nIndex] = iLogger) THEN
        M_Find := nIndex;
        RETURN;
    END_IF
	nIndex := nIndex + 1;
END_WHILE
END_METHOD

// --- Method: M_Index ---
METHOD PUBLIC M_Index : I_Logger
VAR_INPUT
	nIndex: 	DINT;
END_VAR
IF (nIndex < nLength) THEN
	M_Index := pList[nIndex];
END_IF
END_METHOD

// --- Method: M_Log ---
METHOD PUBLIC M_Log : BOOL
VAR_INPUT
	fbMessage:			FB_Message;
END_VAR
VAR
	nIndex:		INT;
END_VAR
WHILE nIndex < nLength DO
    pList[nIndex].M_Log(fbMessage);
	nIndex := nIndex + 1;
END_WHILE
END_METHOD

// --- Method: M_Remove ---
METHOD PUBLIC M_Remove : BOOL
VAR_INPUT
	iLogger: 	I_Logger;
END_VAR
VAR
	pOldList:			POINTER TO I_Logger;
	nPosition: 			DINT;
END_VAR
IF iLogger <> 0 THEN
	// First Item
	IF nLength >= 0 THEN
		// Item already in List
		nPosition:= M_Find(iLogger);
		IF nPosition <> -1 THEN
			// backup 
			pOldList:= pList;
			// new Length
			nLength:= nLength -1;
			// new pointer
			pList:= __NEW(POINTER TO I_Logger ,DINT_TO_UDINT(nLength));
			// restore lower part
			Memcpy(pList, pOldList, SIZEOF(pList) * DINT_TO_UDINT(nPosition));
			//pList[nPosition]:= iObject;
			Memcpy(pList + (SIZEOF(pList) * nPosition),pOldList + (SIZEOF(pList)*(nPosition + 1)), SIZEOF(pList) * DINT_TO_UDINT(nLength - nPosition));
			// delete old
			__DELETE(pOldList);
		ELSE
			M_Remove:= FALSE;	
			RETURN;
		END_IF
	ELSE
		M_Remove:= FALSE;	
		RETURN;
	END_IF
	M_Remove:= TRUE;
ELSE
	M_Remove:= FALSE;	
END_IF
END_METHOD

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
VAR
	nIndex: 				UINT;
END_VAR
nIndex := 0;
WHILE nIndex < nLength DO
    pList[nIndex].M_Reset();
    nIndex := nIndex + 1;
END_WHILE
M_Reset:= TRUE;
END_METHOD

// --- Property (read/write): P_Length ---
PROPERTY P_Length : UNKNOWN
END_PROPERTY
```

