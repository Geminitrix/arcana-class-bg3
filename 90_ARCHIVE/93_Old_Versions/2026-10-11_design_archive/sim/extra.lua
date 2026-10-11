package.path = arg[0]:gsub("extra%.lua$", "?.lua") .. ";" .. package.path
local S = require("sim")
math.randomseed(4242)
local N = tonumber(arg[1]) or 600
local EFF = 0.765
local function A(L) return L <= 4 and 4 or L <= 8 and 8 or L <= 12 and 11 or 12 end
local function ML(L) return math.min(6, math.ceil(L / 2)) end
local function SHIFT(L) return math.max(0, math.ceil(L / 2) - 6) end
local WT = {[9]=108,[10]=115,[11]=123,[12]=123,[5]=64,[13]=136,[17]=157}
local function titles(L)
  local t = {}
  for i = 1, 2 do t[#t+1] = {id = "k" .. i, lvl = 0, cost = 1, act = "A", cantrip = true} end
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
local function run(L, o)
  local cfg = {cap = 5, reserve = 1, hardCap = 6, opening = 5, handMax = 10, drawPerTurn = 1, T = "mix", reweave = true, start = 0, shift = SHIFT(L), titles = titles(L)}
  for k, v in pairs(o) do cfg[k] = v end
  local m = S.runSE("x", L, cfg, N)
  local cb = m.combats
  return m, ((m.turns / cb) * A(L) + EFF * m.sPts / cb)
end
local function f(x) return string.format("%.2f", x) end
local function pc(x) return string.format("%.0f%%", 100 * x) end

print("== X1: ajuste niveis 9-12 ==")
print("nivel | inicio/teto | razao | desperdicio")
for _, L in ipairs({9, 10, 11, 12}) do
  for _, c in ipairs({{1,4},{1,5},{2,4},{2,5}}) do
    local m, tot = run(L, {start = c[1], cap = c[2]})
    print(table.concat({L, c[1] .. "/" .. c[2], f(tot / WT[L]), pc(1 - m.spent / m.avail)}, " | "))
  end
end

print("\n== X2: reserva (Spare Thread) na tabela proposta ==")
print("nivel | reserva | Threads disp | desperdicio | razao")
for _, c in ipairs({{5,0,2},{9,2,4},{13,2,5},{17,2,6}}) do
  for _, r in ipairs({0, 1, 2}) do
    local m, tot = run(c[1], {start = c[2], cap = c[3], reserve = r, hardCap = (c[3] >= 6 and 7 or 6)})
    print(table.concat({c[1], r, f(m.avail / m.combats), pc(1 - m.spent / m.avail), f(tot / WT[c[1]])}, " | "))
  end
end

print("\n== X3: combates longos (T fixo) - mao inicial 5, compra 1, nivel 13 (2/5) ==")
print("T | cartas/turno | turnos mortos | mao media | desperdicio")
for _, T in ipairs({3, 5, 7, 9}) do
  for _, d in ipairs({1, 2}) do
    local m = run(13, {start = 2, cap = 5, T = T, drawPerTurn = d})
    print(table.concat({T .. " (compra " .. d .. ")", f((m.playsA + m.playsB) / m.turns), pc(m.dead / m.turns), f(m.handSum / m.handN), pc(1 - m.spent / m.avail)}, " | "))
  end
end

print("\n== X4: consistencia - chance de ter 1 carta especifica na mao inicial de 5 ==")
local function comb(n, k) if k < 0 or k > n then return 0 end local r = 1 for i = 1, k do r = r * (n - k + i) / i end return r end
print("deck | 1 copia | 2 copias | 3 copias | ate o turno 4 (8 cartas vistas), 3 copias")
for _, D in ipairs({10, 15, 20, 25, 30, 40}) do
  local row = {D}
  for k = 1, 3 do row[#row+1] = pc(1 - comb(D - k, 5) / comb(D, 5)) end
  row[#row+1] = pc(1 - comb(D - 3, 8) / comb(D, 8))
  print(table.concat(row, " | "))
end
