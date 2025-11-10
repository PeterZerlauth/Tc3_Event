# E_FileState

**Type:** Data Unit Types (TcDUT)
**Source File:** `Helpers/File/E_FileState.TcDUT`

## Details
**Declaration**
```st
{attribute 'qualified_only'}
{attribute 'strict'}
{attribute 'to_string'}
TYPE E_FileState :
(
    OK := 0,             // File could be opened
    NO_FILE := 1,        // No file available
    ILLEGAL_POS := 2,    // Illegal position in the file
    FULL := 3,           // No more space on the filesystem
    EOF := 4             // End of file reached
) UDINT;
END_TYPE
```

