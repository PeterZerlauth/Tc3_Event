# FB_Argument

**Type:** `FUNCTION BLOCK`
**Source File:** `Argument/FB_Argument.TcPOU`

*No documentation found.*

## Methods

### `M_AddBOOL`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `bValue` | `BOOL` | Boolean input value |

**Implementation:**
```iec
sValue:= CONCAT(sValue, BOOL_TO_STRING(bValue));			// convert
sValue:= CONCAT(sValue, '$R');								// add separator
M_AddBOOL:= THIS^;
```
### `M_AddINT`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `nValue` | `LINT` | Integer input value |

**Implementation:**
```iec
sValue:= CONCAT(sValue, CONCAT(LINT_TO_STRING(nValue), '$R'));	// add new arg
M_AddINT:= THIS^;
```
### `M_AddREAL`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `fValue` | `LREAL` | Real input value |
| `nDecimals` | `USINT` | Decimals afer . |

**Implementation:**
```iec
sValue:= CONCAT(sValue, CONCAT(LREAL_TO_FMTSTR(fValue, nDecimals, TRUE), '$R'));				// add new arg
M_AddREAL:= THIS^;
```
### `M_AddSTRING`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `sValue` | `STRING` |  |

**Implementation:**
```iec
THIS^.sValue:= CONCAT(THIS^.sValue, CONCAT(sValue, '$R'));				// add separator 
M_AddSTRING:= THIS^;
```
### `M_AddTIME`
*No documentation found.*
**Inputs:**
| Name | Type | Description |
| --- | --- | --- |
| `tValue` | `TIME` | Time input value |

**Implementation:**
```iec
sValue:= CONCAT(sValue, CONCAT(TIME_TO_STRING(tValue), '$R'));				// add separator
M_AddTIME:= THIS^;
```
### `M_Clear`
*No documentation found.*

**Implementation:**
```iec
sValue:= '';
M_Clear:= THIS^;
```

## Properties

### `P_Value`
*No documentation found.*

