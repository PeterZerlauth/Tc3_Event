# LogLevel_To_TcEventSeverity

**Type:** FUNCTION

**Source File:** `Helpers/LogLevel_To_TcEventSeverity.TcPOU`

```iec
// Converts internal loglevel to twincat severity
FUNCTION LogLevel_To_TcEventSeverity : TcEventSeverity
VAR_INPUT
	eLogLevel:				E_LogLevel;
END_VAR
VAR
END_VAR

// --- Implementation ---
CASE eLogLevel OF
	E_LogLevel.Verbose:
		LogLevel_To_TcEventSeverity:= TcEventSeverity.Verbose;
		
	E_LogLevel.Info:
		LogLevel_To_TcEventSeverity:= TcEventSeverity.Info;
		
	E_LogLevel.Warning:
		LogLevel_To_TcEventSeverity:= TcEventSeverity.Warning;
		
	E_LogLevel.Error:
		LogLevel_To_TcEventSeverity:= TcEventSeverity.Error;
		
	E_LogLevel.Critical:
		LogLevel_To_TcEventSeverity:= TcEventSeverity.Critical;
		
END_CASE
```

### References / Cross-links
- [E_LogLevel](Logger/List/E_LogLevel.md)

