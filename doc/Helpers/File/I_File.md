# I_File

**Type:** INTERFACE

**Source File:** `Helpers/File/I_File.TcIO`

## Declaration

```iecst
INTERFACE I_File
```

## Methods

### M_Close
```iecst
// close file
METHOD PUBLIC M_Close : BOOL
VAR_INPUT
END_VAR
```

### M_Delete
```iecst
// Delete file
METHOD PUBLIC M_Delete : BOOL
VAR_INPUT
    sFileName : STRING(255);
END_VAR
```

### M_GetSize
```iecst
// get file size
METHOD PUBLIC M_GetSize : UDINT
VAR_INPUT
END_VAR
```

### M_Open
```iecst
// Open file
METHOD PUBLIC M_Open : BOOL
VAR_INPUT
    sFileName:				STRING(255);
	eMode: 					SysFile.ACCESS_MODE := SysFile.AM_APPEND_PLUS;
END_VAR
```

### M_Read
```iecst
// Read file
METHOD PUBLIC M_Read : BOOL
VAR_INPUT
END_VAR
```

### M_Status
```iecst
// state of file
METHOD PUBLIC M_Status : E_FileState
VAR_INPUT
END_VAR
```

### M_Write
```iecst
// Write file
METHOD PUBLIC M_Write : BOOL
VAR_INPUT
	pBuffer:	POINTER TO BYTE;
    nSize:     	UDINT;
END_VAR
```

