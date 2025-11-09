# Tc3_Event

**Tc3_Event** is a lightweight and efficient event logging framework for **TwinCAT 3** automation projects.  
It provides structured logging capabilities with reusable Function Blocks, enabling clear visibility of system events, HMI display integration, and file logging.

---

## Features

- **Simple Implementation** – Easy-to-use Function Blocks for Structured Text (ST).  
- **Reusable Components** – Modular design for integration across multiple PLC projects.  
- **PowerShell Automation** – Script included to generate unique IDs for log messages.  
- **Event Tracing** – Efficient debugging and issue identification.  
- **Parameter Support** – Add integers, floats, and strings to log messages dynamically.  
- **Multiple Log Levels** – Supports: `Verbose`, `Info`, `Warning`, `Error`, and `Critical`.  
- **HMI Integration** – Display structured logs on HMIs in real-time.  
- **File Logging (Experimental)** – Capture logs to file (currently under development).  

## Documentation
https://github.com/PeterZerlauth/Tc3_Event/blob/master/doc/00_Overview.md


---

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
PROGRAM MAIN
VAR
	fbLogger:			FB_Logger;
END_VAR

fbLogger();

// Different log levels
// Verbose logging with parameters

fbLogger.M_AddINT(1);
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
        "id":  828536003,
        "key":  "I message %s %s",
        "locale":  {
                       "de":  "",
                       "en":  "I message %s %s"
                   }
    },
    {
        "id":  662973879,
        "key":  "Critical message",
        "locale":  {
                       "de":  "",
                       "en":  "Critical message"
                   }
    },
    {
        "id":  475719235,
        "key":  "E message",
        "locale":  {
                       "de":  "",
                       "en":  "E message"
                   }
    },
    {
        "id":  608464798,
        "key":  "Info message",
        "locale":  {
                       "de":  "",
                       "en":  "Info message"
                   }
    },
    {
        "id":  475719233,
        "key":  "C message",
        "locale":  {
                       "de":  "",
                       "en":  "C message"
                   }
    },
    {
        "id":  475719253,
        "key":  "W message",
        "locale":  {
                       "de":  "",
                       "en":  "W message"
                   }
    },
    {
        "id":  588739376,
        "key":  "Warning message",
        "locale":  {
                       "de":  "",
                       "en":  "Warning message"
                   }
    }
]
```
<img width="1012" height="323" alt="image" src="https://github.com/user-attachments/assets/6491c5bd-8974-447c-8958-210d7c7f3671" />


## Results

<img width="303" height="212" alt="image" src="https://github.com/user-attachments/assets/76e4d475-e2f1-42ff-9ccd-e3bdb786d7bc" />
<img width="768" height="315" alt="image" src="https://github.com/user-attachments/assets/b2c84339-6437-416f-bf1d-d2c682075724" />
<img width="1271" height="195" alt="image" src="https://github.com/user-attachments/assets/dbc4e062-77dd-4cb7-ab16-48f9eb94d3ca" />





