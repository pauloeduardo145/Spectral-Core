# SPECTRAL CORE: TAREFAS

## OBJETIVO DO JOGO
Num antigo laboratório abandonado, o jogador precisa **diagnosticar problemas, fabricar peças e consertar geradores que estão falhando**, enquanto desvia de **raios, fogo, sucata voadora e ataques de garotas fantasma**. Os fantasmas podem ser **aspirados** (viram recurso) ou **beijados** (podem virar aliados). Ao morrer, o jogador **perde os itens** (caem numa mochila), mas **o progresso não reseta**. Há salas secretas.

Fim de jogo (proposta): todos os geradores consertados.

---

## PRIORIDADE: FATIA VERTICAL MÍNIMA
Fazer **uma** volta completa antes de multiplicar o conteúdo:
**1 gerador + 1 defeito + 1 peça fabricável + 1 perigo + perda de itens ao morrer + 1 missão na prancheta.**
Se isso funcionar do início ao fim, o resto é repetição.

- [ ] 1. Mochila: ao morrer, os itens caem no chão e podem ser recuperados
- [ ] 2. Um gerador que falha (estado: funcionando / com defeito / consertado)
- [ ] 3. Um defeito diagnosticável (o jogador descobre qual é a causa)
- [ ] 4. Uma peça fabricável (matéria-prima + bancada + receita)
- [ ] 5. Consertar o gerador usando a peça e uma ferramenta
- [ ] 6. Um perigo simples (sucata voadora)
- [ ] 7. Uma missão real na prancheta ligada a esse gerador
- [ ] 8. Condição de fim de jogo para essa fatia (ex.: gerador consertado = vitória)

---

## FEITO
- [x] Menu, novo jogo, continuar, salvamento robusto (com valores padrão)
- [x] Movimento em 8 direções e animações
- [x] Vida com regeneração, barra colorida, respawn
- [x] Inventário de 5 slots com HUD
- [x] Aspirador remove fantasmas e conta `fantasmas_eliminados`
- [x] Fantasmas corajosos (perseguem) e medrosos (fogem), dano contínuo
- [x] Beijar: chance de virar aliado (máx. 3), aliados seguem o jogador
- [x] Fantasma carrega item (50%) e o aliado entrega ao jogador
- [x] Energia ligar/desligar no painel da sala oeste, com `ligado` salvo
- [x] Prancheta coletável, abre e fecha com E, posse salva e restaurada, some do chão ao continuar
- [x] Versionamento no GitHub

---

## RECURSOS
- [ ] Definir o que o fantasma aspirado rende (ex.: **essência de fantasma**)
- [ ] Contador de essência no `Global`, no HUD e no save
- [ ] Chance de a essência cair ao aspirar (variável `export` ajustável)
- [ ] Melhorar a eficiência do aspirador (alcance, tempo, feedback visual)
- [ ] Decidir se só o aspirador gera essência (evita ciclo infinito)
- [ ] (Opcional, depois da fatia) Arma que usa essência como munição; função a escolher: tiro à distância, atordoante ou apaziguador

## MUNDO
- [ ] Energia do local: decidir se é interruptor (hoje) ou quantidade que se gasta/coleta
- [ ] Fazer algo no jogo **reagir** à energia (luzes, portas, geradores)
- [ ] Geradores: um por sala (começar por um só)
- [ ] Salas secretas: ao menos uma, aberta pela Chave Universal
- [ ] Dar uso às ferramentas (Chave de fenda, Chave Universal, Martelo, Pé de Cabra)
- [ ] Bancada de fabricação e receitas de peças
- [ ] Matéria-prima espalhada pelo laboratório (sucata, fios, fusíveis)

## PERIGOS
- [ ] Sucata voadora (primeiro perigo)
- [ ] Raios (aviso visual antes de cair)
- [ ] Fogo (zonas que causam dano)
- [ ] Equilibrar dano e tempo de reação

## SOBREVIVER E MORTE
- [ ] Perder os itens ao morrer (mochila no local da morte)
- [ ] Regra para morrer de novo antes de recuperar a mochila (sugestão: só existe uma)
- [ ] Evitar mochila inalcançável (perigo em cima): reposicionar para ponto seguro
- [ ] Decidir se o aspirador também cai
- [ ] Progresso (prancheta, geradores, missões) nunca se perde
- [ ] Salvar a posição e o conteúdo da mochila

## FANTASMAS (GAROTAS FANTASMA)
- [ ] Arte: silhueta com cabelo longo e vestido que vira névoa; paleta curta; transparência por `modulate`
- [ ] Animação simples (oscilação por código ou 2 a 4 quadros)
- [ ] Variações de comportamento além de corajoso/medroso
- [ ] Tratar caso `corajoso == medroso` (hoje o fantasma não muda de direção)
- [ ] Revisar `Salas.gd`: fantasmas somem ao sair da sala e reaparecem ao voltar

## MISSÕES (PRANCHETA)
- [ ] Lista de missões no `Global` (id, texto, estado concluído/pendente) e no save
- [ ] A prancheta lê a lista e mostra as tarefas (hoje tem só "Primeiro" e "Segundo")
- [ ] Marcar missão concluída (ícone ou riscado)
- [ ] Primeira missão: encontrar a prancheta; seguintes ligadas à fatia vertical
- [ ] Esconder a prancheta ao iniciar um novo jogo (conferir `iniciar_partida` no HUD)

## FIM DE JOGO
- [ ] Definir a condição de vitória (todos os geradores consertados)
- [ ] Tela de vitória e retorno ao menu
- [ ] Decidir se existe derrota definitiva ou só a perda de itens

## ARTE E SOM
- [ ] Marcadores de posição para tudo o que ainda não tem arte
- [ ] Perigos e peças com formas simples e cores fortes
- [ ] Sons básicos (aspirar, beijar, gerador ligando)
- [ ] Conferir licenças de qualquer recurso de terceiros

---

## LIMPEZA TÉCNICA
- [ ] Renomear `TAREFAS.rm` para `TAREFAS.md` (o GitHub passa a renderizar)
- [ ] `F_numero.gd` depende de `/root/Main/Player`; o valor vem do `Global`, a condição pode ser desnecessária
- [ ] Pasta `Inimigos` vazia: usar ou remover
- [ ] Confirmar que `.gradle` e `build` estão no `.gitignore`
- [ ] `print` de depuração em `Player.gd` (`bejar`) para retirar
- [ ] Revisar duplicações e nomes (`EnergiaManeger`, `Bejar`)
- [ ] Teste do ciclo de save: novo jogo, continuar, sair com Esc

---

## DECISÕES EM ABERTO
1. A energia é interruptor ou recurso que se gasta?
2. Qual é o primeiro defeito do primeiro gerador (peça faltando, fusível, algo a diagnosticar)?
3. A mochila contém tudo, inclusive o aspirador?
4. A arma entra antes ou depois da fatia vertical? (sugestão: depois)
5. Qual a condição exata de fim de jogo?

---

## HÁBITOS
- Uma tarefa por sessão, pequena o bastante para terminar numa noite
- Um commit a cada passo que funciona
- Marcar `[x]` aqui ao concluir
