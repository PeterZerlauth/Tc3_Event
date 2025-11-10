# FB_TcLogger

## Declaration (Variables)

### VAR_INPUT

| Name | Type | Description |
| :--- | :--- | :--- |
| eLogLevel | [E_LogLevel](../../../../../Types/02_E_LogLevel.md) | Provide logging |

### VAR

| Name | Type | Description |
| :--- | :--- | :--- |
| fbSourceInfo | FB_TcSourceInfo |  |
| aAlarm | ARRAY[0..99] |  |
| nAlarm | UINT | Message count |
| bAlarm | ARRAY[0..99] |  |
| nIndex | UINT |  |
| nTimestamp | LINT |  |




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
| sArgument | STRING |  |
| nPosition | INT |  |

### M_Reset

**Returns:** $(System.Collections.Hashtable['Return'])`n


## Properties

### P_LogLevel

**Type:** $propType`n
* **Get:** Available
* **Set:** Available


