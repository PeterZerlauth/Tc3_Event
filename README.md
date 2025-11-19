# Tc3_Event: Event Logging Framework for TwinCAT 3  
[![License](https://img.shields.io/github/license/PeterZerlauth/Tc3_Event)](LICENSE)
![TwinCAT](https://img.shields.io/badge/TwinCAT-3-blue)
![Platform](https://img.shields.io/badge/Platform-PLC%20Automation-green)

**Tc3_Event** is a **lightweight, high-performance event logging framework** designed for **TwinCAT 3 automation projects**.  
It provides structured, standardized logging for diagnostics, simplifies development, and integrates seamlessly with HMIs and SCADA systems.

---

## 📚 Table of Contents
- [Overview](#overview)
- [Key Features](#key-features--developer-benefits)
- [Getting Started](#getting-started)
- [Advanced Usage](#advanced-usage)
- [Exports](#json-export--xml-export)
- [Screenshots](#screenshots)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## 🔍 Overview
Tc3_Event accelerates your development cycle by **30–50%** by eliminating manual steps and implementing **standardized, traceable logging** from day one.  
Built with **Structured Text (ST)** and reusable **Function Blocks**, it ensures clarity, consistency, and operational transparency.

---

## 🛠️ Key Features & Developer Benefits
| Feature | Description | Benefit |
| :--- | :--- | :--- |
| ✅ **Structured Logging** | Reusable Function Blocks in ST | Easy adoption & maintainability |
| 🔢 **Automated ID Generation** | PowerShell script for unique IDs | Faster development, fewer errors |
| 📊 **Dynamic Parameters** | Embed variables in logs | Context-rich diagnostics |
| 🖥️ **HMI Ready** | Real-time display on HMIs | Operational clarity |
| 🔍 **Multi-Level Traceability** | Log levels: `Verbose`, `Info`, `Warning`, `Error`, `Critical` | Efficient debugging |
| 🧪 **Functional Logger** | Dedicated component for testing | Rapid commissioning |

---

## ⚡ Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/PeterZerlauth/Tc3_Event.git
```

### 2. Import into TwinCAT 3
Add the library to your TwinCAT 3 project.

### 3. Initialize Loggers
```pascal
PROGRAM MAIN
VAR
    fbLogger:       Tc3_Event.FB_LoggerManager;
    fbHmiLogger:    Tc3_Event.FB_HmiLogger;
    fbFileLogger:   Tc3_Event.FB_FileLogger;
    fbTcLogger:     Tc3_Event.FB_TcLogger;
END_VAR

// Initialise loggers
fbLogger.M_Add(fbHmiLogger);
fbLogger.M_Add(fbFileLogger);
fbLogger.M_Add(fbTcLogger);
```

---

## 🔍 Advanced Usage
```pascal
PROGRAM MAIN
VAR
    fbEvent: FB_Event;
END_VAR

fbEvent();
fbEvent.P_Logger := fbLogger;

// Verbose message
fbEvent.M_Verbose('Verbose');

// Info message with ID
fbEvent.M_Info(2276475569, 'System initialized');

// Warning with context
fbEvent.M_AddREAL(33.1345321, 3);
fbEvent.M_Warning(1791326186, 'High temperature detected < %s °C');

// Error reporting
fbEvent.M_Error(2621541999, 'Motor communication failed');

// Critical error
fbEvent.M_Critical(2626343866, 'Emergency stop activated');
```

---

## 📤 JSON Export
Export messages for HMI during **Activate Configuration** using PowerShell:

```json
[
    {
        "id": 828536003,
        "key": "I message %s %s",
        "locale": {
            "de": "",
            "en": "I message %s %s"
        }
    },
    {
        "id": 662973879,
        "key": "Critical message",
        "locale": {
            "de": "",
            "en": "Critical message"
        }
    }
]
```

---

## 📤 XML Export
Export messages for TwinCAT Eventlogger:

```xml
<EventClass>
  <EventId>
    <Name Id="828536003">Tc3_Event_828536003</Name>
    <DisplayName TxtId=""><![CDATA[I message {0} {1}]]></DisplayName>
  </EventId>
</EventClass>
```

---

## 📸 Screenshots
| HMI Integration | Logger Manager | Event Trace |
| :---: | :---: | :---: |
| ![HMI](https://github.com/user-attachments/assets/76e4d475-e2f1-42ff-9ccd-e3bdb786d7bc) | ![Logger](https://github.com/user-attachments/assets/b2c84339-6437-416f-bf1d-d2c682075724) | ![Trace](https://github.com/user-attachments/assets/dbc4e062-77dd-4cb7-ab16-48f9eb94d3ca) |

---

## 🚀 Roadmap
- [x] Structured Logging
- [x] HMI Integration
- [x] File Logging
- [ ] TwinCAT Eventlogger Integration (in development)

---

## 🤝 Contributing
Pull requests are welcome! For major changes, please open an issue first.

---

## 📜 License
This project is licensed under the MIT License.
