@echo off
REM Script para duplicar una carpeta y renombrarla con un nombre personalizado y la fecha actual
REM La ruta de la carpeta origen solo se pide la primera vez y se almacena en un archivo .txt

setlocal enabledelayedexpansion

REM Archivo donde se guardará la ruta
set ruta_file=ruta_origen.txt

REM Comprobar si ya se tiene almacenada la ruta
if exist "%ruta_file%" (
    set /p carpeta_origen=<"%ruta_file%"
    echo Usando carpeta origen guardada: "%carpeta_origen%"
) else (
    set /p carpeta_origen="Introduce la ruta completa de la carpeta a duplicar: "
    REM Guardar la ruta para futuras ejecuciones
    echo %carpeta_origen%>"%ruta_file%"
)

REM Verifica si la carpeta existe
if not exist "%carpeta_origen%" (
    echo ERROR: La carpeta de origen no existe.
    pause
    exit /b
)

REM Solicitar el nombre del taller
set /p nombre_taller="Introduce el nombre del taller: "

REM Obtener la fecha actual en formato YYYY-MM-DD
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set fecha=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%

REM Construir el nombre de la nueva carpeta (en la misma ruta del script)
set nombre_nuevo=%fecha%_%nombre_taller%

REM Evita sobrescribir si ya existe la carpeta destino
if exist "%nombre_nuevo%" (
    echo ERROR: Ya existe una carpeta con el nombre %nombre_nuevo%
    pause
    exit /b
)

REM Copiar la carpeta
xcopy "%carpeta_origen%" "%nombre_nuevo%\" /E /I /H /C /Y

REM Verifica si la copia fue exitosa
if exist "%nombre_nuevo%" (
    echo Carpeta duplicada exitosamente como: %nombre_nuevo%
) else (
    echo ERROR: No se pudo duplicar la carpeta.
)

pause