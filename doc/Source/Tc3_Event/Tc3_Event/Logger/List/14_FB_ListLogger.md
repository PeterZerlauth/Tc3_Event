[[_TOC_]]

# FB_ListLogger

---\n
## 📜 Declaration (Variables)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=eLogLevel; Type=[E_LogLevel](../Types/03_E_LogLevel.md); Default=; Comment=Provide logging}.Name) | $(@{Name=eLogLevel; Type=[E_LogLevel](../Types/03_E_LogLevel.md); Default=; Comment=Provide logging}.Type) | Provide logging |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=aMessages; Type=ARRAY; Default=; Comment=}.Name) | $(@{Name=aMessages; Type=ARRAY; Default=; Comment=}.Type) |  |
| $(@{Name=nMessages; Type=UINT; Default=; Comment=}.Name) | $(@{Name=nMessages; Type=UINT; Default=; Comment=}.Type) |  |
| $(@{Name=nIndex; Type=UINT; Default=; Comment=}.Name) | $(@{Name=nIndex; Type=UINT; Default=; Comment=}.Type) |  |
| $(@{Name=nTimestamp; Type=LINT; Default=; Comment=}.Name) | $(@{Name=nTimestamp; Type=LINT; Default=; Comment=}.Type) |  |



---\n
## ⚙️ Methods

### M_Log

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=fbMessage; Type=FB_Message; Default=; Comment=}.Name) | $(@{Name=fbMessage; Type=FB_Message; Default=; Comment=}.Type) |  |

### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n

---\n
## 💎 Properties

### P_LogLevel

**Type:** $propType`n
* **Get:** Available
* **Set:** Available


