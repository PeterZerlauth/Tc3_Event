[[ _TOC_ ]]

## FB_LoggingProvider

**Type:** FUNCTION BLOCK

#### Description  
- 

#### Inputs  
-

#### Outputs  
-

#### Locals  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| nLength | `INT` |  |  |
| pList | `POINTER TO I_Logger` |  |  |
| aList | `POINTER TO POINTER TO ARRAY [0..24] OF I_Logger` | `=ADR(pList)` |  |

### Methods

#### FB_exit

returns : `BOOL`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| bInCopyCode | `BOOL` |  | if TRUE, the exit method is called for exiting an instance that is copied afterwards (online change). |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
M_Clear();
```

</details>

#### M_Add

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| iLogger | `I_Logger` |  |  |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
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
```

</details>

#### M_Clear

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| M_Clear | `bool` |  |  |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
IF pList <> 0 THEN
	nLength:= 0;
	__DELETE(pList);
END_IF
M_Clear:= TRUE;
```

</details>

#### M_Find

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| iLogger | `I_Logger` |  |  |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
// Object already in List
M_Find := -1;
WHILE nIndex < nLength DO
    IF (pList[nIndex] = iLogger) THEN
        M_Find := nIndex;
        RETURN;
    END_IF
	nIndex := nIndex + 1;
END_WHILE
```

</details>

#### M_Index

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| nIndex | `DINT` |  |  |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
IF (nIndex < nLength) THEN
	M_Index := pList[nIndex];
END_IF
```

</details>

#### M_Log

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| fbMessage | `FB_Message` |  |  |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
WHILE nIndex < nLength DO
    pList[nIndex].M_Log(fbMessage);
	nIndex := nIndex + 1;
END_WHILE
```

</details>

#### M_Remove

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| iLogger | `I_Logger` |  |  |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
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
```

</details>

#### M_Reset

returns : `BOOL`  

**Description**  
-

**Input**  
-

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
nIndex := 0;
WHILE nIndex < nLength DO
    pList[nIndex].M_Reset();
    nIndex := nIndex + 1;
END_WHILE
M_Reset:= TRUE;
```

</details>

### Properties

#### P_Length

```iec
{attribute 'OPC.UA.DA.Property' := '1'}
{attribute 'monitoring' := 'variable'}
PROPERTY PUBLIC P_Length : DINT
```

<details>
<summary>Raw IEC/ST</summary>

```iec
{attribute 'no_explicit_call' := 'do not call this POU directly'} 
// Provide the functionality to use more than one Logger target
FUNCTION_BLOCK FB_LoggingProvider IMPLEMENTS I_Logger
VAR
	nLength:		INT;
	pList: 			POINTER TO I_Logger;
	aList:			POINTER TO POINTER TO ARRAY [0..24] OF I_Logger:=ADR(pList);
END_VAR

// --- Implementation ---

// https://peterzerlauth.com/
```

</details>

