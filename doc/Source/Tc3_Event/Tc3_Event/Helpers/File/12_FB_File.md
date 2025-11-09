[[_TOC_]]

# FB_File

---\n
## 📜 Declaration (Variables)

### VAR_OUTPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=pBuffer; Type=POINTER; Default=; Comment=}.Name) | $(@{Name=pBuffer; Type=POINTER; Default=; Comment=}.Type) |  |
| $(@{Name=nBuffer; Type=UDINT; Default=; Comment=}.Name) | $(@{Name=nBuffer; Type=UDINT; Default=; Comment=}.Type) |  |
| $(@{Name=bError; Type=BOOL; Default=; Comment=}.Name) | $(@{Name=bError; Type=BOOL; Default=; Comment=}.Type) |  |

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=sFileName; Type=STRING(255); Default=; Comment=}.Name) | $(@{Name=sFileName; Type=STRING(255); Default=; Comment=}.Type) |  |
| $(@{Name=eMode; Type=SysFile.ACCESS_MODE; Default=; Comment=}.Name) | $(@{Name=eMode; Type=SysFile.ACCESS_MODE; Default=; Comment=}.Type) |  |
| $(@{Name=hFile; Type=SysFile.SysTypes.RTS_IEC_HANDLE; Default=; Comment=}.Name) | $(@{Name=hFile; Type=SysFile.SysTypes.RTS_IEC_HANDLE; Default=; Comment=}.Type) |  |
| $(@{Name=nResult; Type=SysFile.SysTypes.RTS_IEC_RESULT; Default=; Comment=}.Name) | $(@{Name=nResult; Type=SysFile.SysTypes.RTS_IEC_RESULT; Default=; Comment=}.Type) |  |
| $(@{Name=pResult; Type=POINTER; Default=; Comment=}.Name) | $(@{Name=pResult; Type=POINTER; Default=; Comment=}.Type) |  |



---\n
## ⚙️ Methods

### FB_Exit

**Returns:** (None)

FB_Exit muss explizit implementiert werden. Wenn es eine Implementierung gibt, dann wird 
die Methode aufgerufen, bevor die Steuerung den Code der Funktionsbaustein-Instanz entfernt 
(impliziter Aufruf. Der Rückgabewert wird nicht ausgewertet.

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=bInCopyCode; Type=BOOL; Default=; Comment=TRUE: Die Exit-Methode wird aufgerufen, um die Instanz zu verlassen, die hinterher kopiert wird Online-Change).}.Name) | $(@{Name=bInCopyCode; Type=BOOL; Default=; Comment=TRUE: Die Exit-Methode wird aufgerufen, um die Instanz zu verlassen, die hinterher kopiert wird Online-Change).}.Type) | TRUE: Die Exit-Methode wird aufgerufen, um die Instanz zu verlassen, die hinterher kopiert wird Online-Change). |

### M_Close

**Returns:** (None)

Closes the currently opened file.

### M_Delete

**Returns:** (None)

Delete file

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=sFileName; Type=STRING(255); Default=; Comment=Delete file}.Name) | $(@{Name=sFileName; Type=STRING(255); Default=; Comment=Delete file}.Type) | Delete file |

### M_GetSize

**Returns:** (None)

### M_Open

**Returns:** (None)

Open file

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=sFileName; Type=STRING(255); Default=; Comment=Open file}.Name) | $(@{Name=sFileName; Type=STRING(255); Default=; Comment=Open file}.Type) | Open file |
| $(@{Name=eMode; Type=SysFile.ACCESS_MODE; Default=; Comment=}.Name) | $(@{Name=eMode; Type=SysFile.ACCESS_MODE; Default=; Comment=}.Type) |  |

### M_Read

**Returns:** (None)

Read file

### M_Reset

**Returns:** (None)

### M_Status

**Returns:** (None)

### VAR
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=nState; Type=SysFile.SYS_FILE_STATUS; Default=; Comment=}.Name) | $(@{Name=nState; Type=SysFile.SYS_FILE_STATUS; Default=; Comment=}.Type) |  |

### M_Write

**Returns:** (None)

Writes the contents of the buffer into a file.

### VAR_INPUT
| Name | Type | Description |
| :--- | :--- | :--- |
| $(@{Name=pBuffer; Type=POINTER; Default=; Comment=Writes the contents of the buffer into a file.}.Name) | $(@{Name=pBuffer; Type=POINTER; Default=; Comment=Writes the contents of the buffer into a file.}.Type) | Writes the contents of the buffer into a file. |
| $(@{Name=nSize; Type=UDINT; Default=; Comment=}.Name) | $(@{Name=nSize; Type=UDINT; Default=; Comment=}.Type) |  |


