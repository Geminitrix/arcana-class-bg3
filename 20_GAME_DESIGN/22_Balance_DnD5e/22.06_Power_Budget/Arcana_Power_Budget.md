# Orçamento de Poder · BG3 + The Arcana

> Documento de trabalho. Os pesos são **chutes calibrados**, não verdade: o playtest corrige.
> Valores vanilla marcados com **(conferir no jogo)** vêm de memória do 5e/BG3.
> Dados do Arcana lidos dos arquivos do mod (Progressions, Passive, Status_BOOST, Spell_*, LevelMapValues).

---

## 0. Resumo: o que a conta mostra

1. **O Arcana tem cartas demais por dia, e o culpado é o Arcane Recovery.** Com 2 × nível por uso e 2 descansos curtos, o orçamento diário fica entre **1,4× e 2,4× o de um Wizard** (4× no nível 1). Na prática, a partir do nível 5 a classe lança uma magia com custo em **todo** turno do dia e ainda sobra carta. Por isso a regra do Grimório "custo = nível da magia" deixa as magias vanilla importadas **baratas demais**: hoje 1 carta vale uns 3,5 pontos, e 1 slot de nível 1 vale 8.
   → **Correção sugerida:** Arcane Recovery = **nível de Arcana, 1x por descanso longo** (em vez de 2 × nível por descanso curto). Com isso, **1 carta ≈ 1 nível de slot** (≈ 6,5 a 8 pontos) e a regra do Grimório passa a fazer sentido.
2. **O Arcane Overflow (nível 14) torna gratuita toda magia de 1 carta** e gera Shards de graça, porque não tem limite por turno. Sugestão: **1x por turno, só em magias de custo 2 ou mais**.
3. **Nas contas de exemplo:**

   | Habilidade | Veredito | Motivo |
   |---|---|---|
   | Sete Estrelas | Balanceada | Com a correção do item 1 |
   | Glifo de Raízes | Armadilha | Dano e efeito baixos demais para 2 cartas |
   | Rasgo na Trama | Armadilha | Fraca no encontro comum; só vale contra grupos de conjuradores |
   | Starcall EX | Quebrada | Custa só Shards, então economiza a carta, e ainda cura em aura |

   Correções na seção 18.

---

## 1. Suposições (valem para tudo abaixo)

| Símbolo | Valor | Observação |
|---|---|---|
| E (encontros por descanso longo) | **4** | Com E = 6, recursos por descanso valem 50% menos por encontro |
| T (turnos por encontro) | **4** | Com T = 3, efeitos de "combate inteiro" valem 25% menos |
| E × T (turnos por dia) | **16** | |
| R (descansos curtos por descanso longo) | **2** | BG3 (conferir no jogo) |
| Usos típicos de "1x por descanso curto" | **2** (teto R+1 = 3) | O 1º uso só rende depois de gastar |
| Alvos esperados em área | Cone pequeno 2,5 · Esfera média 3 · Linha 2 · Zona 2 | Com 1 alvo, área vira alvo único e perde o bônus |
| Aliados perto (auras, fogo amigo) | 2 | |
| Aliados corpo a corpo que batem num alvo controlado | 1 a 2 | |

### Parâmetros por tier

| Tier | Níveis | CA inimiga | Seu ataque | Sua CD | Resist. inimiga | p(acerto) | p(falha no teste) |
|---|---|---|---|---|---|---|---|
| 1 | 1–4 | 13 | +5 | 13 | +2 | 0,65 | 0,50 |
| 2 | 5–8 | 15 | +7 | 15 | +3 | 0,65 | 0,55 |
| 3 | 9–12 | 16 | +9 | 17 | +4 | 0,70 | 0,60 |
| 4 | 13–16 | 17 | +10 | 18 | +5 | 0,70 | 0,60 |
| 5 | 17–20 | 18 | +11 | 19 | +6 | 0,70 | 0,60 |

**Fórmulas:**
- Ataque: `p = (21 − (CA − bônus)) / 20`, limitado a [0,05; 0,95].
- Dano esperado de ataque: `p × média + 0,05 × média dos dados` (o crítico dobra os dados).
- Teste de resistência: `p_falha = (CD − bônus − 1) / 20`.
- Vantagem: `1 − (1 − q)²`. Desvantagem: `q²`.

### Ajuste do bônus de resistência por atributo (soma ao "Resist. inimiga")

| Teste | Ajuste | Justificativa |
|---|---|---|
| FOR | −1 | Muitos conjuradores e criaturas pequenas |
| DES | 0 | Referência |
| CON | +2 | O teste mais forte dos inimigos do BG3 (conferir no jogo) |
| INT | −2 | O mais fraco; bestas e mortos-vivos |
| SAB | −1 (humanoides −2) | Goblins e bandidos têm SAB baixa (conferir no jogo) |
| CAR | −1 | |

---

## 2. A moeda: o que vale 1 ponto

**1 ponto = 1 de dano esperado contra 1 alvo, já com a chance de acerto descontada.** O resto é convertido para essa moeda.

| Moeda | T1 | T2 | T3 | T4 | T5 | De onde vem |
|---|---|---|---|---|---|---|
| **A** (valor da Ação Principal) | 4 | 8 | 11 | 12 | 12 (16*) | Dano esperado do Fire Bolt no tier (1d10 → 2d10 no nível 5 → 3d10 no nível 10, conferir no jogo). *16 se o framework de nível 20 der 4d10 no nível 17 |
| **Turno inimigo** (o que um inimigo padrão faz num turno) | 2A | 2A | 2A | 2A | 2A | Dano e pressão de um inimigo do mesmo tier |
| **1 PV curado em combate** | 0,6 | | | | | Curar só devolve; dano encurta a luta e evita o dano futuro |
| **1 PV curado fora de combate** | 0,2 | | | | | O descanso resolve |
| **1 PV temporário** | 0,5 | | | | | Parte se perde |
| **1 PV de dano evitado** (CA, resistência) | 0,6 | | | | | Igual à cura |

### Valor do slot de magia, S(N)

Custo fixo de "recurso" de uma magia de nível N. Vem da tabela de conversão de slots do Sorcerer (2/3/5/6/7 pontos de feitiçaria, conferir no jogo), com **1 ponto de feitiçaria = 4 pontos**.

| Slot | 1 | 2 | 3 | 4 | 5 | 6 | 7* | 8* | 9* |
|---|---|---|---|---|---|---|---|---|---|
| S(N) | **8** | **12** | **20** | **24** | **28** | **32** | 36 | 40 | 44 |

\*Extrapolação linear (o 5e não converte esses níveis). Só vale para os tiers 4–5.

### Orçamento diário de referência (Wizard puro, com Arcane Recovery de metade do nível, 1x por descanso longo, conferir no jogo)

| Nível | Slots (1º/2º/3º/4º/5º/6º…) | W = Σ S(N) + Recovery | Níveis de slot por dia |
|---|---|---|---|
| 1 | 2 | 24 | 3 |
| 3 | 4/2 | 68 | 10 |
| 5 | 4/3/2 | 128 | 19 |
| 7 | 4/3/3/1 | 176 | 27 |
| 9 | 4/3/3/3/1 | 260 | 41 |
| 11–12 | 4/3/3/3/2/1 | 328 | 53 |
| 15* | + 7º e 8º | 412 | — |
| 19* | + 5º, 6º, 7º, 8º, 9º | 524 | — |

**Orçamento total do dia:** `D = E×T×A + W` → T1 **132** · T2 **304** · T3 **504** · T4 **604** · T5 **716**.

