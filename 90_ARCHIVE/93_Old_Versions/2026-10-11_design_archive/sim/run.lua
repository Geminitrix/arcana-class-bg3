package.path = arg[0]:gsub("run%.lua$", "?.lua") .. ";" .. package.path
local S = require("sim")
math.randomseed(20260917)
local N = tonumber(arg[1]) or 3000
local SUBS = {"Unbound", "Deceiver", "Starchild", "Eternal"}
local LEVELS = {1, 3, 5, 7, 9, 11, 13, 17, 20}
local EFF = 0.69 -- deck efficiency: random draw x0.9, ramp x0.9, locked versatility x0.85

local function base(over)
  local cfg = {cap = 5, reserve = 1, hardCap = 6, opening = 5, handMax = 10, drawPerTurn = 1, rule = "essence", T = "mix", reweave = true, start = 0}
  for k, v in pairs(over or {}) do cfg[k] = v end
  return cfg
end
local function f(x) return string.format("%.2f", x) end
local function pc(x) return string.format("%.0f%%", 100 * x) end

print("== E1: pool de cartas (titulos sem EX) e deck maximo (3 copias; LR 1) ==")
print("nivel | " .. table.concat(SUBS, " | "))
for _, L in ipairs({1, 2, 3, 4, 5, 7, 9, 11, 12}) do
  local row = {}
  for _, s in ipairs(SUBS) do
    local t = S.pool(s, L, "level")
    local d = 0
    for _, c in ipairs(t) do d = d + ((c.lim == "LR") and 1 or 3) end
    row[#row+1] = #t .. " titulos / deck max " .. d .. (d < 15 and " (<15!)" or "")
  end
  print(L .. " | " .. table.concat(row, " | "))
end

local function seTable(title, cfgOver, levels)
  print("\n== " .. title .. " ==")
  print("sub | nivel | Threads disp/combate | gastos | desperdicio | cartas A+B/turno | fallback/turno | turnos mortos | pts-nivel/combate | alvo Wizard | razao | razao x efic")
  for _, s in ipairs(SUBS) do
    for _, L in ipairs(levels or LEVELS) do
      local cfg = base(type(cfgOver) == "function" and cfgOver(L) or cfgOver)
      local m = S.runSE(s, L, cfg, N)
      local cb, tn = m.combats, m.turns
      local target = S.WIZ[L] / S.E
      local lp = m.levelPts / cb
      print(table.concat({s, L, f(m.avail / cb), f(m.spent / cb), pc(1 - m.spent / m.avail),
        f((m.playsA + m.playsB) / tn), f(m.fallback / tn), pc(m.dead / tn), f(lp), f(target), f(lp / target), f(lp * EFF / target)}, " | "))
    end
  end
end

seTable("E2a: spec atual (rampa 1-5, reserva 1, teto 6, mao 5/10) + custo = ArcaneEssence atual", {rule = "essence"})
seTable("E2b: spec atual + custo = nivel da magia (-1 se 1x/descanso)", {rule = "proposal"})

print("\n== E3: reserva (Spare Thread) 0/1/2 - Deceiver e Starchild, custo proposto ==")
print("sub | nivel | reserva | Threads disp | gastos | desperdicio | pts-nivel/combate")
for _, s in ipairs({"Deceiver", "Starchild"}) do
  for _, L in ipairs({5, 11}) do
    for _, r in ipairs({0, 1, 2}) do
      local m = S.runSE(s, L, base({rule = "proposal", reserve = r}), N)
      print(table.concat({s, L, r, f(m.avail / m.combats), f(m.spent / m.combats), pc(1 - m.spent / m.avail), f(m.levelPts / m.combats)}, " | "))
    end
  end
end

print("\n== E4: mao inicial / limite / compra - Starchild nivel 11 (13 titulos), custo proposto ==")
print("inicial | limite | compra | cartas/turno | turnos mortos | mao media | mao cheia | exiladas/combate | pts-nivel/combate")
for _, o in ipairs({3, 4, 5, 6}) do
  for _, h in ipairs({5, 7, 10}) do
    for _, d in ipairs({1, 2}) do
      local m = S.runSE("Starchild", 11, base({rule = "proposal", opening = o, handMax = h, drawPerTurn = d}), N)
      print(table.concat({o, h, d, f((m.playsA + m.playsB) / m.turns), pc(m.dead / m.turns), f(m.handSum / m.handN),
        pc(m.handFull / m.handN), f(m.exiled / m.combats), f(m.levelPts / m.combats)}, " | "))
    end
  end
end

print("\n== E5: duracao do combate (T fixo), Eternal nivel 11, custo proposto ==")
print("T | Threads disp | gastos | desperdicio | pts-nivel/combate | usou carta 5+ por combate")
for _, T in ipairs({2, 3, 4, 5, 6}) do
  local m = S.runSE("Eternal", 11, base({rule = "proposal", T = T}), N)
  print(table.concat({T, f(m.avail / m.combats), f(m.spent / m.combats), pc(1 - m.spent / m.avail), f(m.levelPts / m.combats), f(m.big / m.combats)}, " | "))
end

local function scaled(L)
  if L <= 4 then return {rule = "proposal", cap = 2, start = 0}
  elseif L <= 8 then return {rule = "proposal", cap = 3, start = 0}
  elseif L <= 12 then return {rule = "proposal", cap = 4, start = 0}
  elseif L <= 16 then return {rule = "proposal", cap = 5, start = 1}
  else return {rule = "proposal", cap = 5, start = 2} end
end
seTable("E6: PROPOSTA - Threads por nivel (teto de base 2/3/4/5/5, inicio +1 no 13, +2 no 17) + custo proposto", scaled)

print("\n== E7: edicao console / fora de combate (sem deck, tudo disponivel) ==")
local PACT = {[1]={1,1},[3]={2,2},[5]={2,3},[7]={2,4},[9]={3,5},[11]={3,6},[13]={3,7},[17]={3,9},[20]={5,9}}
print("sub | nivel | M1 pacto (arquivos): slots x nivel | pts-nivel/combate | razao | M2 pontos: pool/descanso curto | pts-nivel/combate | razao")
for _, s in ipairs(SUBS) do
  for _, L in ipairs(LEVELS) do
    local p = PACT[L]
    local m1 = S.runSlots(s, L, "pact", p[1], p[2], N, "mix")
    local pool = math.floor(S.WIZ[L] / 3 + 0.5)
    local m2 = S.runSlots(s, L, "points", pool, 9, N, "mix")
    local target = S.WIZ[L] / S.E
    print(table.concat({s, L, p[1] .. "x" .. p[2], f(m1.levelPts / m1.combats), f(m1.levelPts / m1.combats / target),
      pool, f(m2.levelPts / m2.combats), f(m2.levelPts / m2.combats / target)}, " | "))
  end
end
