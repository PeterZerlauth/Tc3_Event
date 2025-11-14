# F_Filter

**Type:** `FUNCTION`
**Source File:** `Helpers/F_Filter.TcPOU`

Filter messages, if already existing

**Returns:** `BOOL`

## Inputs
| Name | Type | Description |
| --- | --- | --- |
| `fbMessage` | `FB_Message` | Input message |

## Local Variables
| Name | Type | Description |
| --- | --- | --- |
| `fbMessage` | `FB_Message` | Input message |

## Implementation
```iec
nIndex := 0;
WHILE nIndex < GVL.nBuffer DO
    IF GVL.aBuffer[nIndex].sDefault = fbMessage.sDefault THEN
        GVL.aBuffer[nIndex].bActive := TRUE;
        F_Filter := TRUE;
        RETURN;  // Message found
    END_IF
    nIndex := nIndex + 1;
END_WHILE
```
