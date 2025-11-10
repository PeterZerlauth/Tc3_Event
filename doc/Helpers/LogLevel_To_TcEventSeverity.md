# LogLevel_To_TcEventSeverity

**Type:** FUNCTION

**Source File:** `Helpers/LogLevel_To_TcEventSeverity.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
// Converts internal loglevel to twincat severity
FUNCTION [LogLevel_To_TcEventSeverity](Helpers/LogLevel_To_TcEventSeverity.md) : TcEventSeverity
VAR_INPUT
	eLogLevel:				[E_LogLevel](Logger/List/E_LogLevel.md);
END_VAR
VAR
END_VAR

// --- Implementation code ---
CASE eLogLevel OF
	[E_LogLevel](Logger/List/E_LogLevel.md).Verbose:
		[LogLevel_To_TcEventSeverity](Helpers/LogLevel_To_TcEventSeverity.md):= TcEventSeverity.Verbose;
		
	[E_LogLevel](Logger/List/E_LogLevel.md).Info:
		[LogLevel_To_TcEventSeverity](Helpers/LogLevel_To_TcEventSeverity.md):= TcEventSeverity.Info;
		
	[E_LogLevel](Logger/List/E_LogLevel.md).Warning:
		[LogLevel_To_TcEventSeverity](Helpers/LogLevel_To_TcEventSeverity.md):= TcEventSeverity.Warning;
		
	[E_LogLevel](Logger/List/E_LogLevel.md).Error:
		[LogLevel_To_TcEventSeverity](Helpers/LogLevel_To_TcEventSeverity.md):= TcEventSeverity.Error;
		
	[E_LogLevel](Logger/List/E_LogLevel.md).Critical:
		[LogLevel_To_TcEventSeverity](Helpers/LogLevel_To_TcEventSeverity.md):= TcEventSeverity.Critical;
		
END_CASE
```
</details>
