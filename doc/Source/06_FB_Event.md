[[_TOC_]]

## FB_Event

returns : -   
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|iLogger |I_Logger || 

#### Output  
|Name |Type |Comment| 
|---- |---- |----   | 
|fbArguments |FB_Argument || 

### Method FB_Init  
returns : BOOL  
  
#### Description  
FB_Init ist immer implizit verfügbar und wird primär für die Initialisierung verwendet.  
Der Rückgabewert wird nicht ausgewertet. Für gezielte Einflussnahme können Sie  
die Methoden explizit deklarieren und darin mit dem Standard-Initialisierungscode   
zusätzlichen Code bereitstellen. Sie können den Rückgabewert auswerten.  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|bInitRetains |BOOL |TRUE: Die Retain-Variablen werden initialisiert (Reset warm / Reset kalt)    | 
|bInCopyCode |BOOL |TRUE: Die Instanz wird danach in den Kopiercode kopiert (Online-Change)| 

#### Output  
- 
### Method M_Critical  
returns : BOOL  
  
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|nID |UDINT || 
|sMessage |STRING || 

#### Output  
- 
### Method M_Error  
returns : BOOL  
  
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|nID |UDINT || 
|sMessage |STRING || 

#### Output  
- 
### Method M_Info  
returns : BOOL  
  
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|nID |UDINT || 
|sMessage |STRING || 

#### Output  
- 
### Method M_Verbose  
returns : BOOL  
  
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|sMessage |STRING || 

#### Output  
- 
### Method M_Warning  
returns : BOOL  
  
#### Description  
 
#### Input  
|Name |Type |Comment| 
|---- |---- |----   | 
|nID |UDINT || 
|sMessage |STRING || 

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

