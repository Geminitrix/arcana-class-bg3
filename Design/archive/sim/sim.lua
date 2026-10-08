-- Arcana economy simulation. Loads the mod's real Const.lua / Threads.lua (read-only).
local MOD = "C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data/Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/ScriptExtender/Lua"
local cache = {}
function Req(p) local m = cache[p]; if m == nil then m = dofile(MOD .. "/" .. p) or true; cache[p] = m end; return m end
Ext, Osi = {}, {}
local C = Req("Server/Core/Const.lua")
local Th = Req("Server/Economy/Threads.lua")

-- id, subclass, unlock, spellLevel, currentEssenceCost, action(A/B), limiter(nil/combat/SR/LR)
local CARDS = {
  {"GaleBurst","Unbound",1,1,2,"A"}, {"WindBlast","Unbound",3,2,2,"A"}, {"FlowState","Unbound",3,2,2,"A","combat"},
  {"WindWhispers","Unbound",5,3,1,"B"}, {"StormFists","Unbound",7,4,2,"B"}, {"EvasiveFlow","Unbound",9,5,1,"B"},
  {"Thunderclap","Unbound",11,6,3,"B"},
  {"SigilofMalice","Deceiver",1,1,1,"A"}, {"MaliciousWhispers","Deceiver",1,0,0,"A"}, {"EtherealChains","Deceiver",3,2,2,"A"},
  {"MentalPrison","Deceiver",3,2,3,"A","SR"}, {"HypnoticGaze","Deceiver",3,2,1,"A","SR"}, {"Distortion","Deceiver",5,3,2,"A"},
  {"MirrorImage","Deceiver",7,4,3,"A"}, {"Marionette","Deceiver",9,5,3,"A","LR"}, {"Terrify","Deceiver",9,4,2,"A"},
  {"HostileTakeover","Deceiver",11,5,4,"A","LR"},
  {"Starcall","Starchild",1,1,1,"A"}, {"AstralInfusion","Starchild",1,1,1,"B"}, {"SolarPurge","Starchild",3,2,2,"A","SR"},
  {"LunarAegis","Starchild",3,2,2,"B"}, {"Starbreath","Starchild",5,3,3,"A","LR"}, {"LucentSingularity","Starchild",5,3,2,"A"},
  {"StarRadiance","Starchild",5,3,3,"A"}, {"Wish","Starchild",7,4,3,"B","combat"}, {"MoonGravity","Starchild",7,4,3,"A"},
  {"Equinox","Starchild",9,5,2,"A"}, {"AstralFortitude","Starchild",9,5,3,"A"}, {"SolarFlare","Starchild",11,6,4,"A","LR"},
  {"FinalSpark","Starchild",11,6,3,"A","SR"}, {"StellarGrace","Starchild",12,6,3,"A","LR"},
  {"BloodReaper","Eternal",1,1,1,"B"}, {"Obliterate","Eternal",1,1,2,"A"}, {"Transfusion","Eternal",1,1,1,"A"},
  {"DeathsGrasp","Eternal",3,2,2,"A"}, {"Indestructible","Eternal",3,2,2,"B"}, {"DeathWard","Eternal",5,3,2,"A","SR"},
  {"DeathsAspect","Eternal",9,5,3,"A"}, {"Hemoplague","Eternal",9,5,3,"A"}, {"Hemorrhage","Eternal",11,6,4,"A"},
  {"RealmOfDeath","Eternal",12,6,4,"A"},
}

local COSTRULES = {
  essence = function(c) return math.max(1, c[5]) end,
  level = function(c) return math.max(1, c[4]) end,
  proposal = function(c)
    local k = math.max(1, c[4])
    if c[7] == "SR" or c[7] == "LR" then k = math.max(1, k - 1) end
    return k
  end,
}

-- wizard slot-levels per day incl. Arcane Recovery (5e table, Power Budget sec. 2)
local WIZ = {[1]=3,[2]=5,[3]=10,[4]=13,[5]=19,[6]=23,[7]=27,[8]=31,[9]=41,[10]=47,[11]=53,[12]=54,
             [13]=61,[14]=62,[15]=70,[16]=71,[17]=80,[18]=85,[19]=99,[20]=99}
local E, SEGMENTS = 4, {{1,2},{3},{4}}   -- 2 short rests: after combat 2 and 3

