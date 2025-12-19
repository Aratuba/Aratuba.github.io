; ===============================================
; CRIAQUIZ - Criador Automático de Questões
; Autor: Sistema de Quiz
; Versão: 1.0
; ===============================================

;#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
;#AutoIt3Wrapper_Icon=question.ico
;#AutoIt3Wrapper_Outfile=CriarQuestao.exe
;#AutoIt3Wrapper_Compression=4
;#AutoIt3Wrapper_UseUpx=y
;#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>

; ===============================================
; VARIÁVEIS GLOBAIS
; ===============================================
Global $sQuizDir = @ScriptDir & "\quiz"
Global $sScriptJS = @ScriptDir & "\script.js"
Global $iProximaQuestao = 1
Global $aCategorias[0]
Global $sCategoriaAtual = ""

; ===============================================
; INTERFACE PRINCIPAL
; ===============================================
#Region ### START Koda GUI section ###
$frmMain = GUICreate("Criador de Questões - Quiz", 800, 700, -1, -1)
GUISetBkColor(0xF0F0F0)

; Título
GUICtrlCreateLabel("CRIADOR DE QUESTÕES - QUIZ", 20, 20, 760, 30)
GUICtrlSetFont(-1, 16, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x003366)

; Painel de Informações
GUICtrlCreateGroup("Informações da Questão", 20, 60, 760, 100)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")

; Número da Questão
GUICtrlCreateLabel("Número da Questão:", 40, 90, 120, 20)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$txtNumero = GUICtrlCreateInput("001", 170, 88, 60, 24)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x0000FF)

; Botão para obter próximo número
$btnProximoNumero = GUICtrlCreateButton("Próximo Número", 240, 88, 120, 24)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
GUICtrlSetBkColor(-1, 0x4CAF50)
GUICtrlSetColor(-1, 0xFFFFFF)

; Categoria
GUICtrlCreateLabel("Categoria:", 40, 125, 120, 20)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$cmbCategoria = GUICtrlCreateCombo("", 170, 122, 200, 24)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")

; Botão nova categoria
$btnNovaCategoria = GUICtrlCreateButton("Nova", 380, 122, 60, 24)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Painel do Enunciado
GUICtrlCreateGroup("Enunciado da Questão", 20, 170, 760, 200)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")

$txtEnunciado = GUICtrlCreateEdit("", 40, 200, 720, 150, $ES_WANTRETURN + $WS_VSCROLL + $ES_AUTOVSCROLL)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")

; Dicas HTML para o enunciado
GUICtrlCreateLabel("Dicas HTML: <p>Texto</p> <code>código</code> <pre>bloco código</pre> <strong>negrito</strong>", 40, 355, 720, 20)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetColor(-1, 0x666666)

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Painel das Alternativas
GUICtrlCreateGroup("Alternativas de Resposta", 20, 380, 760, 240)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")

; Alternativa 1 (CORRETA)
GUICtrlCreateLabel("Alternativa 1 (CORRETA):", 40, 410, 150, 20)
GUICtrlSetFont(-1, 9, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x008000)
$txtAlt1 = GUICtrlCreateEdit("", 40, 435, 720, 40, $ES_WANTRETURN + $WS_VSCROLL)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
GUICtrlSetBkColor(-1, 0xE8F5E9)

; Alternativa 2
GUICtrlCreateLabel("Alternativa 2:", 40, 485, 150, 20)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$txtAlt2 = GUICtrlCreateEdit("", 40, 510, 720, 40, $ES_WANTRETURN + $WS_VSCROLL)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")

; Alternativa 3
GUICtrlCreateLabel("Alternativa 3:", 40, 560, 150, 20)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$txtAlt3 = GUICtrlCreateEdit("", 40, 585, 720, 40, $ES_WANTRETURN + $WS_VSCROLL)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")

; Alternativa 4
GUICtrlCreateLabel("Alternativa 4:", 40, 635, 150, 20)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$txtAlt4 = GUICtrlCreateEdit("", 40, 660, 720, 40, $ES_WANTRETURN + $WS_VSCROLL)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")

