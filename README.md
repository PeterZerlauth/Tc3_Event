# Tc3_Event

**Tc3_Event** is a lightweight and efficient event logging framework for TwinCAT 3 automation projects.  
It provides structured logging capabilities through reusable Function Blocks, enabling clear visibility of system events, seamless HMI display integration, and reliable file logging.  
Built for developer productivity and high performance, it helps you maintain clarity and control in complex automation applications.  
With automated ID generation, parameterized messages, and consistent formatting, Tc3_Event removes error-prone manual steps and accelerates development cycles by **30–50%**.


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
- **Functional Logger**  is included to help developers test and debug their TwinCAT projects.
---

## Getting Started

### Setup Loggers
```pascal
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
```pascal
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

```pascal
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
## JSON Export

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
		"..."
    },
]
```
## XML Export

Messages for the Twincat 3 Eventlogger can be quickly and easily exported during “Activate Configuration” using a simple PowerShell script

```xml
<EventClass>
  <EventId>
    <Name Id="828536003">Tc3_Event_828536003</Name>
    <DisplayName TxtId=""><![CDATA[I message {0} {1}]]></DisplayName>
  </EventId>
	...
</EventClass>
```

## Screenshots

<img width="303" height="212" alt="image" src="https://github.com/user-attachments/assets/76e4d475-e2f1-42ff-9ccd-e3bdb786d7bc" />
<img width="768" height="315" alt="image" src="https://github.com/user-attachments/assets/b2c84339-6437-416f-bf1d-d2c682075724" />
<img width="1271" height="195" alt="image" src="https://github.com/user-attachments/assets/dbc4e062-77dd-4cb7-ab16-48f9eb94d3ca" />
