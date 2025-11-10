# FB_Event

**Type:** FUNCTION_BLOCK

**Source File:** `Event/FB_Event.TcPOU`

```iec
{attribute 'reflection'} 
// Providing the event logger
FUNCTION_BLOCK FB_Event IMPLEMENTS I_Event
VAR_INPUT
	iLogger:					I_Logger;		// Interface has to be attached to a Valid target
END_VAR
VAR
    {attribute 'hide'} 
    {attribute 'instance-path'} 
    {attribute 'noinit'} 
    sInstancePath:				STRING(255);
	fbSymbolInfo: 				PLC_ReadSymInfoByNameEx;
	fbSystemTime: 				FB_LocalSystemTime;
	fbArguments:				FB_Argument;
	fbVerbose:					FB_Message;
	fbInfo:						FB_Message;
	fbWarning:					FB_Message;
	fbError:					FB_Message;
	fbCritical:					FB_Message;
END_VAR

// --- Implementation ---
fbSymbolInfo();
fbSystemTime();

// --- Method: FB_Init ---
//FB_Init is always available implicitly and it is used primarily for initialization.
//The return value is not evaluated. For a specific influence, you can also declare the
//methods explicitly and provide additional code there with the standard initialization
//code. You can evaluate the return value.
METHOD FB_Init: BOOL
VAR_INPUT
    bInitRetains: BOOL; // TRUE: the retain variables are initialized (reset warm / reset cold)
    bInCopyCode: BOOL:= TRUE;  // TRUE: the instance will be copied to the copy code afterward (online change)   
END_VAR
fbSymbolInfo.SYMNAME:= F_InstancePath(sInstancePath);
fbSymbolInfo.PORT:= TwinCAT_SystemInfoVarList._AppInfo.AdsPort;
fbSymbolInfo.START:= TRUE;
fbSystemTime.bEnable:= TRUE;
END_METHOD

// --- Method: M_Critical ---
METHOD PUBLIC M_Critical : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
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
END_METHOD

// --- Method: M_Error ---
METHOD PUBLIC M_Error : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
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
END_METHOD

// --- Method: M_Info ---
METHOD PUBLIC M_Info : BOOL
VAR_INPUT
	nID:				UDINT;				// Id of the error message
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
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
END_METHOD

// --- Method: M_Reset ---
METHOD M_Reset : BOOL
VAR_INPUT
END_VAR
IF iLogger <> 0 THEN
	M_Reset:= iLogger.M_Reset();
END_IF
END_METHOD

// --- Method: M_Verbose ---
METHOD PUBLIC M_Verbose : BOOL
VAR_INPUT
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
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
END_METHOD

// --- Method: M_Warning ---
METHOD PUBLIC M_Warning : BOOL
VAR_INPUT
	nID:				UDINT;
	sMessage:			STRING(255);		// content of the error message, placeholder %s
END_VAR
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
END_METHOD

// --- Property (read/write): P_Argument ---
PROPERTY P_Argument : UNKNOWN
END_PROPERTY

// --- Property (read/write): P_Logger ---
PROPERTY P_Logger : UNKNOWN
END_PROPERTY
```

### References / Cross-links
- [FB_Event](Event/FB_Event.md)
- [I_Event](Event/I_Event.md)
- [I_Logger](Logging/I_Logger.md)
- [FB_Argument](Argument/FB_Argument.md)
- [FB_Message](Message/FB_Message.md)
- [E_LogLevel](Logger/List/E_LogLevel.md)

