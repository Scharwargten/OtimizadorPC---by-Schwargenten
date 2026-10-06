@echo off
title Otimizador de PC - CMD
color 0A
mode con cols=80 lines=35

:: Verificar se esta rodando como Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo  [ERRO] Execute este arquivo como Administrador!
    echo  Clique com o botao direito e escolha "Executar como administrador"
    echo.
    pause
    exit
)

:menu
cls
echo.
echo  ========================================================
echo               OTIMIZADOR DE PC - CMD
echo  ========================================================
echo.
echo   [1] Limpeza Rapida (Temp + Prefetch + Lixeira)
echo   [2] Limpeza Completa (Temp + DNS + Cache + Update)
echo   [3] Flush DNS + Renovar IP
echo   [4] Limpar Cache do Windows Store
echo   [5] Ativar Plano de Energia Alto Desempenho
echo   [6] Verificar e Reparar Arquivos do Sistema (SFC)
echo   [7] Limpeza de Disco (cleanmgr)
echo   [8] Reiniciar Explorador do Windows
echo   [0] Sair
echo.
echo  ========================================================
set /p opcao=  Escolha uma opcao: 

if "%opcao%"=="1" goto limpeza_rapida
if "%opcao%"=="2" goto limpeza_completa
if "%opcao%"=="3" goto flush_dns
if "%opcao%"=="4" goto store_cache
if "%opcao%"=="5" goto high_perf
if "%opcao%"=="6" goto sfc
if "%opcao%"=="7" goto cleanmgr
if "%opcao%"=="8" goto restart_explorer
if "%opcao%"=="0" exit
goto menu

:limpeza_rapida
cls
echo.
echo  [1] Limpando arquivos temporarios...
del /s /f /q "%temp%\*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*" >nul 2>&1
del /s /f /q "C:\Windows\Prefetch\*" >nul 2>&1
echo  Arquivos Temp e Prefetch limpos.

echo.
echo  Esvaziando Lixeira...
PowerShell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo  Lixeira esvaziada.

echo.
echo  Limpeza rapida concluida!
pause
goto menu

:limpeza_completa
cls
echo.
echo  [2] Iniciando limpeza completa...
echo.

echo  Limpando Temp do usuario...
del /s /f /q "%temp%\*" >nul 2>&1
del /s /f /q "%LocalAppData%\Temp\*" >nul 2>&1

echo  Limpando Temp do Windows...
del /s /f /q "C:\Windows\Temp\*" >nul 2>&1

echo  Limpando Prefetch...
del /s /f /q "C:\Windows\Prefetch\*" >nul 2>&1

echo  Limpando cache do Windows Update...
net stop wuauserv >nul 2>&1
del /s /f /q "C:\Windows\SoftwareDistribution\Download\*" >nul 2>&1
net start wuauserv >nul 2>&1

echo  Limpando arquivos de log...
del /s /f /q "C:\Windows\Logs\*" >nul 2>&1
del /s /f /q "C:\Windows\System32\LogFiles\*" >nul 2>&1

echo  Esvaziando Lixeira...
PowerShell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1

echo  Limpando DNS...
ipconfig /flushdns >nul

echo.
echo  Limpeza completa concluida!
pause
goto menu

:flush_dns
cls
echo.
echo  [3] Flush DNS e renovando IP...
ipconfig /flushdns
ipconfig /release
ipconfig /renew
echo.
echo  DNS limpo e IP renovado!
pause
goto menu

:store_cache
cls
echo.
echo  [4] Limpando cache da Microsoft Store...
WSReset.exe
echo  Cache da Store limpo!
pause
goto menu

:high_perf
cls
echo.
echo  [5] Ativando plano de Alto Desempenho...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo  Plano de Alto Desempenho ativado!
pause
goto menu

:sfc
cls
echo.
echo  [6] Verificando integridade dos arquivos do sistema...
echo  Isso pode demorar varios minutos...
sfc /scannow
echo.
echo  Verificacao concluida!
pause
goto menu

:cleanmgr
cls
echo.
echo  [7] Abrindo Limpeza de Disco...
cleanmgr /sagerun:1
echo  Limpeza de Disco iniciada!
pause
goto menu

:restart_explorer
cls
echo.
echo  [8] Reiniciando Explorador do Windows...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
echo  Explorador reiniciado!
pause
goto menu
