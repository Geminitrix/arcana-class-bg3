package.path = arg[0]:gsub("ideal%.lua$", "?.lua") .. ";" .. package.path
local S = require("sim")
math.randomseed(17092026)
local MODE = arg[1] or "all"
local N = tonumber(arg[2]) or 300

local EFF = 0.9 * 0.85 -- ramp timing x versatility locked by the hand
local TAVG = 4.0       -- mix 3/4/5 turns (30/40/30)

local function A(L) return L <= 4 and 4 or L <= 8 and 8 or L <= 12 and 11 or 12 end
local function ML(L) return math.min(6, math.ceil(L / 2)) end
local function SHIFT(L) return math.max(0, math.ceil(L / 2) - 6) end

-- 5e full-caster slots + Arcane Recovery, in points (Power Budget sec. 2)
local SLOTS = {
  {2},{3},{4,2},{4,3},{4,3,2},{4,3,3},{4,3,3,1},{4,3,3,2},{4,3,3,3,1},{4,3,3,3,2},
  {4,3,3,3,2,1},{4,3,3,3,2,1},{4,3,3,3,2,1,1},{4,3,3,3,2,1,1},{4,3,3,3,2,1,1,1},{4,3,3,3,2,1,1,1},
  {4,3,3,3,2,1,1,1,1},{4,3,3,3,3,1,1,1,1},{4,3,3,3,3,2,1,1,1},{4,3,3,3,3,2,2,1,1},
}
local function wiz(L)
  local pts, lv = 0, 0
  for n, k in ipairs(SLOTS[L]) do pts = pts + k * S_OF(n); lv = lv + k * n end
  local rec = math.ceil(L / 2)
  return pts + S_OF(math.min(5, rec)), lv + rec
end
local function wizTotal(L) local p = wiz(L); return TAVG * A(L) + p / S.E end