GUICtrlCreateGroup("", -99, -99, 1, 1)

; Botões principais
$btnCriar = GUICtrlCreateButton("CRIAR QUESTÃO", 250, 640, 150, 40)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetBkColor(-1, 0x2196F3)
GUICtrlSetColor(-1, 0xFFFFFF)

$btnLimpar = GUICtrlCreateButton("Limpar Campos", 420, 640, 120, 40)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")

$btnSair = GUICtrlCreateButton("Sair", 560, 640, 80, 40)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")

; Status bar
$lblStatus = GUICtrlCreateLabel("Pronto", 20, 685, 760, 20, $SS_SUNKEN)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

; ===============================================
; INICIALIZAÇÃO
; ===============================================
Inicializar()
AtualizarCategorias()
AtualizarProximoNumero()

; ===============================================
; LOOP PRINCIPAL
; ===============================================
While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE, $btnSair
            Sair()
            
        Case $btnProximoNumero
            AtualizarProximoNumero()
            
        Case $btnNovaCategoria
            CriarNovaCategoria()
            
        Case $btnLimpar
            LimparCampos()
            
        Case $btnCriar
            CriarQuestao()
            
    EndSwitch
WEnd

; ===============================================
; FUNÇÕES
; ===============================================

Func Inicializar()
    ; Criar diretório quiz se não existir
    If Not FileExists($sQuizDir) Then
        DirCreate($sQuizDir)
        GUISetStatus("Diretório 'quiz' criado")
    EndIf
    
    ; Carregar categorias do arquivo
    CarregarCategorias()
EndFunc

Func AtualizarProximoNumero()
    Local $iNum = 1
    
    ; Procurar pelo maior número de questão existente
    Local $aPastas = _FileListToArray($sQuizDir, "questao*", 2)
    If Not @error Then
        For $i = 1 To $aPastas[0]
            Local $sPasta = $aPastas[$i]
            ; Extrair número da pasta (ex: "questao001" -> 1)
            Local $sNumero = StringRegExpReplace($sPasta, "questao(\d+)", "$1")
            If StringIsDigit($sNumero) Then
                Local $iNumPasta = Number($sNumero)
                If $iNumPasta >= $iNum Then
                    $iNum = $iNumPasta + 1
                EndIf
            EndIf
        Next
    EndIf
    
    $iProximaQuestao = $iNum
    Local $sNumeroFormatado = StringFormat("%03d", $iNum)
    GUICtrlSetData($txtNumero, $sNumeroFormatado)
    
    GUISetStatus("Próxima questão: " & $sNumeroFormatado)
EndFunc

Func AtualizarCategorias()
    ; Limpar combo box
    GUICtrlSetData($cmbCategoria, "")
    
    ; Adicionar categorias padrão se array vazio
    If UBound($aCategorias) = 0 Then
        Local $aCatsPadrao[3] = ["HTML5", "CSS3", "JavaScript"]
        For $i = 0 To UBound($aCatsPadrao) - 1
            _ArrayAdd($aCategorias, $aCatsPadrao[$i])
        Next
    EndIf
    
    ; Ordenar categorias
    _ArraySort($aCategorias)
    
    ; Adicionar ao combo box
    Local $sListaCategorias = "|"
    For $i = 0 To UBound($aCategorias) - 1
        $sListaCategorias &= $aCategorias[$i] & "|"
    Next
    
    GUICtrlSetData($cmbCategoria, $sListaCategorias)
    
    ; Selecionar primeira categoria
    If UBound($aCategorias) > 0 Then
        GUICtrlSetData($cmbCategoria, $aCategorias[0])
    EndIf
EndFunc

