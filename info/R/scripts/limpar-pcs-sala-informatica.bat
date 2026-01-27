@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ============================================
REM SCRIPT DE ORGANIZAÇÃO E LIMPEZA DE ARQUIVOS
REM Versão: 2.0 - Com UTF-8 e MOVE
REM ============================================

REM Verificar se está executando como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Este script requer privilégios de administrador.
    echo Execute como administrador.
    pause
    exit /b 1
)

REM Solicitar letra do disco de destino
:askdrive
cls
echo ============================================
echo        ORGANIZADOR DE ARQUIVOS
echo ============================================
echo.
set /p drive=Informe a letra do disco de destino (ex: D, E, F): 
if not defined drive goto askdrive
set "drive=%drive:~0,1%"
set "drive=%drive%:"

REM Verificar se o disco existe
if not exist "%drive%\" (
    echo.
    echo [ERRO] Disco %drive% não encontrado!
    echo.
    pause
    goto askdrive
)

REM Obter nome do computador
for /f "tokens=2 delims==" %%i in ('wmic computersystem get name /value') do set "pcname=%%i"
set "pcname=%pcname:~0,-1%"

REM Definir caminho base de destino
set "basepath=%drive%\arquivo-analise\%pcname%"

REM Mostrar configuração
cls
echo ============================================
echo        CONFIGURAÇÃO SELECIONADA
echo ============================================
echo.
echo Disco de destino: %drive%
echo Nome do computador: %pcname%
echo Caminho base: %basepath%
echo.
echo Pressione qualquer tecla para continuar...
pause >nul

REM Criar estrutura de pastas
echo.
echo Criando estrutura de pastas...
echo.

if not exist "%basepath%" (
    mkdir "%basepath%"
    echo [OK] Pasta base criada
) else (
    echo [INFO] Pasta base já existe
)

set "pastas=Desktop Imagens Downloads Videos Musicas"
for %%p in (%pastas%) do (
    if not exist "%basepath%\%%p\" (
        mkdir "%basepath%\%%p" 2>nul
        echo [OK] Pasta '%%p' criada
    )
)

echo.
echo ============================================
echo        MOVENDO ARQUIVOS
echo ============================================

REM Função para mover arquivos com verificação
call :MoverComVerificacao "%USERPROFILE%\Desktop" "%basepath%\Desktop" "Desktop"
call :MoverComVerificacao "%USERPROFILE%\Pictures" "%basepath%\Imagens" "Imagens"
call :MoverComVerificacao "%USERPROFILE%\Downloads" "%basepath%\Downloads" "Downloads"
call :MoverComVerificacao "%USERPROFILE%\Videos" "%basepath%\Videos" "Vídeos"
call :MoverComVerificacao "%USERPROFILE%\Music" "%basepath%\Musicas" "Músicas"

echo.
echo ============================================
echo        LIMPEZA DE ARQUIVOS TEMPORÁRIOS
echo ============================================
echo.

REM Limpar arquivos temporários com verificações
echo [1/3] Temp do Sistema...
if exist "%SystemRoot%\Temp\*" (
    del /q /f /s "%SystemRoot%\Temp\*" 2>nul
    for /d %%i in ("%SystemRoot%\Temp\*") do rmdir "%%i" /s /q 2>nul
    echo   Limpeza concluída
) else (
    echo   Pasta já está vazia
)

echo.
echo [2/3] Temp do Usuário...
if exist "%TEMP%\*" (
    del /q /f /s "%TEMP%\*" 2>nul
    for /d %%i in ("%TEMP%\*") do rmdir "%%i" /s /q 2>nul
    echo   Limpeza concluída
) else (
    echo   Pasta já está vazia
)

echo.
echo [3/3] Prefetch...
if exist "%SystemRoot%\Prefetch\*" (
    del /q /f /s "%SystemRoot%\Prefetch\*" 2>nul
    echo   Limpeza concluída
) else (
    echo   Pasta já está vazia
)

echo.
echo ============================================
echo        RESUMO DA OPERAÇÃO
echo ============================================
echo.
echo Estrutura criada em:
echo %basepath%
echo.
echo Arquivos movidos para:
for %%p in (%pastas%) do (
    if exist "%basepath%\%%p\*" (
        dir /a-d "%basepath%\%%p" | find /i "arquivo(s)" >nul
        if !errorlevel! equ 0 (
            for /f "tokens=1" %%a in ('dir /a-d "%basepath%\%%p" ^| find /i "arquivo(s)"') do (
                echo %%p: %%a arquivo(s)
            )
        )
    ) else (
        echo %%p: 0 arquivos
    )
)
echo.
echo Operação concluída com sucesso!
echo.
pause
exit /b

REM ============================================
REM FUNÇÃO: Mover arquivos com verificação
REM ============================================
:MoverComVerificacao
set "origem=%~1"
set "destino=%~2"
set "nomepasta=%~3"

echo.
echo [%nomepasta%]
echo   Origem: %origem%
echo   Destino: %destino%

if not exist "%origem%\*" (
    echo   [INFO] Pasta de origem vazia ou não encontrada
    goto :eof
)

REM Contar arquivos antes
set /a contador=0
for /f %%a in ('dir /a-d "%origem%" 2^>nul ^| find /c "arquivo(s)"') do set /a contador=%%a

if %contador% equ 0 (
    echo   [INFO] N達o h叩 arquivos para mover
    goto :eof
)

echo   Movendo %contador% arquivo(s)...

REM Mover arquivos (n達o move pastas)
for %%f in ("%origem%\*") do (
    move "%%f" "%destino%\" >nul 2>&1
    if errorlevel 1 (
        echo   [AVISO] Não foi possível mover: %%~nxf
    )
)

REM Mover subpastas (se existirem)
if exist "%origem%\*" (
    for /d %%d in ("%origem%\*") do (
        move "%%d" "%destino%\" >nul 2>&1
        if errorlevel 1 (
            echo   [AVISO] N達o foi poss鱈vel mover a pasta: %%~nxd
        )
    )
)

REM Verificar se moveu tudo
set /a contador_depois=0
for /f %%a in ('dir /a-d "%origem%" 2^>nul ^| find /c "arquivo(s)"') do set /a contador_depois=%%a

if %contador_depois% equ 0 (
    echo   [OK] Todos os arquivos movidos
) else (
    echo   [AVISO] %contador_depois% arquivo(s) não puderam ser movidos
)

REM Verificar se destino tem arquivos
set /a contador_destino=0
for /f %%a in ('dir /a-d "%destino%" 2^>nul ^| find /c "arquivo(s)"') do set /a contador_destino=%%a

echo   Total no destino: %contador_destino% arquivo(s)
goto :eof
