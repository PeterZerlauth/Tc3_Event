# FB_Event


## Declaration (Variables)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=iLogger; Type=I_Logger; Default=; Comment=}.Name) | $(@{Name=iLogger; Type=I_Logger; Default=; Comment=}.Type) |  |

### VAR_OUTPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=fbArguments; Type=FB_Argument; Default=; Comment=}.Name) | $(@{Name=fbArguments; Type=FB_Argument; Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| sInstancePath | STRING(255) |  |
| fbSymbolInfo | PLC_ReadSymInfoByNameEx |  |
| fbSystemTime | FB_LocalSystemTime |  |
| fbVerbose | FB_Message |  |
| fbInfo | FB_Message |  |
| fbWarning | FB_Message |  |
| fbError | FB_Message |  |
| fbCritical | FB_Message |  |




## Methods

### ### FB_Init

**Returns:** BOOL (Implicit)

FB_Init ist immer implizit verfügbar und wird primär für die Initialisierung verwendet. 
Der Rückgabewert wird nicht ausgewertet. Für gezielte Einflussnahme können Sie 
die Methoden explizit deklarieren und darin mit dem Standard-Initialisierungscode 
zusätzlichen Code bereitstellen. Sie können den Rückgabewert auswerten.

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=bInitRetains; Type=BOOL; Default=; Comment=TRUE: Die Retain-Variablen werden initialisiert (Reset warm / Reset kalt)}.Name) | $(@{Name=bInitRetains; Type=BOOL; Default=; Comment=TRUE: Die Retain-Variablen werden initialisiert (Reset warm / Reset kalt)}.Type) | TRUE: Die Retain-Variablen werden initialisiert (Reset warm / Reset kalt) |
| $(@{Name=bInCopyCode; Type=BOOL; Default=; Comment=}.Name) | $(@{Name=bInCopyCode; Type=BOOL; Default=; Comment=}.Type) |  |

### ### M_Critical

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=nID; Type=UDINT; Default=; Comment=}.Name) | $(@{Name=nID; Type=UDINT; Default=; Comment=}.Type) |  |
| $(@{Name=sMessage; Type=STRING(255); Default=; Comment=}.Name) | $(@{Name=sMessage; Type=STRING(255); Default=; Comment=}.Type) |  |

### ### M_Error

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=nID; Type=UDINT; Default=; Comment=}.Name) | $(@{Name=nID; Type=UDINT; Default=; Comment=}.Type) |  |
| $(@{Name=sMessage; Type=STRING(255); Default=; Comment=}.Name) | $(@{Name=sMessage; Type=STRING(255); Default=; Comment=}.Type) |  |

### ### M_Info

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=nID; Type=UDINT; Default=; Comment=}.Name) | $(@{Name=nID; Type=UDINT; Default=; Comment=}.Type) |  |
| $(@{Name=sMessage; Type=STRING(255); Default=; Comment=}.Name) | $(@{Name=sMessage; Type=STRING(255); Default=; Comment=}.Type) |  |

### ### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n
### ### M_Verbose

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=sMessage; Type=STRING(255); Default=; Comment=}.Name) | $(@{Name=sMessage; Type=STRING(255); Default=; Comment=}.Type) |  |

### ### M_Warning

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=nID; Type=UDINT; Default=; Comment=}.Name) | $(@{Name=nID; Type=UDINT; Default=; Comment=}.Type) |  |
| $(@{Name=sMessage; Type=STRING(255); Default=; Comment=}.Name) | $(@{Name=sMessage; Type=STRING(255); Default=; Comment=}.Type) |  |



##Properties

### ### P_Argument

**Type:** $propType`n
* **Get:** Available

### ### P_Logger

**Type:** $propType`n
* **Get:** Available
* **Set:** Available


