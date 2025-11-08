[[_TOC_]]

## FB_File

returns : -   
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|eMode |SysFile.ACCESS_MODE || 

#### Output  
|Name |Type |Comment| 
|---- |---- |----   | 
|pBuffer |POINTER || 
|nBuffer |UDINT || 
|bOpen |BOOL || 
|bError |BOOL || 

### Method M_Close  
returns : BOOL  
  
#### Description  
Closes the currently opened file.  
 
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
|sFileName |STRING || 

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
### Method M_Status  
returns : BOOL  
  
#### Description  
Closes the currently opened file.  
 
#### Input  
- 
#### Output  
- 
### Method M_Write  
returns : BOOL  
  
#### Description  
Writes the contents of the buffer into a file.  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|pWriteBuffer |POINTER || 
|nWriteSize |UDINT || 

#### Output  
- 

