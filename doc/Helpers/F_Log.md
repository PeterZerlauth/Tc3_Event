# F_Log

**Type:** FUNCTION

**Source File:** `Helpers/F_Log.TcPOU`

```iec
// Backup logger, if no logger is attached to FB_Event
FUNCTION F_Log : BOOL
VAR_INPUT
	fbMessage:			REFERENCE TO FB_Message;
END_VAR
VAR
	sMessage:			STRING(255):= 'Logger null | ';
    nIndex:				UINT;
    nNow:				ULINT:= F_GetSystemTime();
END_VAR
```

