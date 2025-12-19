class QuizManager {
    constructor() {
        this.questoes = [
            { codigo: '001', categoria: 'Interpretação' },
            { codigo: '002', categoria: 'Interpretação' },
            { codigo: '003', categoria: 'Interpretação' },
            { codigo: '004', categoria: 'Interpretação' },
            { codigo: '005', categoria: 'Interpretação' },
            { codigo: '006', categoria: 'Interpretação' },
            { codigo: '007', categoria: 'Interpretação' },
            { codigo: '008', categoria: 'Interpretação' },
            { codigo: '009', categoria: 'Interpretação' },
            { codigo: '010', categoria: 'Interpretação' },
            { codigo: '011', categoria: 'Interpretação' },
            { codigo: '012', categoria: 'Interpretação' },
            { codigo: '013', categoria: 'Interpretação' },
            { codigo: '014', categoria: 'Interpretação' },
            { codigo: '015', categoria: 'Interpretação' }
            //{ codigo: '003', categoria: 'Descritor' },
            // Adicione mais questões conforme necessário
        ];
        
        this.questaoAtual = 0;
        this.respostas = [];
        this.acertos = 0;
        this.embaralhamentoAtual = [];
        
        this.init();
    }

    init() {
        this.carregarQuestao(this.questaoAtual);
        this.setupEventListeners();
    }

    async carregarQuestao(indice) {
        const questao = this.questoes[indice];
        
        try {
            // Carregar enunciado
            const enunciadoResponse = await fetch(`/quiz/questao${questao.codigo}/enunciado.html`);
            const enunciadoHTML = await enunciadoResponse.text();
            document.getElementById('enunciadoContainer').innerHTML = enunciadoHTML;
            
            // Carregar alternativas
            const alternativas = [];
            for (let i = 1; i <= 4; i++) {
                const altResponse = await fetch(`/quiz/questao${questao.codigo}/alternativa${i}.html`);
                const altHTML = await altResponse.text();
                alternativas.push({ numero: i, conteudo: altHTML });
            }
            
            // Embaralhar alternativas
            this.embaralhamentoAtual = this.embaralharAlternativas([0, 1, 2, 3]);
            
            // Exibir alternativas
            this.exibirAlternativas(alternativas, indice);
            
            // Atualizar interface
            this.atualizarInterface(indice);
            
            // Verificar se já existe resposta para esta questão
            if (this.respostas[indice]) {
                this.selecionarAlternativa(this.respostas[indice].respostaIndex);
            }
            
        } catch (error) {
            console.error('Erro ao carregar questão:', error);
            document.getElementById('enunciadoContainer').innerHTML = 
                '<p>Erro ao carregar a questão. Por favor, tente novamente.</p>';
        }
    }

    embaralharAlternativas(array) {
        for (let i = array.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [array[i], array[j]] = [array[j], array[i]];
        }
        return array;
    }

    exibirAlternativas(alternativas, questaoIndex) {
        const container = document.getElementById('alternativasContainer');
        container.innerHTML = '';
        
        const letras = ['A', 'B', 'C', 'D'];
        
        this.embaralhamentoAtual.forEach((indexOriginal, posicaoAtual) => {
            const alternativa = alternativas[indexOriginal];
            const letra = letras[posicaoAtual];
            
            const button = document.createElement('button');
            button.className = 'alternativa-btn';
            button.dataset.originalIndex = indexOriginal;
            button.dataset.currentIndex = posicaoAtual;
            
            button.innerHTML = `
                <div class="alternativa-letter">${letra}</div>
                <div class="alternativa-text">${alternativa.conteudo}</div>
            `;
            
            button.addEventListener('click', () => {
                this.selecionarAlternativa(posicaoAtual);
                this.registrarResposta(questaoIndex, posicaoAtual, indexOriginal);
            });
            
            container.appendChild(button);
        });
    }

    selecionarAlternativa(index) {
        // Remover seleção anterior
        document.querySelectorAll('.alternativa-btn').forEach(btn => {
            btn.classList.remove('selected');
        });
        
        // Adicionar seleção atual
        const buttons = document.querySelectorAll('.alternativa-btn');
        if (buttons[index]) {
            buttons[index].classList.add('selected');
        }
    }

    registrarResposta(questaoIndex, respostaIndex, originalIndex) {
        const questao = this.questoes[questaoIndex];
        
        this.respostas[questaoIndex] = {
            questao: questao.codigo,
            respostaIndex: respostaIndex,
            originalIndex: originalIndex,
            correta: originalIndex === 0, // Alternativa 1 original é a correta
            respondida: true
        };
        
        // Mostrar feedback
        this.mostrarFeedback(originalIndex === 0);
    }

    mostrarFeedback(correto) {
        const feedback = document.getElementById('feedback');
        
        if (correto) {
            feedback.className = 'feedback correct';
            feedback.innerHTML = `
                <i class="fas fa-check-circle"></i>
                <strong>Correto!</strong> Parabéns, você acertou!
            `;
        } else {
            feedback.className = 'feedback incorrect';
            feedback.innerHTML = `
                <i class="fas fa-times-circle"></i>
                <strong>Incorreto!</strong> Tente novamente na próxima.
            `;
        }
        
        feedback.style.display = 'block';
    }

    atualizarInterface(indice) {
        // Atualizar número da questão
        document.getElementById('questionNumber').textContent = 
            `Questão ${indice + 1} de ${this.questoes.length}`;
        
        // Atualizar categoria
        document.getElementById('questionCategory').textContent = 
            this.questoes[indice].categoria;
        
        // Atualizar progresso
        const progresso = ((indice + 1) / this.questoes.length) * 100;
        document.getElementById('progressBar').style.width = `${progresso}%`;
        
        // Atualizar pontuação atual
        this.acertos = this.respostas.filter(r => r && r.correta).length;
        document.getElementById('currentScore').textContent = this.acertos;
        
        // Atualizar botões de navegação
        document.getElementById('prevBtn').disabled = indice === 0;
        
        const nextBtn = document.getElementById('nextBtn');
        const submitBtn = document.getElementById('submitBtn');
        
        if (indice === this.questoes.length - 1) {
            nextBtn.style.display = 'none';
            submitBtn.style.display = 'flex';
        } else {
            nextBtn.style.display = 'flex';
            submitBtn.style.display = 'none';
        }
    }

    setupEventListeners() {
        // Botão anterior
        document.getElementById('prevBtn').addEventListener('click', () => {
            if (this.questaoAtual > 0) {
                this.questaoAtual--;
                this.carregarQuestao(this.questaoAtual);
            }
        });
        
        // Botão próxima
        document.getElementById('nextBtn').addEventListener('click', () => {
            if (this.questaoAtual < this.questoes.length - 1) {
                this.questaoAtual++;
                this.carregarQuestao(this.questaoAtual);
            }
        });
        
        // Botão finalizar
        document.getElementById('submitBtn').addEventListener('click', () => {
            this.finalizarQuiz();
        });
        
        // Botão reiniciar
        document.getElementById('restartBtn').addEventListener('click', () => {
            this.reiniciarQuiz();
        });
    }

    async finalizarQuiz() {
        // Calcular pontuação final
        const acertos = this.respostas.filter(r => r && r.correta).length;
        const total = this.questoes.length;
        
        // Mostrar resultados
        document.getElementById('finalScore').textContent = acertos;
        document.getElementById('scoreMax').textContent = `/${total}`;
        
        // Mensagem baseada na pontuação
        const mensagens = [
            { min: 0, max: 0.3, msg: "Você pode melhorar! Continue estudando." },
            { min: 0.3, max: 0.7, msg: "Bom trabalho! Mas ainda pode melhorar." },
            { min: 0.7, max: 0.9, msg: "Ótimo resultado! Você está quase lá." },
            { min: 0.9, max: 1, msg: "Excelente! Você domina o assunto!" }
        ];
        
        const porcentagem = acertos / total;
        const mensagem = mensagens.find(m => porcentagem >= m.min && porcentagem <= m.max);
        document.getElementById('scoreMessage').textContent = mensagem.msg;
        
        // Mostrar detalhes das respostas
        this.mostrarDetalhesRespostas();
        
        // Alternar entre quiz e resultados
        document.querySelector('.quiz-content').style.display = 'none';
        document.getElementById('resultsContainer').style.display = 'block';
    }

    async mostrarDetalhesRespostas() {
        const container = document.getElementById('answersDetails');
        container.innerHTML = '';
        
        for (let i = 0; i < this.questoes.length; i++) {
            const questao = this.questoes[i];
            const resposta = this.respostas[i];
            
            // Carregar enunciado para mostrar
            const enunciadoResponse = await fetch(`/quiz/questao${questao.codigo}/enunciado.html`);
            let enunciado = await enunciadoResponse.text();
            enunciado = enunciado.replace(/<[^>]*>/g, '').substring(0, 100) + '...';
            
            const detail = document.createElement('div');
            detail.className = `answer-detail ${resposta && resposta.correta ? 'correct' : 'incorrect'}`;
            
            const status = resposta && resposta.correta ? 
                '<span style="color: #10b981;">✓ Correta</span>' : 
                '<span style="color: #ef4444;">✗ Incorreta</span>';
            
            detail.innerHTML = `
                <strong>Questão ${i + 1}:</strong> ${enunciado}<br>
                <small>Status: ${status}</small>
            `;
            
            container.appendChild(detail);
        }
    }

    reiniciarQuiz() {
        this.questaoAtual = 0;
        this.respostas = [];
        this.acertos = 0;
        
        // Alternar de volta para o quiz
        document.getElementById('resultsContainer').style.display = 'none';
        document.querySelector('.quiz-content').style.display = 'block';
        
        // Recarregar primeira questão
        this.carregarQuestao(0);
    }
}

// Inicializar o quiz quando a página carregar
document.addEventListener('DOMContentLoaded', () => {
    new QuizManager();
});