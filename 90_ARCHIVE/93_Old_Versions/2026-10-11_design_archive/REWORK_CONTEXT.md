# The Arcana — contexto do projeto

> **Documentos mais novos (2026-09-17), que valem sobre este onde houver conflito:**
> - `specs/2026-09-17-deck-core-design.md`: arquitetura do deck (edição SE), nomes e palavras-chave.
> - `specs/2026-09-17-resource-economy.md`: números de todos os recursos (mão, deck, Threads por nível, reserva, custos, Woven Spell Slots). Substitui a seção 4 daqui.
> - `plans/2026-09-17-deck-core.md`: plano de implementação da v1.

> **Status: em desenvolvimento ativo.** Este documento descreve uma reformulação grande do mod que **ainda não foi implementada**. Nada aqui é código pronto ou decisão imutável — é o mapa do que estamos construindo juntos, em colaboração com o autor do mod. Quando uma seção disser "decidido", significa que a direção está fechada mas a implementação continua aberta a ajuste. Quando disser "em aberto", pergunte antes de assumir.
>
> Espere que partes deste documento fiquem desatualizadas conforme a implementação avança. Se algo no código contradisser o que está aqui, o código provavelmente é mais novo — confirme com o autor antes de "corrigir" qualquer um dos dois.
>
> **Documentos mais novos (2026-09-17), que valem sobre este:**
> - `specs/2026-09-17-deck-core-design.md` — núcleo do deck (edição SE). Substitui as seções 4 e 5.
> - `specs/2026-09-17-resource-economy.md` — balanceamento de todos os recursos: mão, compra, deck mínimo, Threads por nível, reserva, custo das cartas e `ArcanaSpellSlot` estilo Warlock. **A energia de combate agora é o `ArcanaThread`; o `ArcanaSpellSlot` virou os Woven Spell Slots, usados fora de combate e na edição console.**

---

## 1. O que é o mod

**The Arcana** é uma classe customizada para Baldur's Gate 3, publicada no Nexus e no mod.io. A identidade central é a de um **vidente**: um mortal tocado por Mystra, a Senhora dos Mistérios, que enxerga os fios do destino e os manipula. Adivinhação é o núcleo da classe base (Portent, Third Eye), e cada subclasse é um destino diferente traçado a partir dela.

Cada subclasse é ancorada num Arcano Maior do tarô, sem nunca nomear tarô na ficção.

### As quatro subclasses

| Subclasse | Arcano | Atributo | Papel | Deck temático |
|---|---|---|---|---|
| **The Deceiver** | III · A Imperatriz | Carisma | Controle e ilusão | Mirrored |
| **The Starchild** | XVII · A Estrela | Sabedoria | Cura e suporte celestial | Cosmic |
| **The Unbound** | 0 · O Louco | Destreza | Desarmado e mobilidade, sem armadura | Nomadic |
| **The Eternal** | XIII · A Morte | Constituição | Linha de frente necromântica, armadura pesada | Immortal |

Identidades resumidas, para manter o tom consistente ao escrever qualquer texto novo:

- **Deceiver** — rostos emprestados, mentes lidas, magias espelhadas. O narrador não confiável de qualquer sala em que entra. Forte em controle e utilidade, fraco em sustentação.
- **Starchild** — luz das estrelas que restaura. Cura, ressurreição, escudos solares e lunares. É curandeira, não oráculo: adivinhação pertence à classe base, não a ela.
- **Unbound** — vento, mãos livres, estrada aberta. Sem armadura, sem rota fixa. Não há atrito com Mystra na ficção dela; "Unbound" é sobre liberdade de movimento, não rebeldia.
- **Eternal** — atravessou o próprio fim e voltou. Resiste ao que deveria matá-la e comanda a morte alheia. Juggernaut que sobrevive por atrito.

---

## 2. As três frentes da reformulação

O que estamos construindo se divide em três eixos que se cruzam. Nenhum está implementado.