---

## 3. Veredito

`R = Benefício ÷ Custo`

| R | Veredito |
|---|---|
| < 0,75 | **Armadilha** (ninguém deveria escolher) |
| 0,75 – 0,90 | **Fraco** |
| 0,90 – 1,10 | **Balanceado** |
| 1,10 – 1,25 | **Forte** (aceitável se for nicho) |
| > 1,25 | **Quebrado** |

**Passivas e features sem ação:** compare o valor por dia com uma fração de D.

| Tipo de feature | Fração de D por dia |
|---|---|
| Menor | ≈ 5% |
| Principal de subclasse | ≈ 10% |
| Feat | ≈ 7% |
| Capstone | ≈ 20% |

---

## 4. Economia de Ação

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| Ação Principal | **−A** | Custo de oportunidade: você deixou de lançar o cantrip de referência |
| Ação Bônus | **−0,6A** | No BG3 há muita coisa para fazer com ela (Shove, Jump, poção, ataque com a outra mão), mas rende menos que a ação |
| Reação | **−0,3A** | Quase sempre fica sem uso; o custo real é perder o ataque de oportunidade ou outra reação |
| Negar a reação do alvo | **+0,1A** por inimigo/turno | Evita ataque de oportunidade e contramágica; vale mais contra conjuradores |
| Movimento (custo) | **−0,02A por metro** gasto | 9 m ≈ 0,2A; importa mais para quem luta corpo a corpo |
| Dash / Disengage embutido | **+0,3A** por uso | Economiza uma ação bônus e evita ataques |
| Jump ampliado | **+0,1A** por uso | Posicionamento e altura |
| Ação livre / gatilho automático | **0** de custo | Não disputa nada da economia de ação; limite só pelo gatilho |
| Interrupt com prompt de reação | **−0,3A** | Igual à reação |
| Ação extra (tipo Haste / Action Surge) | **+1A** (ou o valor da melhor ação disponível) | Um turno com duas ações |
| Ataque Extra | **+0,9 × dano esperado do ataque** por turno | Dobra o dano de arma; é o marco do nível 5 dos marciais |
| Ataque extra por ação bônus | **+(valor do ataque) − 0,6A** | Só vale se o ataque passar de 0,6A |
| Ritual / uso fora de combate | **0** de custo de ação | Mas o valor também é de utilidade (seção 14) |
| Magia lançada como ação bônus | **−0,6A** em vez de −A | No BG3, ao que parece, é permitido lançar duas magias com nível no mesmo turno (conferir no jogo). Se for, a magia de ação bônus soma com a da ação e vale quase +0,4A pelo "tempo" do burst |

---

## 5. Recursos e Recargas

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| Uso ilimitado (cantrip) | **0** | O custo é só a ação; A já está calibrado nele |
| Cooldown de 1 turno | **−0,3 × benefício** | Impede o uso em turnos seguidos: U ≈ E×T/2 |
| Cooldown de 2 turnos | **−0,5 × benefício** | U ≈ E×T/3 |
| Cooldown de 3+ turnos | **−0,65 × benefício** | U ≈ 1 a 2 por combate |
| 1x por turno | **0** | Já é o limite da ação; só importa em gatilhos e reações |
| 1x por combate | U = **E = 4** | Some o benefício 4 vezes por dia e compare com D |
| Carga por descanso curto | U = **2 a 3** | |
| Carga por descanso longo | U = **1** | Por uso, pode ser até **2× o teto** do tier |
| Slot de magia nível N | **−S(N)** | Tabela da seção 2 |
| Pontos de Feitiçaria | **−4 por ponto** | Calibrado pela conversão de slots (conferir no jogo) |
| Fúria / Ki / Superioridade | **−(valor do dado ou efeito) × 1,2** | Recurso pequeno, recarga rápida |
| Canalizar Divindade | **−0,5 × S(maior slot do tier)** | 1–2 usos por descanso curto |
| Carga especial da subclasse | **−benefício ÷ U** | O custo é o que se deixa de fazer com a mesma carga |
| Custo de PV próprio | **−0,6 por PV** (−0,3 se houver cura própria na classe) | PV é dano que você tomou |
| Gastar Dados de Vida | **−0,4 por dado médio** | Reduz a cura do descanso curto |
| Recurso que só existe em combate | **×0,5 do valor da unidade** | Some ao fim da luta e só aparece depois de gastar outra coisa |
| Recurso gerado por uso (feedback positivo) | **+(recurso gerado × valor da unidade)** | Some no benefício; se o gerado puder pagar o gerador, é **loop** (seção 18) |
| Reembolso de recurso | **+(reembolso × valor da unidade)** por uso | Um reembolso igual ao custo deixa a magia **grátis** |
| Custo zero ocasional | **+(maior custo típico × valor da unidade)** por uso | O jogador sempre usa na magia mais cara |
| Recuperação no descanso curto (tipo Arcane Recovery) | **+(recuperado × valor da unidade) × U** | Compare com o Wizard: ≈ 8% de D |
| Componente consumível (pergaminho, poção) | **−(preço em ouro ÷ 10)** fora de combate; **0** se for comum | O ouro no BG3 sobra no meio do jogo |
| Taxa de câmbio entre recursos | Ver A1 | Sempre converta para **pontos** antes de comparar |
| **Limitador duplo** (recurso + cooldown) | **−1** extra e aviso | Se o recurso já limita, o cooldown é redundante e a opção cai abaixo da curva |

---

## 6. Dano e Ofensiva

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| 1d4 | **2,5** | Média (N+1)/2 |
| 1d6 | **3,5** | |
| 1d8 | **4,5** | |
| 1d10 | **5,5** | |
| 1d12 | **6,5** | |
| Modificador fixo +1 | **+1** por instância de dano | Não dobra no crítico |
| Modificador de atributo no dano | **+3 a +5** | Pelo tier |
| Dano físico | **×0,93** | Resistência física é comum em alguns inimigos (conferir no jogo) |
| Fogo, frio, relâmpago | **×0,95** | Resistências comuns |
| Ácido, trovão, radiante, psíquico | **×0,97** | Raramente resistidos |
| Necrótico | **×0,90** | Mortos-vivos resistem ou são imunes |
| Veneno | **×0,80** | O mais resistido do jogo |
| Força | **×1,00** | Quase nunca resistido |
| Ignorar resistência | **+5% a +20%** do dano | A base é o multiplicador do tipo (ex.: veneno 0,80 → 1,00) |
| Acerto automático | Trocar p por **1,0** (e sem crítico) | Confiabilidade total |
| Projéteis distribuíveis | **×1,10** | Finaliza alvos com pouca vida e divide entre inimigos |
| Faixa de crítico 19–20 | **+0,05 × dados** por ataque | Dobra a chance de crítico |
| Dados extras no crítico | **+0,05 × dados extras** | |
| Crítico automático (alvo paralisado ou adormecido) | Entra no controle (seção 8) | |
| Upcast | **Benefício extra ÷ custo extra**, avaliado à parte | O jogador escolhe quando vale |
| Escala com o nível do personagem | Calcule no **meio** e no **fim** do tier | Magias com custo fixo e dano crescente saem da curva nos tiers altos (ex.: Starcall) |
| Escala com o modificador | Assuma **+3 / +4 / +5 / +5 / +5** | |
| Alvo único | **×1** | |
| Múltiplos alvos / área | **×M(n)**, com `M(n) = 1 + (n−1) × 0,5` | Dano espalhado vale metade do focado, porque não tira inimigos da luta mais cedo |
| Tamanho da área | n: cone pequeno 2,5 · esfera média 3 · esfera grande 4 · linha 2 · zona 2 | Ver suposições |
| Fogo amigo | **×0,9** | Nem sempre dá para posicionar |
| Dano ao entrar ou terminar o turno numa zona | **dano × p × alvos × 0,5** por turno | A IA do BG3 costuma evitar zonas |
| Dano extra condicional | **dano × frequência da condição** | Ex.: "vs. marcado" com 60% de uptime → ×0,6 |
| Execução / dano extra em alvo com pouca vida | **dano × 0,3** | A condição só aparece no fim da luta |
| Alcance de toque | **−0,1A** | Expõe o conjurador |
| Corpo a corpo 1,5 m | **0** | Para quem já está na linha de frente |
| 9 m | **0** | |
| 18 m | **+0,05A** | Referência dos cantrips |
| Precisa de linha de visão | **0** | É o normal |
| Não precisa de linha de visão | **+0,1A** | |

