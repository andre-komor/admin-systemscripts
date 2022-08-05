@ECHO OFF
CLS
TITLE Windows SystemCheck Script
COLOR 0A 

REM toDOs: GPupdate from currentUSER + Strip & Format Win ErrorLOG...last week 

SET tmpfolder="c:\tmp"

REM problem, while  running as admin..other solution
REM SET javacache="%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment\cache"

IF NOT EXIST %tmpfolder% (
	mkdir %tmpfolder%
)

SET pfad=d:\Edvance\BechtleSide\_UserProblems\Logs\%COMPUTERNAME%

IF NOT EXIST %pfad% (
	mkdir %pfad%
)

xcopy /s /e /h /y /z "%SystemRoot%\System32\Winevt\Logs\*" "%pfad%"

 
ECHO. 
ECHO ===== Do SFC-Scan for Systemfile-Integrity =====
ECHO. 
sfc /scannow
timeout 1

ECHO. 
ECHO ===== Strip SFC-related from CBS-Logfile to c:\tmp =====
ECHO.

findstr /c:"[SR]" c:\Windows\logs\cbs\cbs.log > %tmpfolder%\sfcdetails.txt
ECHO =====...done
timeout 1

ECHO. 
ECHO ===== Restore health from componentstore and save Log to c:\tmp =====
ECHO.
DISM /Online /Cleanup-Image /ScanHealth

REM /Y = Override
xcopy  /Y /H /R /F %windir%\logs\CBS\Checksur.log %tmpfolder%\Checksur_DISM-scan.log


ECHO. 
ECHO ===== Deleting Windows TEMP & TMP=====
ECHO. 
erase "%SystemRoot%\TEMP\*.*" /f /s /q
for /D %%i in ("%SystemRoot%\TEMP\*") do RD /S /Q "%%i"


ECHO. 
ECHO ===== Do GPUpdate and save results=====
ECHO. 
GPUpdate /force
timeout 1
gpresult /H %tmpfolder%\gpresults.html /f
