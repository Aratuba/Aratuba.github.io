@echo off
setlocal enabledelayedexpansion

:: Verifica se o link foi passado como parâmetro
if "%~1"=="" (
    echo Uso: %~nx0 "URL_DO_REDIRECIONAMENTO" [nome_do_arquivo.html] [delay_segundos]
    echo Exemplo: %~nx0 "https://wordwall.net/en-it/community/sports" esportes.html 5
    pause
    exit /b
)

set "LINK=%~1"
set "ARQUIVO=%~2"
if "%ARQUIVO%"=="" set "ARQUIVO=redirecionar.html"
set "DELAY=%~3"
if "%DELAY%"=="" set "DELAY=5"

(
echo ^<!DOCTYPE html^>
echo ^<html lang="pt"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta http-equiv="refresh" content="%DELAY%; url=%LINK%"^>
echo     ^<title^>Redirecionando em %DELAY% segundos...^</title^>
echo     ^<style^>
echo         body {
echo             font-family: Arial, sans-serif;
echo             text-align: center;
echo             padding: 50px;
echo             background-color: #f4f4f4;
echo         }
echo         .container {
echo             background: white;
echo             padding: 30px;
echo             border-radius: 8px;
echo             box-shadow: 0 2px 10px rgba(0,0,0,0.1);
echo             display: inline-block;
echo         }
echo         .countdown {
echo             font-size: 2em;
echo             font-weight: bold;
echo             margin: 20px 0;
echo             color: #0066cc;
echo         }
echo         a {
echo             color: #0066cc;
echo             text-decoration: none;
echo         }
echo         a:hover {
echo             text-decoration: underline;
echo         }
echo     ^</style^>
echo     ^<script^>
echo         var segundos = %DELAY%;
echo         function atualizarContador() {
echo             document.getElementById("contador").innerText = segundos;
echo             if (segundos == 0) {
echo                 window.location.href = "%LINK%";
echo             } else {
echo                 segundos--;
echo                 setTimeout(atualizarContador, 1000);
echo             }
echo         }
echo         setTimeout(function() {
echo             window.location.href = "%LINK%";
echo         }, %DELAY% * 1000);
echo         atualizarContador();
echo     ^</script^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="container"^>
echo         ^<p^>Você será redirecionado em ^<span id="contador" class="countdown"^>%DELAY%^</span^> segundos.^</p^>
echo         ^<p^>Se não for redirecionado automaticamente, ^<a href="%LINK%"^>clique aqui^</a^>.^</p^>
echo     ^</div^>
echo ^</body^>
echo ^</html^>
) > "%ARQUIVO%"

echo Arquivo "%ARQUIVO%" criado com sucesso!
pause