---

## 7. Defesa e Sobrevivência

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| Dado de Vida d6 → d8 | **+0,5 × E por dia** por nível | ≈ +1 PV/nível; 1 PV máximo ≈ 0,5 por encontro |
| d8 → d10 / d10 → d12 | **+0,5 × E por dia** por nível | Mesma conta |
| +1 PV máximo por nível | **+0,5 × E** | |
| Vida temporária | **0,5 por PV** | Parte se perde |
| Cura instantânea | **0,6 por PV** × eficiência (0,8 em aliado ferido, 0,5 em si mesmo por prevenção) | |
| Cura por turno (regeneração) | **0,6 × PV/turno × turnos × 0,7** | Parte cai em quem já está cheio |
| Roubo de vida | **0,5 por PV** | Só cura quem bate |
| Reviver em combate | **+3A** | Devolve um personagem inteiro |
| Cair com 1 PV (1x/DL) | **+2A** | |
| +1 CA permanente | **+0,08A por turno** | −7,5% nos acertos contra você, que é alvo metade do tempo |
| CA mínima (tipo Barkskin 16) | **+0,08A × (16 − CA atual)** por turno | Vale zero para quem já tem 16 |
| +5 CA por reação (tipo Shield) | **+0,4A** por uso | Evita em média 1 ataque |
| Resistência a dano físico | **+0,3A por turno** | ≈ 60% do dano recebido é físico |
| Resistência a 1 elemento | **+0,05A por turno** | |
| Imunidade | **2× a resistência** | |
| Vulnerabilidade | **−2× a resistência** | |
| Imunidade a condição (medo, charme) | **+0,05A por turno** | Condições são raras por encontro |
| Vantagem num teste comum (DES, SAB, CON) | **+0,05A por turno** | |
| Vantagem num teste raro (FOR, INT, CAR) | **+0,02A por turno** | |
| Proficiência num teste | **+0,04A por turno** | Dá +2 a +6 |
| Evasão | **+0,1A por turno** | Metade do dano de área vira zero |
| Imagens (Mirror Image) | **+0,15A por imagem** enquanto durar | Cada imagem absorve ≈ 1/3 de um ataque |
| Desvio de projéteis | **(dado + DES + nível) × 0,6** por uso | Pode zerar o dano |
| Redução de dano fixa | **0,6 × redução × ataques recebidos/turno** | ≈ 1 ataque por turno |
| Desvantagem para quem te ataca | **+0,3A por turno** | Metade dos acertos somem nos tiers baixos |
| Proteção de concentração (vantagem, War Caster) | **+10% do valor dos seus efeitos de concentração** | Diminui o risco da seção 8 |
| Proteger aliado / dividir dano (Warding Bond) | **+1 CA e resistência do aliado − 0,6 × dano dividido** | Metade do valor vai embora no dano que você toma |

---

## 8. Condições, Controle e Efeitos

Valores **por turno em que o efeito está ativo**, contra 1 alvo. Multiplique por `p(sucesso) × duração esperada`.

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| **Paralisado** | **3,5A** | Nega o turno (2A) e dá vantagem + crítico automático aos aliados corpo a corpo (+1,5A) |
| **Atordoado** | **3A** | Nega o turno e dá vantagem, sem crítico automático |
| **Incapacitado** | **2A** | Só nega o turno |
| **Adormecido** | **2A**, duração ≈ **1,5 turno** | Acaba ao tomar dano; o 1º golpe é crítico |
| **Banido** | **1,5A** | Nega o turno, mas o alvo também não pode ser atacado |
| **Petrificado** | **3,5A** | Igual a paralisado, com resistência a dano |
| **Enfeitiçado, lutando por você** | **3A** | Nega o turno e ainda te dá uma ação |
| **Enfeitiçado, atacando o mais próximo** (Crown of Madness) | **2,5A** | |
| **Enfeitiçado, só não te ataca** | **0,5A** | Ele ataca outro aliado |
| Caído (Prone) | **0,4A** | Perde movimento e dá vantagem corpo a corpo |
| Cego | **0,8A** | Desvantagem nos ataques dele e vantagem contra ele |
| Amedrontado | **0,6A** | Desvantagem nos ataques e não se aproxima |
| Lento (Slow) | **1,2A** | −2 CA, sem reação, só ação ou ação bônus (conferir no jogo) |
| Silenciado | **0,8A** vs. conjurador · **0** vs. marcial · **0,4A** na média | |
| Enraizado / Preso | **0,3A** | Nega aproximação; inimigos à distância ainda agem |
| Off Balance | **0,2A** | Vantagem no próximo ataque contra ele (conferir no jogo) |
| Enjoado (perde a ação) | **1,5A** | Mantém movimento e ação bônus |
| Envenenado (condição) | **0,5A** | Desvantagem em ataques |
| Perder a reação | **0,1A** | |
| −1d4 em ataques e testes (Bane) | **0,25A por inimigo** | −12,5% de acerto |
| +1d4 em ataques e testes (Bless) | **0,25A por aliado** | +19% de dano do aliado + testes |
| −2 CA no alvo | **0,15A × atacantes** (≈ 0,3A) | +10% de acerto para todos |
| +1 CA em aliado | **0,08A** | Seção 7 |
| +1 na CD / ataque mágico | **+7% do valor da magia** | +5% absoluto sobre p ≈ 0,65 |
| Vantagem em 1 ataque | **+0,3A** | |
| Marcado / revelar invisível / impedir esconder | **0,2A** (0,6A contra inimigos que se escondem) | |
| Negar cura | **0,1A** (0,5A contra curandeiros/regeneradores) | |
| Quebrar concentração inimiga | **1,5A × P(inimigo concentrado) × p_falha** | P ≈ 0,5 em lutas com conjuradores |
| DoT (Queimando, Sangrando, Envenenado) | **dano/turno × turnos × 0,8** | Pode ser apagado ou o alvo morrer antes |
| **Concentração** | **×0,85** | Risco de perder + disputa com outros efeitos (−10% se a subclasse já depende de concentração) |
| Sem concentração | **×1,0** | |
| 1 turno | **×1** | |
| 2–3 turnos | **×2,5** | |
| 10 turnos / combate inteiro | **×min(10, T restante) ≈ 3,5** | |
| Até descanso longo | **×E × 3,5** | Só se valer em todos os combates |
| Novo teste a cada turno | Duração esperada = **1 ÷ p(o alvo passar)**, com teto na duração | Ex.: p_falha 0,6 → 2,5 turnos |
| Acaba ao tomar dano | **×0,6** na duração | Aliados vão bater |
| Só humanoides / tipo específico | **×0,85** (humanoides) · **×0,6** (tipo raro) | O jogador escolhe o alvo; o custo é não ter alvo válido |
| Limite por PV total (Colour Spray / Sleep) | **×0,7** nos tiers 1–2 · **×0,3** no 3+ | Cai muito com o nível |
| Imunidade comum (mortos-vivos, constructos, imunes a charme/medo) | **×0,85** | |
| Resistência Lendária / chefe | **controle forte ×0,83** | Chefes em ~25% das lutas anulam ~70% |
| Efeito aleatório | **Valor esperado ×0,9** + mostrar o pior caso comum | Aleatório parece injusto (viés de perda) |

