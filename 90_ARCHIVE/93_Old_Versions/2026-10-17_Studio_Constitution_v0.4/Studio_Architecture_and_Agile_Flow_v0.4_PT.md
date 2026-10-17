# Lumox Studios · Arcana Class — Arquitetura de Repositório e Fluxo Ágil

*Lumox Studios, estúdio autônomo de mods · Projeto atual: Arcana Class (Baldur's Gate 3) · Versão 0.4*

## 1. Como usar este documento

Este é o plano-mestre para padronizar o estúdio. Ele deve ser entregue ao Claude responsável pela reestruturação (no Claude Code, dentro da pasta do projeto), que o usa como especificação: audita o que existe hoje, mapeia cada arquivo para a nova estrutura e migra sem apagar nada do original.

**Estrutura do documento.** A **Parte I** (seções 1 a 16) define a organização, o fluxo de trabalho e a operação do estúdio. A **Parte II** (seções 17 a 24) é a base de conhecimento de game design: fundamentos, design de classes e subclasses em D&D 5e e BG3, balanceamento, economia de recursos, narrativa e lore, playtest, glossário e fontes. O Claude executor deve ler as três partes e transformar a Parte II em fichas curtas em `27_Base_de_Conhecimento_Design/`, uma por papel de design, para que cada agente leia só o que precisa.

A **Parte III** (seções 25 a 34) é a base de conhecimento de engenharia de mod: arquitetura e escolha de ferramenta, Stats e LSX, Khonsu e Thoth, Lua e Script Extender, Osiris, fluxo de programação, qualidade e depuração, agentes especialistas (inclusive como montar um agente de Osiris a partir dos scripts do jogo base), glossário e fontes. Ela deve virar fichas curtas em `57_Base_de_Conhecimento_Engenharia/`.

**Instruções para o Claude executor:**

1. Ler o documento inteiro antes de agir e confirmar o entendimento aos Owners em poucas linhas.
2. Auditar as pastas atuais e o mod existente em modo somente leitura e produzir um inventário (o que existe, onde, de quando, o que parece duplicado ou contraditório).
3. Revisar com olhar estratégico o que já existe e o que este documento propõe, registrando propostas conforme o escopo abaixo.
4. Propor uma tabela de mapeamento *local antigo → local novo (ID Johnny.Decimal)* e aguardar a aprovação dos Owners.
5. Criar a estrutura vazia da seção 4, com `_INDEX.md` e `_AGENT.md` em cada categoria.
6. Migrar por **cópia, nunca por movimentação**. O material original fica em `_LEGADO/` até os Owners aprovarem a remoção.
7. Gerar `CLAUDE.md`, `AGENTS.md`, as fichas dos agentes e a pasta `.claude/` (seção 5), e popular o contexto vivo `05` a partir do mod existente (seção 10).
8. Revisar o `.gitignore` e o README com aprovação dos Owners (seção 12).
9. Entregar um relatório final com conflitos, arquivos sem destino claro, propostas e decisões pendentes.
10. **Não implementar código do mod** (Stats, Lua, LSX) em nenhum momento da migração, a menos que o ticket autorize (seção 7).

**Decisões já tomadas pelos Owners:**

| Tema | Decisão | Seção |
| --- | --- | --- |
| Implementação de código | Somente sob demanda; o Owner prefere implementar no Toolkit a partir de specs objetivas e tipadas | 7 |
| Fonte única de dados | Magias, features e status definidos uma vez em YAML (`25_Dados_Mestres`) | 2, 4 |
| Tickets | Cabeçalho YAML para leitura por scripts e agentes | 2, 6 |
| Guardrails | Permissões, hooks do Claude Code e Git, em vez de depender só de combinados | 5 |
| Ativação de agentes | Gradual: 9 papéis ativos na Sprint 0 | 5 |
| Escopo da classe | Núcleo do 1 ao 12; progressão 13 a 20 como módulo de expansão | 1 |
| Narrativa | Todo texto visível ao jogador passa pela Narrativa, amarrado à lore e ao estilo do jogo base | 9 |
| Contexto vivo | Pasta `05` como espelho do mod hoje, mantida por um agente dedicado | 10 |
| Patch notes | Departamento próprio; diferença entre a versão publicada e a build nova; estilo League of Legends com ⇒ | 11 |
| Git e README | Todo o material autoral no repositório privado; `.gitignore` revisado; README atualizado nos commits relevantes | 12 |
| Licenças e plataformas | Seção e pasta próprias (`00.06`) | 13 |
| Compatibilidade com patches do jogo | Não se aplica (BG3 não recebe mais atualizações); versões finais ficam travadas | 15 |
| Playtest | Saves padronizados por nível (`83.02`) | 4 |
| Execução | Claude Code local; sessões separadas por tópico; memória nos arquivos | 5 |
| Liberdade estratégica | O Claude executor pode propor mudanças, inclusive a este documento; os Owners decidem | 1 |

**Escopo e ponto de partida (informado pelos Owners):**

- **Repositório:** já existe e é privado: https://github.com/Geminitrix/arcana-class-bg3. Todo o material autoral do projeto deve ficar nele (seção 12).
- **Natureza do trabalho:** é um *rework* de um mod que já existe, não um projeto novo. Por isso o próximo lançamento talvez não seja a "1.0"; o esquema de versão fica para o Claude executor propor em ADR (seção 16).
- **Níveis:** o núcleo da classe vai do nível 1 ao 12, o padrão do jogo base. Toda a mecânica principal da classe e das subclasses precisa estar completa dentro desses níveis. A progressão do 13 ao 20 será um **módulo de expansão** posterior, e nenhuma mecânica central pode depender dele. A estrutura já reserva lugar para ele (`21.07` e `25_Dados_Mestres/classes`), e um validador deve garantir que nada do núcleo referencie o módulo.
- **Subclasses do escopo:**

| Subclasse | Situação | Trabalho previsto |
| --- | --- | --- |
| Deceiver | Existente | Rework para se adequar aos novos padrões do jogo |
| Starchild | Existente | Rework para nivelar com as demais subclasses |
| Eternal | Existente | Rework para nivelar com as demais subclasses |
| Unbound | Existente | Rework para nivelar com as demais subclasses |
| Resonant | Nova | Em criação |
| Spinner | Nova | Em criação |
| Lionheart | Nova | Em criação |

- **Padrão entre subclasses:** o rework busca um patamar comum de poder, complexidade e quantidade de features. Para isso existe um documento `_PADRAO_DE_SUBCLASSE.md` em `21.04`, que o Claude executor deve propor e os Owners aprovar antes de os reworks começarem.
- **Trabalho já estabelecido pode ser revisado.** Muita coisa do mod existente já foi decidida. O Claude executor tem liberdade para sugerir melhorias estratégicas e revisar o que foi estabelecido, inclusive questionar o que este próprio documento define. Cada sugestão vira uma proposta em `00.04_Decisoes_ADR/PROPOSTAS/` com: problema, evidência, proposta, impacto, custo e risco. Os Owners decidem, e nada é aplicado sem aprovação.

**Ambiente (informado pelos Owners):**

- **Empresa e pasta local:** o projeto é da Lumox Studios. Tudo sobre o projeto e a empresa fica numa pasta local chamada `Arcana Class`, que é a raiz desta estrutura e do repositório.
- **Versão publicada hoje no mod.io:** 3.1.0.28, numeração gerada pelo próprio Toolkit. Esse `.pak` é a primeira baseline do departamento de patch notes (seção 11).
- **Arquivos que o Toolkit builda e envia ao mod.io:** vivem na pasta `Data` do jogo, fora da pasta `Arcana Class`. O Claude executor sabe localizá-la. Como manter as duas pastas em sincronia está na seção 7.

## 2. Princípios de design da estrutura

A estrutura combina três referências: o pipeline clássico de game dev (separação Design / Arte / Engenharia / QA / Release), o sistema Johnny.Decimal (índice numérico fixo e previsível) e as necessidades específicas de agentes de IA, que não têm memória entre sessões e dependem do que está escrito nas pastas.

**Regras que valem para todo o repositório:**

- **Johnny.Decimal adaptado:** áreas 00 a 90, mais a área 05 (Contexto Vivo, lida primeiro por todos os agentes) → categorias de 2 dígitos (ex.: 21) → itens com ID decimal (ex.: 21.03). Profundidade máxima de indexação: 2 níveis. Dentro de um item, a organização é livre, mas o ID nunca muda. Qualquer agente cita um arquivo por ID (ex.: `22.04`), e isso basta para localizá-lo.
- **Um dono por pasta.** Cada categoria tem exatamente um agente responsável. Outros agentes leem, mas só escrevem na pasta alheia via ticket de handoff.
- **Dois arquivos obrigatórios por categoria:** `_INDEX.md` (o que existe aqui, em 10 linhas) e `_AGENT.md` (dono, o que pode ser escrito, convenções, checklist de qualidade). Um agente que entra numa pasta lê esses dois primeiro, o que mantém o consumo de contexto baixo.
- **Memória nos arquivos, não nas conversas.** Como cada sessão e cada subagente começa do zero, tudo que precisa sobreviver (decisões, estado do ticket, pendências) é escrito em arquivo. Se não está escrito, não aconteceu.
- **Dados mestres como fonte única.** Cada magia, feature e status é definido uma vez em YAML (`25_Dados_Mestres`). Fichas de design, planilhas de balanceamento, strings de localização e rascunhos de Stats derivam dessa fonte. Ninguém digita o mesmo número em dois lugares.
- **Tickets legíveis por máquina.** Todo `ARC-####.md` começa com um cabeçalho YAML (status, dono, tipo de implementação, entradas, saídas, dependências, bloqueios). Scripts geram o `SPRINT_BOARD.md` e os `_INDEX.md` a partir dele, em vez de os agentes mantê-los à mão.
- **Implementação sob demanda.** O time produz especificações; escrever o código do mod só acontece quando o Owner pedir (seção 7).
- **Guardrails técnicos.** As regras de propriedade e de aprovação são aplicadas por permissões, hooks e Git (seção 5), não apenas combinadas.
- **Nomenclatura:** `ID_Nome_Em_Snake_Case` para pastas; `ARC-####` para tickets; `SPL_`, `CLS_`, `FEAT_`, `ICO_` como prefixos de assets e entradas de dados. Sem espaços nem acentos em nomes de arquivos do mod (o empacotador `.pak` e o Script Extender são sensíveis a isso).

## 3. Mapa das áreas e donos

| Área | Departamento | Diretor (dono) | Missão |
| --- | --- | --- | --- |
| 00 | Governança | Owners (você + Claude Opus) | Regras do estúdio, decisões, registro de agentes |
| 05 | Contexto Vivo | Guardião do Contexto (líder), sob o Produtor Executivo | Espelho do mod como está hoje, sem histórico; lido primeiro por todos |
| 10 | Produto & Gestão Ágil | Produtor Executivo / Scrum Master | Backlog, sprints, cerimônias, roadmap |
| 20 | Game Design | Diretor de Game Design | GDD da classe, magias, dados mestres em YAML, progressão, balanceamento D&D 5e, economia de recursos, base de conhecimento de design (Parte II) |
| 30 | Narrativa & Lore | Diretor de Narrativa | Todo texto visível ao jogador: lore, nomes e descrições, diálogos, localização |
| 40 | Arte & UI | Diretor de Arte | Ícones, UI, VFX, texturas, pipeline DDS |
| 50 | Engenharia | Diretor de Engenharia | Fonte de verdade do mod, specs de implementação, build; escreve código só sob demanda |
| 60 | QA | Diretor de QA | Plano de testes, bugs, regressão |
| 70 | Release & Distribuição | Diretor de Release | Empacotamento, changelog, patch notes por diff de versão, Nexus Mods, mod.io |
| 80 | Ferramentas & Pipeline | Diretor de Engenharia (delegado a Tech Lead de Pipeline) | Ferramentas externas, scripts de automação |
| 90 | Arquivo | Produtor Executivo | Material descontinuado, sprints encerradas |

## 4. Árvore de diretórios

Legenda: `[DIR]` Diretor · `[LÍDER]` Líder de setor · `[EXEC]` Executor · `[OWN]` Owners. Todo item abaixo tem como dono o responsável indicado na linha da categoria.

```
Arcana Class/                         # = pasta local da Lumox Studios; raiz do repositório github.com/Geminitrix/arcana-class-bg3 (privado)
│
├── README.md                          # Vitrine do projeto (estado, versão publicada, subclasses) + mapa de navegação [Produtor]
├── CLAUDE.md                          # Lido pelo Claude Code em toda sessão: regras curtas + ponteiros [OWN]
├── AGENTS.md                          # Regras universais para todos os agentes [OWN]
├── CODEOWNERS                         # Quem aprova mudanças em cada pasta (GitHub) [OWN]
├── .gitignore  .gitattributes         # Revisados na migração (seção 12); Git LFS para .dds .png .psd .wem .pak [Eng]
│
├── .claude/                           # Configuração do Claude Code [Diretor de Engenharia]
│   ├── agents/                        # Um arquivo .md por profissão (subagentes)
│   │   ├── produtor-scrum.md   lead-class-designer.md   spell-designer.md   balanceador.md   lore-writer.md
│   │   ├── mod-engineer.md   stats-engineer.md   khonsu-engineer.md   lua-engineer.md   osiris-engineer.md   code-reviewer.md     artista-icones.md  qa-lead.md
│   │   ├── guardiao-contexto.md           # Mantém a área 05
│   │   └── patch-notes-lead.md ... (demais dormentes, ver seção 5)
│   ├── commands/                      # /novo-ticket /iniciar-sprint /handoff /fechar-ticket /retro
│   │                                  # /sync-contexto /patch-notes /commit-e-push
│   ├── hooks/                         # Scripts que bloqueiam escrita fora do escopo do ticket
│   └── settings.json                  # Permissões e registro dos hooks
│
├── _LEGADO/                           # Material antigo copiado na migração (somente leitura) [OWN]
│
├── 00_GOVERNANCA/                     # [OWN] Owners
│   ├── 00.01_Constituicao_do_Estudio/ # Visão, valores, escopo do Arcana Class
│   ├── 00.02_Hierarquia_e_RACI/       # Quem decide o quê; matriz de responsabilidades
│   ├── 00.03_Definition_of_Ready_Done/# DoR e DoD globais e por departamento (DoD inclui contexto 05 e README)
│   ├── 00.04_Decisoes_ADR/            # ADRs aprovados (ADR-0001...)
│   │   └── PROPOSTAS/                 # Sugestões estratégicas dos agentes, aguardando decisão dos Owners
│   ├── 00.05_Registro_de_Agentes/     # Ficha de cada agente: papel, escopo, pastas, status (ativo/dormente)
│   ├── 00.06_Licencas_e_Plataformas/  # Licença do mod, créditos, regras Nexus/mod.io, origem de assets
│   └── 00.07_Politica_de_Implementacao/ # Regra do campo implementacao nos tickets (seção 7)
│
├── 05_CONTEXTO_VIVO/                  # [LÍDER] Guardião do Contexto — ESPELHO do mod HOJE (sem histórico). Lida primeiro.
│   ├── 05.00_LEIA_PRIMEIRO.md         # 1 página: o que é o mod, estado atual, onde olhar
│   ├── 05.01_Classe/                  # Identidade, progressão atual 1-12 e módulo 13-20, recursos
│   ├── 05.02_Subclasses/              # Um arquivo por subclasse: Deceiver, Starchild, Eternal, Unbound,
│   │                                  #   Resonant, Spinner, Lionheart (como estão agora)
│   ├── 05.03_Magias_e_Passivas/       # Catálogo vigente: nome interno, nível, tipo, o que faz
│   ├── 05.04_Status_e_Condicoes/
│   ├── 05.05_Texto_e_Lore_Vigentes/   # Nomes oficiais, tom adotado, glossário em uso
│   ├── 05.06_Estado_Tecnico/          # Estrutura do mod, UUIDs, dependências, versões fixas, versão publicada
│   └── 05.07_Mapa_de_Fontes/          # Qual arquivo (25, 51, 33...) é a fonte de cada informação
│
├── 10_PRODUTO_E_GESTAO_AGIL/          # [DIR] Produtor Executivo / Scrum Master
│   ├── 10.01_Product_Backlog/         # [LÍDER] Product Owner Agent
│   │   ├── BACKLOG.md                 # Lista priorizada (MoSCoW + valor/esforço), gerada dos tickets
│   │   ├── epics/                     # EPIC_Rework_Subclasses, EPIC_Subclasses_Novas, EPIC_Nucleo_1_12...
│   │   ├── stories/                   # ARC-0142_Faisca_Arcana.md (cabeçalho YAML + corpo)
│   │   └── _TEMPLATE_TICKET.md        # Campos: id, tipo, status, dono, implementacao, entradas, saidas, bloqueado_por
│   ├── 10.02_Sprint_Ativa/            # [LÍDER] Scrum Master Agent
│   │   ├── SPRINT_GOAL.md             # Meta da sprint em 1 frase
│   │   ├── SPRINT_BOARD.md            # GERADO por script: A Fazer | Em Andamento | Spec Pronta | Em QA | Pronto
│   │   ├── daily_logs/                # 1 arquivo por sessão (feito, bloqueios, próximo passo)
│   │   └── handoffs/                  # Tickets entre departamentos
│   ├── 10.03_Brainstorm_Mecanicas/    # [LÍDER] Game Design Facilitator
│   │   ├── ideias_brutas/             # Despejo livre, sem filtro
│   │   ├── prototipos_papel/          # Testes em planilha/tabletop antes de especificar
│   │   └── ideias_aprovadas_para_backlog.md
│   ├── 10.04_Cerimonias/              # [LÍDER] Scrum Master Agent
│   │   ├── planning/   review/   refinement/
│   │   └── retrospectivas/            # RETRO_S01.md: manter / parar / começar
│   ├── 10.05_Roadmap_e_Releases/      # [LÍDER] Product Owner Agent
│   │   ├── ROADMAP.md                 # Marcos do rework; módulo 13-20 depois
│   │   └── metricas_velocity.md
│   └── 10.06_Impedimentos/            # [LÍDER] Scrum Master — bloqueios abertos
│
├── 20_GAME_DESIGN/                    # [DIR] Diretor de Game Design
│   ├── 21_GDD_Arcana_Class/           # [LÍDER] Lead Class Designer
│   │   ├── 21.01_Visao_e_Pilares.md   # Pilares (3 a 5), fantasia da classe, ficha-chassi (seções 17 e 18)
│   │   ├── 21.02_Identidade_da_Classe/    # Nome, dado de vida, proficiências, spellcasting
│   │   ├── 21.03_Tabela_de_Progressao/    # Features por nível, 1 a 12 (núcleo)
│   │   ├── 21.04_Subclasses/              # Uma pasta por subclasse
│   │   │   └── _PADRAO_DE_SUBCLASSE.md    # Patamar comum de poder, complexidade e nº de features
│   │   ├── 21.05_Features_de_Classe/      # FEAT_*.md (texto de design; números vêm de 25)
│   │   ├── 21.06_Interacoes_e_Sinergias/  # Multiclasse, itens, condições
│   │   ├── 21.07_Modulo_Expansao_13_20/   # Progressão 13-20: extra, nada do núcleo depende dele
│   │   └── 21.08_Matriz_de_Subclasses.md  # Fantasia, papel, recurso, assinatura e features das 7 subclasses + matriz de cobertura de papéis
│   ├── 22_Balanceamento_DnD5e/        # [LÍDER] Balanceador de Status
│   │   ├── 22.01_Referencias_5e_BG3/      # Regras base: SRD 5e, mudanças da Larian
│   │   ├── 22.02_Planilhas_de_Dano/       # Leem os YAML de 25; ajuste de valor é feito em 25
│   │   ├── 22.03_Economia_de_Acoes/       # Efeito da economia de ação no dano (as regras e o mapa de conflitos vivem em 26.03)
│   │   ├── 22.04_Benchmarks_Classes/      # Comparação com classes vanilla e entre as 7 subclasses
│   │   ├── 22.05_Relatorios_de_Balanceamento/
│   │   ├── 22.06_Orcamento_de_Poder/      # Curva de poder por nível (DPR sustentado e nova, dano virtual) com dados do jogo base
│   │   └── 22.07_Metodo_e_Checklists/     # Fluxo de balanceamento, sinais de alerta, modelo de intenção
│   ├── 23_Design_de_Magias/           # [LÍDER] Spell Designer
│   │   ├── 23.01_Lista_de_Magias/         # SPELL_LIST.md: nível, escola, tipo
│   │   ├── 23.02_Fichas_de_Magia/         # SPL_*.md: intenção, fantasia, regras em texto
│   │   └── 23.03_Condicoes_e_Status/      # Texto de design dos status customizados
│   ├── 24_Itens_e_Equipamentos/       # [EXEC] Item Designer
│   ├── 25_Dados_Mestres/              # [LÍDER] Spell Designer + Balanceador — FONTE ÚNICA DOS NÚMEROS
│       ├── schemas/                       # Esquemas de validação (campos obrigatórios, tipos, faixas)
│       ├── spells/                        # SPL_Faisca_Arcana.yaml (nível, dano, alcance, save, escalonamento)
│       ├── features/                      # FEAT_*.yaml
│       ├── statuses/                      # STA_*.yaml
│       └── classes/                       # CLS_Arcana.yaml (níveis 1-12) e CLS_Arcana_Expansao_13_20.yaml
│   ├── 26_Economia_de_Recursos/       # [LÍDER] Balanceador — economia de recursos e de ação (seção 20)
│   │   ├── 26.01_Mapa_e_Auditoria_de_Recursos/  # Fontes, ralos e recargas por classe e subclasse
│   │   ├── 26.02_Descansos_e_Ritmo/       # Dia de aventura de referência; descansos curtos e longos do BG3
│   │   └── 26.03_Economia_de_Acao/        # Ação, bônus, reação, movimento, concentração: mapa de conflitos
│   └── 27_Base_de_Conhecimento_Design/ # [DIR] Diretor de Game Design — fichas curtas da Parte II, uma por tópico
│       ├── 27.01_Fundamentos/             # MDA, pilares, motivação, complexidade (seção 17)
│       ├── 27.02_DnD5e_e_BG3/             # Precisão limitada, chassi, subclasses, limites do BG3 (seção 18)
│       ├── 27.03_Balanceamento/           # Curva de custo, dano virtual, DPR, sinais de alerta (seção 19)
│       ├── 27.04_Economia/                # Recursos, descansos, ação (seção 20)
│       ├── 27.05_Narrativa_e_Lore/        # Harmonia ludonarrativa, bíblia de lore, tom (seção 21)
│       ├── 27.06_Playtest/                # Protocolos e modelos (seção 22)
│       └── 27.07_Fontes.md                # Lista da seção 24, com resumo de cada fonte lida
│
├── 30_NARRATIVA_E_LORE/               # [DIR] Diretor de Narrativa — todo texto visível ao jogador
│   ├── 31_Lore_Arcana/                # [LÍDER] Lore Writer
│   │   ├── 31.01_Biblia_de_Lore.md        # Lore do projeto: origem da classe, tom, temas
│   │   ├── 31.02_Temas_Classe_e_Subclasses/ # Tema e fantasia de cada subclasse, ligados à lore
│   │   ├── 31.03_Guia_de_Estilo_BG3/      # Tom, vocabulário, tamanho e marcação, derivados da loca vanilla
│   │   └── 31.04_Referencia_Vanilla_Loca/ # Extração LOCAL da loca do jogo base (FORA do Git)
│   ├── 32_Integracao_BG3/             # [LÍDER] Narrative Integrator
│   │   ├── 32.01_Descricoes_e_Flavor/     # Nomes, descrições e flavor de features, magias e status
│   │   ├── 32.02_Reacoes_de_Companheiros/ # Falas/ganchos opcionais
│   │   ├── 32.03_Consistencia_Faerun/     # Checagem contra o cânone
│   │   └── 32.04_Revisao_Narrativa/       # Registro de aprovação de cada texto (Narrative Gate)
│   └── 33_Localizacao/                # [LÍDER] Localization Agent
│       ├── 33.01_Fonte_EN/                # Strings-mestre (inglês)
│       ├── 33.02_Traducoes/               # pt-BR e outros idiomas
│       └── 33.03_Glossario_Termos/        # Termos fixos
│
├── 40_ARTE_E_UI/                      # [DIR] Diretor de Arte
│   ├── 41_Direcao_de_Arte/            # [LÍDER] Art Lead
│   │   └── 41.01_Style_Guide.md           # Cores arcanas, formas, regras de ícone
│   ├── 42_Icones/                     # [EXEC] Artista de Ícones
│   │   ├── 42.01_Fontes_Editaveis/        # PSD/XCF/SVG (LFS)
│   │   ├── 42.02_Exportados_PNG/          # Saída intermediária
│   │   └── 42.03_Atlas_e_DDS/             # Final para o jogo (via BG3 DDS Convert)
│   ├── 43_UI_e_Interface/             # [LÍDER] UI Artist
│   │   ├── 43.01_Hotbar_e_Spellbook/
│   │   ├── 43.02_Telas_Level_Up/
│   │   └── 43.03_Especificacoes/          # Resoluções, nine-slice, safe areas
│   ├── 44_VFX/                        # [LÍDER] VFX Artist
│   │   ├── 44.01_Conceitos/   44.02_Texturas_VFX/   44.03_Efeitos_Finalizados/
│   └── 45_Modelos_e_Texturas/         # [EXEC] 3D Artist (se houver itens/armas)
│
├── 50_ENGENHARIA/                     # [DIR] Diretor de Engenharia
│   ├── 51_Codigo_Fonte_Mod/           # [LÍDER] Lead Mod Engineer — FONTE DE VERDADE DO MOD
│   │   │                              # Escrita: Owner (no Toolkit) OU subagente SE ticket tiver implementacao: claude
│   │   └── ArcanaClass/               # Espelha a estrutura empacotada em .pak
│   │       ├── Mods/ArcanaClass_<UUID>/
│   │       │   ├── meta.lsx           # Nome, UUID, versão, dependências
│   │       │   ├── ScriptExtender/
│   │       │   │   ├── Config.json    # Configuração do BG3 Script Extender
│   │       │   │   └── Lua/           # BootstrapServer/Client.lua
│   │       │   ├── Story/RawFiles/Goals/ # Osiris (se necessário)
│   │       │   ├── Scripts/thoth/helpers/ # Funções de condição Khonsu (.khn) da classe
│   │       │   ├── Localization/      # XML de strings (gerado de 33_)
│   │       │   └── GUI/               # Layouts e referências de UI
│   │       ├── Public/ArcanaClass_<UUID>/
│   │       │   ├── Stats/Generated/Data/  # Spell_*.txt  Status_*.txt  Passive.txt
│   │       │   ├── ClassDescriptions/     # LSX
│   │       │   ├── Progressions/          # Progressão por nível (LSX)
│   │       │   ├── Lists/                 # Listas de magias, passivas, skills
│   │       │   ├── RootTemplates/
│   │       │   ├── Content/Assets/        # Ícones DDS + atlas (de 42.03)
│   │       │   └── Tags/  Races/  Feats/  # Conforme necessário
│   │       └── Generated/             # Saída de ferramentas (NÃO editar à mão; fora do Git)
│   ├── 52_Padroes_de_Codigo/          # [LÍDER] Lead Mod Engineer
│   │   ├── 52.01_Convencoes_de_Codigo/ # Lua, Khonsu, Osiris, Stats e LSX
│   │   ├── 52.02_Biblioteca_de_Snippets/  # Padrões validados de magia/passiva
│   │   ├── 52.03_Versoes_Fixadas/         # Versão final do jogo + Script Extender + ferramentas usadas
│   │   └── 52.04_Registro_de_UUIDs/       # Todo UUID criado: arquivo, ticket de origem (validador recusa duplicatas)
│   ├── 53_Build_e_Versionamento/      # [LÍDER] Build Engineer
│   │   ├── 53.01_Scripts_de_Build/        # Valida, converte, empacota
│   │   ├── 53.02_Git_Workflow/            # Branches: main, develop, feature/ARC-####
│   │   ├── 53.03_Validadores/             # YAML x schema, UUIDs duplicados, handles de texto, núcleo x expansão
│   │   └── 53.04_Saida_de_Build/          # .pak gerados (fora do git)
│   ├── 54_Documentacao_Tecnica/       # [EXEC] Tech Writer
│   ├── 55_Specs_de_Implementacao/     # [LÍDER] Lead Mod Engineer — o que o Owner (ou o Claude) precisa para implementar
│       ├── 55.00_Catalogo_de_Tipos.md     # Tipos e subtipos (Spell/Target, Status, Passive...) conferidos no Toolkit
│       ├── _TEMPLATE_SPEC.md              # Índice de itens + tabela campo→valor→origem por item
│       └── SPEC_ARC-0142.md               # Spec de um ticket; sem código
│   ├── 56_Referencia_Vanilla_Codigo/  # [LÍDER] Lead Mod Engineer — extração LOCAL do código do jogo base (FORA do Git)
│   │   ├── 56.01_Osiris_Goals/            # Goals extraídos de story.div.osi (Gustav, GustavDev, Honour) via LSLib
│   │   ├── 56.02_Stats_Vanilla/           # Stats/Generated/Data, Modifiers.txt e ValueLists.txt do jogo base
│   │   ├── 56.03_Khonsu_Vanilla/          # Arquivos .khn e scripts thoth do jogo base
│   │   ├── 56.04_Lua_e_SE_Exemplos/       # Mod de exemplo do Script Extender e mods abertos de referência
│   │   └── 56.05_Indices/                 # Índices gerados: eventos, queries, calls, bancos e funções Khonsu
│   └── 57_Base_de_Conhecimento_Engenharia/ # [DIR] Diretor de Engenharia — fichas curtas da Parte III, uma por tópico
│       ├── 57.01_Arquitetura_e_Ferramenta/   # Seção 25
│       ├── 57.02_Stats_e_LSX/                # Seção 26
│       ├── 57.03_Khonsu_Thoth/               # Seção 27
│       ├── 57.04_Lua_SE/                     # Seção 28
│       ├── 57.05_Osiris/                     # Seção 29, catálogo de padrões e avaliação do agente
│       ├── 57.06_Fluxo_e_Qualidade/          # Seções 30 e 31
│       └── 57.07_Fontes.md                   # Lista da seção 34, com resumo de cada fonte lida
│
├── 60_QA_E_TESTES/                    # [DIR] Diretor de QA
│   ├── 61_Plano_de_Testes/            # [LÍDER] QA Lead
│   │   ├── 61.01_Estrategia_QA.md
│   │   ├── 61.02_Casos_de_Teste/          # TC_SPL_*.md ligados às fichas e aos YAML
│   │   └── 61.03_Checklists_de_Release/
│   ├── 62_Bug_Tracker/                # [LÍDER] Bug Triage Agent
│   │   ├── abertos/   em_correcao/   resolvidos/
│   │   └── _TEMPLATE_BUG.md               # Título, versão, repro, esperado/obtido, logs
│   ├── 63_Testes_de_Balanceamento/    # [EXEC] Playtester Agent — prepara e analisa os testes; quem joga são os Owners e testadores
│   ├── 64_Regressao_e_Compatibilidade/# [EXEC] Compat Tester — conflitos com outros mods
│   └── 65_Evidencias/                 # Logs do Script Extender, screenshots
│
├── 70_RELEASE_E_DISTRIBUICAO/         # [DIR] Diretor de Release
│   ├── 71_Empacotamento/              # [LÍDER] Release Engineer
│   │   ├── 71.01_Pak_Final/               # Artefatos aprovados por versão (LFS)
│   │   └── 71.02_Verificacao_Pos_Build/   # Hash, tamanho, instalação limpa
│   ├── 72_Nexus_Mods/                 # [EXEC] Publisher — descrição, imagens, changelog
│   ├── 73_mod_io/                     # [EXEC] Publisher — descrição, imagens, metadados
│   ├── 74_Changelogs/                 # [EXEC] Release Notes Writer — CHANGELOG.md mestre (resumo técnico)
│   ├── 75_Comunidade_e_Suporte/       # [EXEC] Community Agent — FAQ, feedback
│   └── 76_Patch_Notes/                # [LÍDER] Patch Notes Lead — notas para jogadores, estilo League of Legends
│       ├── 76.01_Baseline_Publicada/      # .pak da versão hoje no mod.io (LFS) + hash; extração local fora do Git
│       ├── 76.02_Diffs_de_Versao/         # DIFF_vA_para_vB gerado por script (baseline x build nova)
│       ├── 76.03_Padrao_de_Escrita/       # Guia de estilo, rótulos, exemplos com ⇒
│       ├── 76.04_Rascunhos/
│       └── 76.05_Publicados/              # PATCH_vX.Y.Z.md finais
│
├── 80_FERRAMENTAS_E_PIPELINE/         # [LÍDER] Tech Lead de Pipeline
│   ├── 81_Ferramentas_Externas/       # Divine/LSLib, BG3 Modder's Multitool, BG3 DDS Convert, Script Extender (versões fixas)
│   ├── 82_Automacao/                  # Scripts do pipeline
│   │   ├── gerar_stats_de_yaml        # Rascunho de Spell_*.txt a partir de 25 (opcional). Também: sincronizar_data (pasta Data do Toolkit <-> 51)
│   │   ├── gerar_loca                 # Strings de 33_ para XML de localização
│   │   ├── converter_icones_dds       # PNG → DDS via BG3 DDS Convert
│   │   ├── atualizar_board            # Gera SPRINT_BOARD.md e _INDEX.md dos tickets
│   │   ├── validar_dados              # YAML x schema; números citados em texto x YAML
│   │   ├── extrair_vanilla            # Extrai Osiris, Stats e Khonsu do jogo base para 56 (local)
│   │   ├── indexar_vanilla            # Gera os índices de 56.05 para busca rápida
│   │   ├── lint_codigo                # luacheck (Lua), Khonsu, Stats e LSX contra os esquemas do jogo
│   │   ├── extrair_pak                # Desempacota um .pak e converte formatos binários para comparação
│   │   ├── comparar_versoes           # Diff estruturado baseline x build nova (alimenta 76.02)
│   │   ├── promover_baseline          # Após publicar: a build lançada vira a nova baseline
│   │   └── checar_readme              # Compara README com 05 e com a versão publicada
│   ├── 83_Ambiente_de_Teste/
│   │   ├── 83.01_Setup_do_Jogo/           # Instruções de instalação e configuração
│   │   └── 83.02_Saves_Padrao/            # Saves por nível: nv01, nv05, nv08, nv12
│   └── 84_Documentacao_de_Ferramentas/
│
└── 90_ARQUIVO/                        # [DIR] Produtor Executivo
    ├── 91_Sprints_Encerradas/         # Cópias congeladas de 10.02 após a review
    ├── 92_Ideias_Descartadas/         # Com o motivo do descarte
    └── 93_Versoes_Antigas/            # GDDs, specs e baselines substituídos
```

## 5. Execução no Claude Code: como os agentes funcionam na prática

Os agentes não conversam entre si como pessoas. Cada um roda isolado, com contexto próprio, e a comunicação acontece por arquivos (tickets e handoffs). Quem coordena é o Claude da sessão que você abriu.

| Peça | O que é | Onde vive |
| --- | --- | --- |
| Sessão principal (coordenador) | O Claude com quem você conversa. Lê o ticket, decide qual departamento é necessário e chama o agente certo | `CLAUDE.md` na raiz |
| Subagente (profissão) | Especialista que roda em contexto próprio, faz a tarefa e devolve só um resumo, o que poupa o contexto da sessão | Um `.md` por profissão em `.claude/agents/`, com nome, descrição, ferramentas permitidas e instruções |
| Comando | Rotina que você dispara com uma barra (`/novo-ticket`, `/handoff`, `/retro`) | `.claude/commands/` |
| Hook | Script que o sistema roda antes ou depois de uma ação e que pode bloqueá-la | `.claude/hooks/` e `.claude/settings.json` |

**Quando uma tarefa depende de outro departamento.** Em geral, um subagente não chama outro subagente: quem encadeia é a sessão principal. Exemplo: o Mod Engineer precisa do ícone da Faísca Arcana.

1. O Engineer lê a spec e vê que falta `ICO_Faisca_Arcana.dds` em `42.03`.
2. Em vez de inventar, escreve `HANDOFF_Eng_para_Arte.md` na pasta da Arte, marca o ticket com `status: bloqueado` e `bloqueado_por: arte`, e devolve um resumo ao coordenador.
3. O coordenador chama o Artista de Ícones, que lê o handoff e produz o arquivo.
4. O Artista marca o handoff como atendido e devolve o resumo.
5. O coordenador volta o ticket para `em_andamento` e chama o Engineer de novo, que continua de onde parou.

Para você, isso parece uma conversa só: basta dizer "continua o ARC-0142".

**Sessões separadas por tópico.** Funciona bem, porque a memória está nos arquivos. Cada sessão começa lendo `CLAUDE.md`, o ticket e o último `daily_log`, e termina atualizando o ticket e o log. Sugestão: uma sessão por ticket ou por tema (ex.: "ARC-0142", "Retro S03", "Auditoria do legado").

**Guardrails.** São regras que o sistema aplica sozinho, em vez de depender de o agente lembrar delas. Três camadas:

- **Ferramentas limitadas por subagente:** o Balanceador, por exemplo, só lê e escreve em `20_GAME_DESIGN`.
- **Hooks:** antes de cada escrita, um script confere se o arquivo está no escopo do ticket e se o campo `implementacao` permite escrever em `51`. Se não permitir, bloqueia.
- **Git:** branches `feature/ARC-####` e merge em `main` só com aprovação dos Owners. O `CODEOWNERS` registra o dono de cada pasta (vale se o repositório estiver no GitHub; localmente, o hook cumpre esse papel).

Sempre passam por aprovação humana: ADRs, merges em `main` e publicações nas plataformas.

**Ativação gradual.** Uma ficha em `00.05` existe para todos os papéis, mas só os ativos têm arquivo em `.claude/agents/`. Papel dormente é papel que ainda não custa contexto nem token.

| Papel | Estado na Sprint 0 | Ativar quando |
| --- | --- | --- |
| Produtor / Scrum Master (também mantém o README) | Ativo | — |
| Game Design: Lead Class Designer, Spell Designer e Balanceador (3 agentes, cada um com a sua ficha da Parte II) | Ativo | — |
| Lore Writer (acumula Localização) | Ativo | Separar a Localização quando houver mais de um idioma |
| Mod Engineer, coordenador de engenharia (acumula Build e Pipeline); especialistas em Stats e LSX, Khonsu, Lua e Osiris na Parte III | Ativo, em modo de specs | Ativar cada especialista no primeiro ticket do tipo; separar o Build Engineer quando o build for frequente |
| Artista de Ícones | Ativo | — |
| Guardião do Contexto | Ativo | — |
| QA Lead | Ativo | — |
| Patch Notes Lead | Dormente; a baseline é preparada na Sprint 0 | No primeiro release depois da migração |
| VFX, UI, 3D | Dormente | Quando a primeira magia com efeito próprio entrar na sprint |
| Release, Publisher, Comunidade | Dormente | Antes do primeiro release público do rework |

O Claude Code evolui rápido e tem recursos mais novos de coordenação entre agentes. Antes de adotar qualquer um além de subagentes, comandos e hooks, o Claude executor deve consultar a documentação atual e propor aos Owners.

## 6. Como os agentes se orientam (protocolo de contexto)

1. Ler `CLAUDE.md`, `AGENTS.md` e o `_AGENT.md` da própria pasta.
2. Abrir o ticket (`ARC-####`) e conferir o cabeçalho: status, `implementacao`, entradas, saídas e `bloqueado_por`.
3. Ler apenas os arquivos que o ticket lista por ID Johnny.Decimal (ex.: entrada `25` e `23.02`, saída `55`). Não varrer o repositório inteiro.
4. Escrever somente na própria pasta e dentro do escopo do ticket. Para pedir algo a outro departamento, criar `HANDOFF_<origem>_para_<destino>.md` na pasta de destino e registrar o bloqueio no ticket.
5. Nunca copiar números de balanceamento para outro arquivo: ler sempre de `25_Dados_Mestres`.
6. Ao terminar: atualizar o ticket (status e saídas), registrar a sessão no `daily_log` e rodar `atualizar_board`.
7. Líderes que instanciam sub-agentes para microtarefas (ex.: gerar 12 ícones, redigir 30 descrições) registram o escopo no ticket e revisam a saída antes de marcá-la como pronta. Sub-agentes escrevem em `_wip/` do líder, nunca direto na pasta final.

## 7. Implementação sob demanda

Escrever o código do mod (Stats, Lua, LSX) é o que mais consome tokens, e é a parte que você pode preferir fazer direto no Toolkit. Por isso o time entrega a especificação completa por padrão, e a implementação só acontece quando você pedir. Cada ticket tem o campo `implementacao` no cabeçalho:

| Valor | Quem escreve em `51` | O que o time faz |
| --- | --- | --- |
| `pendente` (padrão) | Ninguém | Engenharia produz `SPEC_ARC-####.md` em `55`; o ticket para em "Spec Pronta" |
| `owner` | Você, no Toolkit | A mesma spec. Depois que você implementar, Engenharia lê o resultado, roda os validadores e abre bug se achar divergência da spec |
| `claude` | Subagente Mod Engineer | Somente depois de você pedir de forma explícita (ex.: "implementa o ARC-0142"). O campo muda para `claude` e o hook libera a escrita |

**Regras:**

- A spec cobre tudo que é necessário para implementar sem adivinhar: arquivos afetados, campos e valores (vindos de `25`), strings e handles, ícones, UUIDs reservados e critérios de aceite. Ela não contém código.
- O hook bloqueia qualquer escrita em `51` quando `implementacao` não for `claude`.
- Se você implementar no Toolkit, sincronize os arquivos editados de volta para `51` (cópia manual ou link simbólico). `51` precisa continuar sendo a fonte de verdade para build, QA e release.
- Design, Arte, Narrativa, QA e Release trabalham normalmente nos três modos.
- O script `gerar_stats_de_yaml` é opcional: gera um rascunho de `Spell_*.txt` que você pode colar no Toolkit sem gastar tokens de agente.

**Pasta `Data` do Toolkit e pasta `51`.** Os arquivos do mod que o Toolkit builda e envia ao mod.io vivem na pasta `Data` do jogo, e a pasta `51` precisa refletir exatamente o mesmo conteúdo. Duas cópias soltas divergem com facilidade, então o Claude executor deve testar e propor em ADR uma das duas soluções:

- **Uma só cópia:** `51` é a pasta real e a `Data` aponta para ela por link simbólico ou junção de diretório (no Windows). Você edita no Toolkit e o Git enxerga tudo.
- **Duas cópias com sincronização:** a `Data` continua sendo a pasta real e o script `sincronizar_data` copia `Data` para `51` antes de cada commit, avisando de qualquer diferença.

A primeira opção é a preferida, desde que o Toolkit e o jogo funcionem bem com o link. Em qualquer caso, nunca se edita nas duas pastas ao mesmo tempo.

**Formato da spec: feita para você implementar no Toolkit.** Cada `SPEC_ARC-####.md` é uma lista numerada de itens de implementação, na ordem em que devem ser criados. Você percorre de cima para baixo e vai ticando. O arquivo começa com um índice que mostra, de relance, o tipo e o subtipo de cada item:

| # | Tipo | Subtipo | Entrada interna | Onde no Toolkit | Depende de | Feito |
| --- | --- | --- | --- | --- | --- | --- |
| 01 | Status | Tipo do status (ex.: BOOST) | STA\_Exemplo | Stats → Status | — | ☐ |
| 02 | Passiva | Tipo de efeito | PAS\_Exemplo | Stats → Passive | 01 | ☐ |
| 03 | Magia | Target / Projectile / Zone / Shout... | SPL\_Faisca\_Arcana | Stats → Spell | 01 | ☐ |
| 04 | Lista de magias | — | LST\_Arcana\_Nv1 | Lists | 03 | ☐ |
| 05 | Progressão | Nível 1 | PRG\_Arcana\_01 | Progressions | 03, 04 | ☐ |
| 06 | Localização | — | handles h\_... | Localization | — | ☐ |
| 07 | Ícone | — | ICO\_Faisca\_Arcana | Assets / atlas | — | ☐ |

A tabela acima é apenas um exemplo do formato. Cada item da spec traz:

- **Identificação:** tipo, subtipo, nome interno da entrada, entrada-mãe herdada (`using`, se houver) e arquivo onde ela vive.
- **Tabela campo → valor → origem:** cada campo a preencher, o valor final e o ID do YAML em `25` de onde o valor veio. Sem texto corrido, para ser possível copiar campo a campo.
- **Dependências:** o que precisa existir antes (o status que a magia aplica, o ícone, os handles de texto), apontando para o número do item.
- **Textos prontos:** handle e texto final aprovado pela Narrativa (seção 9).
- **Como verificar no jogo:** 2 a 4 passos curtos para confirmar que funciona.

A ordem sugerida segue as dependências: status, passivas, magias, listas, progressão, classe e subclasse, localização, ícones. A taxonomia de tipos e subtipos fica em `55.00_Catalogo_de_Tipos.md`. O Claude executor deve montá-la inspecionando o Toolkit e os dados do jogo base instalados na sua máquina, não de memória (por exemplo, a lista completa de tipos de magia como Target, Projectile, ProjectileStrike, Zone, Shout, Rush, Throw e Teleportation precisa ser conferida lá).

## 8. Ciclo de vida de uma feature: nova magia de Nível 1

Exemplo: **Faísca Arcana** (ARC-0142), uma magia de dano de Nível 1 da Arcana Class.

| Etapa | Onde acontece | Agente | Resultado |
| --- | --- | --- | --- |
| 1. Ideação | `10.03_Brainstorm_Mecanicas/ideias_brutas/` | Game Design Facilitator + Owners | Ideia registrada; se aprovada, vai para `ideias_aprovadas_para_backlog.md` |
| 2. Backlog | `10.01_Product_Backlog/stories/ARC-0142_...md` | Product Owner Agent | Ticket com cabeçalho YAML (`implementacao: pendente`) e critérios de aceite, priorizado no `BACKLOG.md` |
| 3. Refinamento e Planning | `10.04_Cerimonias/refinement` e `planning` | Scrum Master + líderes | DoR cumprida, estimativa feita; o ticket entra na Sprint Ativa e aparece no `SPRINT_BOARD.md` |
| 4. Design e dados mestres | `23.02_Fichas_de_Magia/SPL_Faisca_Arcana.md` e `25_Dados_Mestres/spells/SPL_Faisca_Arcana.yaml` | Spell Designer | Intenção e regras em texto na ficha; alcance, área, save, dano e escalonamento no YAML, validado contra o schema |
| 5. Balanceamento | `22.02_Planilhas_de_Dano/` e `22.04_Benchmarks_Classes/` | Balanceador de Status | Planilhas leem o YAML; ajustes são feitos no YAML, nunca em cópias; aprovação registrada no ticket |
| 6. Narrativa e Localização | `32.01_Descricoes_e_Flavor/` e `33.01_Fonte_EN/` | Lore Writer + Localization Agent | Nome, descrição e flavor aprovados; strings-mestre criadas; tradução pt-BR em `33.02` |
| 7. Arte | `42_Icones` → `42.03_Atlas_e_DDS/` e `44_VFX` | Artista de Ícones + VFX Artist | Ícone convertido para DDS pelo BG3 DDS Convert; efeito entregue; handoff para Engenharia |
| 8. Spec de implementação | `55_Specs_de_Implementacao/SPEC_ARC-0142.md` | Mod Engineer | Arquivos, campos, valores, strings e UUIDs reservados. O ticket passa para "Spec Pronta" |
| 9. Implementação (só sob demanda) | `51_Codigo_Fonte_Mod/...` | Owner no Toolkit (`implementacao: owner`) ou Mod Engineer (`claude`) | Magia definida, adicionada à lista de magias e à progressão, strings ligadas. Sem pedido seu, o ticket espera aqui |
| 10. Validação | `53.03_Validadores/` | Mod Engineer / Build Engineer | Schema YAML, UUIDs, handles de texto e sintaxe aprovados |
| 11. Build interno | `53.04_Saida_de_Build/` | Build Engineer | `.pak` de teste gerado |
| 12. QA | `61.02_Casos_de_Teste/`, saves de `83.02`, evidências em `65_Evidencias/` | QA Lead + Playtester | Teste funcional, de balanceamento e de compatibilidade, sempre nos mesmos saves por nível |
| 13. Bugs (se houver) | `62_Bug_Tracker/abertos/BUG-####.md` | Bug Triage Agent → Engenharia | Ciclo volta à etapa 8 ou 9 até o QA aprovar |
| 14. Review da Sprint | `10.04_Cerimonias/review/` | Scrum Master + Owners | **Você valida a entrega**; critérios de aceite e DoD conferidos |
| 15. Release | `71_Empacotamento`, `74_Changelogs`, `72_Nexus_Mods`, `73_mod_io` | Release Engineer + Publisher | Checklist de `00.06` aprovado, `.pak` final, changelog e páginas publicadas |
| 16. Retrospectiva e arquivo | `10.04_Cerimonias/retrospectivas/` e `90_ARQUIVO/91_Sprints_Encerradas/` | Scrum Master | Lições registradas; sprint congelada no arquivo |

**Portões de qualidade:** o ticket só avança se cumprir a Definition of Ready (etapa 3) e a Definition of Done (etapa 14), ambas em `00.03`. A DoD inclui o contexto vivo (`05`) atualizado e o README conferido. As etapas 8 e 9 são separadas de propósito: a spec é sempre entregue, a implementação depende de você. No release, a seção 11 acrescenta a etapa de patch notes. O Portão de Design (18.8) e o Portão Narrativo (seção 9) precisam ser cumpridos antes de "Spec Pronta". Decisões que mudam o escopo da classe ou a arquitetura vão para ADR em `00.04` e exigem aprovação dos Owners.

## 9. Narrativa: todo texto que o jogador lê

Tudo que o jogador lê é narrativa e passa pela Narrativa antes de entrar no mod: nomes e descrições de features, magias, passivas, status e subclasses, textos de level up e lore. Cada texto precisa estar amarrado à lore do projeto, ao tema da classe e ao tema da subclasse, e soar como o jogo base. A base teórica está na seção 21.

- **Lore como base.** `31.01_Biblia_de_Lore.md` e `31.02` definem o tema e a fantasia da classe e de cada subclasse (Deceiver, Starchild, Eternal, Unbound, Resonant, Spinner, Lionheart). Nenhum texto novo é escrito sem consultá-los. Se a lore não cobre o caso, a Narrativa propõe a adição e os Owners aprovam.
- **Estilo do jogo base.** O Lore Writer extrai a localização vanilla do BG3 com as ferramentas de `81` e produz `31.03_Guia_de_Estilo_BG3`: tom, vocabulário, tamanho típico das descrições, como regras e números são expressos, marcação de tooltips e exemplos de como o jogo descreve magias, passivas e status. A extração em si fica em `31.04`, só na sua máquina e fora do Git, porque é conteúdo da Larian.
- **Regra e flavor separados.** Toda descrição tem uma parte de regra (curta, precisa, no vocabulário do jogo) e, quando fizer sentido, uma parte de flavor no tom da lore.
- **Números nunca digitados à mão no texto.** O validador compara os números citados nas descrições com o YAML de `25`. Se divergirem, o ticket não avança.
- **Fluxo.** O Designer entrega a intenção mecânica → o Lore Writer escreve nome, descrição e flavor com base no guia → a Localização cria handles e strings-mestre → a revisão narrativa registra a aprovação em `32.04` → o texto final entra na spec.
- **Narrative Gate.** Nenhuma spec é marcada como pronta com texto sem aprovação registrada. Alterar o texto de uma feature já publicada passa pelo mesmo portão e aparece nos patch notes.

## 10. Contexto vivo: o espelho do mod

A pasta `05_CONTEXTO_VIVO` descreve o mod como ele está **agora**, para os agentes e para você. É o primeiro lugar que qualquer agente lê, antes de abrir o resto do repositório.

- **Espelho, não histórico.** Sem notas de atualização e sem "antes era X". Se um valor mudou, o arquivo passa a mostrar o novo valor. O histórico já existe no Git, nos ADRs, nos changelogs e nos patch notes.
- **Dono:** o Guardião do Contexto, uma profissão própria. Ele não cria conteúdo: lê as fontes (`21`, `25`, `33`, `51`) e reescreve o espelho.
- **Quando atualiza:** ao fechar cada ticket (faz parte da DoD), depois de cada merge em `develop` e depois de cada release. O comando `/sync-contexto` força uma sincronização completa.
- **Cabeçalho de cada arquivo:** `fonte` (IDs das fontes), `sincronizado_em` (data e commit) e `estado` (sincronizado ou desatualizado). Se uma fonte mudou depois da última sincronização, um script marca o arquivo como desatualizado.
- **Nunca é fonte de verdade.** Em caso de conflito vale a fonte (`25` e `51`), e o Guardião corrige o espelho. Os outros agentes não editam `05` diretamente; pedem ao Guardião por handoff.
- **Curto de propósito.** Cada arquivo cabe numa leitura rápida, e `05.00_LEIA_PRIMEIRO.md` aponta para o resto. É isso que mantém o contexto barato em sessões novas.
- **Para você:** serve de consulta rápida do estado atual de cada subclasse, magia e texto, sem abrir o código.
- **Primeira carga:** na migração, o Guardião gera o espelho a partir do mod existente. Essa carga também é o melhor teste do inventário feito na auditoria (seção 16).

## 11. Patch notes e comparação entre versões

Os patch notes nascem da **diferença real** entre a versão publicada e a build nova, não de mensagens de commit nem de memória. O departamento é `76_Patch_Notes`, liderado pelo Patch Notes Lead e subordinado ao Diretor de Release.

1. **Baseline.** O `.pak` que está hoje no mod.io é baixado por você e guardado em `76.01_Baseline_Publicada/vX.Y.Z/` com o hash. O script `extrair_pak` o desempacota e converte os formatos binários (por exemplo, `.lsf` para `.lsx`, via Divine/LSLib) para que possam ser comparados. A extração fica local, fora do Git.
2. **Build nova.** O `.pak` de `53.04` passa pelo mesmo `extrair_pak`.
3. **Diff.** `comparar_versoes` gera `DIFF_vA_para_vB` em `76.02`: o que foi adicionado, removido e alterado, separado por tipo (magias, passivas, status, progressão, listas, textos, ícones).
4. **Conferência com os tickets.** Mudança no diff sem ticket correspondente vira alerta (alteração acidental ou não documentada). Ticket concluído sem mudança no diff também vira alerta (algo não entrou na build).
5. **Rascunho.** O Patch Notes Lead escreve em `76.04` a partir do diff, usando os tickets só para entender a intenção de design, e segue o padrão de `76.03`.
6. **Aprovação.** Você revisa e aprova.
7. **Publicação.** Você publica no mod.io pelo Toolkit. O texto final vai para `76.05`.
8. **Promoção da baseline.** Depois de publicar, `promover_baseline` registra a build lançada como a nova baseline, e a anterior vai para `90_ARQUIVO/93`. A partir daí, tudo que for construído é comparado a ela.

**Padrão de escrita, no estilo dos patch notes de League of Legends:**

- **Abertura:** 2 a 4 linhas com o foco do patch, seguidas de **Destaques** com o que mais muda para o jogador.
- **Uma seção por subclasse** (mais uma para a classe base). Dentro dela, uma entrada por magia ou feature, com o nome oficial do jogo e o nível, e uma linha de identificação do tipo (Passiva, Ação, Ação Bônus, Reação, Magia).
- **Intenção em uma frase.** Cada entrada de balanceamento abre com a razão da mudança, no tom direto de quem projetou. Entradas pequenas podem ser só as linhas de mudança.
- **Linhas de mudança no formato `Atributo: antes ⇒ depois`.** A seta ⇒ é a marca fixa, e o valor novo aparece em destaque (negrito, se a plataforma aceitar markdown). Valores que escalam por nível usam barras (`1 / 2 / 3`).
- **Rótulos fixos:** NOVO e REMOVIDO para o que entra ou sai. Quando ajudar, indicar o que ficou inalterado (por exemplo, "Dano do projétil: inalterado").
- **Seções finais:** **Correções de bugs**, sempre no formato "Corrigido um bug em que...", e **Textos e localização** para descrições reformuladas.
- **Tom** direto e sem marketing, com os termos do glossário (`33.03`).

Exemplo ilustrativo, com valores fictícios:

```
DECEIVER

Faísca Arcana (Magia, nível 1)
Ajustada para ganhar alcance sem aumentar o dano de pico.
- Dano: 1d8 ⇒ 1d10
- Alcance: 18 m ⇒ 24 m
- Teste de resistência: Destreza ⇒ Sabedoria

NOVO  Véu de Sombras (Feature, nível 3)
Permite se esconder como ação bônus.
- Duração: 3 turnos

CORREÇÕES DE BUGS
- Corrigido um bug em que Faísca Arcana não aplicava o status em alvos já enfraquecidos.
```

O padrão acima foi inspirado nos patch notes oficiais de League of Legends (patch 26.20), em que cada campeão tem uma frase de intenção e linhas de mudança com a seta. O exemplo acima é ilustrativo, com valores fictícios. Se o Patch Notes Lead propuser uma organização mais padronizada, ela é bem-vinda, desde que preserve o ⇒.

O primeiro patch do rework será comparado com a versão antiga, então o diff será enorme. Nesse caso o Patch Notes Lead escreve um resumo por subclasse e detalha só o que mudou de forma relevante para o jogador.

**Numeração de versões.** O Toolkit usa quatro números (Maior.Menor.Revisão.Build), e a versão publicada hoje é 3.1.0.28. Uma sugestão simples de uso, para os Owners confirmarem em ADR:

| Número | Quando sobe | Exemplo |
| --- | --- | --- |
| Maior | Rework ou mudança estrutural da classe | O rework sairia como 4.0.0.x |
| Menor | Conteúdo novo (subclasse, magia relevante, módulo de expansão) | 4.1.0.x |
| Revisão | Balanceamento e correções | 4.1.2.x |
| Build | Contador que o Toolkit incrementa a cada build | Não entra nos patch notes |

Os patch notes levam os três primeiros números no título. O Claude executor deve verificar como o Toolkit grava a versão no `meta.lsx` e no mod.io antes de fixar a regra.

## 12. Git e README

O repositório privado https://github.com/Geminitrix/arcana-class-bg3 é a casa de todo o material autoral do projeto. A tabela abaixo é o ponto de partida para revisar o `.gitignore`:

| Categoria | No Git? | Motivo |
| --- | --- | --- |
| Documentação, dados mestres (YAML), specs, tickets, contexto, GDD, lore, glossário | Sim | Material autoral |
| Código-fonte do mod (`51`), scripts de `82` e `.claude/` (exceto arquivos locais) | Sim | Fonte de verdade e pipeline |
| Fontes de arte (PSD, SVG), ícones finais e DDS | Sim, via LFS | Pesados e autorais |
| `.pak` de releases (`71.01`) e baselines publicadas (`76.01`) | Sim, via LFS | Rastreabilidade das versões |
| Conteúdo extraído do jogo base (loca vanilla, assets, `31.04`) | Não | Pertence à Larian; fica só na sua máquina |
| Extração de baselines, saída de build (`53.04`) e `Generated/` | Não | Regenerável |
| Arquivos de máquina (`.DS_Store`, `Thumbs.db`, logs, `.claude/settings.local.json`) | Não | Específicos do computador |
| Segredos (tokens, chaves de API) | Nunca | Segurança, mesmo em repositório privado |

**Regras:**

- O `.gitignore` atual foi escrito para deixar partes de fora. O Claude executor lê o arquivo, entende cada regra e o motivo dela, propõe a nova versão seguindo a tabela e mostra o diff para os Owners aprovarem antes de aplicar. Também confere o `git status` para saber o que já está versionado e o que passará a ser.
- Nunca reescrever o histórico nem apagar arquivos do repositório sem aprovação.
- O GitHub limita o armazenamento e a banda do LFS. Confira a cota antes de subir `.pak` e DDS em volume.
- Branches `feature/ARC-####`; mensagens de commit começam com o ticket (`ARC-0142: ...`); o push só acontece com a sua aprovação.

**README.** É a vitrine do repositório: o que é o mod, versão publicada, as 7 subclasses e o estado de cada uma, o escopo (núcleo 1 a 12, expansão 13 a 20), como o repositório está organizado e por onde começar a navegar. Todo commit que muda estrutura, estado das subclasses, versão ou escopo atualiza o README antes do push. O comando `/commit-e-push` roda `checar_readme` (compara o README com `05` e com a versão publicada), propõe o texto atualizado e mostra o diff do README junto com o resto para a sua aprovação. O dono do README é o Produtor, e os fatos vêm do Guardião do Contexto.

## 13. Licenciamento e regras de plataforma

Publicar sem checar licenças e regras é o erro mais caro de corrigir depois. Tudo fica em `00.06_Licencas_e_Plataformas`, mantido pelo Produtor e aprovado pelos Owners. Nenhum release vai para `72` e `73` sem o checklist de `00.06` aprovado.

| Tema | O que registrar | Arquivo em `00.06` |
| --- | --- | --- |
| Licença do mod | Quem pode reutilizar, modificar ou redistribuir o Arcana Class, e com qual crédito | `LICENCA_MOD.md` |
| Ferramentas de terceiros | Nome, versão, licença e pedido de crédito de cada ferramenta usada (Divine/LSLib, Modder's Multitool, BG3 DDS Convert, Script Extender) | `CREDITOS_FERRAMENTAS.md` |
| Conteúdo da Larian e da Wizards | Política de modding da Larian; licença do SRD 5.1 para textos de regras de D\&D; o que não pode ser redistribuído (assets extraídos do jogo, texto fora do SRD) | `CONTEUDO_DE_TERCEIROS.md` |
| Origem de assets | Para cada ícone, VFX, texto e som: autor, ferramenta usada (inclusive IA) e licença | `REGISTRO_DE_ORIGEM_DE_ASSETS.md` |
| Regras das plataformas | Regras vigentes do Nexus Mods e do mod.io (conteúdo permitido, divulgação de uso de IA, requisitos de página), com a data da consulta | `REGRAS_PLATAFORMAS.md` |

O Claude executor deve consultar as fontes oficiais e registrar a data de cada consulta. Essas políticas mudam, então não devem ser presumidas de memória.

## 14. Cadência de sprint sugerida

- **Sprint de 1 semana**, ritmo compatível com agentes de IA e com a sua disponibilidade para validar entregas.
- **Sprint 0** sem feature nova: montar o ambiente (`83`) e validar o pipeline ponta a ponta com uma magia mínima.
- **Planning** no dia 1. O `daily_log` é escrito ao fim de cada sessão de trabalho, não só uma vez por dia. **Review** e **retrospectiva** no último dia.
- **Refinement** contínuo: o Product Owner Agent mantém sempre 2 sprints de tickets prontos (DoR cumprida) no topo do backlog.

## 15. Pontos de atenção técnicos

- **Sem matriz de patches.** BG3 não recebe mais atualizações, então o risco de o jogo quebrar o mod não existe. Em `52.03_Versoes_Fixadas`, registre a versão final do jogo, a do Script Extender e a de cada ferramenta usada. Só é preciso revalidar o mod se uma dessas versões mudar (por exemplo, uma nova versão do Script Extender).
- **Compatibilidade com outros mods continua importando.** `64_Regressao_e_Compatibilidade` mantém a lista de mods de classe populares testados e a ordem de carga recomendada.
- **Padrões validados no seu ambiente.** Confirme a estrutura exata de `meta.lsx`, handles de localização e UUIDs com o Toolkit instalado antes de fixar os padrões em `52_Padroes_de_Codigo`; não confie só em memória do modelo.
- Mantenha `Generated/` e `53.04_Saida_de_Build/` fora do versionamento.
- Use Git LFS para PSD, DDS, PNG grandes e `.pak`.
- Fixe a versão de cada ferramenta externa em `81_Ferramentas_Externas` para o build ser reproduzível.

## 16. Plano de migração e próximos passos

1. **Fase 0 — Auditoria (somente leitura).** Inventário do repositório, do mod existente, das pastas atuais e do `.gitignore`, com duplicatas, versões conflitantes e arquivos sem dono. Primeiras propostas estratégicas em `00.04/PROPOSTAS`.
2. **Fase 1 — Esqueleto.** Criar a árvore vazia, os `_INDEX.md` e `_AGENT.md`, `CLAUDE.md`, `AGENTS.md`, `_LEGADO/`, o `.gitignore` aprovado (seção 12) e o Git LFS.
3. **Fase 2 — Migração por cópia.** Aprovar o mapeamento antigo → novo, copiar os arquivos, converter números soltos em YAML de `25_Dados_Mestres` e registrar o que sobrou sem destino. O Guardião do Contexto gera o primeiro espelho `05` do mod existente.
4. **Fase 3 — Padrões e regras.** Propor e aprovar `_PADRAO_DE_SUBCLASSE.md`, o guia de estilo do jogo base (`31.03`), o catálogo de tipos (`55.00`), DoR e DoD (`00.03`), fichas dos agentes (`00.05`), licenças (`00.06`) e política de implementação (`00.07`).
5. **Fase 4 — Agentes e automação.** Criar os 9 agentes ativos em `.claude/agents/`, os comandos e os hooks; montar os scripts de validação, `extrair_pak` e `comparar_versoes`; registrar como baseline o `.pak` hoje publicado no mod.io (versão 3.1.0.28).
6. **Fase 5 — Sprint 0.** Rodar um ticket piloto de ponta a ponta (uma magia ou feature de uma subclasse em rework): spec tipada, Narrative Gate, implementação feita por você no Toolkit, QA, atualização do contexto e do README. Só depois disso escalar o backlog.

**Perguntas ainda em aberto para os Owners responderem ao Claude executor:**

- Você aprova o esquema de versão proposto na seção 11, em que o rework sairia como 4.0.0.x? Se não, qual numeração prefere?

## PARTE II — Base de conhecimento de Game Design

A Parte I (seções 1 a 16) define onde cada coisa fica e quem faz o quê. Esta parte define **como pensar** o design da Arcana Class. Ela é o material que o Claude executor deve transformar em fichas curtas em `27_Base_de_Conhecimento_Design/`, e que cada agente de design lê antes de trabalhar.

**Regras de uso:**

- **Cada agente lê só a ficha do próprio papel** (tabela abaixo), para manter o contexto barato.
- **Fontes têm pesos diferentes.** A seção 24 classifica cada fonte como acadêmica/primária, de indústria ou de comunidade. Fóruns e wikis servem de ponto de partida, não de autoridade, e o Claude executor deve ler as fontes primárias antes de adotar qualquer método como regra do estúdio.
- **Números nunca vêm de memória.** Valores de referência (dano por círculo de magia, bônus por nível, durações) saem dos dados do jogo base, lidos no Toolkit, e do SRD 5.1.
- **Frameworks são lentes, não leis.** Se um método contradiz o que funciona no jogo, a discussão vai para uma proposta em `00.04/PROPOSTAS/`, e os Owners decidem.

| Agente | Fichas obrigatórias | Pergunta-chave que o agente se faz |
| --- | --- | --- |
| Lead Class Designer | 17, 18 | Esta subclasse cumpre a sua fantasia e se encaixa nos pilares? |
| Spell Designer | 17, 19, 20 | O que esta magia custa e o que ela entrega? |
| Balanceador (acumula economia) | 19, 20, 22 | Onde ela fica na curva de poder, e qual é a intenção da mudança? |
| Lore Writer | 21 | O texto expressa o tema e soa como o jogo base? |
| QA Lead e Playtester | 22 | Que decisão este teste vai informar? |
| Mod Engineer | 20 | A spec traz o custo e a recarga corretos? |
| Patch Notes Lead | 19 (intenção), 16 | A intenção da mudança está registrada em uma frase? |
| Guardião do Contexto | 23 | Os termos do espelho seguem o glossário? |

## 17. Fundamentos de game design aplicados à Arcana Class

**17.1 MDA: projetar a partir da experiência.** O framework MDA (Hunicke, LeBlanc e Zubek) descreve um jogo em três camadas: as *mecânicas* (regras e componentes), as *dinâmicas* (o comportamento dessas regras em execução, quando o jogador age) e a *estética* (as respostas emocionais que o jogo quer provocar). O designer só controla diretamente as mecânicas, mas o jogador percorre o caminho inverso: sente primeiro a estética, observa as dinâmicas e só depois entende as regras.

| Camada | Pergunta | Na Arcana Class |
| --- | --- | --- |
| Mecânica | Qual regra, custo, alcance, teste? | Os campos do YAML em `25` e da spec em `55` |
| Dinâmica | O que o jogador passa a fazer por causa disso? | Guarda o recurso para o turno certo? Combina com os companheiros? |
| Estética | O que ele deve sentir? | Definida nos pilares (17.2): domínio, poder, surpresa, tensão |

Regra do estúdio: **toda feature nasce com uma frase de estética alvo** ("deve parecer...") e só depois ganha números. Dinâmicas são imprevisíveis e só se confirmam jogando (seção 22). Além disso, acrescentar mecânicas tende a aumentar a complexidade das dinâmicas, então cada nova regra precisa justificar o custo.

**17.2 Pilares de design.** São 3 a 5 frases curtas que descrevem a experiência que o projeto promete. Servem de filtro: diante de qualquer ideia, pergunta-se se ela serve aos pilares ou os contradiz. Bons pilares falam de experiência, não de features nem de enredo, são relativamente rígidos ao longo do projeto e não se confundem com pontos de venda. Poucos pilares são mais fáceis de lembrar e de usar.

| Pilar | Experiência prometida | Pergunta-filtro | Anti-exemplo |
| --- | --- | --- | --- |
| (a definir) | (o que o jogador sente) | (pergunta de sim ou não) | (o que quebraria o pilar) |

Na Fase 0, o Claude executor extrai os pilares implícitos do mod existente (nas descrições, nas escolhas de design e nas subclasses mais queridas) e propõe a versão formal para os Owners aprovarem. Os pilares aprovados entram em `21.01` e, em forma resumida, no `CLAUDE.md`.

**17.3 Motivação: autonomia, competência e relação.** A teoria da autodeterminação, aplicada a jogos por Ryan, Rigby e Przybylski, sustenta que um jogo motiva na medida em que satisfaz três necessidades: autonomia (sentir controle e escolha), competência (sentir que domina e progride) e relação (sentir conexão com outros). Aplicação ao design de classe:

| Necessidade | No design de classe e subclasse | Verificação |
| --- | --- | --- |
| Autonomia | Escolhas significativas: subclasse, magias, quando gastar recursos | Existem pelo menos dois usos razoáveis para cada recurso? Alguma opção é armadilha ou escolha óbvia? |
| Competência | Feedback claro (descrição, números, ícone, efeito visual) e curva de domínio: fácil de usar, difícil de otimizar | Um jogador novo entende a feature em uma leitura? O poder crescente é perceptível a cada nível? |
| Relação | BG3 é jogo de grupo e de história: sinergias com companheiros e textos que reconhecem a escolha do jogador | A feature interage com o grupo? A subclasse é reconhecida no texto? |

Existe um questionário acadêmico para medir essa satisfação (PENS), mas o uso comercial exige permissão do centro que o mantém. Não adotar sem conferir os termos.

**17.4 Orçamento de complexidade.** Cada feature consome atenção do jogador. Adicionar é barato, e subtrair depois é caro. Práticas recomendadas, a serem confirmadas pelos Owners:

- Cada subclasse tem uma **assinatura** clara: a coisa que só ela faz.
- Sugestão inicial: no máximo 3 novas ações ativas por subclasse até o nível 12, e no máximo 1 recurso principal mais 1 secundário.
- Toda feature precisa se explicar em um tooltip curto. Se exige um parágrafo de exceções, é sinal de que está complexa demais.

**17.5 Ciclo iterativo.** Design → protótipo em planilha → playtest → ajuste. O protótipo mais barato é o YAML de `25` mais a planilha de `22.02`. O jogo só é consultado depois que a planilha deixa de apontar problemas (seção 19).

## 18. Design de classes e subclasses em D&D 5e e BG3

**18.1 Base de regras.** O BG3 adapta a quinta edição de D&D, e os dados do jogo (lidos no Toolkit) mandam sobre qualquer regra de livro. Regras de versões mais novas do D&D não se aplicam automaticamente. Para textos de regra, o SRD 5.1 é a fonte aberta (licença Creative Commons com atribuição, ver seção 13).

**18.2 Precisão limitada (bounded accuracy).** É a filosofia da 5e de não assumir que ataque e defesa crescem só por subir de nível. Na prática: o bônus de proficiência é único e cresce pouco, itens mágicos dão bônus pequenos, os atributos têm teto baixo, e a vantagem substitui bônus numéricos. O efeito é que criaturas de nível baixo continuam relevantes e que classes sem bônus de ataque ainda contribuem. (As cifras exatas aparecem em wikis de comunidade; confirmar no SRD e nos dados do jogo.)

Implicação para a Arcana Class: evite bônus planos empilháveis em ataque, CD de magia e defesa. Prefira dados, vantagem, recursos e efeitos condicionais. Qualquer bônus plano precisa justificar o impacto na curva de acerto.

**18.3 Limites do BG3.** O nível máximo é 12 e as magias vão até o 6º círculo (espaços maiores servem só para upcast). Segundo Swen Vincke, em entrevista de 2023, o teto existe por equilíbrio: acima do nível 12 os poderes ficam quase divinos e os encontros ficam muito mais difíceis de balancear. Consequências para o projeto:

- O **núcleo 1 a 12** precisa estar completo e coerente por si só.
- O **módulo 13 a 20** é opcional. Ele não pode exigir magias de 7º círculo ou superior que o jogo base não possui sem uma decisão explícita, e precisa decidir como lidar com encontros que não escalam acima do 12 (por exemplo, ganhos modestos ou dependência de um mod de escala). Isso vai para ADR.

**18.4 Ficha-chassi de uma classe.** Todo item abaixo é preenchido e aprovado antes de qualquer feature ser detalhada:

| Item | Pergunta de design |
| --- | --- |
| Dado de vida e sobrevivência | Quão resistente a classe deve ser em relação às de referência? |
| Proficiências (armas, armaduras, salvaguardas, perícias) | Seguem o padrão do jogo base ou quebram convenção? Por quê? |
| Conjuração | Tipo (completa, parcial, por pacto, nenhuma), atributo, círculo máximo, truques, conhecidas ou preparadas |
| Recursos próprios | Quais, com que recarga (seção 20)? |
| Nível de subclasse e cadência de features | Em que níveis, e com quantas features? |
| Melhorias de atributo e talentos | Níveis em que ocorrem (conferir no jogo base) |
| Multiclasse | Pré-requisitos, interação com espaços de magia e recursos |
| Equipamento e lista de magias | Que lista, e o que ela deixa de fora de propósito? |

As classes oficiais seguem convenções claras, como um par fixo de proficiências em salvaguardas e uma cadência regular de níveis de subclasse. O Claude executor levanta essas convenções nos dados do jogo base e só as quebra com justificativa registrada em ADR.

**18.5 Método para projetar uma subclasse.** Em uma conversa sobre o processo de design de subclasses da quinta edição, Jeremy Crawford descreve prioridades que devem guiar o trabalho, nesta ordem:

1. A opção faz o que se propõe a fazer?
2. Ela conta a história e a fantasia da sua classe?
3. Só depois, equilibrar: a subclasse como um todo atinge um alcance de poder parecido com o das outras subclasses da mesma classe em dano, cura, defesa e controle?

Para efeitos que não causam dano, usa-se o **dano virtual**: traduzir o efeito em dano equivalente comparando-o com magias de poder semelhante (ex.: uma habilidade de teleporte como reação é comparada a uma magia do mesmo círculo e, depois, a uma magia de dano de nível parecido). Isso dá uma estimativa grosseira, que o playtest refina.

**Matriz de subclasses (`21.08`).** Para cada uma das 7 subclasses, uma linha com: fantasia em uma frase, papel(éis), recurso(s), assinatura, features por nível, sinergias, riscos e estado (nova, rework). Em seguida, uma matriz de cobertura de papéis, que serve para verificar que as subclasses não se sobrepõem:

| Subclasse | Dano sustentado | Burst | Controle | Suporte e cura | Defesa | Utilidade e exploração | Social |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Deceiver, Starchild, Eternal, Unbound, Resonant, Spinner, Lionheart | (marcar principal ou secundário) |  |  |  |  |  |  |

**18.6 Rework das subclasses existentes.** Deceiver, Starchild, Eternal e Unbound já têm jogadores e expectativas. Princípios, adaptados de como a Riot descreve o "remodelar" um campeão: preservar o que os jogadores mais gostam, mudar a estrutura quando o problema é estrutural (não apenas números) e aceitar o risco de uma mudança grande, porque a subclasse não será revisitada tão cedo. Processo:

1. **Diagnóstico:** qual é a fantasia, o que funciona, o que falha? Fontes: feedback no mod.io, testes e a matriz de papéis.
2. **Manter, mudar ou remover:** tabela por feature, com o motivo.
3. **Prototipar** no YAML de `25`.
4. **Validar** contra `_PADRAO_DE_SUBCLASSE.md` e contra a curva (seção 19).
5. **Registrar a intenção** em uma frase, que alimenta os patch notes.

**18.7 Comunidade e compatibilidade.** O projeto BG3 Community Library mantém um "Subclass Compatibility Framework" para subclasses de mods conviverem. O Claude executor avalia se vale adotá-lo e registra a decisão em ADR.

**18.8 Portão de Design.** Nenhum ticket de feature chega a "Spec Pronta" sem passar por este portão, que se soma ao Portão Narrativo (seção 9):

| # | Pergunta | Responsável |
| --- | --- | --- |
| 1 | Está ligada a um pilar e à fantasia da subclasse? | Lead Class Designer |
| 2 | Tem papel claro e não duplica outra subclasse (matriz de cobertura)? | Lead Class Designer |
| 3 | Que recurso consome e com que recarga? (seção 20) | Spell Designer |
| 4 | O poder está dentro da faixa da curva (dano virtual e DPR)? | Balanceador |
| 5 | Explica-se em uma leitura? Respeita o orçamento de complexidade? | Lead Class Designer |
| 6 | Interações checadas: concentração, ação bônus, empilhamento, ciclos? | Balanceador |
| 7 | O núcleo 1 a 12 não depende do módulo 13 a 20? | Validador |
| 8 | A intenção da mudança está registrada em uma frase? | Spell Designer |

## 19. Balanceamento: método

**19.1 Para que serve o balanceamento.** Balancear é deixar o jogo justo e, ao mesmo tempo, com a dose certa de desafio, sem torná-lo previsível. Mistura matemática, psicologia e, às vezes, economia e teoria dos jogos (Schreiber e Romero). Em design de subclasses de D&D, o balanceamento vem **depois** de a opção cumprir sua fantasia e contar a história da sua classe (18.5). Número perfeito numa feature sem identidade é uma falha de design.

**19.2 Tipos de balanceamento.**

| Tipo | Ideia | Onde aparece na Arcana Class |
| --- | --- | --- |
| Transitivo | Mais poder custa mais; a relação custo e benefício é equivalente | Círculo da magia, usos por descanso, ação gasta |
| Intransitivo | Pedra, papel e tesoura: cada opção vence uma e perde para outra | Tipos de dano e resistências, controle contra imunidade |
| Situacional | O poder depende do contexto | Feature forte contra grupos e fraca contra um chefe |
| Entre estratégias | Várias builds viáveis, e nenhuma domina | As 7 subclasses e as combinações de magias |

Quatro perguntas resumem o assunto: os jogadores têm chances equivalentes? O desafio está no nível certo para o público? As estratégias são igualmente viáveis? Os recursos têm a mesma relação custo e benefício?

**19.3 Curva de custo.** Dê a cada habilidade um preço numa moeda comum de poder e compare o preço com o benefício. Componentes do preço: efeito (em dano virtual), alcance e área, ação usada, recurso consumido, duração e concentração, teste de resistência contra acerto automático, condições de uso. O ponto de partida são **âncoras**: magias e features do jogo base de mesmo nível, lidas no Toolkit. Existem sistemas de pontos criados pela comunidade para magias de 5e, que servem de inspiração, mas nenhum é canônico.

**19.4 Dano virtual (para efeitos sem dano).** Passos: (1) identificar o efeito; (2) achar a magia mais antiga do jogo que faz algo equivalente e anotar o círculo; (3) achar uma magia de dano desse mesmo círculo; (4) usar o dano médio dela como estimativa de valor; (5) ajustar pela situação (alcance, duração, teste). O resultado é uma estimativa, e o playtest decide.

**19.5 Duas medidas de dano por turno.** Autores do Level Up: Advanced 5th Edition mediram o dano médio por rodada de cada classe em duas situações:

| Medida | O que mede | Para que serve |
| --- | --- | --- |
| DPR sustentado | Dano por rodada usando só o que se repete à vontade, sem gastar recursos | Mostra o piso da classe |
| DPR nova | Dano por rodada gastando tudo (espaços, recursos de classe) para maximizar | Mostra o teto da classe |

Recomendação do estúdio: para cada nível de 1 a 12, registrar as duas medidas para as classes de referência e para cada subclasse, incluindo a chance de acerto e vantagem (uma feature que dá vantagem precisa entrar na conta do dano). Em vez de copiar o valor de cada classe, o melhor guia é a média agregada entre classes. Na amostra desses autores, o dano crescia de forma aproximadamente linear com o nível, e isso deve ser verificado com os dados do BG3.

**19.6 Faixa de tolerância.** As classes de referência são escolhidas pela matriz de papéis (18.5) e pelos dados do jogo base. Sugestão inicial, a ser fixada em ADR: manter o DPR (sustentado e nova) de cada subclasse dentro de uma faixa de cerca de ±15% em torno da curva de referência do mesmo papel. Desvios maiores exigem justificativa de fantasia ou um custo compensador.

**19.7 Fluxo de balanceamento de uma mudança.**

1. Escrever a **intenção** em uma frase (o que esta mudança deve causar no jogo).
2. Confirmar o papel e o pilar da feature.
3. Escolher as **âncoras** no jogo base.
4. Pontuar custo e benefício na curva.
5. Simular na planilha (`22.02`): DPR sustentado e nova, por nível.
6. Checar **interações**: concentração, ação bônus, empilhamento, ciclos de recurso (seção 20).
7. Playtest com os saves padronizados (seção 22).
8. Ajustar o valor **em `25`**, nunca em cópias.
9. Registrar o resultado e a intenção no ticket.

**19.8 Sinais de alerta.**

| Sinal | Por que é um problema | Ação |
| --- | --- | --- |
| Sempre a melhor escolha, em qualquer situação | Opção dominante: anula as outras | Aumentar o custo ou reduzir o benefício |
| Ninguém escolhe | Preço alto demais ou fantasia fraca | Rever o custo; revisar a fantasia |
| Só funciona em um combo | Frágil e dependente de outras features | Dar valor isolado mínimo |
| Ciclo de recurso (gasta A, ganha B, B devolve A) | Gera um motor sem limite | Limitar por turno ou por descanso (seção 20) |
| Empilha bônus planos | Distorce a curva de acerto (18.2) | Trocar por vantagem, dado ou condição |
| Consome espaço da ação bônus sem alternativa | Compete com habilidades de todos os jogadores | Conferir a economia de ação (20.4) |
| Complexidade sem ganho | Fere a competência do jogador (17.3) | Simplificar ou cortar |

**19.9 Balanceamento contínuo de um mod vivo.** O mod não tem telemetria, então se apoia em quatro "lentes": a intenção de design, a comparação com a curva, o feedback da comunidade (mod.io) e os testes próprios. A Riot descreve um modelo parecido: declarar para quem e para quê cada mudança é feita, estimar o poder esperado de algo novo antes do lançamento e fazer uma revisão depois de cada patch. No estúdio isso vira duas regras: **toda mudança tem uma intenção em uma frase** (que alimenta os patch notes) e **todo release tem uma retrospectiva de balanceamento**, comparando o que se esperava com o que a comunidade e os testes mostraram. Os Owners definem a dificuldade de referência do balanceamento (sugestão: Balanceado e Tático).

## 20. Economia de recursos e economia de ação

**20.1 Princípio.** Todo recurso entra no sistema por uma **fonte** e sai por um **ralo**. Se as fontes superam os ralos, o recurso sobra e perde valor (inflação). Se os ralos superam as fontes, o jogador sente escassez e frustração. O preço de um recurso deve refletir o poder que ele compra: um recurso barato demais é desperdiçado, e caro demais nunca é usado.

**20.2 Mapa de recursos de uma classe.**

| Recurso | Fonte | Ralo | Recarga | Decisão que ele cria |
| --- | --- | --- | --- | --- |
| Espaços de magia | Nível e classe | Conjurar (ou upcast) | Descanso longo nos conjuradores comuns; descanso curto no Bruxo | Gastar agora ou guardar |
| Recurso próprio da classe | Nível | Usar features | Curto ou longo, definido por feature | Qual feature merece o recurso |
| Usos por descanso | Feature | Cada uso | Curto ou longo | Quando usar o único |
| Recarga por turno ou combate | Feature | Cada uso | Por turno, combate ou descanso (confirmar os tipos no Toolkit, `55.00`) | Quando acionar |
| Pontos de vida | Cura e descanso | Dano | Descansos e cura | Risco contra segurança |
| Ação, ação bônus, reação, movimento | Todo turno | Cada ação | Por turno ou rodada | O que fazer neste turno |
| Concentração | Um efeito por vez | Manter o efeito | Até a concentração quebrar | Qual efeito manter |
| Suprimentos de acampamento (global) | Exploração | Descanso longo | Coleta | Quando descansar |

**20.3 O ritmo de descansos no BG3.** Fatos: o grupo pode fazer descansos curtos duas vezes por descanso longo, e eles não custam suprimentos. O descanso longo custa 40 suprimentos de acampamento (80 nas dificuldades Tática e Honra). Sem suprimentos, o grupo faz um descanso parcial, que restaura os recursos só até a metade do máximo e não devolve os descansos curtos. Implicações de design:

- Recursos de **descanso curto** têm até 3 janelas por dia (começo e depois de cada descanso curto), então cada uso deve valer menos poder que um recurso de descanso longo.
- O descanso longo é o ritmo-base: o que recarrega só nele deve ser mais forte, mas escasso.
- O quanto de recurso se gasta por combate depende do ritmo de jogo, e o jogador pode descansar quase à vontade quando tem suprimentos. Um padrão de referência vem de D&D 3.x, que visava gastar cerca de 20% dos recursos por encontro; para o BG3, o Balanceador define em ADR um **dia de aventura de referência** (quantos combates, quantos descansos curtos) a partir de testes reais.

**20.4 Economia de ação.**

| Recurso de turno | Regra de design |
| --- | --- |
| Ação | É o custo principal. Features que não gastam ação precisam de outro limite |
| Ação bônus | Espaço disputado por todas as classes; evitar várias features concorrentes na mesma subclasse |
| Reação | Uma por rodada; features de reação competem entre si e com as do jogo base |
| Movimento | Cuidado com efeitos que dão movimento extra ou deslocamento sem custo |
| Concentração | Efeitos fortes e duradouros devem exigir concentração ou outro custo equivalente |

Regra geral: **toda feature responde à pergunta "qual recurso paga por isto?"**.

**20.5 Ciclos de retroalimentação e armadilhas.** Retroalimentação positiva (o sucesso gera mais sucesso, por exemplo, abater um inimigo devolve recursos) tende a produzir bola de neve, e a negativa tende a estagnação. Duas armadilhas conhecidas:

| Armadilha | Descrição | Cuidado |
| --- | --- | --- |
| Motor | Gastar um recurso para obter outro e usar o novo para recuperar o primeiro | Limitar por turno ou por descanso, ou exigir custo líquido positivo |
| Impasse | Ciclo de ralos e fontes que trava o uso do recurso | Revisar dependências cruzadas entre features |

**20.6 Auditoria de recursos.** Tabela a preencher para cada classe e subclasse (`26.01`):

| Recurso | Fontes por descanso | Ralos | Saldo | Risco (acumula ou falta) | Ação |
| --- | --- | --- | --- | --- | --- |
| (a preencher) |  |  |  |  |  |

**20.7 Carga cognitiva de recursos.** Mais recursos distintos significam mais coisas para acompanhar. A sugestão inicial (seção 17.4) é um recurso principal e um secundário por subclasse, e todo recurso tem um indicador visível (ícone, contador ou status).

## 21. Narrativa, lore e criação de fantasia

Esta seção é a base teórica da seção 9 (que define o processo e o Portão Narrativo).

**21.1 Tema como filtro e harmonia ludonarrativa.** O tema é a ideia que a classe discute (por exemplo, o preço de um poder). Um tema que só aparece num parágrafo é decoração: se a classe fala de algo, precisa ter mecânica sobre isso. A *dissonância ludonarrativa* acontece quando mecânica e narrativa se contradizem, e a *harmonia* quando se reforçam. Uma tese acadêmica propõe seis eixos para avaliar essa harmonia, que viram perguntas de revisão:

| Eixo | Pergunta para a Arcana Class |
| --- | --- |
| Alinhamento mecânica e tema | Cada mecânica expressa o tema da classe ou da subclasse? |
| Consistência de feedback e narrativa | Ícone, efeito visual, som e texto contam a mesma coisa? |
| Fidelidade do papel do jogador | O jogador age como o personagem que a fantasia promete? |
| Impacto narrativo da escolha | Escolher esta subclasse muda algo perceptível no jogo ou no texto? |
| Harmonia entre o emergente e o embutido | O que o jogador faz livremente combina com o que a lore afirma? |
| Sincronia entre progressão e estrutura | Os níveis 1 a 12 contam um arco: promessa, assinatura, realização? |

**21.2 Bíblia de lore (`31.01`).** A lore de jogos funciona melhor quando é pensada em função do jogador e mantida **enxuta, pesquisável e coerente**. Estrutura sugerida:

- **Premissa:** a ideia central da classe em poucas linhas.
- **Origem e fonte de poder:** de onde vem a magia da classe e como ela se liga ao cânone de Forgotten Realms (o ponto de contato com a Tecelagem e as regras do mundo é verificado em `32.03`).
- **Subclasses:** para cada uma, origem, ethos, vocabulário próprio e identidade visual.
- **Glossário e regras de consistência:** termos fixos e o que a lore nunca afirma.
- **Camadas:** o que o jogador vê, o que descobre jogando e o que fica nos bastidores.

Princípio: a lore se revela **pelo uso** (descrições, efeitos, escolhas), não por despejo de texto. O mundo é projetado a partir do que o jogador vai fazer, em vez de apenas derivado de obras anteriores.

**21.3 Tom e escrita no estilo do BG3.** Segundo o diretor de roteiro Adam Smith, a série Baldur's Gate sempre misturou tons: dark, leve, estranho, bobo e romântico, e acertava ao deixar tudo coexistir. Outro princípio da equipe da Larian é dar a todo personagem mais profundidade do que ficha, raça e classe, e reconhecer as escolhas do jogador. Para os textos da Arcana Class:

- Ancorar o tom no guia de estilo derivado da localização do jogo base (`31.03`), sem copiar frases.
- Separar regra e flavor (seção 9).
- Frases curtas, verbos ativos, vocabulário do jogo e termos sempre iguais ao glossário (`33.03`).
- **Nomes** de classe, subclasses, features e magias: pronunciáveis, coerentes em família, sem colidir com nomes do jogo base nem de mods populares (checar a loca vanilla e o Nexus Mods).
- Tamanho e densidade parecidos com os das descrições do jogo base.
- Reatividade opcional: quando fizer sentido, falas ou ganchos que reconheçam a subclasse (`32.02`).

**21.4 Oficina de fantasia (classe e subclasse).** Prática recomendada, em ordem:

1. **Fantasia em uma frase:** quem o jogador se sente sendo.
2. **Referências e limites:** arquétipos de literatura, mitologia e jogos, e o que a classe *não* é.
3. **Papel no grupo:** o que ela entrega que outras classes não entregam.
4. **Verbo central:** a ação que a define (o que o jogador *faz* repetidamente).
5. **Assinatura e recurso:** a feature que só ela tem e o recurso que a sustenta.
6. **Curva da fantasia:** promessa nos primeiros níveis, assinatura no meio, realização no nível 12.
7. **Nome e texto:** passam pelo Portão Narrativo.
8. **Teste dos 30 segundos:** um jogador novo entende a fantasia lendo o nome e o tooltip?

**21.5 Narrativa e mecânica nascem juntas.** Sessões de especialistas, como a de Lauren Bond (Wizards of the Coast) na GDC 2025, defendem estratégias para integrar mecânica e narrativa e a colaboração direta entre designer de narrativa e designer de jogo. No estúdio, o Lore Writer participa do passo de design (etapa 4 do ciclo de vida), e não só da escrita final.

## 22. Playtest e validação de design

**22.1 Princípios.** Playtest é parte do processo de design, não polimento final. Pontos centrais:

- **Quem projetou não consegue testar o próprio jogo:** tem pontos cegos sobre o que é óbvio.
- Todo teste começa por **a decisão que ele vai informar** (ex.: "reduzir ou manter o dano?"), não por "o jogo é bom?".
- **Observe o comportamento.** O comportamento revela o problema, e o feedback revela o sintoma. Não explique o jogo antes nem defenda as decisões durante.
- Combine dados **quantitativos** (dano, recursos gastos, mortes, tempo de decisão) e **qualitativos** (observação e entrevista), com perguntas neutras, que não induzam a resposta.
- Feedback repetido em várias sessões é sinal; um comentário isolado, não.
- Distinga **bug** (falha técnica) de **feedback de design** (o jogador não entendeu ou não gostou).

**22.2 O que os agentes de IA podem e não podem fazer.** Podem simular em planilha, checar consistência de regras, preencher checklists, redigir protocolos e resumir feedback. **Não substituem** o jogo real: a sensação de uma feature só é julgada por pessoas jogando. Os testes de jogo são seus (Owners) e, quando possível, de testadores e da comunidade. O "Playtester Agent" de `63` prepara, organiza e analisa os testes, e não os executa no lugar de um jogador.

**22.3 Protocolo de teste (modelo em `61.02`).**

| Campo | Conteúdo |
| --- | --- |
| Decisão que informa | O que mudaremos com o resultado |
| Hipótese | O que esperamos observar |
| Cenário | Save de `83.02`, dificuldade, composição do grupo |
| Métricas | Dano por turno e por combate, recursos gastos, turnos para decidir, mortes |
| Critério de sucesso | Faixa de resultado aceitável (ver 19.6) |
| Resultado e observações | O que aconteceu, com evidências em `65` |
| Decisão | Manter, ajustar (qual valor em `25`) ou descartar |

**22.4 Cenários padrão.** Saves de nível 1, 5, 8 e 12 (`83.02`) × dificuldade (Balanceado e Tático como padrão; Honra opcional) × composição (a classe isolada e a classe com companheiros).

**22.5 Feedback da comunidade.** Recolher os comentários do mod.io, classificar por feature, separar bugs de feedback de design, priorizar o que se repete e transformar em ticket. Perguntas ao testador devem ser neutras.

**22.6 Retrospectiva de balanceamento por release.** Depois de cada release, comparar o que a intenção de cada mudança prometia com o que os testes e a comunidade mostraram. O resultado alimenta o próximo patch e o aprendizado do estúdio.

## 23. Glossário de game design

| Termo | Significado neste documento |
| --- | --- |
| MDA | Mecânicas, dinâmicas e estética: três camadas de análise de um jogo |
| Pilar de design | Frase curta sobre a experiência prometida, usada como filtro de decisões |
| Autonomia, competência, relação | As três necessidades da teoria da autodeterminação |
| Precisão limitada | Filosofia da 5e de limitar o crescimento numérico de acerto e defesa |
| Chassi da classe | O conjunto-base de uma classe: vida, proficiências, conjuração, recursos |
| Dano virtual | Estimativa do valor de um efeito sem dano em dano equivalente |
| DPR sustentado e DPR nova | Dano por rodada sem gastar recursos e gastando tudo |
| Curva de custo | Relação entre o preço (em poder) e o benefício de cada habilidade |
| Transitivo e intransitivo | Mais poder custa mais, contra pedra, papel e tesoura |
| Fonte e ralo | Como um recurso entra e sai do sistema |
| Motor | Ciclo de recursos que se alimenta sem limite |
| Economia de ação | Ação, ação bônus, reação, movimento e concentração |
| Harmonia ludonarrativa | Mecânica e narrativa se reforçam |
| Âncora | Magia ou feature do jogo base usada como referência de poder |
| Intenção | Frase que diz o que uma mudança deve causar no jogo |
| Portão (Gate) | Checklist que o ticket precisa cumprir para avançar |

## 24. Fontes e leituras recomendadas

**Classificação:** *Primária* (autor ou fonte oficial), *Acadêmica*, *Indústria* (profissionais ou veículos do setor), *Comunidade* (fóruns, wikis, com menor autoridade). O Claude executor deve ler as fontes primárias e acadêmicas antes de adotar um método como regra.

| Fonte | Tipo | Usada em |
| --- | --- | --- |
| [Hunicke, LeBlanc e Zubek, MDA: A Formal Approach to Game Design](https://users.cs.northwestern.edu/~hunicke/MDA.pdf) | Acadêmica | 17.1 |
| [Ryan, Rigby e Przybylski, The Motivational Pull of Video Games (2006)](https://www.rochester.edu/warner/lida/wp-content/uploads/2022/11/02bfe513dd59366750000000.pdf) | Acadêmica | 17.3 |
| [Przybylski, Rigby e Ryan, A Motivational Model of Video Game Engagement (2010)](https://repository.essex.ac.uk/7228/) | Acadêmica | 17.3 |
| [Center for Self-Determination Theory, PENS](https://selfdeterminationtheory.org/player-experience-of-needs-satisfaction-pens/) | Acadêmica | 17.3 |
| [Schreiber e Romero, Game Balance (CRC Press)](https://www.routledge.com/9781498799577) | Indústria (livro) | 19 |
| [Ian Schreiber, Game Balance Concepts (curso online)](https://gamebalanceconcepts.wordpress.com/2010/07/21/level-3-transitive-mechanics-and-cost-curves/) | Indústria | 19.2, 19.3 |
| [Cornell CS 3152, aula 6: Economies and Balance](https://www.cs.cornell.edu/courses/cs3152/2026sp/lectures/lecture6/slides-6.pdf) | Acadêmica (aula) | 20 |
| [Jeremy Crawford sobre design de subclasses (resumo do Bell of Lost Souls)](https://www.belloflostsouls.net/?p=303165) | Indústria (secundária) | 18.5, 19.1 |
| [Level Up A5E: How Much Damage Should a Damage Dealer Deal? (repostagem no EN World)](https://www.enworld.org/posts/8113336/) | Comunidade e indústria | 19.5 |
| [D&D Lore Wiki: Bounded accuracy](https://dungeonsdragons.fandom.com/wiki/Bounded_accuracy) | Comunidade | 18.2 |
| [Wizards of the Coast, Systems Reference Document 5.1](https://dnd.wizards.com/resources/systems-reference-document) | Primária | 13, 18.1 |
| [BG3 Wiki: Resting](https://bg3.wiki/wiki/Resting) | Comunidade (wiki) | 20.3 |
| [Prima Games: nível máximo do BG3 (cita Swen Vincke, 2023)](https://primagames.com/tips/what-is-the-max-level-in-baldurs-gate-3-answered) | Imprensa | 18.3 |
| [BG3 Community Library: Tutorials](https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Tutorials) | Comunidade | 18.7 |
| [PC Gamer: How Larian is keeping Baldur's Gate 3 weird](https://pcgamer.com/how-larian-is-keeping-baldurs-gate-3-weird) | Imprensa (entrevista) | 21.3 |
| [GameBanshee: entrevista com Adam Smith](https://gamebanshee.com/34dua) | Imprensa (entrevista) | 21.3 |
| [Edwin McRae, Narrative Worldbuilding](https://payhip.com/b/GbPON) | Indústria (livro) | 21.2 |
| [Tese ITU: Designing for ludonarrative harmony](https://polen.itu.edu.tr/entities/publication/be3d78cf-4358-4ab4-8b57-e43396c3b7e5) | Acadêmica | 21.1 |
| [GDC 2025, Lauren Bond: Creating Playable Stories](https://gdcvault.com/play/1035559/Game-Narrative-Summit-Creating-Playable) | Indústria | 21.5 |
| [Game Developer: Design Pillars, the Core of Your Game](https://www.gamedeveloper.com/design/design-pillars-the-core-of-your-game) | Indústria | 17.2 |
| [Ellen Beeman: Product Pillars](https://www.ellenbeeman.com/single-post/2018/01/01/product-pillars-the-what-and-the-why) | Indústria | 17.2 |
| [Schell Games: guia de perguntas de playtest](https://schellgames.com/blog/the-definitive-guide-to-playtest-questions-for-video-game-playtesters) | Indústria | 22 |
| [PCGamesN: Champion Balance Framework da Riot](https://www.pcgamesn.com/league-of-legends/balance) | Imprensa | 19.9 |
| [Sportskeeda: filosofia por trás do rework do Amumu](https://www.sportskeeda.com/esports/riot-dev-explains-philosophy-behind-amumu-s-buff) | Imprensa | 18.6 |
| [League of Legends: patch notes 26.20](https://www.leagueoflegends.com/en-us/news/game-updates/league-of-legends-patch-26-20-notes/) | Primária | 16 |
| [Artificial Twenty: dicas de homebrew para 5e](https://artificialtwenty.com/2020/07/28/five-essential-tips-for-homebrewing-in-dungeons-and-dragonsfifth-edition/) | Comunidade | 18.4 |

**Leituras de livros sugeridas** (não acessadas na pesquisa que originou esta seção): *The Art of Game Design: A Book of Lenses*, de Jesse Schell; *Game Design Workshop*, de Tracy Fullerton; e o *Dungeon Master's Guide* da quinta edição, no capítulo sobre criar magias e monstros. **Lacuna conhecida:** não foram consultados o texto original de Rodney Thompson sobre precisão limitada nem o DMG. O Claude executor deve lê-los antes de fixar valores de referência.

## PARTE III — Base de conhecimento de engenharia de mod

A Parte I define o fluxo de trabalho e a Parte II define como pensar o design. Esta parte define **como o código e os dados do mod são pensados, escritos, testados e entregues**. Ela é escrita também para quem não programa: cada tecnologia é explicada em linguagem simples antes do detalhe técnico. O Claude executor deve transformá-la em fichas curtas em `57_Base_de_Conhecimento_Engenharia/` e em agentes especialistas (seção 32).

**Regras de uso (as mesmas da Parte II):** cada agente lê só a ficha do seu papel; fontes de comunidade são ponto de partida, não autoridade (a seção 34 classifica todas); e **nomes de funções, eventos, campos e valores nunca vêm de memória**: vêm do código extraído do jogo base (seção 32) e da documentação das ferramentas.

## 25. Arquitetura do mod e escolha da ferramenta certa

**25.1 Mapa em linguagem simples.**

| Tecnologia | O que é, em linguagem simples | Precisa do Script Extender? |
| --- | --- | --- |
| Stats (`.txt`) | As "fichas" de magias, passivas e status: dados quase sem código | Não |
| LSX (`.lsx`) | Tabelas em XML que ligam classe, níveis e listas de magias | Não |
| Khonsu (`.khn`) | Pequenas funções que respondem "posso usar isto agora? este alvo vale?", escritas numa linguagem parecida com Lua | Não |
| Thoth | A biblioteca de funções de condição que o jogo já traz e que você chama dentro de condições | Não |
| Osiris | Scripts de "história" que reagem a eventos do jogo, no formato SE acontecer X, ENTÃO faça Y | Não |
| Lua (Script Extender) | Scripts poderosos que mexem em dados e eventos internos do motor | **Sim** |

**25.2 Qual ferramenta usar.** Regra de ouro: **o menor poder que resolve**. Dados são mais seguros e compatíveis que código, e código mais simples quebra menos.

| Eu quero... | Use | Por quê |
| --- | --- | --- |
| Criar ou alterar magia, passiva ou status | Stats | Dado puro, o jeito nativo do jogo |
| Ligar isso à classe, aos níveis e às listas | LSX | É a estrutura que o jogo lê para a progressão |
| Uma condição complexa ou reutilizável (alvo válido, requisito de uso) | Khonsu, com funções Thoth | Vai além das expressões simples, e funciona sem o Script Extender |
| Reagir a algo que acontece no jogo (fim de turno, subir de nível) e os stats não cobrem | Osiris, ou um listener em Lua | Código orientado a eventos |
| Alterar dados em tempo de execução, mexer em interface, entidades, variáveis salvas | Lua (Script Extender) | Só dá para fazer ali |

Há mods de magias complexas que funcionam quase só com Khonsu, com poucas partes em Osiris e sem exigir o Script Extender, o que mostra quanto dá para fazer sem Lua.

**25.3 Princípios.**

- **Dados antes de código.** Se um campo de Stats resolve, não escreva script.
- **Prefixo único do projeto em tudo** (a confirmar com o mod existente, cujo prefixo tem prioridade; sugestão: `ARC_`). Nomes de entradas de Stats, bancos de dados do Osiris, `ModTable` do Lua, variáveis do Script Extender e tipos de interface são globais, e colidir com o jogo base ou com outros mods causa sobrescrita silenciosa.
- **Nunca editar nem sobrescrever o jogo base.** Criar entradas novas e herdar (`using`) das existentes.
- **Uma responsabilidade por arquivo**, com um cabeçalho que cita o ticket e a spec de origem.
- **O jogo é sempre "multijogador".** Mesmo no modo solo existe servidor e cliente (seção 28). Pense nos dois lados.
- **Desempenho.** O servidor roda cerca de 30 vezes por segundo, então nada pesado a cada tick.
- **Sem rede.** O Script Extender não acessa a internet nem outros programas.

**25.4 Dependência do Script Extender é decisão de produto.** Todo recurso em Lua restringe quem pode usar o mod, porque o jogador precisa instalar o Script Extender. Prefira Stats, Khonsu e Osiris quando bastam. Quando Lua for necessário, isso é registrado em `00.06` e avisado na página do mod.

## 26. Stats e LSX: os dados do mod

**26.1 Stats.** Ficam em `Public/<Mod>/Stats/Generated/Data/*.txt`. Cada entrada tem um nome único, um tipo e uma lista de campos, e pode **herdar** de outra entrada com `using`, mudando só o que interessa. Exemplo ilustrativo (nomes fictícios; os campos válidos de cada tipo estão em `Modifiers.txt`, ver 26.3):

```
new entry "ARC_Target_Exemplo"
type "SpellData"
using "Target_Exemplo_Base"
data "SpellType" "Target"
data "Level" "1"
data "UseCosts" "ActionPoint:1"
data "TargetConditions" "not Self() and not Dead()"
data "DamageType" "Force"
```

**26.2 Tipos de entrada.** Os principais são `SpellData` (magias, subdivididas por `SpellType`: Target, Projectile, Shout, Throw, Wall, Zone e outros), `StatusData` (status e condições), `PassiveData` (passivas), `InterruptData` (reações), além de `Armor`, `Weapon`, `Character`, `Object`, `SpellSet` e `EquipmentSet`. O catálogo de tipos e subtipos do projeto fica em `55.00`.

**26.3 Campos importantes.**

| Campo | O que faz |
| --- | --- |
| `UseCosts` | Custo de uso (ação, ação bônus, espaço de magia, recurso), por exemplo `ActionPoint:1` |
| `TargetConditions` | Quem pode ser alvo (expressão de condição) |
| `SpellProperties` | Efeitos, por exemplo aplicar um status com chance e duração |
| `Boosts` | Bônus aplicados, separados por ponto e vírgula (habilidade, tags, desbloquear magia) |
| `StatsFunctorContext`, `StatsFunctorConditions`, `StatsFunctors` | Em passivas e status: quando, sob que condição e o que acontece |
| `Level`, `SpellSchool`, `DamageType` | Nível, escola e tipo de dano |
| `Icon`, `DisplayName`, `Tooltip*` | Ícone, nome (referência a um texto da localização) e textos de tooltip |
| `LevelMapValue(Nome)` | Valores que escalam com o nível, vindos dos mapas de nível |

Os campos válidos de cada tipo estão em `Public/Shared/Stats/Generated/Structure/Modifiers.txt`, e as listas de valores aceitos (enumerações) em `ValueLists.txt` ou `Enumerations.xml`. **Esses arquivos do jogo são o esquema oficial:** o validador de `53.03` e o agente de Stats os usam em vez de memória.

**26.4 Herança com `using`.** Uma entrada nova pode puxar tudo de uma existente e sobrescrever só alguns campos. É o jeito certo de criar variantes sem copiar tudo. Cuidado: se a entrada-mãe for de outro mod, uma atualização dele pode alterar a sua.

**26.5 LSX: estrutura da classe.**

| Arquivo | Função |
| --- | --- |
| `Mods/<Mod>/meta.lsx` | Identidade do mod: pasta, nome, UUID, versão e dependências |
| `ClassDescriptions.lsx` | Definição da classe e das subclasses |
| `Progressions.lsx` | O que cada nível concede (selecionar e adicionar magias e passivas, recursos) |
| `Lists/SpellLists.lsx`, `PassiveLists.lsx`, `SkillLists.lsx` | Listas referenciadas pela progressão |
| `ActionResourceDefinitions.lsx`, `AbilityDistributionPresets.lsx` | Recursos de ação e distribuição de atributos |

Regras dos UUIDs: **sobrescrever** algo do jogo exige o UUID idêntico ao original, e **adicionar** algo exige um UUID novo, gerado do zero. A progressão aponta para as listas por UUID. Fluxo para uma magia nova: entrada em Stats → entrada em `SpellLists.lsx` (com UUID novo) → referência em `Progressions.lsx` → texto na localização → ícone. Para uma passiva, ela entra no campo de passivas adicionadas da progressão, sem lista.

**26.6 Registro de UUIDs.** Mantenha `52.04_Registro_de_UUIDs` com todo UUID criado, o arquivo onde está e o ticket de origem. O validador de `53.03` recusa duplicatas.

**26.7 Localização.** Textos aparecem no jogo por **handles** (identificadores longos como `h…;1`), referenciados no campo `DisplayName` e nos tooltips. O handle é gerado pelo Toolkit ou por script, e o texto vem de `33` (seção 9).

**26.8 Erros comuns.**

| Sintoma | Causa provável | Verificação |
| --- | --- | --- |
| Sobrescreveu algo do jogo sem querer | Nome de entrada igual ao do jogo base | Prefixo único; comparar com a extração do jogo base |
| A magia não aparece | Faltou lista, referência na progressão ou `meta.lsx` | Seguir o fluxo da 26.5 |
| Aplica o status errado ou nenhum | Comando no campo errado ou com parâmetros errados | Conferir o campo e os parâmetros contra um exemplo do jogo base |
| Falha de build | Pastas ou nomes diferentes da estrutura do jogo | Comparar com o índice da ferramenta de build |
| Conflito misterioso | Outro mod altera o mesmo conteúdo | Testar com os outros mods desligados (`64`) |

## 27. Khonsu e Thoth: condições e funções

**27.1 O que são.** Khonsu é a linguagem de script do motor da Larian usada em condições e functors dos Stats. Os arquivos têm extensão `.khn`, e a linguagem é uma variante de Lua, de modo que linters de Lua em geral servem. **Thoth** é o nome das funções de condição que o jogo já traz: a maioria devolve um dado do tipo `ConditionResult`. Elas ficam em scripts auxiliares (pasta `thoth/helpers`). Condições e functors usados em Stats também existem em Khonsu. **Atenção:** não encontrei documentação oficial da Larian sobre Khonsu e Thoth; o que está aqui vem de um guia da comunidade (mod.io) e de mods abertos. O Claude executor deve confirmar a taxonomia exata lendo os `.khn` extraídos do jogo (`56.03`).

**27.2 Diferenças em relação às condições dentro dos Stats.** Em Khonsu, os operadores lógicos `not`, `and`, `or` dos Stats são substituídos pelos operadores bit a bit `~`, `&` e `|`.

**27.3 Como usar no Toolkit.**

1. Coloque os `.khn` em `Data/Mods/<Mod>/Scripts/thoth/helpers/`.
2. Os scripts são carregados quando os stats são recarregados no Toolkit.
3. Se houver erro, o Toolkit pode travar, e o detalhe fica em `errors.txt`, na pasta do Toolkit. Teste após cada alteração pequena.

**27.4 Mensagens de erro para o jogador.** Funções de condição podem devolver um `ConditionError`, uma mensagem ligada a um texto da localização. Isso explica ao jogador por que uma feature não pode ser usada (por exemplo, "não funciona com armadura pesada"). Para features de classe com requisitos, planeje o texto de erro na spec (seção 7) e na localização.

**27.5 Boas práticas.**

- Uma função, um propósito, nome com prefixo do projeto.
- Não editar tabelas compartilhadas do jogo base: definições de Khonsu que sobrescrevem as de outros podem ser vencidas por qualquer mod que carregue depois. Prefira arquivos e nomes próprios.
- Tratar valores ausentes (`nil`) e testar o caso verdadeiro e o falso.
- Para linters, existem bibliotecas da comunidade com as classes e funções do Khonsu (ex.: o repositório Bg3-Khn-Libs). Elas estão em andamento, então o `.khn` do jogo base continua sendo a referência.
- O jogo está na sua versão final (Patch 8), que inclui funções novas em relação às de patches antigos. A extração do jogo instalado é a verdade.

**27.6 Khonsu, Osiris ou Lua?** Se a lógica é uma **condição** (verdadeiro ou falso sobre alvo, contexto ou estado), use Khonsu. Se é uma **reação a um evento** do jogo, use Osiris. Se precisa de acesso ao motor, use Lua.

## 28. Lua e o Script Extender

**28.1 O que é.** O Script Extender (BG3SE), de Norbyte, adiciona ao jogo scripts em Lua e novas funções de Osiris. Ele é instalado à parte pelo jogador. Cada mod que o usa precisa de um arquivo de configuração e de scripts de inicialização:

| Item | Função |
| --- | --- |
| `Mods/<Mod>/ScriptExtender/Config.json` | Declara `RequiredVersion` (versão mínima do Script Extender), `ModTable` (nome único do mod na tabela global de mods) e `FeatureFlags` (por exemplo, `["Lua"]`) |
| `ScriptExtender/Lua/BootstrapServer.lua` | Primeiro script carregado no lado do servidor |
| `ScriptExtender/Lua/BootstrapClient.lua` | Primeiro script carregado no lado do cliente |

Outros arquivos são carregados a partir dos Bootstrap com `Ext.Require("Caminho/Arquivo.lua")`, e isso só deve acontecer durante a inicialização do módulo.

**28.2 Servidor e cliente.** Internamente o jogo tem um servidor e um ou mais clientes, e mesmo o modo solo é um "multijogador" com um único cliente local. O Osiris roda sempre no servidor. O Lua tem estados separados para o servidor e para cada cliente, e eles não enxergam variáveis um do outro. Regra do estúdio: **o que muda o estado do jogo roda no servidor; interface roda no cliente; a conversa entre os dois usa o NetChannel** (a API mais antiga, NetMessage, está obsoleta).

**28.3 Eventos do ciclo de vida.**

| Evento | Quando acontece | Uso típico |
| --- | --- | --- |
| `ModuleLoadStarted` | O motor começou a carregar os mods | Redirecionar arquivos antes de carregarem |
| `StatsLoaded` | Os stats foram (re)carregados | **Aplicar aqui as alterações de Stats válidas para toda sessão** |
| `SessionLoading` | Começou a montar a sessão (novo jogo, carregar save, entrar em multijogador) | Preparar estado |
| `SessionLoaded` | A sessão está pronta | Ler variáveis salvas, iniciar lógica |
| `ResetCompleted` | O Lua foi recarregado (comando `reset`) | Reinicializar sem reiniciar o jogo |
| `GameStateChanged` | Mudou o estado do jogo (menu, carregando, pausa) | Reagir a transições |
| `Tick` | Depois de cada tick do motor (cerca de 33 ms no servidor) | Só para tarefas leves e raras |

Assinatura típica: `Ext.Events.SessionLoaded:Subscribe(function(e) ... end)`.

**28.4 Osiris a partir do Lua.** O Lua do servidor tem uma tabela global `Osi` com todos os símbolos do Osiris (chamadas, queries, eventos, PROCs e bancos de dados). `Ext.Osiris.RegisterListener(nome, aridade, "before" ou "after", função)` captura eventos, bancos e PROCs. Bancos são lidos com `:Get` e apagados com `:Delete`, e `nil` nos parâmetros significa "qualquer valor".

**28.5 Stats a partir do Lua.** `Ext.Stats.Get(nome)` devolve uma entrada que se lê e escreve como uma tabela. Pontos de atenção:

- Alterações feitas durante `StatsLoaded` não precisam de sincronização. Depois do carregamento, é preciso chamar `:Sync()` na entrada.
- Campos que são tabelas (como `Requirements` ou `SpellProperties`) precisam ser **reatribuídos** depois de alterados, senão a mudança é ignorada.
- A lista de atributos válidos vem de `Modifiers.txt` (seção 26.3).

**28.6 Persistência.** O estado do Lua zera a cada recarga do jogo. Para guardar dados no save use variáveis de usuário (`Ext.Vars.RegisterUserVariable`) ou variáveis de mod (`RegisterModVariable`). `PersistentVars` está obsoleto. As variáveis precisam ser registradas durante o carregamento dos Bootstrap, antes do save ser lido, e, ao alterar uma tabela dentro de uma variável, é preciso reatribuí-la para a mudança ser detectada e sincronizada.

**28.7 Regras de segurança.**

- **Escopo de objetos:** objetos do motor (personagem, status, entidade) só valem dentro do listener em que foram obtidos. Guardá-los para usar depois (por exemplo, num `OnNextTick`) gera erro. Guarde identificadores (UUIDs), não objetos.
- Ler ou escrever propriedade inexistente lança erro. Isso é bom: falha alto, em vez de silenciosa.
- Código de interface (Noesis) deve rodar dentro de `Ext.UI.Defer`.
- Sem rede e sem acesso a arquivos fora das pastas permitidas.
- Funções de depuração (`_P`, `_D`, `_C`) são só para desenvolvimento e não devem ficar no release.
- Nada pesado no `Tick`.

**28.8 Ferramentas de edição e qualidade.** O repositório do Script Extender traz o `ExtIdeHelpers.lua`, definições de tipos que dão autocompletar e verificação no editor (por exemplo, VS Code com um servidor de linguagem Lua). O `luacheck` é um analisador estático que detecta variáveis globais indefinidas, variáveis sem uso e código inalcançável. Configure um `.luacheckrc` declarando os globais do Script Extender (`Ext`, `Osi`, `Mods`, `_P`, `_D`, `_C`). Para lógica pura (funções que não chamam o motor) o `busted` permite testes unitários. A versão exata de Lua e os globais disponíveis devem ser confirmados na instalação do Script Extender usada.

## 29. Osiris: scripts de história

**29.1 O que é.** Osiris é uma linguagem em grande parte **declarativa**, parecida com Prolog em alguns pontos. Um programa Osiris é uma coleção de regras que operam sobre um banco de dados global do jogo. Ele reage a **eventos** (algo aconteceu), consulta o estado do jogo por **queries** e o altera por **calls**. O conjunto de todos os arquivos (**goals**) do mod e das suas dependências forma a **Story**. Os goals do mod ficam em `Story/RawFiles/Goals/*.txt`.

**29.2 Anatomia.**

| Elemento | Função |
| --- | --- |
| Goal | Um arquivo de script, com três seções: `INITSECTION` (ações na inicialização), `KBSECTION` (regras) e `EXITSECTION` (ações ao terminar) |
| Banco de dados (`DB_...`) | Uma tabela tipada; cada linha é um "fato". O nome precisa começar com `DB_` e é global a todos os mods |
| Regra | `IF` condições `THEN` ações. Eventos só podem ser a **primeira** condição |
| Event, Query, Call | O jogo avisa o Osiris (event), o Osiris pergunta ao jogo (query) ou o Osiris manda o jogo mudar algo (call) |
| `QRY_...` | Query definida por você; várias definições do mesmo nome criam um OU lógico |
| `PROC_...` | Procedimento: agrupa ações, com condições extras opcionais |
| `GoalCompleted;` | Encerra o goal e ativa os subgoals |

Exemplo ilustrativo (nomes fictícios):

```
INITSECTION
DB_ARC_Exemplo("Valor");

KBSECTION
IF
DB_ARC_Exemplo(_X)
THEN
DB_ARC_Resultado(1);

EXITSECTION
NOT DB_ARC_Exemplo("Valor");
```

**29.3 Regras de execução que mais causam bugs.**

- **Orientado a eventos:** não existe "main". Regras só disparam quando um evento chega ou quando um fato é definido ou removido.
- **Ordem das regras:** as regras são avaliadas de cima para baixo na Story inteira, e os goals são ordenados **alfabeticamente pelo nome**, ignorando dependências entre mods.
- **Inicialização:** goals de nível superior iniciam ao carregar o mod, e subgoals iniciam quando o goal-pai termina. Dentro da `INITSECTION`, não dependa de PROCs ou queries de outros goals e não faça consultas ao jogo, porque ele ainda não terminou de inicializar.
- **Fatos repetidos não disparam de novo.** Para repetir uma regra com o mesmo valor, remova o fato antes (`NOT DB_...`).
- **Tipos:** o primeiro uso de um banco ou query define os tipos das colunas, e é fonte comum de erro de tipo no começo.
- **Quadros (frames):** tudo que um evento dispara acontece num mesmo quadro, de forma atômica. Alguns efeitos, como flags vistas por diálogos, só aparecem no quadro seguinte.
- **Limpeza:** remova da `EXITSECTION` os bancos que não são mais usados. Isso reduz o tamanho do save.

**29.4 Padrões de projeto.** Coloque ajudantes globais em goals de nível superior. Defina bancos na `INITSECTION`. Mova verificações repetidas para queries próprias. Use um prefixo único em goals, bancos, queries e PROCs, porque o espaço de nomes é único.

**29.5 Aviso sobre a documentação.** A melhor documentação pública de Osiris da Larian é a wiki do motor Divinity, escrita na época de *Divinity: Original Sin 2*. Os conceitos valem para o BG3, mas **as chamadas, queries e eventos disponíveis são diferentes**. A verdade para o BG3 está no código do jogo base e nas definições extraídas (seção 32).

**29.6 Osiris ou Lua?** O Script Extender permite escrever a lógica em Lua e ouvir eventos do Osiris. Regra do estúdio: use Osiris quando um evento da história basta e se quer evitar a dependência do Script Extender; use Lua quando precisar de mais poder ou de melhor depuração. **Nunca duplique a mesma lógica nos dois.**

**29.7 Ferramentas.** O Story Editor do Toolkit (gera as definições e compila a Story do mod), o LSLib para extrair os goals do jogo base, formatadores de Osiris da comunidade e o BG3 Forge, que lê Stats, LSX e as histórias compiladas do jogo instalado.

## 30. Fluxo de trabalho de programação

Este fluxo detalha as etapas 8 a 13 do ciclo de vida (seção 8) do ponto de vista de quem escreve o código e os dados.

**30.1 Etapas.**

| # | Etapa | O que acontece | Saída |
| --- | --- | --- | --- |
| 1 | Ler a spec | O agente lê `SPEC_ARC-####` e divide em itens por camada | Lista de itens de trabalho |
| 2 | Explorar o jogo base | Procura âncoras e exemplos reais em `56` (modo de planejamento, somente leitura) | Referências citadas por caminho |
| 3 | Plano curto | Arquivos a criar ou alterar, ordem, riscos | Plano aprovado (por você, se `implementacao: owner`) |
| 4 | Implementar por camadas | Stats → LSX → Khonsu → Lua ou Osiris → localização → ícones | Arquivos em `51` |
| 5 | Autoverificação | Validadores (`53.03`), linters, recarregar stats sem erros | Relatório sem pendências |
| 6 | Teste no jogo | Save padrão de `83.02`, passos "como verificar" da spec | Evidências em `65` |
| 7 | Revisão de código | Checklist do Portão de Código (30.5) | Aprovação ou lista de ajustes |
| 8 | Commit e build | Branch `feature/ARC-####`, `.pak` de teste | Build em `53.04` |
| 9 | QA | Casos de teste de `61.02` | Aprovado ou bugs em `62` |

**30.2 Ordem das camadas.** Respeita as dependências: uma magia que aplica um status exige o status antes, e uma progressão que usa uma lista exige a lista antes. A ordem da spec (seção 7) já segue isso.

**30.3 Git.**

- Uma branch por ticket (`feature/ARC-####`), commits pequenos (um por camada) e mensagem começando pelo ticket. Um padrão de mensagens como o Conventional Commits ajuda a ler o histórico.
- Nada do jogo base entra no repositório (seção 12).
- Nunca forçar push em `main`; merges só com a sua aprovação.
- O Code Reviewer lê o diff de cada branch antes do merge.

**30.4 Os dois modos de implementação.**

- **`implementacao: owner` (você, no Toolkit).** A spec é seguida item a item. Depois de sincronizar a pasta `Data` com `51` (seção 7), o agente de engenharia roda os validadores, compara o resultado com a spec, item por item, e abre um bug em `62` para qualquer divergência. O agente não corrige por conta própria.
- **`implementacao: claude`.** O agente trabalha em etapas pequenas: planeja, implementa uma camada, verifica, e só então segue. Para cada alteração, mostra o comando de verificação que rodou e o resultado.

**30.5 Portão de Código (revisão).**

| # | Pergunta | Responsável |
| --- | --- | --- |
| 1 | Os nomes têm o prefixo do projeto e não colidem com o jogo base nem com outros mods? | Code Reviewer |
| 2 | Nenhum arquivo do jogo base foi alterado ou sobrescrito? | Code Reviewer |
| 3 | Os stats recarregam sem erro e os validadores passam (schema, UUIDs, handles)? | Mod Engineer |
| 4 | Khonsu: o `errors.txt` está limpo e há mensagem de erro para o jogador onde cabe? | Khonsu Engineer |
| 5 | Lua: `luacheck` limpo, sem objetos guardados fora do listener, sem trabalho pesado no `Tick`? | Lua Engineer |
| 6 | Osiris: goals com prefixo, `EXITSECTION` que limpa os bancos, sem consulta ao jogo na inicialização? | Osiris Engineer |
| 7 | Funciona no servidor e no cliente (e em partida com mais de um jogador, quando aplicável)? | Lua Engineer |
| 8 | O comportamento bate com a spec, item por item? | Code Reviewer |
| 9 | Cada API ou função usada aparece em um exemplo do jogo base ou na documentação? | Code Reviewer |

**30.6 Definition of Done de engenharia.** Passou no Portão de Código; teste no jogo com evidência; spec e `55` atualizadas se algo mudou; contexto `05` atualizado pelo Guardião; nada do jogo base versionado; versão e `meta.lsx` conferidos.

**30.7 Compatibilidade com outros mods.** Teste com e sem os mods de classe mais populares (`64`). `meta.lsx` declara dependências. Em Lua, `Ext.Mod.IsModLoaded` e `GetLoadOrder` permitem detectar outros mods. Registre conflitos conhecidos em `52.03`.

## 31. Qualidade, depuração e testes

**31.1 Quatro camadas de verificação.**

| Camada | O que verifica | Como |
| --- | --- | --- |
| Estática | Schema dos Stats (`Modifiers.txt`), UUIDs duplicados, XML e LSX válidos, handles de texto, `luacheck` em Lua, núcleo 1 a 12 sem dependência do módulo 13 a 20 | Validadores em `53.03` e `lint_codigo` em `82` |
| Lógica | Funções puras (cálculos, escolhas) sem chamar o motor | Testes unitários (`busted`), quando houver lógica própria em Lua |
| No jogo | Que a feature funciona de verdade | Saves padrão de `83.02` e os passos "como verificar" da spec |
| Regressão e compatibilidade | Que nada antigo quebrou e que convive com outros mods | `64` e a lista de mods testados |

**31.2 Ferramentas de depuração.**

| Ferramenta | Para quê |
| --- | --- |
| Console do Script Extender | Executar Lua na hora (servidor ou cliente), recarregar scripts com `reset`, comandos próprios com prefixo `!`, imprimir com `_P` e inspecionar objetos com `_D` |
| Configurações do Script Extender (`ScriptExtenderSettings.json`) | Ligar logs (`EnableLogging`, `LogRuntime`, `LogCompile`, `LogFailedCompile`), console e depuradores de Osiris e de Lua (portas 9999 e 9998 por padrão) |
| `Ext.IO.SaveFile` com `Ext.DumpExport` | Salvar um objeto grande em arquivo para analisar fora do jogo |
| `errors.txt` do Toolkit | Erros de Khonsu ao recarregar os stats |
| Story Editor | Erros de compilação do Osiris |
| Mod de depuração oficial da Larian | Ferramentas de teste: mudar atributos, pular para regiões, manipular flags de script |

**31.3 Checklist de teste por camada.**

| Camada | O que conferir |
| --- | --- |
| Stats | Aparece no livro de magias e na barra? Custo, alcance, área e teste corretos? Aplica o status esperado? Tooltip legível? Entra pelo caminho de level up? |
| Khonsu | A condição dá verdadeiro e falso nos casos certos? A mensagem de erro aparece no tooltip? |
| Lua | Funciona depois de `reset` e depois de recarregar o save? E em partida com mais de um jogador? Sem erro de objeto expirado? Sem queda de desempenho? |
| Osiris | O goal inicia e termina como esperado? Os bancos são limpos? Os logs mostram as regras disparando? |
| LSX | A progressão entrega o que a tabela diz em cada nível, de 1 a 12? A multiclasse funciona? |

**31.4 Compatibilidade de saves.** Mods que mudam a progressão podem exigir que o jogador refaça o personagem em saves existentes. Prática recomendada: **nunca renomear nem apagar entradas já publicadas** (Stats, listas, UUIDs). Para aposentar algo, mantenha a entrada antiga funcionando ou como equivalente de uma nova, e registre no changelog e nos patch notes (seção 11).

**31.5 Diagnóstico rápido.**

| Sintoma | Onde olhar |
| --- | --- |
| O mod não aparece no jogo | `meta.lsx`, estrutura de pastas contra o jogo base, UUIDs |
| Magia ou passiva não chega ao personagem | Lista, referência na progressão, UUID duplicado, campo errado |
| Toolkit trava ao recarregar stats | `errors.txt` (Khonsu) |
| Erro de objeto expirado no Lua | Objeto guardado fora do listener (28.7) |
| Mudança em tabela de stat é ignorada | Faltou reatribuir a tabela (28.5) |
| Dado some após carregar o save | Variável não registrada no Bootstrap ou tabela não reatribuída (28.6) |
| Efeito só acontece uma vez | Fato repetido não dispara de novo no Osiris (29.3) |

## 32. Agentes especialistas e base de conhecimento de código

**32.1 Princípio: fundamentar no código real.** Modelos de IA conhecem partes do modding de BG3, mas erram nomes de eventos, campos e funções. Por isso o estúdio adota a regra: **antes de usar qualquer função, evento, campo ou valor, o agente encontra um exemplo real no jogo base extraído (`56`) ou na documentação**. Se não encontrar, ele diz "não sei" e abre uma pergunta, em vez de inventar.

**32.2 Elenco de engenharia.**

| Agente | Domínio | Lê | Escreve | Ativação |
| --- | --- | --- | --- | --- |
| Mod Engineer (coordenador) | Arquitetura, specs, integração, build | Seções 25, 30, 31 | `55`; `51` só com `implementacao: claude` | Ativo |
| Stats e LSX Engineer | Stats, LSX, handles | Seção 26 e `56.02` | `51` (Stats, Lists, Progressions) | Ativo em modo de spec; código sob demanda |
| Khonsu Engineer | Condições `.khn` | Seção 27 e `56.03` | `51` (`Scripts/thoth`) | Sob demanda |
| Lua e SE Engineer | Lua | Seção 28 e `56.04` | `51` (`ScriptExtender`) | Sob demanda |
| Osiris Engineer | Goals | Seção 29 e `56.01` | `51` (`Story`) | Sob demanda, depois da extração |
| Code Reviewer | Revisão de diffs | Seções 30 e 31 | Relatórios (nunca o código) | Ativo quando houver código |

Todos são subagentes em `.claude/agents/`, cada um com as ferramentas mínimas: os de leitura só leem `56` e `57`, e só escrevem em `51` quando o ticket permite.

**32.3 Como montar o agente especialista em Osiris.** O jogo base traz milhares de linhas de Osiris, e é essa a melhor fonte de verdade:

1. **Localizar** os arquivos `story.div.osi` do jogo base, que ficam nos módulos Gustav, GustavDev e Honour. Os patches também trazem versões, então confira as pastas de patch desempacotadas.
2. **Extrair** com o LSLib, na ferramenta "Story (OSI)": informar o arquivo, clicar em Load, escolher a pasta de saída dos goals e clicar em Extract. A saída vai para `56.01_Osiris_Goals/` (local, fora do Git). O BG3 Forge, de código aberto, também lê as histórias compiladas.
3. **Indexar** com o script `indexar_vanilla`: para cada goal, o pai, o primeiro gatilho de cada regra (evento ou banco), os bancos definidos e lidos, as PROCs e QRYs definidas e chamadas e as chamadas nativas usadas. O resultado vai para `56.05_Indices/`.
4. **Catálogo de padrões** (`57.05`): para cada tarefa comum (dar um item, aplicar um status, reagir a um evento de combate ou de turno, marcar uma flag), dois ou três exemplos reais, com caminho do arquivo e explicação em palavras próprias.
5. **Ficha de conhecimento:** os conceitos da seção 29, as convenções do projeto e a regra de fundamentação da 32.1.
6. **Definição do agente** em `.claude/agents/osiris-engineer.md`: leitura em `56` e `57`, escrita em `51/Story` somente com `implementacao: claude`, prefixo obrigatório do projeto, e instrução de citar o arquivo do jogo base de onde tirou cada API.
7. **Avaliação antes de liberar:** uma bateria de cerca de 10 tarefas (por exemplo, explicar o que um goal simples faz, achar onde um evento é tratado, escrever uma regra equivalente a uma existente). O agente só é ativado se acertar e citar as fontes. O resultado fica em `57.05`.
8. **Manutenção:** o jogo está na versão final, então a extração é feita uma vez e só se repete se a versão do jogo ou do Script Extender mudar.

O mesmo método vale para **Stats** (`56.02`: `Public/Shared/Stats/Generated/Data`, `Modifiers.txt`, `ValueLists.txt`), **Khonsu** (`56.03`: os `.khn` e os scripts `thoth`) e **Lua** (`56.04`: o mod de exemplo do Script Extender e mods abertos de referência).

**32.4 Cuidado com conteúdo da Larian.** A extração é para uso local e **nunca** vai ao Git nem a terceiros (seções 12 e 13). Os índices, por derivarem do conteúdo, também ficam locais. As fichas de `57` são escritas em palavras próprias, com trechos curtos só quando indispensáveis.

**32.5 Regras para agentes que escrevem código** (adaptadas das práticas do Claude Code):

- **Dar ao agente um jeito de verificar o próprio trabalho:** validadores, `luacheck`, recarregar stats, o teste da spec. Sem verificação, ele para quando "parece pronto".
- **Explorar, planejar e só então codar.** O modo de planejamento separa a pesquisa da execução.
- **O contexto é o recurso mais escasso.** Usar subagentes para pesquisar no jogo base (eles devolvem só um resumo), limpar o contexto entre tarefas não relacionadas e nunca carregar a extração inteira: consultar primeiro o índice e depois abrir só os arquivos necessários.
- **`CLAUDE.md` curto.** Um arquivo inchado faz o agente ignorar as instruções. Ele deve ser um "roteador": regras essenciais e ponteiros para as fichas.
- **Hooks para as regras que não podem falhar:** bloquear escrita em `56` e em qualquer arquivo do jogo base, bloquear escrita em `51` sem `implementacao: claude`, e rodar o linter depois de cada edição. Hooks executam sempre, ao contrário de instruções em texto.
- Commits pequenos, um por camada.

## 33. Glossário de engenharia

| Termo | Significado |
| --- | --- |
| Stats | Arquivos `.txt` de dados de magias, passivas, status e itens |
| LSX, LSF | Formatos de dados do motor: LSX é XML legível, LSF é a versão binária |
| Loca, handle | Sistema de textos traduzíveis; o handle é o identificador de um texto |
| UUID | Identificador único universal de uma entrada |
| `using` | Herança: uma entrada de Stats que parte de outra |
| Boost | Bônus aplicado por uma passiva, status ou item |
| Functor | Efeito executado quando uma condição ocorre |
| Khonsu (`.khn`) | Linguagem de script do motor para condições e functors, variante de Lua |
| Thoth | Funções de condição que o jogo já traz e que devolvem `ConditionResult` |
| Osiris | Linguagem declarativa de scripts de história, baseada em regras |
| Goal, Story | Arquivo de script Osiris, e o conjunto de todos os goals carregados |
| DB, PROC, QRY | Banco de dados do Osiris, procedimento e query definidos pelo mod |
| Event, Query, Call | Aviso do jogo ao Osiris, pergunta do Osiris ao jogo e ordem do Osiris ao jogo |
| Script Extender (BG3SE) | Ferramenta que adiciona Lua e novas funções ao jogo |
| `Ext`, `Osi`, `Mods` | Tabelas globais do Script Extender: API própria, símbolos do Osiris e mods |
| `ModTable` | Nome único do mod na tabela global de mods do Lua |
| Bootstrap | Primeiro script carregado do mod no servidor e no cliente |
| ModVars, UserVars | Variáveis do Script Extender que persistem no save |
| `meta.lsx` | Arquivo que identifica o mod e suas dependências |
| Toolkit | Editor oficial da Larian para mods |
| LSLib, Divine | Ferramentas para abrir e converter arquivos e pacotes do jogo |
| Multitool | Utilitário de comunidade que organiza, indexa e empacota mods |
| `.pak` | Pacote do mod |
| Linter | Programa que aponta erros e maus hábitos no código sem executá-lo |
| Fundamentação (grounding) | Exigir que cada afirmação técnica venha de uma fonte real, não de memória |

## 34. Fontes da Parte III

**Classificação:** *Primária* (autor da ferramenta ou a Larian), *Comunidade* (wikis, guias e mods de terceiros, com menor autoridade). Lacunas conhecidas: não localizei documentação oficial de Khonsu e Thoth; a documentação de Osiris da Larian é da época de Divinity: Original Sin 2; o guia de Khonsu do mod.io só pôde ser lido por trechos de busca; e não abri o mod de exemplo do Script Extender nem os arquivos `.khn` do jogo. O Claude executor deve cobrir essas lacunas com a extração do jogo instalado.

| Fonte | Tipo | Usada em |
| --- | --- | --- |
| [Larian, Osiris Overview](https://docs.larian.game/Osiris_Overview) | Primária (era DOS2) | 29 |
| [Larian, Osiris Design Patterns](https://docs.larian.game/Osiris_Design_Patterns) | Primária (era DOS2) | 29.4 |
| [Larian, Your First Story Script](https://docs.larian.game/Your_First_Story_Script) | Primária (era DOS2) | 29 |
| [Larian, Osiris APIs](https://docs.larian.game/Category:Osiris_APIs) | Primária (era DOS2) | 29.5 |
| [Norbyte, BG3 Script Extender (repositório)](https://github.com/Norbyte/bg3se/) | Primária | 28, 31 |
| [Norbyte, BG3SE Lua API](https://github.com/Norbyte/bg3se/blob/master/Docs/API.md) | Primária | 28 |
| [BG3 Modding Community Wiki, Unpacking Osiris Code](https://wiki.bg3.community/Information/Osiris/unpacking-osiris) | Comunidade | 32.3 |
| [mod.io, Adding Khonsu (.khn) condition scripts](https://mod.io/g/baldursgate3/r/adding-khonsu-khn-condition-scripts) | Comunidade | 27 |
| [NellyDevo, Bg3-Khn-Libs](https://github.com/NellyDevo/Bg3-Khn-Libs) | Comunidade | 27.5 |
| [bg3.wiki, Modding: LSX files](https://bg3.wiki/wiki/Modding:LSX_files) | Comunidade | 26.5 |
| [BG3 Community Library, Setting up a Development Environment](https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Setting-up-a-Development-Environment) | Comunidade | 30 |
| [BG3 Community Library, Testing Your Changes](https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Testing-Your-Changes) | Comunidade | 26.8, 31 |
| [BG3 Community Library, Using Community Library Content](https://github.com/BG3-Community-Library-Team/BG3-Community-Library/wiki/Using-Community-Library-Content) | Comunidade | 26.4, 26.5 |
| [ImADoctorNotA, Como criar uma passiva (Medium)](https://medium.com/@imadoctornota/allergic-to-passives-how-to-make-a-custom-bg3-passive-fde603bf08df) | Comunidade | 26.3 |
| [LSLib, issue com o guia da CLI Divine](https://github.com/norbyte/lslib/issues/50) | Comunidade | 32.3 |
| [BG3 Forge (PyPI)](https://pypi.org/project/bg3forge/) | Comunidade | 29.7, 32.3 |
| [libbg3 (leitura de histórias do Osiris)](https://awesome.ecosyste.ms/projects/github.com%2Feiz%2Flibbg3) | Comunidade | 29.7 |
| [Osiris formatter (Nexus Mods)](https://www.nexusmods.com/baldursgate3/mods/20931) | Comunidade | 29.7 |
| [awesome-bg3: lista de ferramentas e tutoriais](https://github.com/bg3mods/awesome-bg3) | Comunidade | Geral |
| [Anthropic, Claude Code: best practices](https://code.claude.com/docs/en/best-practices) | Primária | 32.5 |
| [Luacheck](https://github.com/lunarmodules/luacheck) | Primária (da ferramenta) | 28.8, 31 |

**Para consultar com o Toolkit aberto:** o Toolkit e os arquivos extraídos do jogo são a referência final. O site bg3.norbyte.dev, citado no guia de Khonsu como navegador de exemplos do jogo base, não foi acessado nesta pesquisa.
