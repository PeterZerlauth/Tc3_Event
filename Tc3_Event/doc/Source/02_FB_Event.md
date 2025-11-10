[[_TOC_]]

## FB_Event

returns : -   
#### Description  
Providing the event logger  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|iLogger |I_Logger |Interface has to be attached to a Valid target| 

#### Output  
- 
### Method FB_Init  
returns : BOOL  
  
#### Description  
FB_Init is always available implicitly and it is used primarily for initialization.  
The return value is not evaluated. For a specific influence, you can also declare the  
methods explicitly and provide additional code there with the standard initialization  
code. You can evaluate the return value.  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|bInitRetains |BOOL |TRUE: the retain variables are initialized (reset warm / reset cold)| 
|bInCopyCode |BOOL |TRUE: the instance will be copied to the copy code afterward (online change)   | 

#### Output  
- 
### Method M_Critical  
returns : BOOL  
  
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|nID |UDINT |Id of the error message| 
|sMessage |STRING |content of the error message, placeholder %s| 

#### Output  
- 
### Method M_Error  
returns : BOOL  
  
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|nID |UDINT |Id of the error message| 
|sMessage |STRING |content of the error message, placeholder %s| 

#### Output  
- 
### Method M_Info  
returns : BOOL  
  
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|nID |UDINT |Id of the error message| 
|sMessage |STRING |content of the error message, placeholder %s| 

#### Output  
- 
### Method M_Reset  
returns : BOOL  
  
#### Description  
 
#### Input  
- 
#### Output  
- 
### Method M_Verbose  
returns : BOOL  
  
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|sMessage |STRING |content of the error message, placeholder %s| 

#### Output  
- 
### Method M_Warning  
returns : BOOL  
  
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|nID |UDINT || 
|sMessage |STRING |content of the error message, placeholder %s| 

#### Output  
- 
### Method P_Argument  
returns : BOOL  
  
#### Description  
 
#### Input  
- 
#### Output  
- 
### Method Get  
returns : I_Argument]]></Declaration>  
  
#### Description  
 
#### Input  
- 
#### Output  
- 
### Method P_Logger  
returns : I_Argument]]></Declaration>  
  
#### Description  
 
#### Input  
- 
#### Output  
- 
### Method Get  
returns : I_Logger]]></Declaration>  
  
#### Description  
 
#### Input  
- 
#### Output  
- 
returns : I_Logger]]></Declaration>  
  
#### Description  
 
#### Input  
- 
#### Output  
- 

