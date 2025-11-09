# FB_LoggingProvider


## Declaration (Variables)

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| nLength | INT |  |
| pList | POINTER |  |
| aList | POINTER |  |




## Methods

### FB_exit

**Returns:** $(System.Collections.Hashtable['Return'])`n
### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| bInCopyCode | BOOL | if TRUE, the exit method is called for exiting an instance that is copied afterwards (online change). |

### M_Add

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| iLogger | I_Logger |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| pOldList | POINTER |  |

### M_Clear

**Returns:** (None)

### M_Find

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| iLogger | I_Logger |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| nIndex | UINT |  |

### M_Index

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| nIndex | DINT |  |

### M_Log

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| fbMessage | FB_Message |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| nIndex | INT |  |

### M_Remove

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| iLogger | I_Logger |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| pOldList | POINTER |  |
| nPosition | DINT |  |

### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n
### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| nIndex | UINT |  |



##Properties

### P_Length

**Type:** $propType`n
* **Get:** Available


