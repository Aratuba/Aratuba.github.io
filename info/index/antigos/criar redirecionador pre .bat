@echo off
setlocal

set "LINK=https://duckduckgo.com/"
set "ARQUIVO=d.html"
set "DELAY=5"

if exist "%ARQUIVO%" del "%ARQUIVO%"

echo Criando "%ARQUIVO%"...

echo ^<!DOCTYPE html^> > "%ARQUIVO%"
echo ^<html lang="pt-BR"^> >> "%ARQUIVO%"
echo ^<head^> >> "%ARQUIVO%"
echo ^<meta charset="UTF-8"^> >> "%ARQUIVO%"
echo ^<title^>Redirecionando...^</title^> >> "%ARQUIVO%"

echo ^<script^> >> "%ARQUIVO%"
echo var segundos = %DELAY%; >> "%ARQUIVO%"
echo function atualizar() { >> "%ARQUIVO%"
echo document.getElementById("c").innerText = segundos; >> "%ARQUIVO%"
echo if (segundos == 0) { >> "%ARQUIVO%"
echo window.location.href = "%LINK%"; >> "%ARQUIVO%"
echo } else { >> "%ARQUIVO%"
echo segundos--; >> "%ARQUIVO%"
echo setTimeout(atualizar,1000); >> "%ARQUIVO%"
echo } >> "%ARQUIVO%"
echo } >> "%ARQUIVO%"
echo window.onload = atualizar; >> "%ARQUIVO%"
echo ^</script^> >> "%ARQUIVO%"

echo ^</head^> >> "%ARQUIVO%"
echo ^<body^> >> "%ARQUIVO%"
echo Redirecionando em ^<span id="c"^>%DELAY%^</span^> segundos... >> "%ARQUIVO%"
echo ^</body^> >> "%ARQUIVO%"
echo ^</html^> >> "%ARQUIVO%"

echo.
echo Arquivo criado!
pause
