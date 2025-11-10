# F_Log

```iecst
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

### VAR_INPUT

| Name | Type | Description |
| :--- | :--- | :--- |
| `fbMessage` | `REFERENCE` | Backup logger, if no logger is attached to FB_Event |

### VAR

| Name | Type | Description |
| :--- | :--- | :--- |
| `sMessage` | `STRING(255)` |  |
| `nIndex` | `UINT` |  |
| `nNow` | `ULINT` |  |

