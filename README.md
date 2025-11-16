<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./logoDark.svg">
  <source media="(prefers-color-scheme: light)" srcset="./logo.svg">
  <img src="./logo.svg" width="420" alt="Tc3_Event Logo">
</picture>

# Tc3_Event: The Essential Event Logging Framework for TwinCAT 3

**Tc3_Event** is a **lightweight, high-performance event logging framework** engineered specifically for **TwinCAT 3 automation projects**. 
It provides a robust, structured approach to system diagnostics that dramatically simplifies development and improves operational clarity.

By using reusable **Function Blocks** in Structured Text (ST), Tc3_Event provides clear visibility into system events, ensures **seamless HMI display integration**, 
and lays the foundation for reliable file logging.
**Accelerate your development cycle by 30–50%** by eliminating error-prone manual steps and implementing standardized, traceable logging from day one.

---

## 🛠️ Key Features & Developer Benefits

| Feature | Description | Developer Benefit |
| :--- | :--- | :--- |
| **Structured Logging** | Utilizes simple, reusable Function Blocks (FBs) in Structured Text (ST). | **Easy Adoption:** Standardized, clear logging that's easy to implement and maintain across projects. |
| **Automated ID Generation** | Includes a **PowerShell script** to automatically generate unique, sequential message IDs. | **Reduced Errors & Speed:** Removes manual ID tracking, ensuring consistency and accelerating development. |
| **Dynamic Parameter Support** | Easily embed variables (**integers, floats, strings**) directly into your log messages. | **Context-Rich Diagnostics:** Capture critical runtime data, making debugging significantly faster and more precise. |
| **HMI/SCADA Ready** | Built-in functionality for real-time display of structured logs on **Human-Machine Interfaces (HMIs)**. | **Operational Clarity:** Provides operators with immediate, actionable visibility into system status and faults. |
| **Multi-Level Traceability** | Supports standard log levels: `Verbose`, `Info`, `Warning`, `Error`, and `Critical`. | **Efficient Debugging:** Filter and prioritize logs quickly for efficient event tracing and issue identification. |
| **Integrated Functional Logger** | A dedicated component for testing and debugging your PLC code. | **Rapid Testing:** Helps developers validate logic flow and component behavior during commissioning. |

---

## 🚀 Future Roadmap (In Development)

* **Reliable File Logging:** Capturing system events to persistent log files for long-term analysis.
* **TwinCAT 3 Eventlogger Integration:** Native support for the standard TwinCAT 3 Eventlogger system.
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