1. **Conexão temática mais forte com Mystra e a Trama** — novas magias e passivas organizadas em listas temáticas escolhíveis.
2. **Nova economia de recursos** — `ArcanaSpellSlot` como energia estilo Slay the Spire.
3. **Sistema de deck building de combate** — via Script Extender, em Lua.

Os três são independentes o bastante para serem implementados em ordens diferentes, mas o eixo 3 depende do eixo 2 estar definido.

---

## 3. Eixo temático — magia, Mystra e a Trama

### Listas temáticas

O jogador escolhe X magias de cada lista. Base: magias existentes do BG3, reaproveitando ícones, com rebalanceamento conforme o nível em que são recebidas.

| Lista | Escolhas | Conceito |
|---|---|---|
| **Hand** | 3 | Tema vem do ícone: toda magia mostra uma mão |
| **Ward Protection** | 2 | Glyphs, com efeitos extras e glyphs novos |
| **Sensations** | 2 | Uma magia por sentido humano |
| **Feelings** | 2 | Uma magia por emoção |
| **Wall** | 1 | Magias de parede |

**Hand** inclui Arcane Hand, Produce Flame, Bone Chill, e "Whossa Large Fellow" (Enlarge com ícone de mão aberta). *Em aberto:* a lista mistura cantrips e magias de nível 1, e ainda não foi decidido entre nerfar as de nível 1, bufar os cantrips, ou separar em duas listas.

**Sensations** — olfato, tato, visão, paladar, audição.

**Feelings** — mapeamento aceito por enquanto: amor/Charm Person, serenidade/Calm Emotions, medo/Fear, alegria/Tasha's Hideous Laughter, fúria/Crown of Madness, coragem/Heroism, esperança/Bless, desespero/Bane.

**Ward Protection** — quer efeito extra em cada glyph existente e glyphs novos: alertar quando alguém passa, enraizar no chão, marcar alvo com bola de luz.

### Temas aprovados

- **Tessituras** — metamagia paga com Arcane Cards. Sem Twinned, porque duplicação pertence ao Deceiver.
- **Destino** e **Tempo** — listas separadas, sem Hold.
- **Rasgo na Trama**
- **Eco de Magia** e **Selo da Senhora dos Mistérios** — passivas de nível alto.
- **Sete Estrelas** — *em aberto:* ainda não se sabe como fazer projéteis diferentes na mesma magia.

### Temas rejeitados

- **Passagens** — conflita com Unbound, Deceiver e Arcane Gate.
- **Elementos** — só entraria se cobrisse todos os elementos.

### Outras decisões

- Cada subclasse ligada a uma escola de magia; a classe base escolhe uma escola extra. A ideia de aprender magias no estilo do Wizard agradou.
- Find Familiar já existe no mod: animal escolhido no nível 1, sem troca.
- Animate Dead conflita com o Eternal.
- Spiritual Weapon no nível 1 está sendo considerado como opção barata.
- **Sistema de Boons** será separado, baseado na mitologia grega. Fora do escopo desta reformulação.
- **Arcane Shards** ficam fora desta mudança por ora.

---

## 4. Eixo de economia — `ArcanaSpellSlot`

**Decidido.** O recurso único Arcane Cards dá lugar ao `ArcanaSpellSlot`, que funciona como **energia estilo Slay the Spire**:

- Valor fixo, **recarregado no início de cada turno**.
- **Não acumula**: sobrou, perdeu. É isso que torna "gastar tudo" a jogada certa.
- Aumenta com a progressão de nível.

### Histórico das decisões descartadas

Registrado porque o autor mudou de ideia mais de uma vez e é útil saber o que já foi rejeitado:

1. Poucos slots estilo Warlock, renovando no descanso curto → descartado, não deixava combar magias num mesmo combate.
2. Meio-termo entre Warlock e Wizard, ainda no descanso curto → descartado pela decisão de energia por turno.
3. "A carta é o único custo, magia grátis em combate" → descartado; o custo agora é igual dentro e fora do combate.

### Cantrips

