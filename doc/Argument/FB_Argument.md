[[ _TOC_ ]]

## FB_Argument

**Type:** FUNCTION BLOCK

#### Description  
- 

#### Inputs  
-

#### Outputs  
-

#### Locals  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sValue | `STRING(255)` |  | storage for arguments |

### Methods

#### M_AddBOOL

returns : `-`  

**Description**  
add boolean value to arguments

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| bValue | `BOOL` |  | Boolean input value |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
sValue:= CONCAT(sValue, BOOL_TO_STRING(bValue));			// convert
sValue:= CONCAT(sValue, '$R');								// add separator
M_AddBOOL:= THIS^;
```

</details>

#### M_AddINT

returns : `-`  

**Description**  
add int value to arguments

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| nValue | `LINT` |  | Integer input value |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
sValue:= CONCAT(sValue, CONCAT(LINT_TO_STRING(nValue), '$R'));	// add new arg
M_AddINT:= THIS^;
```

</details>

#### M_AddREAL

returns : `-`  

**Description**  
add real value to arguments

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| fValue | `LREAL` |  | Real input value |
| nDecimals | `USINT` |  | Decimals afer . |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
sValue:= CONCAT(sValue, CONCAT(LREAL_TO_FMTSTR(fValue, nDecimals, TRUE), '$R'));				// add new arg
M_AddREAL:= THIS^;
```

</details>

#### M_AddSTRING

returns : `-`  

**Description**  
add string value to arguments

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sValue | `STRING(255)` |  | String input value |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
THIS^.sValue:= CONCAT(THIS^.sValue, CONCAT(sValue, '$R'));				// add separator 
M_AddSTRING:= THIS^;
```

</details>

#### M_AddTIME

returns : `-`  

**Description**  
add time value to arguments

**Input**  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| tValue | `TIME` |  | Time input value |

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
sValue:= CONCAT(sValue, CONCAT(TIME_TO_STRING(tValue), '$R'));				// add separator
M_AddTIME:= THIS^;
```

</details>

#### M_Clear

returns : `-`  

**Description**  
Clear arguments

**Input**  
-

**Implementation**

<details>
<summary>Raw IEC/ST</summary>

```iec
sValue:= '';
M_Clear:= THIS^;
```

</details>

### Properties

#### P_Value

```iec
// Returns the list with arguments
PROPERTY PUBLIC P_Value : STRING(255)
```

<details>
<summary>Raw IEC/ST</summary>

```iec
{attribute 'no_explicit_call' := 'do not call this POU directly'}
// Store arguments in a single string seperated by $R
FUNCTION_BLOCK FB_Argument IMPLEMENTS I_Argument
VAR_INPUT
END_VAR
VAR_OUTPUT
END_VAR
VAR
	sValue:					STRING(255);		// storage for arguments
END_VAR
```

</details>

