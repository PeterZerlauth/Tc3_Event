# F_Hash

**Type:** FUNCTION

**Source File:** `Helpers/F_Hash.TcPOU`

## Declaration

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

