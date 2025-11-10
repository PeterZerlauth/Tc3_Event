# FB_FileLogger

## Declaration (Variables)

### VAR_INPUT

| Name | Type | Description |
| :--- | :--- | :--- |
| eLogLevel | [E_LogLevel](../../../../../Types/02_E_LogLevel.md) | Provide logging |
| sPathName | STRING(255) |  |

### VAR

| Name | Type | Description |
| :--- | :--- | :--- |
| fbFile | [FB_File](../../Helpers/File/12_FB_File.md) |  |
| aBuffer | ARRAY[0..99] |  |
| nBuffer | UINT |  |




## Methods

### M_Log

**Returns:** (None)

### VAR_INPUT

| Name | Type | Description |
| :--- | :--- | :--- |
| fbMessage | [FB_Message](../../Message/18_FB_Message.md) |  |

### VAR

| Name | Type | Description |
| :--- | :--- | :--- |
| nTimestamp | Tc2_Utilities.T_FILETIME64 |  |
| nIndex | uINT |  |
| sLogLine | STRING(255) |  |

### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n


## Properties

### P_LogLevel

**Type:** $propType`n
* **Get:** Available
* **Set:** Available


