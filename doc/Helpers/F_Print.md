# F_Print

**Type:** FUNCTION

**Source File:** `Helpers/F_Print.TcPOU`

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
```

