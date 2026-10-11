# Como uma carta é paga — o modelo que ficou de pé

Fecha a pergunta que arrastou três tentativas falhas: **por que uma carta de nível 2 não era conjurável
com um espaço de nível 5.**

## A leitura errada

Eu tratei "o Warlock conjura em qualquer nível" como uma regra de custo frouxa. Não é. O motor **nunca**
paga um custo de nível N com um espaço de nível maior. O que o Warlock faz — e o que o jogo inteiro faz —
é conjurar **outra entrada de magia**, uma por nível. O jogo base traz 1208 dessas
(`Projectile_MagicMissile_2` até `_6`). Quem parece flexível é a UI, não a economia.

## O que passou a valer

### 1. O espaço sobe de nível com o personagem

Igual ao Warlock vanilla, conferido na `Shared.pak`:

```
Warlock nv 3   ActionResource(WarlockSpellSlot,2,2);ActionResourceOverride(WarlockSpellSlot,0,1)
```

Duas coisas que eu tinha errado e o vanilla corrigiu:

- o `ActionResource` traz o **total novo**, não um incremento;
- o `ActionResource` vem **antes** do `ActionResourceOverride`.

A faixa da Arcana, mantendo a curva de quantidade que já existia (2, 4, 6, 7, 9 … 22):

| Personagem | 1–2 | 3–4 | 5–6 | 7–8 | 9–10 | 11+ |
|---|---|---|---|---|---|---|
| Nível do espaço | 1 | 2 | 3 | 4 | 5 | 6 |

Teto em 6 porque nenhuma carta passa de 6.

### 2. Cada carta ganhou suas variantes

`Design/Rework/tools/gen_upcast_variants.pl` — **187 variantes para 57 cartas**, nos dois lados
(`Stats/Generated` e as tabelas do Editor). A variante é idêntica à carta menos o custo:

```
new entry "Target_Arcana_Card_Spell_Distortion_5"
using "Target_Arcana_Card_Spell_Distortion"
data "RootSpellID" "Target_Arcana_Card_Spell_Distortion"
data "PowerLevel" "5"
data "UseCosts" "ActionPoint:1;ArcanaSpellSlot:1:5;ArcanaHandCard:1;"
```

Conjurar num nível maior **não deixa a carta mais forte** — a potência continua vindo do `LevelMap`, que
escala pelo nível do personagem. A variante só existe para a carta poder ser paga.

> ⚠️ **Rode o gerador de novo** sempre que acrescentar, renomear ou mudar o nível de uma carta. Ele é
> idempotente: apaga as variantes anteriores antes de gerar.

### 3. O recurso fantasma saiu

`ArcanaSpellSlotUnlock` existia só para destravar a tela de criação de personagem. Com o espaço de
verdade subindo de nível, não tem mais função — definição e a linha de progressão que o concedia foram
apagadas.

### 4. O contador de cartas na mão estava escondido

`ArcanaHandCard` tinha `IsHidden true`. Era por isso que ele nunca apareceu no painel, apesar do
`ShowOnActionResourcePanel true`. Agora aparece.

## O que a variante quebrou no Lua, e que foi consertado junto

Uma variante é **uma magia própria** no grimório. Sem tratamento, duas coisas dariam errado:

1. o deck contaria `Distortion`, `Distortion_3`, `Distortion_4`… como cartas diferentes — o baralho
   quadruplicaria;
2. pior: com a carta **fora da mão**, o bloqueio pousa em `Distortion`, e `Distortion_4` continuaria
   conjurável. O jogador furaria a mão inteira subindo um nível.

A correção: `Po.Cards` ignora variantes, e `Po.Relevant` devolve cada variante com o campo `root`. O
`Sync` decide **pela carta dona** e escreve o boost **no nome da variante**. Dois testes novos travam
isso (101 no total).

## O que só o jogo pode dizer

- `IsSpellLevel(n)` no `ARCANA_WEAVING`: não sei se ele lê o `Level` herdado da base ou o `PowerLevel` da
  variante. Isso decide se conjurar acima do nível custa mais Threads em combate. Em combate o custo em
  espaço é zerado em todos os níveis (`-1`), então nos dois casos a carta sai — muda só o preço.
- Se o `ArcanaSpellSlot` finalmente aparece no painel do personagem.
- **Precisa de respec** para a progressão nova valer num save antigo.

---

## A regra, fechada (2026-09-23)

Toda entrada que paga com `ArcanaSpellSlot` obedece a duas condições. A primeira variante resolve; a
segunda, não — e é a que morde.

**1. Precisa de variante do seu nível+1 até 6.** O personagem só tem espaço de **um** nível por vez, e
do 11 em diante esse nível é 6. Sem a variante, a carta simplesmente não é conjurável. Vale inclusive
para `Created` e `Card_Passive`: eu as tinha deixado de fora porque em combate o `ARCANA_WEAVING` zera
o custo do espaço, mas **o `ARCANA_WEAVING` só existe na edição com SE** — no console o custo vale como
está escrito.

**2. O nível da carta não pode passar do nível de espaço que o personagem tem quando a recebe.** O BG3
não tem downcast: não existe conjurar nível 3 com espaço de nível 2. Uma carta que chega antes do
espaço fica morta *ocupando vaga no baralho* — continua sendo sorteada e entregue na mão.

`FlowState` e `MentalPrison` estavam nesse caso (nível 3, concedidas no personagem nível 3, quando o
espaço ainda é 2) e desceram para nível 2. **Confira esta condição sempre que mudar o nível de uma
carta ou o nível em que ela é concedida.** A faixa de referência:

