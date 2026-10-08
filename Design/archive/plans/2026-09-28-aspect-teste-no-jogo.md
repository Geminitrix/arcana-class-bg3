# Despertar do Aspecto — teste no jogo

Guia para o primeiro teste do Despertar do Aspecto (spec `specs/2026-09-28-aspect-awakening-design.md`,
plano `plans/2026-09-28-aspect-awakening.md`). Cada passo diz o que fazer, o que deve acontecer e o que
anotar se não acontecer. O `S` na frente é a dúvida da spec que o passo responde.

## 0. Antes de abrir o jogo

1. **Toolkit → Reload Stats.** Os arquivos novos são `Spell_Rush.txt`/`Rush.stats` e `Status_DOWNED.txt`.
   Se o Toolkit não mostrar o Leap of Faith na lista de Rush, anote: pode ser que ele não pegue um `.stats`
   novo sem reiniciar.
2. **Story Editor → compilar.** Ler `Story\log.txt` até a linha final `N error(s), M warning(s)`.
   - Precisa dar **0 erros**. Um erro de tipo (CHARACTER/GUIDSTRING) aponta a linha do goal; me mande a linha.
   - Avisos que importam: `Database defined but never checked` com nome `DB_ARCANA_*`.
   - O goal `ARCANA_Passive_DarknessRise` foi apagado de propósito.
3. **Publicar** e abrir o **jogo com Script Extender**. O play mode do Toolkit roda sem SE, então lá não
   há Threads nem mão, e a carta do Aspecto só aparece no spellbook (é o comportamento do console).

Personagem de teste: um de cada subclasse, **nível 12** (para ver os três tiers). Para os passos de tier
único, nível 3 serve.

## 1. The Fool (Unbound)

| # | Faça | Deve acontecer | Se não |
|---|---|---|---|
| 1.1 | Tier I (nível 3), com 2+ inimigos vivos: acerte 1 inimigo | **Wanderlust** mostra 1 | — |
| 1.2 | Acerte de novo o mesmo inimigo nesta rodada | Continua em 1 (repetido não conta quando há inimigos suficientes) | — |
| 1.3 | No próximo turno, sem ter chegado a 2 | O contador zera (a rodada acabou) | Anote se o número continuar |
| 1.3b | Com **1** inimigo vivo no início do turno, acerte-o 2 vezes (ataque e Zephyr) | Desperta | — |
| 1.3c | Gale Deflection devolvendo um projétil e acertando | Conta como acerto | Anote se não contar |
| 1.4 | 2 inimigos diferentes na mesma rodada (Tier II: 3, Tier III: 4) | **0 - The Fool** com o VFX do Haste; +3 m de movimento; andar sem ataque de oportunidade; +1d4 Trovão desarmado | — |
| 1.5 | (Nível 7+) Faça o Zephyr | Não gasta Bonus Action na primeira vez do turno; na segunda, gasta | — |
| 1.6 | (Nível 12) Deixe um inimigo te atacar | Aparece o prompt do **Fool's Luck**; aceitando, o ataque erra. Só uma vez por rodada | — |
| 1.7 (S3) | Jogue **Leap of Faith** através de 2 inimigos em linha | Rola ataque contra os dois; depois você tem o Zephyr Strike | Anote se só acertou o primeiro (`OnlyHit1Target`) |
| 1.8 (S9) | Use Wind Whispers e passe o turno; deixe um inimigo corpo a corpo errar você | O Wind Whispers ainda está ativo no turno do inimigo e o **Wind Riposte** revida sozinho, gastando a reação (conta para o Wanderlust) | Anote se o status já tiver sumido |
| 1.9 | Evasive Flow | Pular sem Bonus Action e Vantagem no próximo golpe desarmado; **não** anda mais sem ataque de oportunidade | — |
| 1.10 | Use qualquer carta (Flow State, Storm Fists, Thunderclap, Wind Blast, Evasive Flow, Gale Burst, Untethered) ou True Strike | O **Zephyr Strike** fica disponível no mesmo turno. Durações: Storm Fists 3, Thunderclap 5, Flow State 5; o THP do Flow State bate com o texto (nível × 2) |
| 1.11 | Nível 3, veja as passivas | **0 - The Fool: Awakening** explica o objetivo por faixa de nível; o Tier I só fala dos bônus. Idem nas outras subclasses | 

## 2. The Empress (Deceiver)

