# I_File

**Type:** INTERFACE

**Source File:** `Helpers/File/I_File.TcIO`

```iec
INTERFACE I_File
```

## Methods

### M_Close
```iec
// close file
METHOD PUBLIC M_Close : BOOL
VAR_INPUT
END_VAR
```

### M_Delete
```iec
// Delete file
METHOD PUBLIC M_Delete : BOOL
VAR_INPUT
    sFileName : STRING(255);
END_VAR
```

### M_GetSize
```iec
// get file size
METHOD PUBLIC M_GetSize : UDINT
VAR_INPUT
END_VAR
```

### M_Open
```iec
// Open file
METHOD PUBLIC M_Open : BOOL
VAR_INPUT
    sFileName:				STRING(255);
	eMode: 					SysFile.ACCESS_MODE := SysFile.AM_APPEND_PLUS;
END_VAR
```

### M_Read
```iec
// Read file
METHOD PUBLIC M_Read : BOOL
VAR_INPUT
END_VAR
```

### M_Status
```iec
// state of file
METHOD PUBLIC M_Status : E_FileState
VAR_INPUT
END_VAR
```

### M_Write
```iec
// Write file
METHOD PUBLIC M_Write : BOOL
VAR_INPUT
	pBuffer:	POINTER TO BYTE;
    nSize:     	UDINT;
END_VAR
```

