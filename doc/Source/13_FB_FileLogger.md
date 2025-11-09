[[_TOC_]]

# FB_FileLogger

---\n
## 📜 Declaration (Variables)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=eLogLevel; Type=[E_LogLevel](Types\3_E_LogLevel.md); Default=; Comment=Provide logging}.Name) | $(@{Name=eLogLevel; Type=[E_LogLevel](Types\3_E_LogLevel.md); Default=; Comment=Provide logging}.Type) | Provide logging |
| $(@{Name=sPathName; Type=STRING(255); Default=; Comment=}.Name) | $(@{Name=sPathName; Type=STRING(255); Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=fbFile; Type=FB_File; Default=; Comment=}.Name) | $(@{Name=fbFile; Type=FB_File; Default=; Comment=}.Type) |  |
| $(@{Name=aBuffer; Type=ARRAY; Default=; Comment=}.Name) | $(@{Name=aBuffer; Type=ARRAY; Default=; Comment=}.Type) |  |
| $(@{Name=nBuffer; Type=UINT; Default=; Comment=}.Name) | $(@{Name=nBuffer; Type=UINT; Default=; Comment=}.Type) |  |



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
| $(@{Name=nTimestamp; Type=Tc2_Utilities.T_FILETIME64; Default=; Comment=}.Name) | $(@{Name=nTimestamp; Type=Tc2_Utilities.T_FILETIME64; Default=; Comment=}.Type) |  |
| $(@{Name=nIndex; Type=uINT; Default=; Comment=}.Name) | $(@{Name=nIndex; Type=uINT; Default=; Comment=}.Type) |  |
| $(@{Name=sLogLine; Type=STRING(255); Default=; Comment=}.Name) | $(@{Name=sLogLine; Type=STRING(255); Default=; Comment=}.Type) |  |

### ### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n

---\n
## 💎 Properties

### ### P_LogLevel

**Type:** $propType`n
* **Get:** Available
* **Set:** Available


