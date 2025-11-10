# F_Hash

```iecst
// Calculate hash value 
FUNCTION F_Hash : UDINT
VAR_INPUT
    sInput:					STRING(255);   				// input string to hash
END_VAR
VAR
    nLength:				INT := 0;    				// length of the input string
    nPrime:					UDINT := 37; 				// base for polynomial rolling hash
    nModulus:				UDINT := 1000000009; 		// large prime modulus
    nHashValue:				UDINT := 0;  				// resulting hash
    nPowerOfBase:			UDINT := 1;  				// p^i mod m
    nIndex:					INT;         				// loop counter
    nChar:					UDINT;       				// numeric value of character
END_VAR
```

### VAR_INPUT

| Name | Type | Description |
| :--- | :--- | :--- |
| `sInput` | `STRING(255)` | input string to hash |

### VAR

| Name | Type | Description |
| :--- | :--- | :--- |
| `nLength` | `INT` | length of the input string |
| `nPrime` | `UDINT` | base for polynomial rolling hash |
| `nModulus` | `UDINT` | large prime modulus |
| `nHashValue` | `UDINT` | resulting hash |
| `nPowerOfBase` | `UDINT` | p^i mod m |
| `nIndex` | `INT` | loop counter |
| `nChar` | `UDINT` | numeric value of character |

