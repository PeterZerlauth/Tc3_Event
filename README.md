# Tc3_Event

**Tc3_Event** is a lightweight and efficient event logging framework for **TwinCAT 3** automation projects.
It provides structured logging capabilities with reusable Function Blocks, enabling clear visibility of system events, HMI display integration, and File logging.

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
- **TwinCAT 3 Eventlogger (Experimental)** (currently under development). 
---

## 🚀 Getting Started

### Setup Loggers
```iecst
PROGRAM MAIN
VAR
	fbLogger:			Tc3_Event.FB_LoggerManager;
	fbHmiLogger:		Tc3_Event.FB_HmiLogger;
	fbFileLogger:		Tc3_Event.FB_FileLogger;
	fbTcLogger:			Tc3_Event.FB_TcLogger;
END_VAR

// Initialise loggers
fbLogger.M_Add(fbHmiLogger);
fbLogger.M_Add(fbFileLogger);
fbLogger.M_Add(fbTcLogger);

```

### Setup Event
```iecst
PROGRAM MAIN
VAR
	fbEvent:			FB_Event;
END_VAR

fbEvent();

// set event target
fbEvent.P_Logger:= fbLogger;

// send a simple test message
IF bVerbose THEN
	fbEvent.M_Verbose('Verbose');
END_IF
```

## Advanced Usage

```iecst
PROGRAM MAIN
VAR
	fbEvent:			FB_Event;
END_VAR

fbEvent();

// Different log levels
fbEvent.M_AddINT(1);
fbEvent.M_AddSTRING('cycles');
fbEvent.M_Verbose('Process completed: %s %s');

// Simple info message
fbEvent.M_Info(2276475569, 'System initialized');

// Warning with context
fbEvent.M_AddREAL(33.1345321, 3);
fbEvent.M_Warning(1791326186, 'High temperature detected < %s °C');

// Error reporting
fbEvent.M_Error(2621541999, 'Motor communication failed');

// Critical error
fbEvent.M_Critical(2626343866, 'Emergency stop activated');

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
```xml
<EventClass>
  <EventId>
    <Name Id="475719253">Tc3_Event_475719253</Name>
    <DisplayName TxtId=""><![CDATA[W message]]></DisplayName>
    <Severity>Warning</Severity>
  </EventId>
  <EventId>
    <Name Id="828536003">Tc3_Event_828536003</Name>
    <DisplayName TxtId=""><![CDATA[I message %s %s]]></DisplayName>
    <Severity>Verbose</Severity>
  </EventId>
  <EventId>
    <Name Id="475719235">Tc3_Event_475719235</Name>
    <DisplayName TxtId=""><![CDATA[E message]]></DisplayName>
    <Severity>Error</Severity>
  </EventId>
  <EventId>
    <Name Id="475719233">Tc3_Event_475719233</Name>
    <DisplayName TxtId=""><![CDATA[C message]]></DisplayName>
    <Severity>Critical</Severity>
  </EventId>
</EventClass>
```

<img width="1012" height="323" alt="image" src="https://github.com/user-attachments/assets/6491c5bd-8974-447c-8958-210d7c7f3671" />


## Results

<img width="303" height="212" alt="image" src="https://github.com/user-attachments/assets/76e4d475-e2f1-42ff-9ccd-e3bdb786d7bc" />
<img width="768" height="315" alt="image" src="https://github.com/user-attachments/assets/b2c84339-6437-416f-bf1d-d2c682075724" />
<img width="1271" height="195" alt="image" src="https://github.com/user-attachments/assets/dbc4e062-77dd-4cb7-ab16-48f9eb94d3ca" />