Func CarregarCategorias()
    Local $sArquivoCats = @ScriptDir & "\categorias.txt"
    
    If FileExists($sArquivoCats) Then
        Local $hFile = FileOpen($sArquivoCats, 0)
        If $hFile <> -1 Then
            Local $sConteudo = FileRead($hFile)
            FileClose($hFile)
            
            $aCategorias = StringSplit(StringStripWS($sConteudo, 8), @CRLF, 2)
            ; Remover linhas vazias
            For $i = UBound($aCategorias) - 1 To 0 Step -1
                If $aCategorias[$i] = "" Then
                    _ArrayDelete($aCategorias, $i)
                EndIf
            Next
        EndIf
    EndIf
EndFunc

Func SalvarCategorias()
    Local $sArquivoCats = @ScriptDir & "\categorias.txt"
    Local $hFile = FileOpen($sArquivoCats, 2) ; 2 = Sobrescrever
    
    If $hFile <> -1 Then
        For $i = 0 To UBound($aCategorias) - 1
            FileWriteLine($hFile, $aCategorias[$i])
        Next
        FileClose($hFile)
    EndIf
EndFunc

Func CriarNovaCategoria()
    Local $sNovaCategoria = InputBox("Nova Categoria", "Digite o nome da nova categoria:", "", "", 300, 130)
    
    If Not @error And $sNovaCategoria <> "" Then
        ; Verificar se já existe
        For $i = 0 To UBound($aCategorias) - 1
            If $aCategorias[$i] = $sNovaCategoria Then
                MsgBox(64, "Categoria Existente", "Esta categoria já existe!")
                Return
            EndIf
        Next
        
        ; Adicionar categoria
        _ArrayAdd($aCategorias, $sNovaCategoria)
        SalvarCategorias()
        AtualizarCategorias()
        
        ; Selecionar nova categoria
        GUICtrlSetData($cmbCategoria, $sNovaCategoria)
        
        GUISetStatus("Nova categoria adicionada: " & $sNovaCategoria)
    EndIf
EndFunc

