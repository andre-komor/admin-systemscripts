SETLOCAL EnableDelayedExpansion

REM Ordner im aktuellen Verzeicniss durchlaufen 
for /d %%X in (*) do (

REM Zeitstempel setzen Format: 2012-12-12
SET data=%date:~-4,4%"-"%date:~-7,2%"-"%date:~-10,2%

REM 7zippen a--> ADD -m0-->compressionMethod mit dictionary 1024MB, Wordsize 273 | -mhc = compress Header| -mmt = threads | -mx=9 = MaxCompression..0=min | ms=+ = solidArchiv..also 2,4,8..possible (blocksize)
REM -mhe = encrypt FileNames 
"c:\Program Files\7-Zip\7z.exe" a -m0=LZMA2:d1536m:fb273 -mhc=on -mmt=1 -mx=9 -mhe=on -pSUPERPassWord -ms=+ -v16384m -- "%%X_!data!.7z" "%%X\" 

timeout /T 1

delete Folder
rd /s /q "%%X\"
)