-- ideal content rules: 2 cantrips; 3 level-1 cards at L1; +1 card per level at the highest level available;
-- every 3rd card is a bonus action; every 5th is 1x/short rest (cost -1)
local function idealTitles(L, opts)
  opts = opts or {}
  local t = {}
  local function add(lvl, i)
    local act = (i % 3 == 0) and "B" or "A"
    local lim = (i % 5 == 0) and "SR" or nil
    local cost = math.max(1, lvl - ((lim and not opts.noLimDiscount) and 1 or 0))
    t[#t+1] = {id = "c" .. i, lvl = lvl, cost = cost, act = act, lim = lim, cantrip = false}
  end
  for i = 1, (opts.cantrips or 2) do t[#t+1] = {id = "k" .. i, lvl = 0, cost = 1, act = "A", cantrip = true} end
  local i = 0
  for _ = 1, (opts.start or 3) do i = i + 1; add(1, i) end
  for l = 2, L do for _ = 1, (opts.perLevel or 1) do i = i + 1; add(ML(l), i) end end
  return t
end

local function cfgFor(L, over)
  local cfg = {cap = 5, reserve = 1, hardCap = 6, opening = 5, handMax = 10, drawPerTurn = 1, T = "mix", reweave = true, start = 0, shift = SHIFT(L)}
  for k, v in pairs(over or {}) do cfg[k] = v end
  cfg.titles = cfg.titles or idealTitles(L, cfg.content)
  return cfg
end

local function evalSE(L, over, n)
  local cfg = cfgFor(L, over)
  local m = S.runSE("ideal", L, cfg, n or N)
  local cb = m.combats
  local total = (m.turns / cb) * A(L) + EFF * m.sPts / cb
  return {
    ratio = total / wizTotal(L), avail = m.avail / cb, spent = m.spent / cb, waste = 1 - m.spent / m.avail,
    dead = m.dead / m.turns, perTurn = (m.playsA + m.playsB) / m.turns, hand = m.handSum / m.handN,
    full = m.handFull / m.handN, exiled = m.exiled / cb, big = m.big / cb, sPts = m.sPts / cb,
  }
end

local function f(x) return string.format("%.2f", x) end
local function pc(x) return string.format("%.0f%%", 100 * x) end

if MODE == "all" or MODE == "ref" then
  print("== I0: referencia Wizard por nivel (pontos) ==")
  print("nivel | A | niveis de slot/dia | W pts/dia | total/combate (4 turnos x A + W/4) | carta max")
  for L = 1, 20 do local p, lv = wiz(L); print(table.concat({L, A(L), lv, p, f(wizTotal(L)), ML(L) .. (SHIFT(L) > 0 and (" (+" .. SHIFT(L) .. " efetivo)") or "")}, " | ")) end

  print("\n== I1: spec atual (rampa 1-5, reserva 1) com o pool ideal ==")
  print("nivel | Threads disp | gastos | desperdicio | cartas/turno | turnos mortos | razao total vs Wizard")
  for _, L in ipairs({1, 2, 3, 5, 7, 9, 11, 13, 15, 17, 20}) do
    local r = evalSE(L)
    print(table.concat({L, f(r.avail), f(r.spent), pc(r.waste), f(r.perTurn), pc(r.dead), f(r.ratio)}, " | "))
  end
end

if MODE == "all" or MODE == "opt" then
  print("\n== I2: otimizador por nivel (inicio 0-2, teto de base 1-6, reserva 0-2) ==")
  print("restricoes: turnos mortos <= 10%, desperdicio <= 25%; alvo razao = 1,00")
  print("nivel | melhor (inicio/teto/reserva) | razao | Threads disp | desperdicio | mortos | 2o melhor")
  for L = 1, 20 do
    local res = {}
    for st = 0, 2 do for cap = 1, 6 do for rs = 0, 2 do
      if st < cap then
        local r = evalSE(L, {start = st, cap = cap, reserve = rs}, N)
        if r.dead <= 0.10 and r.waste <= 0.25 then
          res[#res+1] = {k = st .. "/" .. cap .. "/" .. rs, r = r, score = math.abs(r.ratio - 1) - (rs == 1 and 0.01 or 0)}
        end
      end
    end end end
    table.sort(res, function(a, b) return a.score < b.score end)
    local b, s = res[1], res[2]
    if b then
      print(table.concat({L, b.k, f(b.r.ratio), f(b.r.avail), pc(b.r.waste), pc(b.r.dead), s and (s.k .. " (" .. f(s.r.ratio) .. ")") or "-"}, " | "))
    else
      print(L .. " | nenhuma config cumpre as restricoes")
    end
  end
end

-- proposed tier table (filled after the optimizer run)
local PROPOSAL = {
  {to = 4, start = 0, cap = 1},
  {to = 6, start = 0, cap = 2},
  {to = 8, start = 0, cap = 3},
  {to = 10, start = 1, cap = 4},
  {to = 12, start = 1, cap = 5},
  {to = 16, start = 2, cap = 5},
  {to = 20, start = 2, cap = 6},
}
local function proposal(L) for _, p in ipairs(PROPOSAL) do if L <= p.to then return {start = p.start, cap = p.cap, reserve = 1} end end end

if MODE == "all" or MODE == "prop" then
  print("\n== I3: tabela proposta por nivel (N grande) ==")
  print("nivel | inicio/teto | Threads disp | gastos | desperdicio | cartas/turno | mortos | razao | carta 5+ por combate")
  for L = 1, 20 do
    local p = proposal(L)
    local r = evalSE(L, p, N * 4)
    print(table.concat({L, p.start .. "/" .. p.cap, f(r.avail), f(r.spent), pc(r.waste), f(r.perTurn), pc(r.dead), f(r.ratio), f(r.big)}, " | "))
  end
end

if MODE == "all" or MODE == "hand" then
  print("\n== I4: mao inicial / limite / compra (tabela proposta), niveis 5 e 13 ==")
  print("nivel | inicial | limite | compra | cartas/turno | mortos | mao media | mao cheia | exiladas/combate | razao")
  for _, L in ipairs({5, 13}) do
    for _, o in ipairs({3, 4, 5}) do
      for _, h in ipairs({5, 7, 10}) do
        local p = proposal(L); p.opening = o; p.handMax = h
        local r = evalSE(L, p, N * 2)
        print(table.concat({L, o, h, 1, f(r.perTurn), pc(r.dead), f(r.hand), pc(r.full), f(r.exiled), f(r.ratio)}, " | "))
      end
    end
  end
end

if MODE == "all" or MODE == "deck" then
  print("\n== I5: tamanho do deck (copias por titulo) - nivel 7, tabela proposta ==")
  print("nivel | copias | deck | cartas/turno | mortos | razao | carta do nivel max. por combate")
  for _, L in ipairs({1, 7, 13}) do
    for _, k in ipairs({1, 2, 3}) do
      local p = proposal(L); p.copies = k
      local cfg = cfgFor(L, p)
      local m = S.runSE("ideal", L, cfg, N * 2)
      local n = 0
      for _, c in ipairs(cfg.titles) do n = n + ((c.lim == "LR") and 1 or k) end
      print(table.concat({L, k, n, f((m.playsA + m.playsB) / m.turns), pc(m.dead / m.turns),
        f(((m.turns / m.combats) * A(L) + EFF * m.sPts / m.combats) / wizTotal(L)), f(m.big / m.combats)}, " | "))
    end
  end
end

if MODE == "all" or MODE == "slots" then
  print("\n== I6: Woven Spell Slots (pontos, descanso curto) - console e fora de combate ==")
  print("nivel | pool proposto (niveis de slot/dia / 3) | razao total vs Wizard | pool com razao ~1")
  for L = 1, 20 do
    local _, lv = wiz(L)
    local titles = idealTitles(L)
    local pool = math.max(1, math.floor(lv / 3 + 0.5))
    local m = S.runSlots("ideal", L, "points", pool, 9, N, "mix", titles, SHIFT(L))
    local ratio = ((m.turns / m.combats) * A(L) + m.sPts / m.combats) / wizTotal(L)
    local best, bd = pool, math.abs(ratio - 1)
    for p = math.max(1, pool - 6), pool + 8 do
      local mm = S.runSlots("ideal", L, "points", p, 9, N, "mix", titles, SHIFT(L))
      local rr = ((mm.turns / mm.combats) * A(L) + mm.sPts / mm.combats) / wizTotal(L)
      if math.abs(rr - 1) < bd then best, bd = p, math.abs(rr - 1) end
    end
    print(table.concat({L, pool, f(ratio), best}, " | "))
  end
end
