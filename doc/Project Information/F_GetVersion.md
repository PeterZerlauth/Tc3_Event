# F_GetVersion

**Type:** FUNCTION

**Source File:** `Project Information/F_GetVersion.TcPOU`

<details>
<summary>Raw IEC/ST</summary>

```iec
// This function has been automatically generated from the project information.
{attribute 'signature_flag' := '1073741824'}
{attribute 'TcGenerated'}
{attribute 'no-analysis'}
FUNCTION [F_GetVersion](Project%20Information/F_GetVersion.md) : ST_LibVersion
VAR_INPUT
	
END_VAR

// --- Implementation code ---
[F_GetVersion](Project%20Information/F_GetVersion.md).iMajor := 0;
[F_GetVersion](Project%20Information/F_GetVersion.md).iMinor := 0;
[F_GetVersion](Project%20Information/F_GetVersion.md).iBuild := 0;
[F_GetVersion](Project%20Information/F_GetVersion.md).iRevision := 1;
[F_GetVersion](Project%20Information/F_GetVersion.md).sVersion := '0.0.0.1';
[F_GetVersion](Project%20Information/F_GetVersion.md).nFlags := 0;
```
</details>
