# Tc3_Logging

> A simple and efficient logging framework for TwinCAT 3 automation projects,
> providing structured logging capabilities with reusable Function Blocks.
> This logger helps you debug issues, trace events, and monitor system behavior efficiently in industrial automation environments

## ✨ Features

- 🚀 **Simple Implementation**: Easy-to-use Function Block for structured text
- 📊 **Structured Logging**: Organized log messages with consistent formatting
- 🔧 **Reusable Components**: Modular design for integration across projects
- 📝 **PowerShell Automation**: Includes a script to generate IDs for messages
- 📈 **Event Tracing**: Efficient debugging and issue identification
- 🔢 **Parameter Support**: Support for adding integers,floats and strings to log messages
- 📊 **Multiple Log Levels**: Verbose, Info, Warning, Error, and Critical levels

## 🚀 Getting Started

### Prerequisites
- TwinCAT 3 environment
- Basic knowledge of Structured Text (ST) programming
- PowerShell for script execution


## Basic Usage

```iecst
PROGRAM MAIN
VAR
    fbLogging        : FB_Logging;
    fbTcLogging      : FB_TcLogging;
    fbLogger         : FB_Logger;
    
    bVerbose         : BOOL := TRUE;
    bInfo            : BOOL := TRUE;
    bWarning         : BOOL := TRUE;
    bError           : BOOL := FALSE;
    bCritical        : BOOL := FALSE;
END_VAR

// Initialize logging components
fbLogging();
fbLogging.M_Attach(fbTcLogging);
fbTcLogging();

// Set up logger
fbLogger.iLogging := fbLogging;
fbLogger();

// Example logging at different levels
IF bVerbose THEN
    fbLogger.M_AddINT(134052566194980000);
    fbLogger.M_AddSTRING('mm');
    fbLogger.M_Verbose('Verbose message %s %s');
END_IF

IF bInfo THEN
    fbLogger.M_Info(2276475569, 'Info message');
END_IF

IF bWarning THEN
    fbLogger.M_Warning(1791326186, 'Warning message');
END_IF

IF bError THEN
    fbLogger.M_Error(2621541999, 'Error message');
END_IF

IF bCritical THEN
    fbLogger.M_Critical(2626343866, 'Critical message');
END_IF
```
