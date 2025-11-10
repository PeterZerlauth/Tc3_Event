# FB_ListLogger

**Type:** FUNCTION BLOCK

**Source File:** `Logger/List/FB_ListLogger.TcPOU`

## Declaration

```iecst
// Provide logging 
FUNCTION_BLOCK FB_ListLogger IMPLEMENTS I_Logger, I_LogLevel
VAR_INPUT
	eLogLevel:				E_LogLevel:= E_LogLevel.Verbose;
END_VAR
VAR
	{attribute 'OPC.UA.DA.Property' := '1'}
	aMessages:				ARRAY[0..99] OF FB_Message; 	// Message store
	{attribute 'OPC.UA.DA.Property' := '1'}
    nMessages:				UINT := 0;                     // Message count
	{attribute 'hide'} 
	nIndex: 				UINT;
	{attribute 'hide'} 
	nTimestamp:				LINT;
END_VAR
```

