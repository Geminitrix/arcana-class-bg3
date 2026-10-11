# Arcana — guia de teste no jogo (2026-09-20)

Guia passo a passo do que clicar e digitar. Substitui a Task 12 do `2026-09-17-deck-core.md` (escrita com
nomes e números antigos) e cumpre a Task 1 do `2026-09-19-card-costs-reactions.md`.

**Tempo:** ~20 min a rodada 1, ~10 min cada rodada seguinte.
**Anote o resultado** na ficha do fim do arquivo. Os passos marcados 🔴 são os que decidem se eu preciso
reescrever código; o resto é confirmação.

---

# Parte 0 — preparar (obrigatório)

### 0.1 Fechar e reabrir o jogo

O jogo lê os stats **uma única vez, ao abrir**. Se ele estava aberto enquanto os arquivos foram escritos
hoje, está rodando com os dados velhos e nenhum teste vale.

1. Feche o Baldur's Gate 3 por completo (não só o save — o jogo inteiro).
2. Abra de novo.

*Não precisa do Toolkit.* O `Arcana Class` está no `modsettings` sem `.pak`, então o jogo lê direto os
arquivos soltos da pasta `Data\`.

### 0.2 Achar a janela do console

Junto com o jogo abre uma **segunda janela, preta, de console** (é o Script Extender — o
`ScriptExtenderSettings.json` já está com `CreateConsole: true`).

1. Alt+Tab até ela, ou clique nela na barra de tarefas.
2. Clique dentro da janela antes de digitar.
3. Digite `server` e Enter **uma vez**. Isso põe o console no contexto do servidor, que é onde o mod roda.
   O prompt passa a mostrar `S >`. *Se já estiver `S >`, pule.*
4. Daqui em diante: comandos do mod começam com `!` (ex.: `!arcanatest`). Linhas de Lua vão sem `!`.

Os comandos úteis: `!arcanahand` (a mão, com contagem e custo), `!arcanadeck` (o que falta comprar),
`!arcanathreads` (a energia), `!arcanapool` (tudo que o deck acompanha), `!arcanatext on|off` (o texto
sobre o personagem), `!arcanadraw N`, `!arcanareset`.

> **Dica:** deixe a janela do console ao lado do jogo em modo janela (Alt+Enter no jogo, ou
> Opções → Vídeo → Modo de exibição → Janela). Você vai alternar muito entre os dois.

### 0.3 Escolher o personagem de teste

Tudo o que mudou entra **pela progressão**, então o personagem precisa passar pela progressão de novo —
**inclusive se você já respecou numa rodada anterior**, porque entrou um recurso novo (`ArcanaHandCard`,
o contador de cartas na mão) concedido no nível 1:

- **Melhor caminho:** carregue um save com um Arcana de **nível 11 ou mais** e faça **respec no Withers**
  (acampamento → falar com Withers → *"I wish to change..."* → custa **100 de ouro**). O respec refaz a
  progressão do nível 1 e aplica tudo.
- Se não tiver save alto, crie um Arcana novo — mas aí só dá para testar os blocos A, B e C.

**Subclasse por rodada** (cada uma testa coisas diferentes; respec de novo entre elas):

| Rodada | Subclasse | Nível mínimo | O que testa |
|---|---|---|---|
| **1** | **Deceiver** | 11 | Partes 1, 2, 3, 4 (Instinctive Charm + Hollow Image), 5 (Mimic), 6 |
| **2** | **Unbound** | 3 | Parte 4 (Gale Deflection) e passo 6.2 |
| **3** | **Eternal** | nível do Hemoplague | Parte 5 (Hemoplague) |

Se for fazer só uma rodada, **faça a 1** — é onde está o teste mais importante (passo 2.2).

---

# Parte 1 — o mod carregou? (2 min)

### 1.1 Olhar o console

Logo depois de carregar o save, procure na janela do console a linha:

```
[ArcanaDeck] loaded
```

- ✅ Apareceu e não há linha vermelha de erro → siga.
- ❌ Apareceu erro com `Req` ou `Ext.Require` → **copie a mensagem inteira e pare o teste.** É problema meu.

### 1.2 Rodar a suíte de testes

No console, digite:

```
!arcanatest
```

**Esperado:** `99 passed, 0 failed`.

- ❌ Se der qualquer `failed`, copie as linhas `[FAIL]`.

### 1.3 Ver o que o mod enxerga do personagem

Com o Arcana **selecionado no jogo** (clique no retrato dele), digite:

```
!arcanapool
```

**Esperado:** uma lista com as categorias `Card`, `Created`, `Util` e — se o nível alcançar —
`Passive` (as cartas "Ready: ..."). 

- ❌ **Não pode aparecer nada de `Reaction`.** Se aparecer, me avise.
- ❌ Se a lista vier **vazia**, digite isto e me mande o resultado:
  ```
  _D(Ext.Entity.Get(Osi.GetHostCharacter()).SpellBook.Spells[1])
  ```

---

# Parte 2 — 🔴 o custo vira Threads (5 min) — O TESTE MAIS IMPORTANTE

É isto que valida a decisão de arquitetura do dia. Se falhar, eu reescrevo a Task 4 inteira.

### 2.1 Fora de combate

1. Esteja **fora de combate** (no acampamento serve).
2. Ache o **Distortion** na hotbar (ícone de teleporte roxo). Se não estiver, abra o livro de magias pelo
   ícone de livro na ponta direita da hotbar.
3. **Passe o mouse em cima e leia a tooltip.**

**Esperado:** custa **1 Woven Spell Slot** + **1 carta da mão** + 1 ação — para **qualquer** carta,
seja ela de nível 1 ou 6. **Não pode** mencionar *Arcane Essence* nem *Arcane Shards*.

> 🔴 **Este passo testa a terceira tentativa de resolver o mesmo problema, e vale entender por quê.**
> As duas primeiras assumiram que o motor paga um custo de nível N com um slot de nível maior. Ele não
> paga: no BG3 isso é feito com **variantes da magia** (1208 delas no vanilla, uma por nível acima),
> e nossas cartas não têm nenhuma.
>
> Então o `ArcanaSpellSlot` deixou de ser nivelado. Virou uma **reserva de pontos com cara de slot**:
> toda carta custa 1 ponto, e a quantidade de pontos é a mesma de espaços que um Wizard tem (2 no
> nível 1, 9 no 5, 22 no 20), recarregando em descanso longo.
>
> **Confirme aqui que uma carta de nível alto e uma de nível baixo custam o mesmo 1 ponto**, e que dá
> para conjurar as duas.

### 2.2 🔴 Em combate

1. Carregue um save **perto de inimigos** e entre em combate (ataque qualquer um).
2. Espere chegar o seu turno.
3. O Distortion precisa estar **na mão** — se ele estiver acinzentado, é porque não foi comprado; use
   `!arcanadraw 5` no console até ele aparecer aceso.
4. **Passe o mouse nele de novo.**

**Esperado:** agora custa **3 Threads + 1 carta**, e **nenhum ponto de Woven Spell Slot**.

5. **Conjure.** Confirme que os Threads caíram 3 e que a reserva de Woven Spell Slots **não** mexeu.

> **O que mudou desde a sua última rodada:** o `Replace` trocando um recurso por **outro** não existe
> no jogo — não há um só exemplo disso nos dados do vanilla, e era por isso que o custo não virava
> Thread. O que o vanilla faz, cinco vezes, é `Replace` com **o mesmo recurso e quantidade 0** para
> zerar, e `Add` para somar. O status agora faz os dois: zera o slot e soma os Threads.

### 2.3 Se o 2.2 falhar

Se continuar pedindo slot em combate, digite no console:

```
_D(Osi.HasActiveStatus(Osi.GetHostCharacter(), "ARCANA_WEAVING"))
```

| Resultado | O que significa | Anote |
|---|---|---|
| `0` | O status não está sendo aplicado. Erro meu no `Weaving.lua`. | **"caso 0"** |
| `1` | O status está lá; a sintaxe do boost é que não pegou. | **"caso 1"** |

**É só isso que eu preciso saber** — a partir daí eu sei exatamente o que corrigir.

### 2.4 Conferir outro nível

Mesma coisa com o **Sigil of Malice** (deve custar **1 Thread**) e, se tiver, o **Final Spark**
(**6 Threads**).

### 2.5 🔴 O truque custa 1 Thread

Passe o mouse no **Malicious Whispers**:

- **Fora de combate:** **nenhum** custo de recurso — truque não gasta espaço de magia. Só a ação e 1 carta.
- **Em combate:** **1 Thread** + 1 carta.

É o único caso em que o status **só soma** (não há slot para zerar), então ele testa a outra metade do
mecanismo. O **Reweave** é a exceção proposital: continua de graça, sem custo de carta nem de Thread.

### 2.6 🔴 O contador de cartas na mão

Olhe o painel de recursos, ao lado dos espaços de magia.

**Esperado:** um recurso **"Cards in Hand"** mostrando quantas cartas você tem. Ele desce 1 a cada carta
jogada e sobe a cada carta comprada. Compare com o `!arcanahand`: os dois números têm de bater.

É esse recurso que faz o motor saber o que é carta — inclusive o truque, que não gasta espaço de magia.

### 2.7 Texto sobre o personagem

A cada compra e a cada carta jogada deve aparecer um texto flutuante sobre o personagem:
`Drawn: <nome>`, `Played: <nome>`, e `Unravelled: <nome>` quando uma carta é exilada por estouro de mão.

No turno 1 saem 4 de uma vez, então pode empilhar. `!arcanatext off` desliga, `on` religa.

---

# Parte 3 — o deck funcionando (5 min)

Ainda no mesmo combate:

### 3.1 O que brilha e o que trava

Olhe a hotbar.

**Esperado:** só as cartas **da mão** estão acesas. As outras estão acinzentadas, **na mesma posição de
sempre** (nada muda de lugar). Passe o mouse numa acinzentada: a tooltip mostra **"Not in Hand"**.

### 3.2 Mão de abertura e energia

No seu **primeiro turno** do combate:

```
!arcana
```
**Esperado:** `hand` com **4 cartas** (fora as Fated, que vêm por cima do limite) e o **Reweave**.

```
!arcanathreads
```
**Esperado:** `current 1` se o personagem for nível 1–4. Em nível 11+, `current` começa em 4.

### 3.3 Reweave (o mulligan)

Conjure o **Reweave** (ícone de magia tempestuosa, está na mão no turno 1).

**Esperado:** a mão inteira é trocada por cartas novas e o próprio Reweave some.

### 3.4 Reserva e teto

1. Passe o turno **sem gastar nada**.
2. No turno seguinte: `!arcanathreads`.

**Esperado:** o valor subiu e ainda somou reserva (guarda no máximo **2**). **Nunca passa de 6.**

### 3.5 Limite de mão

```
!arcanadraw 12
```
```
!arcana
```
**Esperado:** `hand` para em **10**; o excedente aparece em `unraveled`.

### 3.6 Descarte

Conjure qualquer carta e rode `!arcana`.

**Esperado:** ela está em `frayed`.

### 3.7 Fim do combate

Mate os inimigos e rode `!arcana`.

**Esperado:** `combat = nil` e **todas** as magias destravadas na hotbar.

### 3.8 Salvar e carregar no meio do combate

Entre em combate de novo, salve, carregue o save e rode `!arcana`.

**Esperado:** a mão bate com o que está aceso na hotbar. Depois rode `!arcanareset`: nada duplica nem
fica travado.

---

# Parte 4 — 🔴 reações (5 min por reação)

**Tudo aqui é novo de hoje.** A ideia: fora de combate a reação funciona como sempre; em combate ela fica
desligada até você jogar a carta "Ready: ...".

## 4A — Gale Deflection *(rodada Unbound, nível 3+)*

Precisa de **inimigos com ataque à distância** (arco/besta). Acampamento goblin serve.

### 4A.1 Fora de combate
Leve um tiro sem estar em combate (difícil de forçar — se não conseguir, pule).
**Esperado:** a reação é oferecida normalmente.

### 4A.2 🔴 Em combate, antes da ativação
Entre em combate e deixe um arqueiro atirar em você.

**Esperado:** a reação **não** é oferecida. Nenhum pop-up de reação aparece.

### 4A.3 🔴 Jogar a carta de ativação
Ache **"Ready: Gale Deflection"** na mão (ícone de desviar projétil). Se não estiver na mão,
`!arcanadraw 5`.

**Esperado:** custa **2 Threads** e **nenhuma ação** (nem ação, nem bônus). Conjure.

### 4A.4 Depois da ativação
Deixe outro arqueiro atirar.

**Esperado:** agora a reação é oferecida, e continua sendo **pelo resto do combate**.

### 4A.5 Ricochete
Depois de desviar um tiro com sucesso, deve aparecer a segunda reação, a de **devolver o projétil**.

### 4A.6 Fim do combate
Termine o combate, entre em outro **sem descansar**.
**Esperado:** a reação está desligada de novo (e a carta "Ready" voltou para o deck).

## 4B — Instinctive Charm *(rodada Deceiver, nível 5+)*

Mesma sequência, com um inimigo **atacando você corpo a corpo**:
1. Em combate, antes de ativar → a reação **não** aparece.
2. Jogue **"Ready: Instinctive Charm"** (**2 Threads**, sem ação).
3. Agora a reação aparece quando você é atacado.

## 4C — Hollow Image *(rodada Deceiver, nível 11+)*

1. Em combate, antes de ativar → **não** aparece.
2. Jogue **"Ready: Hollow Image"** (**3 Threads**, sem ação).
3. Use a reação neste turno.
4. **No turno seguinte, use de novo.** *Esperado:* ela **recarregou** (é a única das três que recarrega
   todo turno).

## 4D — as cartas se escondem sozinhas

Fora de combate, procure as cartas "Ready: ..." na hotbar.

**Esperado:** elas **não aparecem** (ou aparecem travadas). Elas só existem em combate e só quando a
reação está desligada — assim você não gasta um slot à toa.

---

# Parte 5 — contêineres: Hemoplague e Mimic (5 min)

## 5A — Hemoplague *(rodada Eternal)*

1. Em combate, com o **Hemoplague** na mão, conjure num inimigo.
2. **Esperado:** o jogo abre um menu com as **6 doenças** (Blinding Sickness, Filth Fever, Flesh Rot,
   Mindfire, Seizure, Slimy Doom).
3. Escolha uma.
4. **Esperado:** cobra **4 Threads** — **uma vez só**, não duas.
5. `!arcana` → **as 6 doenças não podem aparecer** na mão, no deck nem nas pilhas.
6. Enquanto o Hemoplague está na mão, as 6 opções aparecem **acesas**, não acinzentadas.

## 5B — Mimic *(rodada Deceiver)*

1. Conjure o **Distortion**.
2. **Esperado:** aparecem na mão o **Withdraw** e o **Mimic Distortion**, acesos, e o contêiner **Mimic**
   também acende.
3. Passe o turno. **Esperado:** o Mimic Distortion some da mão.

---

# Parte 6 — correções pontuais (3 min)

### 6.1 Arcane Recovery *(qualquer subclasse)*
Fora de combate, conjure o **Arcane Recovery**.

**Esperado:** devolve **1 ponto**, 1x por descanso longo. E agora **funciona dentro do combate** —
mas só para o console: na edição com SE o deck tranca toda Util em combate, então você o verá acinzentado.
O recurso agora se chama **Woven Spell Slots**, não "Arcana Spell Slot".

❌ Se não devolver nada, me avise.

### 6.2 Evasive Flow EX *(rodada Unbound)*
Olhe as magias ganhas no **nível 4**.
**Esperado:** o **Evasive Flow EX não está lá** (ele só entra no nível 13).

### 6.3 Howl of the Dead
Procure na lista de magias.
**Esperado:** aparece **sem o sufixo EX** e como **truque** (sem custo).

### 6.4 Familiares fora do combate
Em combate, procure os **familiares arcanos** (Cat, Dog, Crab, Frog, Rat, Raven, Spider).
**Esperado:** não dá para conjurar nenhum — eles ganharam `Requirements "!Combat"` nos stats, então é o
próprio jogo que bloqueia, sem depender do Lua. Fora de combate continuam normais.
Confira também que **não aparecem mais** no `!arcanapool`, junto com as ~40 variantes do Faceless.

### 6.5 Utilitarias de graca
Todas as utilitarias devem custar **zero** recurso. Dispel Magic, Third Eye: Projection e Arcane Gate
ganharam **1x descanso longo** (antes nao tinham recarga nenhuma).

### 6.6 Varredura geral
Passe o olho nas tooltips das magias da Arcana.
**Esperado:** **nenhuma** menciona *Arcane Essence* ou *Arcane Shards*.

---

# Parte 7 — o que já está quebrado (não investigue)

Só confirme, para sabermos o tamanho do estrago. Já sei que estão assim:

- **Arcana Mastery** ("próxima magia de graça") não faz mais nada.
- **Mirrored Charm** nunca liga (ela exige 2 Arcane Essence).
- Qualquer coisa que dependa de **Osiris** pode se comportar de forma estranha, porque a Story ainda está
  compilada com os nomes antigos.

---

# Ficha de anotação

Copie e preencha — é o que eu preciso de volta:

```
RODADA 1 (Deceiver nv __)
1.1 [ArcanaDeck] loaded ........ ( ) ok  ( ) erro: ____________________
1.2 !arcanatest ................ ____ passed, ____ failed   (esperado 99)
1.3 !arcanapool ................ ( ) ok  ( ) vazio  ( ) apareceu Reaction

