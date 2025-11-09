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

### ### FB_Exit

**Returns:** (None)

FB_Exit muss explizit implementiert werden. Wenn es eine Implementierung gibt, dann wird 
die Methode aufgerufen, bevor die Steuerung den Code der Funktionsbaustein-Instanz entfernt 
(impliziter Aufruf. Der Rückgabewert wird nicht ausgewertet.

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| bInCopyCode | BOOL | TRUE: Die Exit-Methode wird aufgerufen, um die Instanz zu verlassen, die hinterher kopiert wird Online-Change). |

### ### M_Close

**Returns:** (None)

Closes the currently opened file.

### ### M_Delete

**Returns:** (None)

Delete file

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| sFileName | STRING(255) | Delete file |

### ### M_GetSize

**Returns:** (None)

### ### M_Open

**Returns:** (None)

Open file

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| sFileName | STRING(255) | Open file |
| eMode | SysFile.ACCESS_MODE |  |

### ### M_Read

**Returns:** (None)

Read file

### ### M_Reset

**Returns:** (None)

### ### M_Status

**Returns:** (None)

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| nState | SysFile.SYS_FILE_STATUS |  |

### ### M_Write

**Returns:** (None)

Writes the contents of the buffer into a file.

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| pBuffer | POINTER | Writes the contents of the buffer into a file. |
| nSize | UDINT |  |


