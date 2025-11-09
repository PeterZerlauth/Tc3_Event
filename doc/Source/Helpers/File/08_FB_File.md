# FB_File


## Declaration (Variables)

### VAR_OUTPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| pBuffer | POINTER |  |
| nBuffer | UDINT |  |
| bError | BOOL |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| sFileName | STRING(255) |  |
| eMode | SysFile.ACCESS_MODE |  |
| hFile | SysFile.SysTypes.RTS_IEC_HANDLE |  |
| nResult | SysFile.SysTypes.RTS_IEC_RESULT |  |
| pResult | POINTER |  |




## Methods

### FB_Exit

**Returns:** (None)

FB_Exit must be implemented explicitly. If there is an implementation, then the 
method is called before the controller removes the code of the function block instance 
(implicit call). The return value is not evaluated. 
Try to close and reset on exit

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| bInCopyCode | BOOL | TRUE: the exit method is called in order to leave the instance which will be copied afterwards (online change). |

### M_Close

**Returns:** (None)

Closes the file if opened

### M_Delete

**Returns:** (None)

Delete file

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| sFileName | STRING(255) | Delete file |

### M_GetSize

**Returns:** (None)

Get file size

### M_Open

**Returns:** (None)

Open file

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| sFileName | STRING(255) | file path |
| eMode | SysFile.ACCESS_MODE |  |

### M_Read

**Returns:** (None)

Read file

### M_Reset

**Returns:** (None)

Reset all

### M_Status

**Returns:** (None)

File status

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| nState | SysFile.SYS_FILE_STATUS |  |

### M_Write

**Returns:** (None)

Writes content to a file

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| pBuffer | POINTER | Writes content to a file |
| nSize | UDINT |  |


