package.path = arg[0]:gsub("ideal2%.lua$", "?.lua") .. ";" .. package.path
local S = require("sim")
math.randomseed(3092026)
local MODE = arg[1] or "all"
local N = tonumber(arg[2]) or 300

local E = 3
local SEGS = {{1}, {2}, {3}}          -- 3 fights, 2 short rests in between
S.setDay(E, SEGS)
local EFF = 0.765
local TAVG = 4.0
local function A(L) return L <= 4 and 4 or L <= 8 and 8 or L <= 12 and 11 or 12 end
local function ML(L) return math.min(6, math.ceil(L / 2)) end
local function SHIFT(L) return math.max(0, math.ceil(L / 2) - 6) end
local SLOTS = {
  {2},{3},{4,2},{4,3},{4,3,2},{4,3,3},{4,3,3,1},{4,3,3,2},{4,3,3,3,1},{4,3,3,3,2},
  {4,3,3,3,2,1},{4,3,3,3,2,1},{4,3,3,3,2,1,1},{4,3,3,3,2,1,1},{4,3,3,3,2,1,1,1},{4,3,3,3,2,1,1,1},
  {4,3,3,3,2,1,1,1,1},{4,3,3,3,3,1,1,1,1},{4,3,3,3,3,2,1,1,1},{4,3,3,3,3,2,2,1,1},
}
local function wizPts(L)
  local pts = 0
  for n, k in ipairs(SLOTS[L]) do pts = pts + k * S_OF(n) end
  return pts + S_OF(math.min(5, math.ceil(L / 2)))
end
local function wizTotal(L) return TAVG * A(L) + wizPts(L) / E end

