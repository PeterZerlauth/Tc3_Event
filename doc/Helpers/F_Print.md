[[ _TOC_ ]]

## F_Print

**Type:** FUNCTION

#### Description  
Helper to generate a message with replaced arguments

#### Inputs  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sMessage | `STRING(255)` |  |  |
| sArguments | `STRING(255)` |  | Arguments are separated by $R |

#### Outputs  
-

#### Locals  
| Name | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| sArg | `STRING` |  | single argument |
| nPosition | `INT` |  | Position of the $R delimiter |
| nPlaceholder | `INT` |  | Position of the %s placeholder |

<details>
<summary>Raw IEC/ST</summary>

```iec
// Helper to generate a message with replaced arguments
FUNCTION F_Print : STRING(255)
VAR_INPUT
    sMessage:				STRING(255);
    sArguments:				STRING(255);	// Arguments are separated by $R 
END_VAR
VAR
    sArg:					STRING; 		// single argument
    nPosition:				INT;         	// Position of the $R delimiter
    nPlaceholder:			INT;         	// Position of the %s placeholder
END_VAR

// --- Implementation ---

// replace placeholders with arguments
F_Print := sMessage;

IF sArguments = '' THEN
    RETURN;
END_IF

nPosition := FIND(sArguments, '$R');
WHILE nPosition > 0 DO
    
    sArg := LEFT(sArguments, nPosition - 1);
    
    nPlaceholder := FIND(F_Print, '%s');
    IF nPlaceholder > 0 THEN
        F_Print := REPLACE(F_Print, sArg, 2, nPlaceholder);
    ELSE
        RETURN;
    END_IF
	
    sArguments := DELETE(sArguments, nPosition, 1);
    nPosition := FIND(sArguments, '$R');
    
END_WHILE
```

</details>

