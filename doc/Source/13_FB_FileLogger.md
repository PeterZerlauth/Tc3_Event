# FB_FileLogger


## Declaration (Variables)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=eLogLevel; Type=[E_LogLevel](../Types/03_E_LogLevel.md); Default=; Comment=Provide logging}.Name) | $(@{Name=eLogLevel; Type=[E_LogLevel](../Types/03_E_LogLevel.md); Default=; Comment=Provide logging}.Type) | Provide logging |
| $(@{Name=sPathName; Type=STRING(255); Default=; Comment=}.Name) | $(@{Name=sPathName; Type=STRING(255); Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| fbFile | FB_File |  |
| aBuffer | ARRAY |  |
| nBuffer | UINT |  |




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
| nTimestamp | Tc2_Utilities.T_FILETIME64 |  |
| nIndex | uINT |  |
| sLogLine | STRING(255) |  |

### ### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n


##Properties

### ### P_LogLevel

**Type:** $propType`n
* **Get:** Available
* **Set:** Available