---

## 9. Resolução e Confiabilidade

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| Jogada de ataque | **×p(acerto)** + crítico | Tabela do tier |
| Teste de resistência | **×p_falha** com o ajuste por atributo | Seção 1 |
| Metade do dano no sucesso | **×(p_falha + 0,5 × (1 − p_falha))** | T2: 0,775 |
| Efeito parcial no sucesso | **×(p_falha + 0,3 × (1 − p_falha))** | |
| Anulado no sucesso | **×p_falha** | |
| Vantagem garantida | **p → 1 − (1 − p)²** | 0,65 → 0,88 |
| Desvantagem imposta ao alvo no teste | **p_falha → 1 − (1 − p_falha)²** | 0,6 → 0,84 |
| Acerto garantido | **p → 1,0** | |
| Falha garantida no próximo teste | **Benefício da magia seguinte × (1 − p_falha)** | Custeie no melhor caso (a magia mais forte) |
| Manipulação de dados (Portent, rolar de novo) | **0,5 × valor do evento-chave** por dado | O jogador usa no teste que decide a luta |
| Resistência Lendária | Seção 8 | |
| +1 CD / ataque mágico | **+7% do valor das magias afetadas** | |
| −1 CD / ataque mágico | **−7%** | |

---

## 10. Interação Ambiental

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| Superfície de fogo | **0,2A por turno × 0,5 alvos** | A IA evita; Queimando soma |
| Gelo | **0,15A por turno** | Escorregar = derrubar (teste de DES) |
| Graxa | **0,1A por turno** (+0,3A se houver fogo na party) | Combo |
| Água (Molhado) | **0,1A por turno** (+0,3A com relâmpago/frio na party) | Molhado aumenta o dano de relâmpago e frio (conferir no jogo) |
| Água eletrificada | **0,3A por turno** | |
| Ácido | **0,2A por turno** | Reduz CA (conferir no jogo) |
| Veneno / nuvem | **0,15A por turno** | |
| Sangue | **0,05A** | Quase só estético |
| Névoa / escuridão | **0,3A por turno** para a zona | Obscurece e quebra linhas de visão (mas atrapalha aliados) |
| Terreno difícil | **0,1A por turno** | |
| Superfície perto de aliados | **×0,7** | Fogo amigo |
| Empurrão 1,5 m | **0,05A** | |
| Empurrão 3 m | **0,1A** | |
| Empurrão 4,5 m+ com borda ou superfície perigosa | **+0,2A** | Chance de matar por queda ≈ 20% |
| Puxão | **igual ao empurrão** | |
| Queda (dano) | **1d6 a cada 3 m** × chance da situação | Conferir no jogo |
| Vantagem de altura | **+0,1A por turno** | +2 no ataque (conferir no jogo) |
| Luz em área (anti-invisível) | **0,1A por turno** | Mais contra inimigos furtivos |
| Parede que bloqueia passagem | **0,5A por turno** | Divide o campo |
| Zona persistente | **valor/turno × min(duração, T)** | |
| Armadilha ativada por inimigo | **×0,6** | Nem sempre alguém passa por ela |
| Colocar antes do combate | Ação principal **0** | Planejamento é recompensado |
| Limite de efeitos simultâneos | Valor máximo = **limite × valor de um** | Ex.: 2 glifos |

---

## 11. Mobilidade e Posicionamento

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| +3 m de movimento | **+0,1A por turno** (+0,15A para quem luta corpo a corpo) | |
| +30% de movimento | **+0,05A por turno** | |
| −3 m no alvo | **0,05A** | |
| Teletransporte 9 m | **+0,4A** por uso | Ignora terreno e ataques de oportunidade |
| Teletransporte 18 m+ | **+0,5A** | |
| Teletransporte que leva aliados | **+0,2A por aliado** | |
| Voo / levitar | **+0,3A por turno** | Altura + ignorar terreno |
| Salto ampliado / escalar | **+0,1A** | |
| Trocar de posição com aliado | **+0,3A** | Resgate |
| Trocar de posição com inimigo | **+0,3A** + valor da superfície | |
| Movimento sem ataque de oportunidade | **+0,2A por turno** | |

---

## 12. Invocações e Companheiros

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| Invocação que age no próprio turno | **(dano esperado dela/turno) × turnos × 0,7** | Pode morrer antes |
| PV da invocação (tanque) | **+0,3 por PV** | Absorve ataques que iriam para a party |
| CA da invocação | Afeta a sobrevivência (×0,7 → ×0,8 com CA alta) | |
| Duração | Até **T** (combate) ou **E×T** (dia) | |
| Limite de invocações | Valor máximo = **limite × valor de uma** | |
| Familiar | **+0,2A por turno** (Help, distração) + utilidade | |
| Clone / cópia de si | **+0,5A por turno** (distração) ou o valor da ação copiada | |
| Copiar magia inimiga | **Valor da magia copiada × 0,7** | Depende do que o inimigo tem |

---

## 13. Passivas e Gatilhos

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| Sempre ativa | **Valor/turno × E×T** | Comparar com a fração de D (seção 3) |
| Condicional | **× frequência da condição** | |
| Gatilho ao acertar | **× p(acerto) × ataques/turno** | |
| Gatilho ao lançar magia | **× magias/turno (≈ 1,2)** | Ação + às vezes ação bônus |
| Gatilho ao matar | **× 0,4 por turno** | Poucas mortes por turno |
| Gatilho ao ser atingido | **× 0,5 por turno** | |
| Gatilho no início do turno | **× 1 por turno** | |
| Limite 1x por turno | Teto = **1 × valor** por turno | Sem ele, conte todos os gatilhos |
| Empilha com ela mesma | **×(número de pilhas)** + aviso de loop | |
| Não empilha | **×1** | |
| Sinergia / combo da classe | **Melhor caso − custo de montar** | O jogador busca o combo |

---

## 14. Utilidade Fora de Combate (peso reduzido)

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| Diálogo / social (Telepatia, Charm, disfarce) | **+3 por dia** | Abre opções, mas não é poder de combate |
| Detectar / revelar | **+2 por dia** | |
| Destrancar | **+1 por dia** | Há outras soluções |
| Invisibilidade fora de combate | **+3 por dia** | |
| Feather Fall / travessia | **+2 por dia** | |
| Ritual sem custo | **Valor de utilidade × 1** | Sem gasto de recurso |
| Substituir um item ou companheiro | **+ o valor que o item daria** | |
| **Teto da utilidade** | **≤ 10% de S1 por feature** | Não deve decidir a escolha de uma lista de combate |

---

## 15. Bloco Arcana

### A1. Arcane Cards (interno: `ArcaneEssence`)