| # | Faça | Deve acontecer |
|---|---|---|
| 2.1 | Marque com Sigil e detone com outra carta | Status **Obsession** avança 1 por detonação que deu dano |
| 2.1b | Com o alvo já marcado, jogue Sigil of Malice de novo e mate o alvo | O Obsession sobe **1**, não 2, e nenhum dano de Sigil aparece no log depois da morte (antes da correção de 29/09 aparecia) |
| 2.2 | 3 detonações | **3 - The Empress** com o VFX do Blur; a carta **Heartbreak** na mão |
| 2.3 (S8) | Um inimigo marcado ataca você | Ataca com Desvantagem. Marcado atacando outro aliado: sem Desvantagem |
| 2.4 (S5) | (Nível 7+) Detone uma marca com outro inimigo a menos de 6 m | A marca aparece nele, uma vez por turno |
| 2.5 | Jogue Heartbreak com 2+ marcas | Todas detonam, todos ficam Charmed 1 turno, e a marca **não** pula para ninguém |
| 2.6 | (Nível 12) Um inimigo te ataca | Prompt do **Beloved**: save de Sabedoria ou Charmed. Uma vez por rodada |
| 2.7 | Malicious Whispers num alvo marcado | Além do dano, o alvo fica **Paranoia** (sem reação) |
| 2.8 | Instinctive Charm | O atacante redirecionado ataca com Vantagem |

## 3. The Star (Starchild)

| # | Faça | Deve acontecer | Se não |
|---|---|---|---|
| 3.1 (S1) | Nível 3: cure um aliado ferido com Astral Infusion | **Beacon** aparece com a porcentagem da meta no ícone: meta 15 de cura efetiva no nível 3, então 5 de cura mostra **33**; desperta em 100 | Se nunca aparece, o `HitpointsChanged` não dispara com cura: me avise, o plano B é contar cartas de cura |
| 3.2 | Cure um aliado com HP cheio | Não conta nada (cura em excesso) | — |
| 3.3 | Chegue a 3 | **17 - The Star** com o VFX do Bless; carta **Wish Upon a Star** na mão | — |
| 3.4 | Desperto: cure ou jogue carta num aliado, e ataque com ele | Tier I: **Moonlit**, o próximo acerto causa +1d4 Frio e aplica Ray of Frost (−3 m). Tier II: Moonlit 2d4 e **Sunlit** (+1d4 Fogo e Burning por 2 turnos). Tier III: Sunlit 2d4 e **Eclipse** (resistência a Frio e Fogo por 2 turnos). Os status somem no primeiro acerto e duram 2 turnos | Anote se o dano sai mas o Ray of Frost / Burning não |
| 3.5 (S6) | (Nível 12) Deixe um aliado cair | Volta com metade do HP (sem THP: o Lunar Wisp da cura já cuida disso); o **Undying Hope** some de todos | Anote se ele caiu mesmo assim |
| 3.6 | (Nível 12) | **Sem** voo (saiu em 2026-09-29) | — |

## 4. Death (Eternal)

| # | Faça | Deve acontecer | Se não |
|---|---|---|---|
| 4.1 | Apanhe | **Sorrow** mostra a porcentagem dos 30% do HP máximo já perdidos (ex.: perder 15% mostra **50**); curar não volta; desperta em 100 | — |
| 4.2 (S2) | Use Indestructible e apanhe | Anote se o dano absorvido pelo THP conta | — |
| 4.3 | Chegue a 30% | **13 - Death** e a aura do **Darkness Rise** | — |
| 4.4 | (Nível 7+) Tome um golpe fatal | Fica com 1 HP (**Mourning**), uma vez | — |
| 4.5 (S7) | (Nível 7+) Um inimigo sozinho a 3 m ataca | Ataca com **Dread** (Desvantagem); com um aliado dele a 6 m, não | Anote qual dos dois casos falhou |
| 4.6 | (Nível 12) Mate um inimigo a até 9 m | Ganha 1 ação extra (**Harvest**), uma vez por turno | — |
| 4.7 | Jogue **The Final Toll** | Dano necrótico = HP perdido no combate, no máximo metade do seu HP máximo; se matar, levanta zumbi | Se o dano for 0, o registro não foi preenchido |
| 4.8 | Blood Offering | Perde 1/10 do HP (conta no Sorrow) e as cartas causam necrótico extra até o fim do turno | — |
| 4.9 | Death Ward | Não mira mais você mesmo | — |

## 5. Geral

1. **Mão (PC):** a carta do Aspecto entra na mão ao despertar, fica até o fim do combate e, jogada, vai
   para o exílio.
2. **Console (sem SE):** a carta aparece no spellbook ao despertar e some quando o combate acaba.
3. **Fim do combate:** todos os status de progresso, despertar, aura e marcas somem. O próximo combate
   começa do zero.
4. **Capstones:** um personagem nível 20 não tem mais as passivas de tarô fora de combate; Friends: Faux
   Amis (Deceiver) e Howl of the Dead (Eternal) aparecem no nível 13.
5. **Texto:** leia as descrições dos tiers, dos status e das cartas novas. Anote qualquer texto que não
   renderize (`[1]` cru, LSTag quebrada).