local function pool(sub, lvl, rule)
  local out = {}
  for _, c in ipairs(CARDS) do
    if c[2] == sub and c[3] <= lvl then
      out[#out+1] = {id=c[1], lvl=c[4], cost=COSTRULES[rule](c), act=c[6], lim=c[7], cantrip=(c[4]==0)}
    end
  end
  return out
end

local STAB = {8, 12, 20, 24, 28, 32, 36, 40, 44}
function S_OF(n) if n <= 0 then return 0 end return STAB[math.min(9, n)] end

local function shuffle(t) for i = #t, 2, -1 do local j = math.random(i); t[i], t[j] = t[j], t[i] end end
local function value(card) return card.cantrip and 0.5 or card.lvl end

local function turnsFor(Tmode)
  if type(Tmode) == "number" then return Tmode end
  local r = math.random(); return r < 0.3 and 3 or (r < 0.7 and 4 or 5)
end

-- choose best (A,B) pair playable with th threads; returns a, b, spent
local function choose(hand, th, used, noB)
  local bestA, bestB, bestV, bestS = nil, nil, -1, 0
  local function ok(c) return not (c.lim and used[c.id]) end
  local As, Bs = {false}, {false}
  for i, c in ipairs(hand) do
    if ok(c) then
      if c.act == "A" then As[#As+1] = i elseif c.act == "B" and not noB then Bs[#Bs+1] = i end
    end
  end
  for _, ia in ipairs(As) do for _, ib in ipairs(Bs) do
    local ca, cb = ia and hand[ia], ib and hand[ib]
    local need = 0
    if ca then need = need + (ca.cantrip and 1 or ca.cost) end
    if cb then need = need + (cb.cantrip and 1 or cb.cost) end
    -- a cantrip needs 1 available but refunds it
    local spent = (ca and not ca.cantrip and ca.cost or 0) + (cb and not cb.cantrip and cb.cost or 0)
    if need <= th and (need <= th) then
      local v = (ca and value(ca) or 0) + (cb and value(cb) or 0)
      if v > bestV or (v == bestV and spent < bestS) then bestA, bestB, bestV, bestS = ia, ib, v, spent end
    end
  end end
  return bestA, bestB, bestS, bestV
end

-- one SE combat
local function seCombat(cfg, deckList, T, used, m)
  local draw = {}
  for _, c in ipairs(deckList) do draw[#draw+1] = c end
  shuffle(draw)
  local hand, frayed = {}, {}
  local combat = {turn = 0, binds = cfg.start or 0, leftover = 0}
  local function drawOne()
    if #draw == 0 then
      if #frayed == 0 then return end
      draw, frayed = frayed, {}; shuffle(draw)
    end
    local c = table.remove(draw)
    if #hand >= cfg.handMax then m.exiled = m.exiled + 1 else hand[#hand+1] = c end
  end
  for t = 1, T do
    combat.turn = t
    local th = Th.Compute(combat)
    m.avail = m.avail + (th - math.min(C.THREAD_RESERVE_MAX, combat.leftover))
    for _ = 1, (t == 1 and cfg.opening or cfg.drawPerTurn) do drawOne() end
    if t == 1 and cfg.reweave then
      local cheap = false
      for _, c in ipairs(hand) do if c.cost <= 2 or c.cantrip then cheap = true end end
      if not cheap and #hand > 0 then
        local n = #hand
        for _, c in ipairs(hand) do draw[#draw+1] = c end
        hand = {}; shuffle(draw)
        for _ = 1, n do drawOne() end
        m.reweaves = m.reweaves + 1
      end
    end
    -- economy cards (bonus action): E-draw = cost, draw N; E-gain = cost 0, +N Threads now
    local econSpent, noB = 0, false
    local function playEcon(i)
      local c = table.remove(hand, i)
      frayed[#frayed+1] = c
      noB = true
      m.econ = m.econ + 1
      th = th - c.cost; econSpent = c.cost
      if c.gain then local cap = C.THREAD_CAP; th = math.min(cap, th + c.gain); m.gained = m.gained + c.gain end
      if c.draw then for _ = 1, c.draw do drawOne() end; m.drawn = m.drawn + c.draw end
    end
    do
      local di, gi
      for i, c in ipairs(hand) do
        if c.act == "E" and c.draw and c.cost <= th then di = di or i end
        if c.act == "E" and c.gain then gi = gi or i end
      end
      local _, _, _, vNow = choose(hand, th, used)
      if gi then
        -- gain only if it unlocks a better play this turn
        local _, _, _, vGain = choose(hand, math.min(C.THREAD_CAP, th + hand[gi].gain), used, true)
        if vGain > vNow + 0.01 then playEcon(gi); di = nil end
      end
      if di and not noB and #hand <= (cfg.drawBelow or 3) then
        local c = hand[di]
        local _, _, _, vAfter = choose(hand, th - c.cost, used, true)
        if vAfter >= vNow - 1.01 then playEcon(di) end
      end
    end
    local ia, ib, spent, v = choose(hand, th, used, noB)
    spent = spent
    if ia or ib then
      m.levelPts = m.levelPts + v
      for _, i in ipairs({ia or 0, ib or 0}) do
        local c = hand[i]
        if c and not c.cantrip then m.sPts = m.sPts + S_OF(c.lvl + (cfg.shift or 0)) end
      end
      m.spent = m.spent + spent
      if ia then m.playsA = m.playsA + 1 else m.fallback = m.fallback + 1 end
      if ib then m.playsB = m.playsB + 1 end
      local rm = {}
      for _, i in ipairs({ia or 0, ib or 0}) do if i > 0 then rm[#rm+1] = i end end
      table.sort(rm, function(a, b) return a > b end)
      for _, i in ipairs(rm) do
        local c = table.remove(hand, i)
        if c.lim then used[c.id] = true end
        if c.cost >= 5 and not c.cantrip then m.big = m.big + 1 end
        frayed[#frayed+1] = c
      end
    else
      m.fallback = m.fallback + 1; m.dead = m.dead + 1
    end
    m.spent = m.spent + econSpent
    combat.leftover = th - spent
    if t == T then m.wasteEnd = m.wasteEnd + combat.leftover end
    m.handSum = m.handSum + #hand; m.handN = m.handN + 1
    if #hand >= cfg.handMax then m.handFull = m.handFull + 1 end
  end
  m.turns = m.turns + T
end

local function newM() return {avail=0,spent=0,levelPts=0,sPts=0,playsA=0,playsB=0,fallback=0,dead=0,exiled=0,wasteEnd=0,
  handSum=0,handN=0,handFull=0,big=0,turns=0,reweaves=0,combats=0,econ=0,gained=0,drawn=0} end

local function runSE(sub, lvl, cfg, N)
  C.THREAD_BASE_MAX, C.THREAD_RESERVE_MAX, C.THREAD_CAP = cfg.cap, cfg.reserve, cfg.hardCap or 6
  local titles = cfg.titles or pool(sub, lvl, cfg.rule)
  local deck = cfg.deck
  if not deck then
    deck = {}
    for _, c in ipairs(titles) do for _ = 1, (c.lim == "LR" and 1 or (cfg.copies or 3)) do deck[#deck+1] = c end end
  end
  local m = newM()
  for _ = 1, N do
    local usedDay = {}
    for seg, combats in ipairs(cfg.segments or SEGMENTS) do
      local usedSR = {}
      for _, _ in ipairs(combats) do
        local used = {}
        for k, v in pairs(usedDay) do used[k] = v end
        for k, v in pairs(usedSR) do used[k] = v end
        local before = {}
        seCombat(cfg, deck, turnsFor(cfg.T), used, m)
        for _, c in ipairs(titles) do
          if used[c.id] and c.lim == "LR" then usedDay[c.id] = true end
          if used[c.id] and c.lim == "SR" then usedSR[c.id] = true end
        end
        m.combats = m.combats + 1
      end
    end
  end
  return m, #titles, #deck
end

-- console / out of combat: points pool (M2) or pact slots (M1), all cards available, no deck
local function runSlots(sub, lvl, model, poolSize, pactLevel, N, Tmode, titles, shift)
  titles = titles or pool(sub, lvl, "level")
  shift = shift or 0
  local m = newM()
  for _ = 1, N do
    local usedDay = {}
    for _, combats in ipairs(SEGMENTS) do
      local res = poolSize
      local usedSR = {}
      for ci = 1, #combats do
        local left = #combats - ci + 1
        local budget = (model == "points") and math.floor(res / left + 0.5) or math.ceil(res / left)
        local used = {}
        for k in pairs(usedDay) do used[k] = true end
        for k in pairs(usedSR) do used[k] = true end
        local T = turnsFor(Tmode)
        m.turns = m.turns + T
        for t = 1, T do
          for _, act in ipairs({"A", "B"}) do
            local best, bv = nil, 0
            for _, c in ipairs(titles) do
              if c.act == act and not (c.lim and used[c.id]) and not c.cantrip then
                local price = (model == "points") and c.lvl or 1
                local okLevel = (model == "points") or c.lvl <= pactLevel
                if okLevel and price <= budget and c.lvl > bv then best, bv = c, c.lvl end
              end
            end
            if best then
              local price = (model == "points") and best.lvl or 1
              budget, res = budget - price, res - price
              m.levelPts = m.levelPts + best.lvl
              local castLvl = (model == "pactUp") and pactLevel or best.lvl
              m.sPts = m.sPts + S_OF(castLvl + shift)
              if act == "A" then m.playsA = m.playsA + 1 else m.playsB = m.playsB + 1 end
              m.spent = m.spent + price
              if best.lim then used[best.id] = true; if best.lim == "LR" then usedDay[best.id] = true end; if best.lim == "SR" then usedSR[best.id] = true end end
            end
          end
        end
        m.combats = m.combats + 1
      end
    end
  end
  return m
end

local function setDay(e, segs) E, SEGMENTS = e, segs end

return {setDay = setDay, runSE = runSE, runSlots = runSlots, pool = pool, WIZ = WIZ, E = E, CARDS = CARDS, COSTRULES = COSTRULES, C = C}