**Como está hoje** (Progressions e Spell_Shout):
- 8 cartas no nível 1, +2 por nível.
- Recarregam no descanso longo.
- Arcane Recovery: 2 × nível, 1x por descanso curto.
- Arcane Overflow (nível 14): +1 carta **por magia lançada**, sem limite.
- Arcane Mastery (nível 16): 1 magia grátis por descanso longo.
- Custos das magias do mod (contagem nos arquivos): **24 magias custam 1 · 18 custam 2 · 16 custam 3 · 6 custam 4.**

**Cartas por dia vs. Wizard** (Recovery usado 2x, Overflow ≈ 16 cartas por dia):

| Nível | Cartas/dia hoje | Com a correção* | Níveis de slot/dia do Wizard | Hoje ÷ Wizard | Correção ÷ Wizard |
|---|---|---|---|---|---|
| 1 | 12 | 9 | 3 | 4,0× | 3,0× |
| 3 | 24 | 15 | 10 | 2,4× | 1,5× |
| 7 | 48 | 27 | 27 | 1,8× | 1,0× |
| 11 | 72 | 39 | 53 | 1,4× | 0,74× (≈ 0,9× com as magias de nível 5–6 a 4 cartas) |
| 15 | 112 | 61 | — | | |
| 19 | 136 | 73 | — | | |

\*Correção: Recovery = **nível, 1x por descanso longo**; Overflow = **1x por turno, só magias de custo 2+** (≈ 10 cartas/dia).

**Magias com custo por dia** (custo médio 2,1 no nível 7): hoje ≈ 23, ou seja, uma magia **todo turno (16)** e ainda sobra. Com a correção ≈ 13, parecido com o Wizard (≈ 13).

**Valor de 1 carta** = `W ÷ cartas por dia`

| | T1 | T2 | T3 | T4 | T5 |
|---|---|---|---|---|---|
| **V_card hoje** | 3 | 3,5 | 4,5 | 3,5 | 4 |
| **V_card com a correção** | 4,5 | 6,5 | 8 | 7 | 7 |

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| 1 Arcane Card | **−V_card(tier)** | Tabela acima; use a coluna "com a correção" se aceitar a mudança |
| Câmbio carta ↔ slot (com a correção) | **1 carta ≈ 1 nível de slot** (S(N)/N = 8 / 6 / 6,7 / 6 / 5,6 / 5,3) | Por isso a regra do Grimório "custo = nível" funciona com a correção |
| Câmbio carta ↔ Ponto de Feitiçaria | **1 carta ≈ 2 PF** (com a correção) · ≈ 1 PF (hoje) | 1 PF = 4 pontos |
| Curva de custo 0/1/2/2–3/3/4 | L1 e L2 na curva; **L3 com 2 cartas é a maior pechincha** (vale 20, custa 13); L4 com 3 cartas fica um pouco barato; **L6 com 4 cartas também** | A curva é quase linear e **achatada no topo**. Sugestão: **0 / 1 / 2 / 3 / 3–4 / 4 / 5** |
| Arcane Recovery (hoje) | **+104/dia no T2 = 34% de D** | Quebrado: o Wizard tem 8% |
| Arcane Recovery (nível, 1x/DL) | **+45/dia no T2 = 15% de D** | Forte, mas aceitável: a classe não tem slots |
| Arcane Overflow (hoje) | **≈ +140/dia no T4 = 2,3× uma feature principal** | Quebrado. Toda magia de 1 carta vira grátis e gera Shards |
| Arcane Overflow (1x/turno, custo 2+) | **≈ +70/dia = 1,17×** | Forte, aceitável como feature do nível 14 |
| Arcane Mastery | **+4 × V_card ≈ 28/dia** = 0,5× feature principal | Fraco, mas ok como bônus pequeno |
| Slot de nível 1 só no nível 1 | **+8** no nível 1, depois 0 | Irrelevante para o balanceamento |
| Tessitura (metamagia) | **−(custo em cartas × V_card)** | Regra: **custo em cartas ≈ custo em PF ÷ 2 (mínimo 1)** |

**Tessituras (T3, V_card = 8)**

| Tessitura | Custo atual | Benefício quando usada | Veredito | Sugestão |
|---|---|---|---|---|
| Careful | 1 | ≈ 24 (evita ~40 PV de fogo amigo) | Forte, mas **situacional** | Manter 1 |
| Distant | 1 | ≈ 2 (≈ 0,2A); mais para magias de toque | Fraco | Manter 1 (utilidade) |
| Extended | 1 | ≈ 5 em efeitos de 1–3 turnos; ≈ 0 em concentração de 10 turnos | Fraco | Manter 1 |
| Transmuted | 1 | ≈ 12 contra alvo resistente; 0 contra os outros | Situacional | Manter 1 |
| Empowered | 1 | +0,75 (d6) / +1 (d8) / +1,25 (d10) por dado relançado × até 5 dados × M(n) em área → **até 12,5** | **Quebrado em área** | Máximo de **3 dados**, ou custo 2 em magias de área |
| Heightened | 3 | +40% no controle de alvo único (≈ +16) | Fraco (0,67) | **Custo 2** |
| Quickened | 3 | ≈ 1A + tempo do burst ≈ 16 | Fraco (0,69) com a correção · forte hoje | **Custo 2** (o PF é 3 → 1,5 carta) |

### A2. Arcane Shards (interno: `ArcaneShards`)

**Como está hoje:**
- Liberados no nível 13.
- Passiva `ArcaneShards` com gatilhos `OnCombatStarted;OnCast` e a condição `IsArcanaSpell`: dá Shards iguais ao `SpellPowerLevel`.
- Zeram ao fim do combate.
- As versões EX custam **só Shards**, e `IsArcanaSpell` exige custo em `ArcaneEssence`. Por isso **uma EX não gera Shards: não há loop direto** ✅.

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| 1 Arcane Shard | **−0,5 × V_card** (T4 ≈ 3,5 com a correção; 1,75 hoje) | Vem "de graça" ao gastar cartas (≈ 1 Shard por carta), some no fim da luta e só aparece depois do 1º turno |
| Geração por turno | **≈ 1,2 × nível médio da magia lançada** ≈ **1,3** (só magias de 1 carta) a **3** (magias de 2–3 cartas) | Ação + às vezes ação bônus |
| Zerar no fim do combate | Já está no **×0,5** | Não dá para guardar para o chefe |
| Loop via Overflow | **Aviso** | Hoje uma magia de 1 carta custa 0 no nível 14+ e gera 1 Shard: Shards infinitos, só limitados pela ação |
| Possível ganho dobrado | **Conferir no jogo** | Se o combate começa **com** uma magia Arcana, `OnCombatStarted` e `OnCast` podem disparar juntos |

**Em que turno cada EX fica disponível** (3 Shards/turno; 1,3 se só lançar magias de 1 carta)

| Custo da EX | Com 3 Shards/turno | Com 1,3/turno |
|---|---|---|
| 1–2 | Turno 1, se a EX usar outra ação que não a da magia que gerou os Shards | Turno 1–2 |
| 3–4 | Turno 2 | Turno 3 |
| 5–6 | Turno 2–3 → **~1 vez por combate** | Turno 4–5 → **quase nunca** |

**Leitura:** o sistema empurra o jogador a lançar magias mais caras antes de usar as EX. É um bom desenho, contanto que o custo em cartas pese (depende da correção do A1).

### A3. Outras cargas da classe

