[[_TOC_]]

## FB_File

returns : -   
#### Description  
SysFile from codesys  
 
#### Input  
- 
#### Output  
|Name |Type |Comment| 
|---- |---- |----   | 
|pBuffer |POINTER || 
|nBuffer |UDINT || 
|bError |BOOL || 

### Method FB_Exit  
returns : BOOL  
  
#### Description  
FB_Exit must be implemented explicitly. If there is an implementation, then the  
method is called before the controller removes the code of the function block instance  
(implicit call). The return value is not evaluated.  
Try to close and reset on exit  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|bInCopyCode |BOOL |TRUE: the exit method is called in order to leave the instance which will be copied afterwards (online change).  | 

#### Output  
- 
### Method M_Close  
returns : BOOL  
  
#### Description  
Closes the file if opened  
 
#### Input  
- 
#### Output  
- 
### Method M_Delete  
returns : BOOL  
  
#### Description  
Delete file  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|sFileName |STRING || 

#### Output  
- 
### Method M_GetSize  
returns : UDINT  
  
#### Description  
Get file size  
 
#### Input  
- 
#### Output  
- 
### Method M_Open  
returns : BOOL  
  
#### Description  
Open file  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|sFileName |STRING |file path| 
|eMode |SysFile.ACCESS_MODE |file mode| 

#### Output  
- 
### Method M_Read  
returns : BOOL  
  
#### Description  
Read file  
 
#### Input  
- 
#### Output  
- 
### Method M_Reset  
returns : BOOL  
  
#### Description  
Reset all   
 
#### Input  
- 
#### Output  
- 
### Method M_Status  
returns : E_FileState  
  
#### Description  
File status  
 
#### Input  
- 
#### Output  
- 
### Method M_Write  
returns : BOOL  
  
#### Description  
Writes content to a file  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|pBuffer |POINTER || 
|nSize |UDINT || 

#### Output  
- 