**Decidido.** Cantrips custam 1 `ArcanaSpellSlot` e **restituem 1 ao serem conjurados**. Na prática são grátis, mas exigem ter pelo menos 1 de energia — com o orçamento zerado, nem cantrip sai. O objetivo é que toda magia da classe passe pelo recurso.

*Atenção na implementação:* o functor `RestoreResource` em `SpellSuccess` só devolve a mana quando o ataque acerta. Se a intenção for devolver sempre, usar `SpellProperties`.

### As três moedas

A carta diz **o que**; a mana diz **quanto**; a ação diz o **ritmo**. Apenas a primeira é programada em Lua; as outras duas são economia nativa do BG3.

Movimento também é um `ActionResource` e pode entrar como custo em magias específicas, criando tradeoff posicional. *Em aberto.*

---

## 5. Eixo do deck building

**O sistema todo está por implementar.** Existe um guia de implementação separado, escrito passo a passo, que deve ser tratado como a especificação técnica.

### Regras

| Regra | Valor |
|---|---|
| Mão inicial | 3 cartas |
| Mão máxima | 5 cartas |
| Compra por turno | 1 (só se a mão tiver menos de 5) |
| Cópias repetidas na mão | permitido |
| Cópias do mesmo título no baralho | 0 a 3, escolha do jogador |
| Tamanho mínimo do baralho | 5 cartas |
| Carta jogada | vai para o descarte |
| Baralho vazio | descarte reembaralhado na hora |
| Início de combate | baralho remontado da lista, embaralhado, compra 3 |
| Fora de combate | baralho não se aplica, tudo disponível |

Referências de desenho: *Slay the Spire* para a energia e o reset por combate; *Lord of the Rings LCG* para o limite de 3 cópias por título.

### O princípio técnico central

**O script nunca adiciona nem remove magias.** Elas continuam sendo concedidas pela progressão, no toolkit. Continuam no grimório e na hotbar, na mesma posição.

Em combate, o script **bloqueia** o que não está na mão aplicando um boost que cobra um recurso impagável. O jogo desenha essas magias acinzentadas sozinho. As cartas da mão recebem um boost de brilho.

Isso foi escolhido em vez de duas alternativas rejeitadas:

- **Tirar as magias da progressão e defini-las só em Lua** — funcionaria, mas duplicaria manutenção e tiraria as magias do toolkit.
- **Usar `AddSpell`/`RemoveSpell` no grimório** — mexe no grimório de verdade, e level up, respec e recarregamento de save devolveriam magias sem avisar.

Com o modelo escolhido, o pior caso de qualquer bug é **magia acinzentada indevidamente**, nunca magia sumida.

### Os dois recursos necessários

- **`ArcanaSpellSlot`** — a mana. `MaxAmount` deve ficar 4 ou 5 acima do valor de recarga, para que cartas de energia tenham teto onde crescer.
- **`ArcanaLocked`** — recurso de bloqueio, máximo 0, nunca concedido. Seu `DisplayName` aparece na tooltip da magia bloqueada e deve ser localizado como algo que explique a regra: **"Not in Hand"**.

### Os dois boosts

```
LOCK: UnlockSpellVariant(SpellId('%s'),ModifyUseCosts(Add,ArcanaLocked,1,0),ModifyTooltipDescription())
GLOW: UnlockSpellVariant(SpellId('%s'),ModifyUseCosts(Add,ArcanaSpellSlot,0,0),ModifyIconGlow(),ModifyTooltipDescription())
```

`ModifyTooltipDescription()` faz a tooltip recalcular e refletir a variante — sem ele, a magia acinzenta mas a tooltip pode continuar mostrando o custo original, e o jogador não entende o motivo.

*Em aberto:* o `ModifyUseCosts` de 0 no GLOW é um no-op que existe caso a variante precise de uma modificação concreta para registrar. Se o brilho funcionar sem ele, remover. Se não funcionar de jeito nenhum, o brilho é dispensável.

### Convenção de nomes

O pool de cartas é **derivado do grimório**, não de uma lista manual. Isso exige prefixo:

