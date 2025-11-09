# FB_LoggingProvider


## Declaration (Variables)

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| nLength | INT |  |
| pList | POINTER |  |
| aList | POINTER |  |




## Methods

### ### FB_exit

**Returns:** $(System.Collections.Hashtable['Return'])`n
### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=bInCopyCode; Type=BOOL; Default=; Comment=if TRUE, the exit method is called for exiting an instance that is copied afterwards (online change).}.Name) | $(@{Name=bInCopyCode; Type=BOOL; Default=; Comment=if TRUE, the exit method is called for exiting an instance that is copied afterwards (online change).}.Type) | if TRUE, the exit method is called for exiting an instance that is copied afterwards (online change). |

### ### M_Add

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=iLogger; Type=I_Logger; Default=; Comment=}.Name) | $(@{Name=iLogger; Type=I_Logger; Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| pOldList | POINTER |  |

### ### M_Clear

**Returns:** (None)

### ### M_Find

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=iLogger; Type=I_Logger; Default=; Comment=}.Name) | $(@{Name=iLogger; Type=I_Logger; Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| nIndex | UINT |  |

### ### M_Index

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=nIndex; Type=DINT; Default=; Comment=}.Name) | $(@{Name=nIndex; Type=DINT; Default=; Comment=}.Type) |  |

### ### M_Log

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=fbMessage; Type=FB_Message; Default=; Comment=}.Name) | $(@{Name=fbMessage; Type=FB_Message; Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| nIndex | INT |  |

### ### M_Remove

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=iLogger; Type=I_Logger; Default=; Comment=}.Name) | $(@{Name=iLogger; Type=I_Logger; Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| pOldList | POINTER |  |
| nPosition | DINT |  |

### ### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n
### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| nIndex | UINT |  |



##Properties

### ### P_Length

**Type:** $propType`n
* **Get:** Available


