# FB_TcLogger


## Declaration (Variables)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=eLogLevel; Type=[E_LogLevel](../Types/03_E_LogLevel.md); Default=; Comment=Provide logging}.Name) | $(@{Name=eLogLevel; Type=[E_LogLevel](../Types/03_E_LogLevel.md); Default=; Comment=Provide logging}.Type) | Provide logging |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| fbSourceInfo | FB_TcSourceInfo |  |
| aAlarm | ARRAY |  |
| nAlarm | UINT | Message count |
| bAlarm | ARRAY |  |
| nIndex | UINT |  |
| nTimestamp | LINT |  |




## Methods

### ### M_Log

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=fbMessage; Type=FB_Message; Default=; Comment=}.Name) | $(@{Name=fbMessage; Type=FB_Message; Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| sArgument | STRING |  |
| nPosition | INT |  |

### ### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n


##Properties

### ### P_LogLevel

**Type:** $propType`n
* **Get:** Available
* **Set:** Available


