# FB_LoggingProvider

---\n
## Declaration (Variables)

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=nLength; Type=INT; Default=; Comment=}.Name) | $(@{Name=nLength; Type=INT; Default=; Comment=}.Type) |  |
| $(@{Name=pList; Type=POINTER; Default=; Comment=}.Name) | $(@{Name=pList; Type=POINTER; Default=; Comment=}.Type) |  |
| $(@{Name=aList; Type=POINTER; Default=; Comment=}.Name) | $(@{Name=aList; Type=POINTER; Default=; Comment=}.Type) |  |



---\n
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
| $(@{Name=pOldList; Type=POINTER; Default=; Comment=}.Name) | $(@{Name=pOldList; Type=POINTER; Default=; Comment=}.Type) |  |

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
| $(@{Name=nIndex; Type=UINT; Default=; Comment=}.Name) | $(@{Name=nIndex; Type=UINT; Default=; Comment=}.Type) |  |

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
| $(@{Name=nIndex; Type=INT; Default=; Comment=}.Name) | $(@{Name=nIndex; Type=INT; Default=; Comment=}.Type) |  |

### ### M_Remove

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=iLogger; Type=I_Logger; Default=; Comment=}.Name) | $(@{Name=iLogger; Type=I_Logger; Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=pOldList; Type=POINTER; Default=; Comment=}.Name) | $(@{Name=pOldList; Type=POINTER; Default=; Comment=}.Type) |  |
| $(@{Name=nPosition; Type=DINT; Default=; Comment=}.Name) | $(@{Name=nPosition; Type=DINT; Default=; Comment=}.Type) |  |

### ### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n
### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=nIndex; Type=UINT; Default=; Comment=}.Name) | $(@{Name=nIndex; Type=UINT; Default=; Comment=}.Type) |  |


---\n
##Properties

### ### P_Length

**Type:** $propType`n
* **Get:** Available


