# FB_Event


## Declaration (Variables)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| iLogger | I_Logger | Interface has to be attached to a Valid target |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| sInstancePath | STRING(255) |  |
| fbSymbolInfo | PLC_ReadSymInfoByNameEx |  |
| fbSystemTime | FB_LocalSystemTime |  |
| fbArguments | FB_Argument |  |
| fbVerbose | FB_Message |  |
| fbInfo | FB_Message |  |
| fbWarning | FB_Message |  |
| fbError | FB_Message |  |
| fbCritical | FB_Message |  |




## Methods

### FB_Init

**Returns:** BOOL (Implicit)

FB_Init is always available implicitly and it is used primarily for initialization. 
The return value is not evaluated. For a specific influence, you can also declare the 
methods explicitly and provide additional code there with the standard initialization 
code. You can evaluate the return value.

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| bInitRetains | BOOL | TRUE: the retain variables are initialized (reset warm / reset cold) |
| bInCopyCode | BOOL |  |

### M_Critical

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| nID | UDINT | Id of the error message |
| sMessage | STRING(255) | content of the error message, placeholder %s |

### M_Error

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| nID | UDINT | Id of the error message |
| sMessage | STRING(255) | content of the error message, placeholder %s |

### M_Info

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| nID | UDINT | Id of the error message |
| sMessage | STRING(255) | content of the error message, placeholder %s |

### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n
### M_Verbose

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| sMessage | STRING(255) | content of the error message, placeholder %s |

### M_Warning

**Returns:** (None)

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| nID | UDINT |  |
| sMessage | STRING(255) | content of the error message, placeholder %s |



## Properties

### P_Argument

**Type:** $propType`n
* **Get:** Available

### P_Logger

**Type:** $propType`n
* **Get:** Available
* **Set:** Available