Func CriarQuestao()
    ; Validar campos
    Local $sNumero = StringStripWS(GUICtrlRead($txtNumero), 8)
    Local $sCategoria = GUICtrlRead($cmbCategoria)
    Local $sEnunciado = GUICtrlRead($txtEnunciado)
    Local $sAlt1 = GUICtrlRead($txtAlt1)
    Local $sAlt2 = GUICtrlRead($txtAlt2)
    Local $sAlt3 = GUICtrlRead($txtAlt3)
    Local $sAlt4 = GUICtrlRead($txtAlt4)
    
    ; Validações
    If $sNumero = "" Or Not StringRegExp($sNumero, "^\d{3}$") Then
        MsgBox(48, "Erro", "Número da questão inválido! Use 3 dígitos (ex: 001)")
        GUICtrlSetState($txtNumero, $GUI_FOCUS)
        Return
    EndIf
    
    If $sCategoria = "" Then
        MsgBox(48, "Erro", "Selecione ou crie uma categoria!")
        Return
    EndIf
    
    If $sEnunciado = "" Then
        MsgBox(48, "Erro", "Digite o enunciado da questão!")
        GUICtrlSetState($txtEnunciado, $GUI_FOCUS)
        Return
    EndIf
    
    If $sAlt1 = "" Or $sAlt2 = "" Or $sAlt3 = "" Or $sAlt4 = "" Then
        MsgBox(48, "Erro", "Preencha todas as 4 alternativas!")
        Return
    EndIf
    
    ; Criar nome da pasta
    Local $sPastaQuestao = $sQuizDir & "\questao" & $sNumero
    
    ; Verificar se pasta já existe
    If FileExists($sPastaQuestao) Then
        Local $iResposta = MsgBox(52, "Pasta Existente", "A pasta para esta questão já existe!" & @CRLF & _
            "Deseja sobrescrever?")
        If $iResposta <> 6 Then ; 6 = IDYES
            Return
        EndIf
    EndIf
    
    ; Criar pasta
    DirCreate($sPastaQuestao)
    If @error Then
        MsgBox(48, "Erro", "Não foi possível criar a pasta da questão!")
        Return
    EndIf
    
    ; Criar arquivos
    Local $hFile
    
    ; 1. enunciado.html
    $hFile = FileOpen($sPastaQuestao & "\enunciado.html", 2)
    FileWrite($hFile, $sEnunciado)
    FileClose($hFile)
    
    ; 2. alternativa1.html (CORRETA)
    $hFile = FileOpen($sPastaQuestao & "\alternativa1.html", 2)
    FileWrite($hFile, $sAlt1)
    FileClose($hFile)
    
    ; 3. alternativa2.html
    $hFile = FileOpen($sPastaQuestao & "\alternativa2.html", 2)
    FileWrite($hFile, $sAlt2)
    FileClose($hFile)
    
    ; 4. alternativa3.html
    $hFile = FileOpen($sPastaQuestao & "\alternativa3.html", 2)
    FileWrite($hFile, $sAlt3)
    FileClose($hFile)
    
    ; 5. alternativa4.html
    $hFile = FileOpen($sPastaQuestao & "\alternativa4.html", 2)
    FileWrite($hFile, $sAlt4)
    FileClose($hFile)
    
    ; Atualizar script.js
    AtualizarScriptJS($sNumero, $sCategoria)
    
    ; Mostrar código para copiar
    Local $sCodigoJS = "    { codigo: '" & $sNumero & "', categoria: '" & $sCategoria & "' },"
    
    ; Mostrar mensagem de sucesso
    Local $sMensagem = "Questão " & $sNumero & " criada com sucesso!" & @CRLF & @CRLF & _
                      "Pasta: " & $sPastaQuestao & @CRLF & @CRLF & _
                      "Adicione este código ao array 'questoes' em script.js:" & @CRLF & _
                      $sCodigoJS
    
    MsgBox(64, "Sucesso!", $sMensagem)
    
    ; Copiar código para área de transferência
    ClipPut($sCodigoJS)
    
    ; Atualizar próximo número
    AtualizarProximoNumero()
    
    GUISetStatus("Questão " & $sNumero & " criada com sucesso!")
EndFunc

Func AtualizarScriptJS($sNumero, $sCategoria)
    Local $sArquivoJS = $sScriptJS
    
    If Not FileExists($sArquivoJS) Then
        ; Se script.js não existir, criar um template básico
        $hFile = FileOpen($sArquivoJS, 2)
        FileWriteLine($hFile, "class QuizManager {")
        FileWriteLine($hFile, "    constructor() {")
        FileWriteLine($hFile, "        this.questoes = [")
        FileWriteLine($hFile, "            // Adicione as questões aqui")
        FileWriteLine($hFile, "        ];")
        FileWriteLine($hFile, "        // ... resto do código")
        FileWriteLine($hFile, "    }")
        FileWriteLine($hFile, "}")
        FileClose($hFile)
        
        GUISetStatus("script.js criado (não existia)")
    EndIf
    
    ; Criar arquivo de backup
    Local $sBackup = $sArquivoJS & ".backup_" & @YEAR & @MON & @MDAY
    FileCopy($sArquivoJS, $sBackup, 1)
    
    ; Tentar atualizar automaticamente (opcional)
    ; Esta parte é mais complexa e pode ser manual
EndFunc

Func LimparCampos()
    GUICtrlSetData($txtEnunciado, "")
    GUICtrlSetData($txtAlt1, "")
    GUICtrlSetData($txtAlt2, "")
    GUICtrlSetData($txtAlt3, "")
    GUICtrlSetData($txtAlt4, "")
    
    GUISetStatus("Campos limpos")
EndFunc

Func GUISetStatus($sMensagem)
    GUICtrlSetData($lblStatus, "Status: " & $sMensagem & " (" & @HOUR & ":" & @MIN & ":" & @SEC & ")")
EndFunc

Func Sair()
    SalvarCategorias()
    GUIDelete($frmMain)
    Exit
EndFunc