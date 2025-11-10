[[ _TOC_ ]]

## I_Event

**Type:** INTERFACE

#### Declaration

```iec
INTERFACE I_Event
```

### Methods

#### M_Critical

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| nID | `UDINT` |  |  |
| sMessage | `STRING(255)` |  |  |

#### M_Error

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| nID | `UDINT` |  |  |
| sMessage | `STRING(255)` |  |  |

#### M_Info

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| nID | `UDINT` |  |  |
| sMessage | `STRING(255)` |  |  |

#### M_Verbose

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sMessage | `STRING(255)` |  |  |

#### M_Warning

returns : `-`  

**Description**  
-

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| nID | `UDINT` |  |  |
| sMessage | `STRING(255)` |  |  |

### Properties

#### P_Argument

```iec
PROPERTY PUBLIC P_Argument : I_Argument
```

#### P_Logger

```iec
PROPERTY PUBLIC P_Logger : I_Logger
```