| Elemento Mecânico | Valor em Pontos / Peso | Justificativa do Peso |
|---|---|---|
| `GaleDeflectMissiles_Charge` (Unbound, 1x/DC) | **(1d10 + DES + nível) × 0,6 por uso × U 2–3** | No nível 3: ≈ 7 por uso, ≈ 17/dia. Parecido com o Deflect Missiles do Monk, que é mais livre |
| `HollowImage_Charge` (Deceiver, por turno) + 2 Shards + reação | **Limite 1x/turno**; custo −0,3A − 2 × V_shard | O limite real são os Shards |
| Portent | **0,5 × valor do evento-chave × 2 dados por DL** ≈ **12% de D no T1** | Forte, igual ao Wizard de Adivinhação (referência vanilla) |
| Expert Divination | **Conferir no jogo** como está no mod | No vanilla, recupera slot ao lançar Adivinhação de nível 2+ |
| Cosmic Omen (Starchild) | **0,5 × valor do evento × usos** | Mesma lógica do Portent |
| Status "usado" 1x/DL (ex.: `ARCANE_MASTERY_USED`) | **U = 1** | |

### A4. Listas "escolha N"

| Regra | Peso | Justificativa |
|---|---|---|
| Força da lista | **Soma das N melhores opções** | O jogador pega as melhores |
| Faixa aceitável dentro da lista | **R entre 0,85 e 1,15 para todas** | Fora disso, uma vira obrigatória e outra vira armadilha |
| Opção que repete algo da subclasse | **×0,3** para aquela subclasse | Retorno decrescente: filtre por subclasse |
| Opção que imita a identidade de outra subclasse | **−0,1 × valor da subclasse imitada** (custo de design) | Ex.: Fear × Terrify, Beacon of Hope × Stellar Grace |
| Troca de 1 escolha por nível | Opções de nicho **×1,2** | Dá para ajustar à campanha |
| Mais escolhas | **+ valor da opção extra × 0,8** | Retorno decrescente |
| Versatilidade (lista com respostas diferentes) | **+5% por tipo de situação coberta** | Vale na proporção da incerteza dos encontros |

**Hand (T1, V_card = 4,5):** Burning Hands a 1 carta dá R ≈ 11,8 ÷ 8,5 ≈ **1,39**, e um cantrip dá R ≈ 1. Então todo mundo pega as de nível 1 e os cantrips viram armadilha → a **opção C (2 cantrips + 1 de nível 1)** é a que resolve.

### A5. Afinidade de Escola (T3, V_card = 8)

**Suposições:** ≈ 16 magias por dia, 40% afinadas, 70% delas custando 2+, 4 cantrips afinados por dia.

| Opção | Conta | Por dia | ÷ feature menor (25) | Veredito |
|---|---|---|---|---|
| **A)** −1 carta (mínimo 1) | 4,5 cartas × 8 | **36** | 1,44 | **Quebrado**, e com o Overflow atual faz magias de 2 cartas saírem grátis |
| **B)** +1 CD e ataque | 7% × (6,4 magias × 25 + 4 cantrips × 11) | **14** | 0,56 | Fraco |
| **B+)** +1 no nível 2, +2 no nível 10 | Dobra no T3 | **28** | 1,1 | **Recomendado** |

### A6. Efeitos customizados: estimativa rápida (sem conta completa)

| Efeito | Veredito provável | Motivo principal | Ajuste sugerido |
|---|---|---|---|
| Eco de Magia (50%, 1x/turno, custo 0) | **Quebrado** (≈ 96/dia vs. 60) | +50% no dano de uma magia por turno | **30%** (≈ 58/dia) |
| Selo da Senhora dos Mistérios | Forte | Anula uma magia inteira e devolve carta | Ok como mistério do nível 19 |
| Pressentimento (2 cartas, 1x/DL, dura até o DL) | Forte hoje (≈ 2×) · balanceado com a correção (≈ 1,1) | ≈ 0,45A por combate × 4 combates ≈ 14 | Manter 2 se aceitar a correção; senão **3 cartas** |
| Destino Selado | Forte / combo | Falha garantida + controle forte = melhor caso | **3 cartas**; não afeta chefes com Resistência Lendária |
| Fio do Destino | Balanceado / situacional | Depende da rolagem copiada | — |
| Roda da Fortuna | Balanceado se o valor esperado ≈ 0,5 × (buff − debuff) | Aleatório | Mostrar a tabela para o jogador |
| Déjà Vu (2 cartas, 1x/turno) | **Conferir a ação** | Com ação bônus é **quebrado** (Haste sem concentração); com ação ≈ 0,7 | Manter como **ação** |
| Retroceder (3 cartas, 1x/DC) | Balanceado | Cura ≈ 2A num aliado | — |
| Pausa (4 cartas, 1x/DL) | Fraco | Nega 1 turno, mas protege o alvo | 2 turnos, ou 3 cartas |
| Fogo Prateado (4 cartas, 1x/DC) | Calcular vs. S5 = 28 | Ignora resistência = ×1,05 a ×1,25 | Limitador duplo: tirar o 1x/DC **ou** baixar o custo |
| Sete Estrelas / Glifos / Rasgo na Trama | Seção 18 | | |

---

## 16. Multiplicadores e a fórmula

### Quando somar e quando multiplicar

- **Somar:** efeitos independentes (dano + controle + cura) e custos (ação + recurso + limitações).
- **Multiplicar:** tudo que muda a *chance* ou o *alcance* do mesmo efeito (acerto, alvos, duração, concentração, tipo de dano, restrição de alvo).

| Multiplicador | Valor |
|---|---|
| Confiabilidade | p(acerto) / p_falha / metade no sucesso (seção 9) |
| Área | M(n) = 1 + (n−1) × 0,5 |
| Fogo amigo | ×0,9 |
| Projéteis distribuíveis | ×1,10 |
| Tipo de dano | ×0,80 a ×1,00 |
| Duração | ×1 / ×2,5 / ×3,5 / ×E×3,5 |
| Novo teste por turno | Duração = 1 ÷ p(o alvo passar) |
| Concentração | ×0,85 |
| Alvo válido | ×0,85 (humanoide) / ×0,6 (tipo raro) |
| Acaba ao tomar dano | ×0,6 na duração |
| Armadilha | ×0,6 |
| Resistência Lendária (controle forte) | ×0,83 |
| Efeito aleatório | ×0,9 |
| Zona que o inimigo pode sair | ×0,7 |
| Cura em si / em aliado | ×0,5 / ×0,8 |

### Fórmula da planilha

```
1. Benefício_i = ValorBase_i × Confiabilidade_i × Duração_i × M(n)_i × Tipo_i × Situação_i
2. Benefício   = Σ Benefício_i + bônus fixos (utilidade, mobilidade)
3. Custo       = Ação (A, 0,6A, 0,3A ou 0)
               + Recurso (S(N) | cartas × V_card | Shards × V_shard | PF × 4 | PV × 0,6)
               + Limitações (cooldown, limitador duplo, alcance de toque)
4. Saldo       = Benefício − Custo
5. R           = Benefício ÷ Custo → veredito (seção 3)
6. Com cooldown/usos: compare Benefício × U com a fração de D.
```

---

## 17. Tetos por tier

| Tier | A | Maior S(N) | **Teto por habilidade** (A + S) | 1x/combate | 1x/DC | 1x/DL (capstone) | **Teto por turno** sustentado (A + W/16) | W (Wizard) | **D** (total do dia) |
|---|---|---|---|---|---|---|---|---|---|
| 1 (1–4) | 4 | 12 | **16** | 19 | 24 | 32 | **8** | 68 | **132** |
| 2 (5–8) | 8 | 24 | **32** | 38 | 48 | 64 | **19** | 176 | **304** |
| 3 (9–12) | 11 | 32 | **43** | 52 | 65 | 86 | **31** | 328 | **504** |
| 4 (13–16) | 12 | 36* | **48** | 58 | 72 | 96 | **38** | 412* | **604** |
| 5 (17–20) | 12 | 44* | **56** | 67 | 84 | 112 | **45** | 524* | **716** |

