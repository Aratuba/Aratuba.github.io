@echo off
setlocal

:: ==============================
:: INPUT DO USUÁRIO
:: ==============================
echo ==============================
echo   GERADOR DE REDIRECIONADOR
echo ==============================
echo.

set /p LINK=Digite a URL de destino: 
echo.

set /p ARQUIVO=Nome do arquivo (ex: pagina.html): 
echo.

set /p DELAY=Tempo de espera em segundos (padrão 5): 

:: Se não digitar nada, usa 5
if "%DELAY%"=="" set DELAY=5

:: ==============================
:: REMOVE ARQUIVO ANTIGO
:: ==============================
if exist "%ARQUIVO%" del "%ARQUIVO%"

echo.
echo Criando "%ARQUIVO%"...
echo.

:: ==============================
:: CRIA HTML
:: ==============================

echo ^<!DOCTYPE html^> > "%ARQUIVO%"
echo ^<html lang="pt-BR"^> >> "%ARQUIVO%"
echo ^<head^> >> "%ARQUIVO%"
echo ^<meta charset="UTF-8"^> >> "%ARQUIVO%"
echo ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> "%ARQUIVO%"
echo ^<title^>Redirecionando...^</title^> >> "%ARQUIVO%"

echo ^<style^> >> "%ARQUIVO%"
echo body {font-family: Arial; text-align:center; padding:50px; background:#f4f4f4;} >> "%ARQUIVO%"
echo .box {background:#fff; padding:30px; border-radius:10px; display:inline-block;} >> "%ARQUIVO%"
echo .c {font-size:2em; color:#0066cc; font-weight:bold;} >> "%ARQUIVO%"
echo ^</style^> >> "%ARQUIVO%"

echo ^<script^> >> "%ARQUIVO%"
echo var s=%DELAY%; >> "%ARQUIVO%"
echo function go(){ >> "%ARQUIVO%"
echo document.getElementById("c").innerText=s; >> "%ARQUIVO%"
echo if(s==0){window.location.href="%LINK%";} >> "%ARQUIVO%"
echo else{s--;setTimeout(go,1000);} >> "%ARQUIVO%"
echo } >> "%ARQUIVO%"
echo window.onload=go; >> "%ARQUIVO%"
echo ^</script^> >> "%ARQUIVO%"

echo ^</head^> >> "%ARQUIVO%"
echo ^<body^> >> "%ARQUIVO%"
echo ^<div class="box"^> >> "%ARQUIVO%"
echo Redirecionando em ^<span id="c" class="c"^>%DELAY%^</span^> segundos... >> "%ARQUIVO%"
echo ^<br^> >> "%ARQUIVO%"
echo ^<a href="%LINK%"^>Clique aqui se não redirecionar^</a^> >> "%ARQUIVO%"
echo ^</div^> >> "%ARQUIVO%"
echo ^</body^> >> "%ARQUIVO%"
echo ^</html^> >> "%ARQUIVO%"

:: ==============================
:: FINALIZAÇÃO
:: ==============================

echo.
echo Arquivo criado com sucesso!
echo.

:: Abre automaticamente
start "" "%ARQUIVO%"

pause