2.1 Distortion fora de combate . ( ) 1 slot nv3   ( ) outro: __________
2.2 Distortion EM COMBATE 🔴 ... ( ) 3 Threads    ( ) continuou slot
2.3 se falhou .................. ( ) caso 0       ( ) caso 1
2.4 Sigil=1 / Final Spark=6 .... ( ) ok  ( ) ____________
2.5 truque custa 1 Thread 🔴 ... ( ) ok  ( ) ____________
2.6 contador Cards in Hand 🔴 .. ( ) bate com !arcanahand  ( ) nao aparece
2.7 texto sobre o personagem ... ( ) ok  ( ) nao aparece

3.1 só a mão brilha ............ ( ) ok
3.2 mão 4 + Reweave ............ ( ) ok    threads turno 1: ____
3.3 Reweave troca a mão ........ ( ) ok
3.4 reserva / teto 6 ........... ( ) ok
3.5 mão para em 10 ............. ( ) ok
3.7 fim do combate destrava .... ( ) ok
3.8 salvar/carregar ............ ( ) ok

4B Instinctive Charm 🔴 ........ desligada? ( )  ativação 2 Threads? ( )  voltou? ( )
4C Hollow Image 🔴 ............. desligada? ( )  recarrega por turno? ( )
4D cartas escondidas fora ...... ( ) ok