\*Extrapolado de regras do 5e. Confira se o framework de nível 20 dá slots de 7º a 9º e cantrip 4d10.

**Faixas de veredito para uma habilidade:** ≤ 0,75 × teto = armadilha · 0,90–1,10 = balanceado · > 1,25 = quebrado.

**Marcos do tier:**
- Feats nos níveis 4, 8, 12, 16 e 19 (+7% de D cada).
- Ataque Extra no 5 (Eternal).
- EX nos níveis 13, 15, 17 e 19.
- Capstones no 20.
- Não junte uma lista nova com um desses marcos no mesmo nível (o Grimório já evita).

---

## 18. Exemplos resolvidos

### 18.1 Referências vanilla (conferir no jogo todos os dados)

**Fire Bolt (T1, cantrip, 1d10 fogo, 18 m)**
- Dano: 0,65 × 5,5 + 0,05 × 5,5 = 3,85.
- Fogo: × 0,95 = 3,66. Chance de incendiar: +0,1 → **3,76**.
- Custo: A = 4 → **R = 0,94 · Balanceado** (por definição, é a âncora).

**Magic Missile (T1, nível 1, 3 × (1d4+1) força, acerto automático)**
- Dano: 3 × 3,5 = 10,5 × 1,0 (acerto) × 1,0 (força).
- Distribuível: × 1,10 = **11,55**.
- Custo: A 4 + S1 8 = 12 → **R = 0,96 · Balanceado**.

**Burning Hands (T1, nível 1, cone 3d6 fogo, DES metade)**
- Por alvo: 10,5 × (0,5 + 0,25) = 7,875.
- Área: M(2,5) = 1,75 → 13,78.
- Fogo amigo × 0,9 e fogo × 0,95 → 11,78.
- Superfície +0,5 e alcance curto −0,5 → **11,78**.
- Custo: 12 → **R = 0,98 · Balanceado**.

**Hold Person (T1, nível 2, SAB, humanoide, concentração, novo teste por turno)**
- Chance de falhar: CD 13 vs. +2 − 2 (humanoide) = +0 → p_falha = 0,6.
- Duração esperada: 1 ÷ 0,4 = 2,5 turnos.
- Paralisado: 3,5A = 14 por turno.
- Conta: 0,6 × 2,5 × 14 = 21 × 0,85 (concentração) × 0,85 (humanoide) = **15,2**.
- Custo: A 4 + S2 12 = 16 → **R = 0,95 · Balanceado**.
- No T2, o controle cresce com A e o S2 não: R ≈ 1,9. Hold Person fica forte com o nível, como a comunidade já percebe.

**Fireball (T2, nível 3, esfera 8d6 fogo, DES metade)**
- Por alvo: 28 × 0,775 = 21,7.
- Área: M(3) = 2 → 43,4.
- Fogo amigo × 0,9 e fogo × 0,95 → 37,1. Superfície +1 → **38,1**.
- Custo: A 8 + S3 20 = 28 → **R = 1,36 · Quebrado**.

  Isso é intencional no 5e: o Fireball tem +2d6 acima da curva de propósito. A régua foi calibrada com o **Fireball "de curva" (6d6)**: 21 × 0,775 × 2 × 0,9 × 0,95 + 1 = **28,8** → **R = 1,03** ✓. **Nunca use o Fireball real como meta para o mod.**

### 18.2 Sete Estrelas (Arcana, nível 3, 3 cartas; assumido no T2, nível 6)

Contada com o método "contador" (efeitos determinísticos), com as 7 estrelas no mesmo alvo.

| Parte | Conta | Pontos |
|---|---|---|
| Dano | 7 × 2,5 = 17,5 × 1,0 (acerto automático) × 1,0 (força) × 1,10 (distribuível) | 19,25 |
| Abjuração (+1 CA, 1 turno) | 0,08A × 0,5 | 0,3 |
| Conjuração (empurra 1,5 m) | 0,05A × 0,5 | 0,2 |
| Encantamento (−1d4 no próximo ataque) | | 0,5 |
| Evocação (+1d4 de dano) | | 2,5 |
| Ilusão (Cego, CON) | CD 15 vs. +3 +2 → p = 0,45 × 0,8A × 8 × 0,75 (efeito curto) | 2,2 |
| Necromancia (sem cura) | 0,1A × 0,4 | 0,3 |
| Transmutação (−3 m) | | 0,3 |
| **Benefício** | | **25,6** |

| Cenário | Custo | R | Veredito |
|---|---|---|---|
| Hoje (V_card 3,5) | 8 + 10,5 = 18,5 | **1,38** | Quebrado |
| Com a correção (V_card 6,5) | 8 + 19,5 = 27,5 | **0,93** | Balanceado |
| Comparação: slot de nível 3 | 8 + 20 = 28 | **0,91** | Balanceado |

**Observação:** com o método "chance" (`ApplyStatus(...,15,1)`), os efeitos valem ≈ 15% do total → benefício ≈ 20 → R ≈ 0,73 (armadilha). **Use o contador.**

### 18.3 Glifo de Raízes (Arcana, 2 cartas, armadilha; T2, nível 7)

| Parte | Conta | Pontos |
|---|---|---|
| Dano | 1d8 = 4,5 × 0,775 (DES metade) × 0,93 (perfurante) | 3,2 |
| Enraizado 2 turnos | 0,3A × 2 = 4,8 × p_falha FOR (CD 15 vs. +3 −1 → 0,6) | 2,9 |
| Armadilha | × 0,6 | |
| **Benefício** | (3,2 + 2,9) × 0,6 | **3,7** |

| Cenário | Custo | R | Veredito |
|---|---|---|---|
| Colocado antes do combate, hoje | 7 | 0,52 | Armadilha |
| Em combate, hoje | 15 | 0,24 | Armadilha |
| Antes do combate, com a correção | 13 | 0,28 | Armadilha |

Para comparar, o **Glifo de Fogo com 3d8** dá R = 0,83 com a correção. Ou seja, **o dano de todos os glifos está baixo**.

**Ajustes:**
- Dano base dos glifos: **4d8 no nível 7** → Fogo com R = **1,06**.
- Raízes: **3d8 + Enraizado em área de 2 m**, e o 1º turno enraizado sem teste (teste de FOR no fim do turno para escapar) → benefício 12,2 → **R = 0,94** ✓.

### 18.4 Rasgo na Trama (Arcana, nível 4, 3 cartas, 1x/DC, concentração; T3, nível 10)

Encontro genérico: 3 inimigos na zona, 1 conjurador, os inimigos podem sair (× 0,7).

| Parte | Conta | Pontos |
|---|---|---|
| Quebrar concentração | 1,5A × P 0,5 × p_falha CON (CD 17 vs. +4 +2 → 0,5) | 4,1 |
| Desvantagem em ataques mágicos (3 turnos) | 0,35 × 0,5 × 2A por turno × 3 × 0,7 | 8,1 |
| Sem reações (3 inimigos × 3 turnos) | 0,1A × 9 × 0,7 | 6,9 |
| **Benefício** | × 0,85 (concentração) | **16,2** |

