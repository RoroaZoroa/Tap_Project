@echo off
set PACKAGE=com.itt.toluca.itt_portal_estudiantil
set DB_NAME=itt_portal.db
set REMOTE_PATH=/data/data/%PACKAGE%/databases/%DB_NAME%

echo [SINCRO] Jalando base de datos desde el emulador Android...
adb pull %REMOTE_PATH% ./%DB_NAME%

if %ERRORLEVEL% EQU 0 (
    echo [EXITO] Los cambios hechos en el emulador se han copiado a tu carpeta de proyecto.
    echo Refresca el visualizador de SQLite en VS Code para ver los datos.
) else (
    echo [ERROR] No se pudo conectar con el emulador. 
    echo Asegurate de que el emulador este prendido y la App haya sido abierta al menos una vez.
)
pause
