# LogLevel_To_TcEventSeverity

**Type:** `FUNCTION`
**Source File:** `Helpers/LogLevel_To_TcEventSeverity.TcPOU`

Converts internal loglevel to twincat severity

**Returns:** `TcEventSeverity`

## Inputs
| Name | Type | Description |
| --- | --- | --- |
| `eLogLevel` | `E_LogLevel` |  |

## Local Variables
| Name | Type | Description |
| --- | --- | --- |
| `eLogLevel` | `E_LogLevel` |  |

## Implementation
```iec
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