| Cenário | Custo | R | Veredito |
|---|---|---|---|
| Genérico, hoje | 11 + 13,5 + 1 (limitador duplo) = 25,5 | **0,64** | Armadilha |
| Genérico, com a correção | 11 + 24 + 1 = 36 | **0,45** | Armadilha |
| 2 conjuradores (benefício 26,6), hoje | 25,5 | **1,04** | Balanceado |
| 2 conjuradores, com a correção | 36 | **0,74** | Armadilha |

**Ajustes (todos implementáveis sem Script Extender):**
1. **Tirar o 1x/DC** (a concentração já limita).
2. **Inimigos dentro da zona têm desvantagem em testes de resistência contra magia** (≈ +13; conferir se o boost existe).
3. **Quem falha no teste de CON fica Silenciado por 1 turno** (≈ +4,4).

→ Benefício 33,6, custo 35 → **R = 0,96** ✓.

### 18.5 Starcall EX (Starchild, 2 Shards; T4, nível 13)

**Dados do mod:**
- Starcall base: ação + 1 carta, ataque mágico à distância.
- Dano `Starcall_Damage`: 7d6 radiante no nível 13.
- `STARCALL_SLOW`: −30% de movimento por 1 turno.
- Você ganha `REJUVENATION` por 2 turnos: cura SAB no fim do turno e +30% de movimento.
- A EX custa **só 2 Shards** e espalha a Rejuvenation numa aura de 6 m para aliados.

| Parte | Conta | Pontos |
|---|---|---|
| Dano | 24,5 × (0,70 + 0,05) × 0,97 | 17,8 |
| Lentidão no alvo | | 0,6 |
| Cura própria | SAB 5 × 2 turnos × 0,6 × 0,5 | 3,0 |
| +30% de movimento, 2 turnos | | 1,2 |
| **Base** | | **22,6** |
| **Extra da EX:** 2 aliados | 10 PV × 0,6 × 0,8 × 2 = 9,6, + movimento 2,4 | +12 |
| **EX** | | **34,6** |

| Cenário | Custo | R | Veredito |
|---|---|---|---|
| Base, hoje (V_card 3,5) | 12 + 3,5 | **1,46** | Quebrado |
| Base, com a correção (V_card 7) | 12 + 7 | **1,19** | Forte |
| EX, hoje (V_shard 1,75) | 12 + 3,5 | **2,23** | Quebrado |
| EX, com a correção (V_shard 3,5) | 12 + 7 | **1,82** | Quebrado |

**Diagnóstico:** o dano da base cresce até 10d6 com custo fixo de 1 carta. A EX, além de curar, **também economiza a carta**, então ela domina a base sempre que há Shards.

**Ajustes:**
- EX custa **1 carta + 2 Shards**.
- Cura da aura = **metade da SAB**.
- Dano da base para de subir em **6d6 a partir do nível 11**.

→ Base 20,1 ÷ 19 = **1,06** · EX 27,3 ÷ 26 = **1,05** ✓.

**Conferir no jogo:** a aura `REJUVENATION_EX_TECH` é aplicada com duração 0. Veja quantos aliados ela pega e por quanto tempo.

---

## 19. Riscos

| Risco | Onde | Por que quebra | Mitigação |
|---|---|---|---|
| **Loop Overflow → magia grátis → Shards** | Nível 14+ | Magia de 1 carta custa 0 e gera Shard; o único limite é a ação | Overflow 1x/turno, só custo 2+ |
| **Afinidade A + Overflow** | Nível 14+ | Magia afinada de 2 cartas vira 1, reembolsa 1 → grátis | Usar a opção B |
| **Recovery 2× nível** | Todos os níveis | Orçamento diário 1,4× a 4× o do Wizard | Nível, 1x/DL |
| **EX só com Shards** | Níveis 13–20 | A EX economiza a carta e ainda é melhor | EX = 1 carta + Shards |
| **Custo fixo com dano crescente** | Tiers 4–5 | Starcall 1 carta → 10d6 | Teto de dano ou custo por tier |
| **Empowered em área** | Tessituras | O relance vale para todos os alvos | Máximo 3 dados |
| **Destino Selado + controle forte** | Destino | Combo de melhor caso = controle garantido | Custo 3; chefes ignoram |
| **Déjà Vu como ação bônus** | Tempo | Ação extra sem concentração | Manter como ação |
| **Nível 1** | Início | 8 cartas vs. 2 slots do Wizard (4×) | Pool inicial 6, ou aceitar como "tutorial generoso" |
| **Nível 20** | Capstones | Sem referência vanilla | Teto de 2× o teto do T5 por uso 1x/DL; comparar entre as 4 subclasses |
| **Multiclasse: `LevelMapValue`** | Starcall e outros | Se usar o nível do **personagem**, 1 nível de Arcana já dá o dano total por 1 carta (conferir no jogo) | Usar `ClassLevel(Arcana)` no scaling |
| **Multiclasse: cantrips** | A (tier) | A é pelo nível do personagem; as cartas são pelo nível de Arcana | O esquema assume a **classe pura**; em multiclasse, recalcule V_card com as cartas reais |
| **Multiclasse: slots vanilla + cartas** | Qualquer | Dois recursos independentes somam | Aviso: o esquema não cobre essa soma |
| **Possível Shard em dobro ao iniciar combate** | Passiva `ArcaneShards` | `OnCombatStarted` + `OnCast` | Testar; se acontecer, tirar `OnCombatStarted` |
| **Script Extender** | — | Nenhuma sugestão aqui depende dele | Todos os ajustes usam `UseCosts`, `Cooldown`, `ApplyStatus` e `LevelMapValue` |

---

## 20. Plano de playtest

**Encontros padronizados** (repetir cada um 3 vezes por subclasse, nos níveis 3, 7, 11, 15 e 19):
1. **1 contra 1:** um inimigo com CA e PV do tier.
2. **Em inferioridade:** party de 4 contra 6 inimigos, incluindo 1 conjurador.
3. **Em superioridade:** party de 4 contra 2 inimigos.
4. **Dia completo:** 4 encontros com 2 descansos curtos.

**Métricas**

| Métrica | Como coletar | Critério |
|---|---|---|
| Dano por turno (Arcana vs. Wizard/Sorcerer do mesmo nível) | Log de combate | Dentro de ±15% do teto por turno do tier |
| Turnos para vencer | Contagem | Arcana ≈ Wizard ±1 turno |
| **Cartas restantes no fim do dia** | Anotar antes do descanso longo | **> 25% do pool = orçamento alto** (confirma o achado do A1) |
| Magias com custo por dia | Contagem | ≈ 70–80% dos turnos; 100% com sobra = pool alto |
| Shards restantes no fim de cada combate | Anotar | Sempre > 6 = EX baratas demais; sempre 0 = caras demais |
| Turno do 1º uso de cada EX | Anotar | Deve bater com a tabela do A2 |
| Taxa de escolha de cada opção das listas | Enquete no Discord + saves | Nenhuma opção < 10% nem > 60% |
| Uso de Careful / Transmuted | Contagem | Se nunca usadas, reavaliar |
| Uso do Glifo de Raízes e do Rasgo na Trama depois do buff | Contagem | Pelo menos 15% de escolha |

**Como validar cada peso:**
- Se o dano por turno medido ficar mais de 15% acima do previsto pela soma, o peso do dano (ou a suposição de alvos em área) está baixo.
- Se o controle vencer lutas mais rápido do que o previsto, suba o "turno inimigo" de 2A para 2,5A.
- **Refute** a correção do Recovery se, com ela, sobrarem menos de 10% das cartas no fim do dia **e** a taxa de derrota subir. Nesse caso, use Recovery = nível, 1x/DC com 1 uso típico.
