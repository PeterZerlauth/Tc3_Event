# Tc3_Logging

> A simple and efficient logging framework for TwinCAT 3 automation projects,
> providing structured logging capabilities with reusable Function Blocks.
> This logger helps you debug issues, trace events, and monitor system behavior efficiently in industrial automation environments

## ✨ Features

- **Simple Implementation**: Easy-to-use Function Block for structured text
- **Structured Logging**: Organized log messages with consistent formatting
- **Reusable Components**: Modular design for integration across projects
- **PowerShell Automation**: Includes a script to generate IDs for messages
- **Event Tracing**: Efficient debugging and issue identification
- **Parameter Support**: Support for adding integers,floats and strings to log messages
- **Multiple Log Levels**: Verbose, Info, Warning, Error, and Critical levels

## 🚀 Getting Started

```iecst
PROGRAM MAIN
VAR
    fbLogging        : FB_Logging;
    fbTcLogging      : FB_TcLogging;
    fbLogger         : FB_Logger;
    
    bInfo            : BOOL := TRUE;
END_VAR

// Initialize logging components
fbLogging();
fbLogging.M_Attach(fbTcLogging);
fbTcLogging();

// Set up logger
fbLogger.iLogging := fbLogging;
fbLogger();

IF bInfo THEN
    fbLogger.M_Info(2276475569, 'Info message');
END_IF
```

## Advanced Usage

```iecst
// Verbose logging with parameters
fbLogger.M_AddINT(counter);
fbLogger.M_AddSTRING('cycles');
fbLogger.M_Verbose('Process completed: %s %s');

// Simple info message
fbLogger.M_Info(2276475569, 'System initialized');

// Warning with context
fbLogger.M_AddREAL(33.1345321, 3);
fbLogger.M_Warning(1791326186, 'High temperature detected < %s °C');

// Error reporting
fbLogger.M_Error(2621541999, 'Motor communication failed');

// Critical error
fbLogger.M_Critical(2626343866, 'Emergency stop activated');
```


