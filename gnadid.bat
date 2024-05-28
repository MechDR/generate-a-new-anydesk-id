@ECHO OFF

TITLE Generate A New AnyDesk ID



@ECHO Disabling the AnyDesk service...

SC.exe stop AnyDesk >NUL 2>&1
SC.exe failure AnyDesk reset= 86400 actions= // >NUL 2>&1
SC.exe failure AnyDesk reset= 86400 actions= //// >NUL 2>&1
SC.exe failure AnyDesk reset= 86400 actions= ////// >NUL 2>&1
SC.exe config AnyDesk start= disabled >NUL 2>&1



@ECHO Killing the AnyDesk process...

TASKKILL.exe /F /IM AnyDesk.exe /T >NUL 2>&1



@ECHO Deleting AnyDesk settings in ProgramData...

TAKEOWN.exe /F "%ProgramData%\AnyDesk" /A /R /D Y >NUL 2>&1
ICACLS.exe "%ProgramData%\AnyDesk" /T /C /Q /GRANT Administrators:F System:F Everyone:F >NUL 2>&1
RMDIR "%ProgramData%\AnyDesk" /S /Q >NUL 2>&1
RD "%ProgramData%\AnyDesk" /S /Q >NUL 2>&1



@ECHO Deleting AnyDesk settings in local user accounts...

DIR %SystemDrive%\Users /AD >> "%WinDir%\Temp\LocalUserAccountsUnfiltered.txt"
TYPE "%WinDir%\Temp\LocalUserAccountsUnfiltered.txt" | FINDSTR.exe /V /I "Volume Directory Public File(s) Dir(s)" | FINDSTR.exe /V /I /C:"All Users" | FINDSTR.exe /V /I /C:"Default User" | FINDSTR.exe /V /I /C:"<DIR>          .." | FINDSTR.exe /V /I /C:"<DIR>          ." | FINDSTR.exe /V /I "^$" >> "%WinDir%\Temp\LocalUserAccountsFiltered.txt"
DEL /F /Q "%WinDir%\Temp\LocalUserAccountsUnfiltered.txt" >NUL 2>&1
ERASE /F /Q "%WinDir%\Temp\LocalUserAccountsUnfiltered.txt" >NUL 2>&1
FOR /F "USEBACKQ TOKENS=5 DELIMS= " %%U IN ("%WinDir%\Temp\LocalUserAccountsFiltered.txt") DO (@ECHO %%U >> "%WinDir%\Temp\LocalUserAccountsFinal.txt")
DEL /F /Q "%WinDir%\Temp\LocalUserAccountsFiltered.txt" >NUL 2>&1
ERASE /F /Q "%WinDir%\Temp\LocalUserAccountsFiltered.txt" >NUL 2>&1
FOR /F "USEBACKQ TOKENS=1 DELIMS= " %%K IN ("%WinDir%\Temp\LocalUserAccountsFinal.txt") DO (
    TAKEOWN.exe /F "%SystemDrive%\Users\%%K\AppData\Roaming\AnyDesk" /A /R /D Y >NUL 2>&1
    ICACLS.exe "%SystemDrive%\Users\%%K\AppData\Roaming\AnyDesk" /T /C /Q /GRANT Administrators:F System:F Everyone:F >NUL 2>&1
    RMDIR "%SystemDrive%\Users\%%K\AppData\Roaming\AnyDesk" /S /Q >NUL 2>&1
    RD "%SystemDrive%\Users\%%K\AppData\Roaming\AnyDesk" /S /Q >NUL 2>&1)
DEL /F /Q "%WinDir%\Temp\LocalUserAccountsFinal.txt" >NUL 2>&1
ERASE /F /Q "%WinDir%\Temp\LocalUserAccountsFinal.txt" >NUL 2>&1



@ECHO Enabling the AnyDesk service...

SC.exe config AnyDesk start= auto >NUL 2>&1
SC.exe failure AnyDesk reset= 0 actions= restart/0 >NUL 2>&1
SC.exe failure AnyDesk reset= 0 actions= restart/0/restart/0 >NUL 2>&1
SC.exe failure AnyDesk reset= 0 actions= restart/0/restart/0/restart/0 >NUL 2>&1
SC.exe start AnyDesk >NUL 2>&1



@ECHO Starting the AnyDesk process...

WMIC OS GET OSArchitecture >> "%WinDir%\Temp\OSArchTemp.txt"
TYPE "%WinDir%\Temp\OSArchTemp.txt" | FINDSTR.exe /V /I "OSArchitecture" >> "%WinDir%\Temp\OSArch.txt"
DEL /F /Q "%WinDir%\Temp\OSArchTemp.txt" >NUL 2>&1
ERASE /F /Q "%WinDir%\Temp\OSArchTemp.txt" >NUL 2>&1
FOR /F "USEBACKQ TOKENS=1 DELIMS= " %%M IN ("%WinDir%\Temp\OSArch.txt") DO SET ARCH=%%M
IF "%ARCH%"=="64-bit" GOTO 64BIT ELSE (
    IF "%ARCH%"=="32-bit" GOTO 32BIT ELSE (
        @ECHO ^+^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^+
        @ECHO ^| This OS architecture is not supported!                            ^|
        @ECHO ^+^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^+
        PAUSE
        GOTO END)



:64BIT

IF EXIST "C:\Program Files (x86)\AnyDesk" (
    CD "C:\Program Files (x86)\AnyDesk" >NUL 2>&1
    START AnyDesk.exe >NUL 2>&1
    GOTO END >NUL 2>&1
    ) ELSE GOTO ADINF



:32BIT

IF EXIST "C:\Program Files\AnyDesk" (
    CD "C:\Program Files\AnyDesk" >NUL 2>&1
    START AnyDesk.exe >NUL 2>&1
    GOTO END >NUL 2>&1
    ) ELSE GOTO ADINF



:ADINF

@ECHO ^+^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^+
@ECHO ^| Seems like AnyDesk is not installed or it's not installed in the  ^|
@ECHO ^| default installation directory. You will have to start AnyDesk    ^|
@ECHO ^| manually, wherever it may reside.                                 ^|
@ECHO ^+^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^+
PAUSE



:END

DEL /F /Q "%WinDir%\Temp\OSArch.txt" >NUL 2>&1
ERASE /F /Q "%WinDir%\Temp\OSArch.txt" >NUL 2>&1
@ECHO Done!