5B Mimic ....................... ( ) ok

6.1 Arcane Recovery 🔴 ......... ( ) devolveu 1 slot  ( ) não devolveu
6.3 Howl of the Dead truque .... ( ) ok
6.4 familiares fora do combate . ( ) ok
6.5 nenhum Essence/Shards ...... ( ) ok


RODADA 2 (Unbound nv __)
4A Gale Deflection 🔴 .......... desligada? ( )  ativação 2 Threads? ( )  voltou? ( )
4A.5 ricochete ................. ( ) ok
6.2 Evasive Flow EX fora do nv4  ( ) ok

RODADA 3 (Eternal nv __)
5A Hemoplague 🔴 ............... 6 opções? ( )  cobrou 4 uma vez? ( )  fora do !arcana? ( )
```

**Se for me mandar só três coisas, mande estas:** o resultado do **2.2** (e o caso do 2.3 se falhou), o do
**4B/4A** (reação desliga e a carta devolve) e o do **6.1** (Arcane Recovery).

---

# Parte 8 — Reteste depois do modelo Warlock (2026-09-22)

**Faça respec antes de qualquer coisa.** A progressão mudou; num save antigo o personagem continua com
os espaços do modelo velho e nada disto vale. Espelho de Loss → Respec.

| # | O que fazer | O que tem de acontecer |
|---|---|---|
| 8.1 | Olhe a barra de recursos, fora de combate | Aparece **Woven Spell Slots**. Nível 1–2 do personagem: 2 espaços de nível 1 |
| 8.2 | Olhe a barra de novo | Aparece o contador de **cartas na mão** (estava escondido até agora) |
| 8.3 | Abra uma carta de nível 2 (ex.: Distortion) com o personagem de nível 3+ | Conjurável. Se pedir "nível exato", o modelo falhou |
| 8.4 | Passe o mouse na mesma carta | Aparece o seletor de nível (1 a 6), como numa magia vanilla |
| 8.5 | Conjure num nível acima do da carta | Sai a magia. O dano **não** aumenta — isso é esperado, quem escala é o `LevelMap` |
| 8.6 | Suba para o nível 3 do personagem | Os espaços de nível 1 **zeram** e viram 6 de nível 2 |
| 8.7 | Entre em combate e rode `!arcanahand` | A mão tem 4 cartas. Nenhuma variante `_2`, `_3`… listada como carta |
| 8.8 | Em combate, tente conjurar uma carta que **não** está na mão, usando o seletor de nível | **Tem de estar bloqueada em todos os níveis.** Se der para conjurar subindo o nível, é o furo do item "variantes" |
| 8.9 | Em combate, conjure uma carta da mão | Cobra Thread, não espaço. Anote quantas Threads sumiram e em que nível você conjurou |

O 8.9 é o que eu não consigo prever: não sei se o custo em Threads segue o nível da carta ou o nível em
que você conjurou. Anote os dois números que eu fecho isso.
