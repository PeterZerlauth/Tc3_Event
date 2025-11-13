# FB_Event

**Type:** `FUNCTION BLOCK`
**Source File:** `Event/FB_Event.TcPOU`

Providing the event logger

## Inputs
| Name | Type | Description |
| --- | --- | --- |
| `iLogger` | `I_Logger` | Interface has to be attached to a Valid target |

## Local Variables
| Name | Type | Description |
| --- | --- | --- |
| `iLogger` | `I_Logger` | Interface has to be attached to a Valid target |

## Methods

### `FB_Init` : `BOOL`
FB_Init is always available implicitly and it is used primarily for initialization.
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `bInitRetains` | `BOOL` | TRUE: the retain variables are initialized (reset warm / reset cold) |
| `bInCopyCode` | `BOOL` |  |

**Implementation:**
```iec
fbSymbolInfo.SYMNAME:= F_InstancePath(sInstancePath);
fbSymbolInfo.PORT:= TwinCAT_SystemInfoVarList._AppInfo.AdsPort;
fbSymbolInfo.START:= TRUE;
fbSystemTime.bEnable:= TRUE;
```

---
### `M_Critical` : `BOOL`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `nID` | `UDINT` | Id of the error message |
| `sMessage` | `STRING` |  |

**Implementation:**
```iec
IF sMessage = '' THEN
	RETURN;
END_IF

fbCritical.bActive:= TRUE;
fbCritical.sMessage:= sMessage;
fbCritical.eLogLevel:= E_LogLevel.Critical;
fbCritical.nID:= nID;
fbCritical.nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
fbCritical.sArguments:= fbArguments.P_Value;
fbCritical.sDefault:= F_Print(sMessage, fbArguments.P_Value);
fbCritical.sSource:= fbSymbolInfo.SYMNAME;
fbCritical.sType:= fbSymbolInfo.SYMINFO.symDataType;

IF iLogger = 0 THEN
	F_Log(fbCritical);
ELSE
	iLogger.M_Log(fbCritical);
END_IF
	
fbArguments.M_Clear();
```

---
### `M_Error` : `BOOL`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `nID` | `UDINT` | Id of the error message |
| `sMessage` | `STRING` |  |

**Implementation:**
```iec
IF sMessage = '' THEN
	RETURN;
END_IF

fbError.bActive:= TRUE;
fbError.sMessage:= sMessage;
fbError.eLogLevel:= E_LogLevel.Error;
fbError.nID:= nID;
fbError.nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
fbError.sArguments:= fbArguments.P_Value;
fbError.sDefault:= F_Print(sMessage, fbArguments.P_Value);
fbError.sSource:= fbSymbolInfo.SYMNAME;
fbError.sType:= fbSymbolInfo.SYMINFO.symDataType;

IF iLogger = 0 THEN
	F_Log(fbError);
ELSE
	iLogger.M_Log(fbError);
END_IF

fbArguments.M_Clear();
```

---
### `M_Info` : `BOOL`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `nID` | `UDINT` | Id of the error message |
| `sMessage` | `STRING` |  |

**Implementation:**
```iec
IF sMessage = '' THEN
	RETURN;
END_IF

fbInfo.bActive:= TRUE;
fbInfo.sMessage:= sMessage;
fbInfo.eLogLevel:= E_LogLevel.Info;
fbInfo.nID:= nID;
fbInfo.nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
fbInfo.sArguments:= fbArguments.P_Value;
fbInfo.sDefault:= F_Print(sMessage, fbArguments.P_Value);
fbInfo.sSource:= fbSymbolInfo.SYMNAME;
fbInfo.sType:= fbSymbolInfo.SYMINFO.symDataType;

IF iLogger = 0 THEN
	F_Log(fbInfo);
ELSE
	iLogger.M_Log(fbInfo);
END_IF

fbArguments.M_Clear();
```

---
### `M_Reset` : `BOOL`
*No documentation found.*

**Implementation:**
```iec
IF iLogger <> 0 THEN
	M_Reset:= iLogger.M_Reset();
END_IF
```

---
### `M_Verbose` : `BOOL`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `sMessage` | `STRING` |  |

**Implementation:**
```iec
IF sMessage = '' THEN
	RETURN;
END_IF

fbVerbose.bActive:= TRUE;
fbVerbose.sMessage:= sMessage;
fbVerbose.eLogLevel:= E_LogLevel.Verbose;
fbVerbose.nID:= 0;
fbVerbose.nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
fbVerbose.sArguments:= fbArguments.P_Value;
fbVerbose.sDefault:= F_Print(sMessage, fbArguments.P_Value);
fbVerbose.sSource:= fbSymbolInfo.SYMNAME;
fbVerbose.sType:= fbSymbolInfo.SYMINFO.symDataType;

IF iLogger = 0 THEN
	F_Log(fbVerbose);
ELSE
	iLogger.M_Log(fbVerbose);
END_IF

fbArguments.M_Clear();
```

---
### `M_Warning` : `BOOL`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `nID` | `UDINT` |  |

**Implementation:**
```iec
IF sMessage = '' THEN
	RETURN;
END_IF

fbWarning.bActive:= TRUE;
fbWarning.sMessage:= sMessage;
fbWarning.eLogLevel:= E_LogLevel.Warning;
fbWarning.nID:= nID;
fbWarning.nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
fbWarning.sArguments:= fbArguments.P_Value;
fbWarning.sDefault:= F_Print(sMessage, fbArguments.P_Value);
fbWarning.sSource:= fbSymbolInfo.SYMNAME;
fbWarning.sType:= fbSymbolInfo.SYMINFO.symDataType;

IF iLogger = 0 THEN
	F_Log(fbWarning);
ELSE
	iLogger.M_Log(fbWarning);
END_IF

fbArguments.M_Clear();
```

---

## Properties

### `P_Argument`
*No documentation found.*

**Get Implementation:**
```iec
P_Argument:= fbArguments;
```

---
### `P_Logger`
*No documentation found.*

**Get Implementation:**
```iec
P_Logger:= iLogger;
```
**Set Implementation:**
```iec
iLogger:= P_Logger;
```

---

## Implementation
```iec
fbSymbolInfo();
IF nCycleTime <> TwinCAT_SystemInfoVarList._TaskInfo[GETCURTASKINDEXEX()].CycleTime THEN
	nCycleTime:= TwinCAT_SystemInfoVarList._TaskInfo[GETCURTASKINDEXEX()].CycleTime;
	fbSystemTime();
	nTimestamp:= SYSTEMTIME_TO_FILETIME64(fbSystemTime.systemTime);
	GVL.nTimestamp:= nTimestamp;	
END_IF
```
