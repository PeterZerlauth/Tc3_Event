# F_InstancePath

**Type:** FUNCTION

**Source File:** `Helpers/F_InstancePath.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
// Filter instance path, to something useful
FUNCTION [F_InstancePath](Helpers/F_InstancePath.md) : STRING(255)
VAR_INPUT
	sInstancePath:			STRING(255);
END_VAR
VAR
    nPosition     : INT;
END_VAR

// --- Implementation code ---
[F_InstancePath](Helpers/F_InstancePath.md):= RIGHT(sInstancePath, LEN(sInstancePath) - FIND(sInstancePath, '.'));
[F_InstancePath](Helpers/F_InstancePath.md):= RIGHT([F_InstancePath](Helpers/F_InstancePath.md), LEN([F_InstancePath](Helpers/F_InstancePath.md)) - FIND([F_InstancePath](Helpers/F_InstancePath.md), '.'));

FOR nPosition:= LEN([F_InstancePath](Helpers/F_InstancePath.md)) TO 1 BY -1 DO
    IF [F_InstancePath](Helpers/F_InstancePath.md)[nPosition] = 46 THEN
		[F_InstancePath](Helpers/F_InstancePath.md) := LEFT([F_InstancePath](Helpers/F_InstancePath.md), nPosition);
		RETURN;
	END_IF
END_FOR
```
</details>
