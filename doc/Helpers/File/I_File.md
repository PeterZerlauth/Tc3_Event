[[ _TOC_ ]]

## I_File

**Type:** INTERFACE

#### Declaration

```iec
INTERFACE I_File
```

### Methods

#### M_Close

returns : `-`  

**Description**  
close file

**Input**  
-

#### M_Delete

returns : `-`  

**Description**  
Delete file

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sFileName | `STRING(255)` |  |  |

#### M_GetSize

returns : `-`  

**Description**  
get file size

**Input**  
-

#### M_Open

returns : `-`  

**Description**  
Open file

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sFileName | `STRING(255)` |  |  |
| eMode | `SysFile.ACCESS_MODE` | `= SysFile.AM_APPEND_PLUS` |  |

#### M_Read

returns : `-`  

**Description**  
Read file

**Input**  
-

#### M_Status

returns : `-`  

**Description**  
state of file

**Input**  
-

#### M_Write

returns : `-`  

**Description**  
Write file

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| pBuffer | `POINTER TO BYTE` |  |  |
| nSize | `UDINT` |  |  |

