# Tc3_Event

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
	fbLogger:			FB_Logger;
END_VAR

fbLogger();

// send a simple message
IF bVerbose THEN
	fbEvent.M_Verbose('message');
END_IF

```

## Advanced Usage

```iecst

// Different log levels
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
## JSON Export script

Messages for the HMI can be quickly and easily exported during “Activate Configuration” using a simple PowerShell script

```json
[
    {
        "id": 292272521,
        "messages": {
            "de": "",
            "en": "message"
        }
    },
    {
        "id": 2626343866,
        "messages": {
            "de": "",
            "en": "Critical message"
        }
    },
    {
        "id": 2276475569,
        "messages": {
            "de": "",
            "en": "Info message"
        }
    },
    {
        "id": 2263151477,
        "messages": {
            "de": "",
            "en": "message %s %s"
        }
    },
    {
        "id": 1791326186,
        "messages": {
            "de": "",
            "en": "Warning message"
        }
    },
    {
        "id": 2621541999,
        "messages": {
            "de": "",
            "en": "Error message"
        }
    }
]
```
<img width="1012" height="323" alt="image" src="https://github.com/user-attachments/assets/6491c5bd-8974-447c-8958-210d7c7f3671" />


## Results

<img width="303" height="212" alt="image" src="https://github.com/user-attachments/assets/76e4d475-e2f1-42ff-9ccd-e3bdb786d7bc" />
<img width="768" height="315" alt="image" src="https://github.com/user-attachments/assets/b2c84339-6437-416f-bf1d-d2c682075724" />
<img width="1271" height="195" alt="image" src="https://github.com/user-attachments/assets/dbc4e062-77dd-4cb7-ab16-48f9eb94d3ca" />





