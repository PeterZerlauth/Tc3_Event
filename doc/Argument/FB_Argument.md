# FB_Argument

**Type:** FUNCTION BLOCK

**Source File:** `Argument/FB_Argument.TcPOU`

### References

- [FB_Argument](./Argument/FB_Argument.md)
- [I_Argument](./Argument/I_Argument.md)

<details>
<summary>Raw IEC/ST</summary>

```iec
{attribute 'no_explicit_call' := 'do not call this POU directly'}
// Store arguments in a single string seperated by $R
FUNCTION_BLOCK FB_Argument IMPLEMENTS I_Argument
VAR_INPUT
END_VAR
VAR_OUTPUT
END_VAR
VAR
	sValue:					STRING(255);		// storage for arguments
END_VAR
```
</details>
