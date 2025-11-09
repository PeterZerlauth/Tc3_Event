[[_TOC_]]

# FB_TcLogger

---\n
## 📜 Declaration (Variables)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=eLogLevel; Type=[E_LogLevel](../Types/03_E_LogLevel.md); Default=; Comment=Provide logging}.Name) | $(@{Name=eLogLevel; Type=[E_LogLevel](../Types/03_E_LogLevel.md); Default=; Comment=Provide logging}.Type) | Provide logging |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=fbSourceInfo; Type=FB_TcSourceInfo; Default=; Comment=}.Name) | $(@{Name=fbSourceInfo; Type=FB_TcSourceInfo; Default=; Comment=}.Type) |  |
| $(@{Name=aAlarm; Type=ARRAY; Default=; Comment=}.Name) | $(@{Name=aAlarm; Type=ARRAY; Default=; Comment=}.Type) |  |
| $(@{Name=nAlarm; Type=UINT; Default=; Comment=Message count}.Name) | $(@{Name=nAlarm; Type=UINT; Default=; Comment=Message count}.Type) | Message count |
| $(@{Name=bAlarm; Type=ARRAY; Default=; Comment=}.Name) | $(@{Name=bAlarm; Type=ARRAY; Default=; Comment=}.Type) |  |
| $(@{Name=nIndex; Type=UINT; Default=; Comment=}.Name) | $(@{Name=nIndex; Type=UINT; Default=; Comment=}.Type) |  |
| $(@{Name=nTimestamp; Type=LINT; Default=; Comment=}.Name) | $(@{Name=nTimestamp; Type=LINT; Default=; Comment=}.Type) |  |



---\n
## ⚙️ Methods

### ### M_Log

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=fbMessage; Type=FB_Message; Default=; Comment=}.Name) | $(@{Name=fbMessage; Type=FB_Message; Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=sArgument; Type=STRING; Default=; Comment=}.Name) | $(@{Name=sArgument; Type=STRING; Default=; Comment=}.Type) |  |
| $(@{Name=nPosition; Type=INT; Default=; Comment=}.Name) | $(@{Name=nPosition; Type=INT; Default=; Comment=}.Type) |  |

### ### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n

---\n
## 💎 Properties

### ### P_LogLevel

**Type:** $propType`n
* **Get:** Available
* **Set:** Available


