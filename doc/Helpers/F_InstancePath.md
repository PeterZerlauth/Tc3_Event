# F_InstancePath

**Type:** FUNCTION

**Source File:** `Helpers/F_InstancePath.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
// Filter instance path, to something useful
FUNCTION F_InstancePath : STRING(255)
VAR_INPUT
	sInstancePath:			STRING(255);
END_VAR
VAR
    nPosition     : INT;
END_VAR

// --- Implementation code ---
F_InstancePath:= RIGHT(sInstancePath, LEN(sInstancePath) - FIND(sInstancePath, '.'));
F_InstancePath:= RIGHT(F_InstancePath, LEN(F_InstancePath) - FIND(F_InstancePath, '.'));

FOR nPosition:= LEN(F_InstancePath) TO 1 BY -1 DO
    IF F_InstancePath[nPosition] = 46 THEN
		F_InstancePath := LEFT(F_InstancePath, nPosition);
		RETURN;
	END_IF
END_FOR
```
</details>
