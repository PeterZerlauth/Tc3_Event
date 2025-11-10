# F_Hash

**Type:** `FUNCTION`
**Source File:** `Helpers/F_Hash.TcPOU`

*No documentation found.*

## Inputs
| Name | Type | Description |
| --- | --- | --- |
| `sInput` | `STRING` |  |

## Local Variables
| Name | Type | Description |
| --- | --- | --- |
| `sInput` | `STRING` |  |

## Implementation
```iec
// calculate a hash
nLength := LEN(sInput);
FOR nIndex := 1 TO nLength DO
    nChar := BYTE_TO_UDINT(sInput[nIndex]) - 98;
    F_Hash := (F_Hash + (nChar * nPowerOfBase) MOD nModulus) MOD nModulus;
    nPowerOfBase := (nPowerOfBase * nPrime) MOD nModulus;
END_FOR
```