- `Arcana_Card_...` → entra no baralho
- `Arcana_Util_...` → nunca vira carta (Portent, Third Eye, Arcane Gate, Comprehend Languages)

Consequência boa: nível e subclasse são respeitados automaticamente, porque magia que a progressão ainda não deu não está no grimório. Magia nova entra no sistema só por existir com o prefixo certo.

### Arquitetura em Lua

```
SeuMod/ScriptExtender/
├── Config.json                  RequiredVersion 32, ModTable ArcanaDeck
└── Lua/
    ├── BootstrapServer.lua
    ├── Server/Deck.lua          toda a lógica
    ├── BootstrapClient.lua      só na fase de visualização
    ├── Shared/Channels.lua      só na fase de visualização
    └── Client/DeckText.lua      só na fase de visualização
```

Regras de ouro do código:

1. **Nunca chamar `AddBoosts`/`RemoveBoosts` fora da função `SyncLocks`.** Mudar só o estado e chamar Sync. A função é idempotente e sempre converge.
2. **Estado persistido em ModVars**, nunca em variável Lua solta. E a escrita precisa reatribuir o objeto inteiro: mutar subpropriedade não marca a variável como suja e a mudança não vai pro save.
3. **`applied` guarda a string exata do boost**, não `true`, porque uma magia troca de boost ao sair da mão.
4. **Fim de combate usa `CombatEnded` (aridade 1)**, não `LeftCombat`, para que ninguém destrave o pool enquanto a luta continua.

### Fases de implementação

1. Instalar o SE e ver o console abrir.
2. Criar os dois `ActionResource`.
3. Testar o boost de bloqueio manualmente no console, antes de qualquer código.
4. Derivar o pool do grimório e validar com `!deckpool`.
5. Baralho, mão, descarte e sincronização.
6. Energia e ganchos de combate.
7. Edição do baralho.
8. Visualização interina via passiva com descrição dinâmica.
9. **Futuro:** UI de cartas de verdade, com `Ext.UI` no cliente.
10. **Futuro:** passivas de combate viram cartas jogáveis. Não exige mudança arquitetural — para o sistema, uma carta é só um nome de magia, e uma passiva jogável é uma `Shout` sem alvo que aplica status.

---

## 6. Questões em aberto

Perguntar ao autor antes de decidir qualquer uma:

- Lista **Hand**: nerfar magias de nível 1, bufar cantrips, ou separar em duas listas?
- **Sete Estrelas**: como fazer projéteis diferentes na mesma magia?
- Movimento entra como custo em quais magias, se entrar?
- Quais magias existentes viram carta e quais ficam como utilitárias fora do baralho?
- Cartas de compra extra no baralho base — com energia fixa, o gargalo tende a ser a mão, não o orçamento.
- Quantas cartas de economia (energia extra, custo restituído) e em quais subclasses?
- O `ReplenishType` do `ActionResource` resolve a recarga por turno, ou vai precisar de refil por script?

---

## 7. Como trabalhar neste projeto

- **Nada aqui é definitivo.** O autor mudou de direção várias vezes ao longo do desenho, e isso é saudável. Se uma decisão parecer inconsistente com outra, aponte em vez de escolher sozinho qual vale.
- **Levante consequências de desenho, não só de código.** Boa parte do valor até aqui veio de apontar que uma decisão abria um buraco em outro lugar: energia que não recarrega fora de combate, teto de recurso que impede cartas de energia funcionarem, duplicata na mão que não vira duas conjurações.
- **Sintaxe de boost e de functor falha em silêncio.** Nunca assuma que uma string funciona: sempre indique como testar no console e o que olhar na tooltip.
- **O autor nunca usou Script Extender antes.** Explique o porquê das escolhas, não só o que digitar. O projeto também serve como aprendizado e portfólio.
- **Escreva textos de ficção em inglês**, no registro seco e compacto da Larian: primeira frase estabelece origem ou natureza, segunda entrega a promessa de jogo. Evitar nomear tarô diretamente.
- **Conversa em português**, código e conteúdo do jogo em inglês.
