# FB_Event


## Declaration (Variables)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| iLogger | I_Logger |  |

### VAR_OUTPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| fbArguments | FB_Argument |  |

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
| bInitRetains | BOOL | TRUE: Die Retain-Variablen werden initialisiert (Reset warm / Reset kalt) |
| bInCopyCode | BOOL |  |

### ### M_Critical

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| nID | UDINT |  |
| sMessage | STRING(255) |  |

### ### M_Error

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| nID | UDINT |  |
| sMessage | STRING(255) |  |

### ### M_Info

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| nID | UDINT |  |
| sMessage | STRING(255) |  |

### ### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n
### ### M_Verbose

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| sMessage | STRING(255) |  |

### ### M_Warning

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| nID | UDINT |  |
| sMessage | STRING(255) |  |



##Properties

### ### P_Argument

**Type:** $propType`n
* **Get:** Available

### ### P_Logger

**Type:** $propType`n
* **Get:** Available
* **Set:** Available