| Personagem | 1–2 | 3–4 | 5–6 | 7–8 | 9–10 | 11+ |
|---|---|---|---|---|---|---|
| Nível do espaço | 1 | 2 | 3 | 4 | 5 | 6 |

### Uma ponta solta

`Shout_Arcana_Created_MimicWithdraw` tem `UseCosts ""` — vazio, o que **apaga** o custo herdado do
`Withdraw`. Ela não cobra ação, nem espaço, nem carta da mão, e por não cobrar `ArcanaHandCard` a
contagem do motor e a do Lua divergem quando ela é jogada. O provável é que devesse custar o mesmo que
o `Withdraw` (`BonusActionPoint:1;ArcanaSpellSlot:1:1;ArcanaHandCard:1;`). Não mexi: é decisão de
carta, não conserto óbvio.

Os três `Deceiver_Clone_Mirror*` também zeram o custo herdado, mas ali está **certo** — quem conjura é
o clone, não o jogador, e ele não deve gastar a mão nem os espaços de quem o invocou.

---

## O formato do custo (2026-09-23)

O Warlock **nunca** mostra seletor de nível: ele tem exatamente um nível de espaço pagável e o motor
escolhe a variante sozinho. A Arcana estava na mesma situação — o `ActionResourceOverride` zera o nível
anterior, simulei a progressão linha por linha — e mesmo assim obrigava o jogador a clicar. A causa
eram duas divergências do vanilla:

**Custo em quatro partes, e pelo GRUPO.** Todos os **2288** custos de magia do jogo base são `grupo:min:max:nível` -- nenhum cobra um recurso de espaço direto.
Existem `SpellSlotsGroup:2:2:1` e `3:3:1`, que é o que prende `min`/`max` como sendo a quantidade. Os
meus tinham três partes (`ArcanaSpellSlot:1:4`), que o motor provavelmente lia como *min 1, max 4,
nível 0* — e sem nível, nada lhe diz qual variante casa com o espaço do personagem.

**`SpellType` explícito nas variantes.** 2276 de 2276 variantes do vanilla declaram. As minhas herdavam
pelo `using`. Agora declaram, na posição do vanilla: depois do `type`, antes do `using`.

## Progressão: incremento dentro da faixa

Concessões **no mesmo nível somam**. O Warlock faz `ActionResource(WarlockSpellSlot,1,1)` no personagem
1 e de novo no 2, chegando a 2. Eu tinha escrito o total acumulado em toda linha, o que compunha: o
nível 20 entregava **133** espaços em vez de 22. Dentro da faixa vai o incremento; na troca de faixa vai
o total novo, porque ali o override acabou de zerar o nível de baixo.

## Onde nome de magia importa, e onde não importa

| Contexto | Enxerga a raiz? | O que fazer |
|---|---|---|
| Osiris (`UsingSpell`, `CastSpell`, `CastedSpell`) | **Sim** | nada — o `RootSpellID` resolve |
| Condição de boost (`SpellId()` em stats/`.khn`) | **Não**, é exata | enumerar cada variante |

A prova do primeiro: o vanilla dispara em `Target_DispelMagic`, `Target_Knock`, `Target_Invisibility`,
`Target_FreedomOfMovement` e `Target_ProtectionFromEvilAndGood` pelo nome nu, as cinco têm variante, e
**nenhum** goal do jogo base dispara num nome com sufixo `_N`. São regras que destravam as barreiras da
Creche e o orbe Thayan — se não pegassem upcast, seria um bug notório.

A do segundo: o vanilla escreve `SpellId('Target_Polymorph') or SpellId('Target_Polymorph_5') or
SpellId('Target_Polymorph_6')`, um por um. Por isso o `IsDeceiverOneTargetSpell.khn` passou a ser
**gerado** pelo `gen_upcast_variants.pl` a partir de uma lista de cartas base — nunca mais fica para trás.

## O grupo (2026-09-23)

Nenhuma magia do jogo base cobra `SpellSlot` ou `WarlockSpellSlot` pelo nome. Os **2288** custos passam
pelo `SpellSlotsGroup`, um `ActionResourceGroup` que guarda os três recursos de espaço. Cobrar o
recurso direto, como a Arcana fazia, é uma forma que o motor não é pedido a tratar em lugar nenhum.

Agora existe o **`ArcanaSpellSlotsGroup`** (`8c9de04f-9bbc-4be9-8cb2-120bfca07777`), com o
`ArcanaSpellSlot` sozinho dentro, e os 255 custos leem `ArcanaSpellSlotsGroup:1:1:N`.

Três coisas que andam juntas e não podem sair de sincronia:

| | |
|---|---|
| Custo das cartas | `ArcanaSpellSlotsGroup:1:1:N` |
| `ARCANA_WEAVING` em combate | zera o **grupo**, não o recurso |
| Progressão | continua concedendo o **recurso** `ArcanaSpellSlot` |

A última é a que confunde: grupo só existe do lado do custo. O vanilla faz igual — concede
`WarlockSpellSlot` e cobra `SpellSlotsGroup`.

**Não mexer no grupo do vanilla.** Ele é compartilhado e não saberia distinguir uma carta da Arcana de
uma magia ganha por multiclasse.

O esquema da tabela do Editor está em `Editor/Config/UuidObjects/TableDefinitions.sod`, no
`stat_object_definition` `bcad45c2-a20a-42d5-8192-7dc1b0ae7ee3`: `Name`, `UUID`, `NameFS`,
`ActionResourceDefinitions`. Vale consultar sempre que for escrever um `.tbl` à mão — chutar ali é
perigoso, porque o Toolkit regenera o `.lsx` a partir dele.