local function titles(L)
  local t = {}
  for i = 1, 2 do t[#t+1] = {id = "k" .. i, lvl = 0, cost = 1, act = "A", cantrip = true} end
  t[#t+1] = {id = "spark", lvl = 0, cost = 0, act = "E", gain = 1}
  t[#t+1] = {id = "glimpse", lvl = 0, cost = 1, act = "E", draw = 2}
  if L >= 9 then
    t[#t+1] = {id = "surge", lvl = 0, cost = 0, act = "E", gain = 2}
    t[#t+1] = {id = "insight", lvl = 0, cost = 1, act = "E", draw = 3}
  end
  local i = 0
  local function add(lvl)
    i = i + 1
    local lim = (i % 5 == 0) and "SR" or nil
    t[#t+1] = {id = "c" .. i, lvl = lvl, cost = math.max(1, lvl - (lim and 1 or 0)), act = (i % 3 == 0) and "B" or "A", lim = lim}
  end
  for _ = 1, 3 do add(1) end
  for l = 2, L do add(ML(l)) end
  return t
end

-- the player builds the strongest legal deck of size D
local CURVE = 0.3
local function buildDeck(L, D, econShare, firstTurn)
  local t = titles(L)
  if CURVE > 0 then
    local econ, cheap, rest = {}, {}, {}
    for _, c in ipairs(t) do
      if c.act == "E" then econ[#econ+1] = c
      elseif c.cantrip or c.cost <= (firstTurn or 1) then cheap[#cheap+1] = c
      else rest[#rest+1] = c end
    end
    table.sort(econ, function(a, b) return (a.gain or a.draw) > (b.gain or b.draw) end)
    table.sort(cheap, function(a, b) return a.lvl > b.lvl end)
    table.sort(rest, function(a, b) return a.lvl > b.lvl end)
    local deck, count = {}, {}
    local function put(c) if #deck < D and (count[c] or 0) < 3 then deck[#deck+1] = c; count[c] = (count[c] or 0) + 1; return true end end
    local wantEcon = math.floor(D * econShare + 0.5)
    for _, c in ipairs(econ) do for _ = 1, 3 do if wantEcon > 0 and put(c) then wantEcon = wantEcon - 1 end end end
    local wantCheap = math.floor(D * CURVE + 0.5)
    for _, c in ipairs(cheap) do for _ = 1, 3 do if wantCheap > 0 and put(c) then wantCheap = wantCheap - 1 end end end
    for _, list in ipairs({rest, cheap}) do for _, c in ipairs(list) do for _ = 1, 3 do put(c) end end end
    return deck, t, #deck >= D
  end
  local econ, spells, cantrips = {}, {}, {}
  for _, c in ipairs(t) do
    if c.act == "E" then econ[#econ+1] = c elseif c.cantrip then cantrips[#cantrips+1] = c else spells[#spells+1] = c end
  end
  table.sort(econ, function(a, b) return (a.gain or a.draw) > (b.gain or b.draw) end)
  table.sort(spells, function(a, b) return a.lvl > b.lvl end)
  local deck = {}
  local wantEcon = math.floor(D * econShare + 0.5)
  for _, c in ipairs(econ) do for _ = 1, 3 do if wantEcon > 0 then deck[#deck+1] = c; wantEcon = wantEcon - 1 end end end
  for _, list in ipairs({spells, cantrips}) do
    for _, c in ipairs(list) do for _ = 1, 3 do if #deck < D then deck[#deck+1] = c end end end
  end
  return deck, t, #deck >= D
end

local function cfgBase(L, o)
  local cfg = {cap = 5, reserve = 2, hardCap = 6, opening = 5, handMax = 10, drawPerTurn = 1, T = "mix",
    reweave = true, start = 0, shift = SHIFT(L), segments = SEGS, D = 15, econ = 0.2, drawBelow = 3}
  for k, v in pairs(o or {}) do cfg[k] = v end
  local deck, t, legal = buildDeck(L, cfg.D, cfg.econ, math.min(cfg.cap, 1 + cfg.start))
  cfg.deck, cfg.titles, cfg.legal = deck, t, legal
  return cfg
end

local function ev(L, o, n)
  local cfg = cfgBase(L, o)
  local m = S.runSE("ideal", L, cfg, n or N)
  local cb = m.combats
  local total = (m.turns / cb) * A(L) + EFF * m.sPts / cb
  return {ratio = total / wizTotal(L), avail = m.avail / cb, gained = m.gained / cb, spent = m.spent / cb,
    waste = 1 - m.spent / (m.avail + m.gained), dead = m.dead / m.turns, perTurn = (m.playsA + m.playsB) / m.turns,
    hand = m.handSum / m.handN, full = m.handFull / m.handN, exiled = m.exiled / cb, econ = m.econ / cb,
    drawn = m.drawn / cb, deck = #cfg.deck, legal = cfg.legal}
end
local function f(x) return string.format("%.2f", x) end
local function pc(x) return string.format("%.0f%%", 100 * x) end

-- final proposal (edit after J1)
local PROP = {
  {to = 4, start = 0, cap = 1},
  {to = 6, start = 0, cap = 3},
  {to = 8, start = 1, cap = 4},
  {to = 10, start = 2, cap = 5},
  {to = 20, start = 3, cap = 6},
}
local function prop(L) for _, p in ipairs(PROP) do if L <= p.to then return {start = p.start, cap = p.cap} end end end

if MODE == "opt" then
  print("== J1: otimizador (E=3, reserva 2, deck 15 com 20% de cartas de economia) ==")
  print("nivel | alvo Wizard/combate | melhor inicio/teto | razao | ganho por turno 1..5 | desperdicio | 2o | 3o")
  for L = 1, 20 do
    local res = {}
    for _, hc in ipairs({6, 8}) do
    for st = 0, 3 do for cap = 1, 8 do if st < cap and cap <= hc then
      local r = ev(L, {start = st, cap = cap, hardCap = hc}, N)
      local pen = (r.dead > 0.10 and 1 or 0) + (r.waste > 0.30 and 0.5 or 0) + (hc > 6 and 0.03 or 0)
      res[#res+1] = {st = st, cap = cap, hc = hc, r = r, s = math.abs(r.ratio - 1) + pen}
    end end end
    end
    table.sort(res, function(a, b) return a.s < b.s end)
    local function k(x) local s = {} for t = 1, 5 do s[#s+1] = math.min(x.cap, t + x.st) end return table.concat(s, ",") .. " (teto " .. x.hc .. ")" end
    local b = res[1]
    print(table.concat({L, f(wizTotal(L)), b.st .. "/" .. b.cap, f(b.r.ratio), k(b), pc(b.r.waste),
      res[2] and (k(res[2]) .. " " .. f(res[2].r.ratio)) or "-", res[3] and (k(res[3]) .. " " .. f(res[3].r.ratio)) or "-"}, " | "))
  end
end

if MODE == "prop" then
  print("== J2: tabela proposta (E=3, reserva 2) ==")
  print("nivel | ganho por turno | reserva | razao | Threads recebidas | +economia | desperdicio | cartas/turno | mortos | mao media")
  for L = 1, 20 do
    for _, r in ipairs({1, 2}) do
      local p = prop(L); p.reserve = r
      local x = ev(L, p, N)
      local s = {} for t = 1, 5 do s[#s+1] = math.min(p.cap, t + p.start) end
      print(table.concat({L, table.concat(s, ","), r, f(x.ratio), f(x.avail), f(x.gained), pc(x.waste), f(x.perTurn), pc(x.dead), f(x.hand)}, " | "))
    end
  end
end

if MODE == "hand" then
  print("== J3: mao inicial / compra / limite, com cartas de economia 20% e 35% (nivel 7 e 13) ==")
  print("nivel | economia | inicial | compra | limite | razao | cartas/turno | mortos | mao media | mao cheia | exiladas/combate | compradas por efeito/combate")
  for _, L in ipairs({7, 13}) do
    for _, e in ipairs({0.2, 0.35}) do
      for _, o in ipairs({3, 4, 5}) do
        for _, d in ipairs({1}) do
          for _, h in ipairs({5, 7, 10}) do
            local p = prop(L); p.econ = e; p.opening = o; p.drawPerTurn = d; p.handMax = h
            local x = ev(L, p, N)
            print(table.concat({L, pc(e), o, d, h, f(x.ratio), f(x.perTurn), pc(x.dead), f(x.hand), pc(x.full), f(x.exiled), f(x.drawn)}, " | "))
          end
        end
      end
    end
  end
end

if MODE == "deck" then
  print("== J4: tamanho do deck (o jogador poe as melhores cartas) ==")
  print("nivel | deck | legal? | razao | cartas/turno | mortos | mao media")
  for _, L in ipairs({1, 3, 5, 9, 13}) do
    for _, D in ipairs({6, 8, 10, 12, 15, 20, 25}) do
      local p = prop(L); p.D = D
      local x = ev(L, p, N)
      print(table.concat({L, D, x.legal and "sim" or ("nao (" .. x.deck .. ")"), f(x.ratio), f(x.perTurn), pc(x.dead), f(x.hand)}, " | "))
    end
  end
end

if MODE == "slots" then
  print("== J5: ArcanaSpellSlot estilo Warlock (recarga no descanso curto) ==")
  local W5E = {{1,1},{2,1},{2,2},{2,2},{2,3},{2,3},{2,4},{2,4},{2,5},{2,5},{3,5},{3,5},{3,5},{3,5},{3,5},{3,5},{4,5},{4,5},{4,5},{4,5}}
  local FILES = {{1,1},{2,1},{2,2},{2,2},{2,3},{2,3},{2,4},{2,4},{3,5},{3,5},{3,6},{3,6},{3,7},{3,7},{3,8},{3,8},{3,9},{3,9},{4,9},{5,9}}
  print("nivel | Warlock 5e | razao (nivel da carta) | razao (conjura no nivel do slot) | arquivos do mod | razao (nivel da carta) | razao (nivel do slot)")
  for L = 1, 20 do
    local t = titles(L)
    local sp = {}
    for _, c in ipairs(t) do if c.act ~= "E" then sp[#sp+1] = c end end
    local out = {L}
    for _, tab in ipairs({W5E, FILES}) do
      local k, lv = tab[L][1], tab[L][2]
      out[#out+1] = k .. " x nivel " .. lv
      for _, model in ipairs({"pact", "pactUp"}) do
        local m = S.runSlots("ideal", L, model, k, lv, N, "mix", sp, SHIFT(L))
        out[#out+1] = f(((m.turns / m.combats) * A(L) + m.sPts / m.combats) / wizTotal(L))
      end
    end
    print(table.concat(out, " | "))
  end
end
