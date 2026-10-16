local C = Req("Server/Core/Const.lua")
local U = Req("Server/Core/Util.lua")

local L = { maxRules = {} }

-- level: the character's (ARC-0017 R55: some cards hold more copies as the character levels up)
function L.MaxCopies(id, level)
    for _, rule in ipairs(L.maxRules) do
        local m = rule(id, level)
        if m then return m end
    end
    return C.MAX_COPIES
end

function L.Size(list)
    local n = 0
    for _, count in pairs(list) do n = n + count end
    return n
end

-- What the next fight would actually shuffle: the minimum deck size is about that, not about cards
-- waiting for a weapon that is not equipped.
function L.AvailableSize(st)
    local n = 0
    for id, count in pairs(st.list) do
        if st.available == nil or st.available[id] then n = n + count end
    end
    return n
end

function L.Default(ids, level)
    local list = {}
    for _, id in ipairs(ids) do list[id] = L.MaxCopies(id, level) end
    return list
end

-- The list remembers every card the character has ever had, with its count; `available` is what
-- the spellbook holds right now. They differ once a card can leave: a weapon action goes away with
-- its weapon, and its count has to be waiting there when the weapon comes back.
-- A card whose maximum grows with the level follows it while the player has not lowered it (ARC-0017 R55):
-- `listMax` remembers the maximum each count was last set to.
function L.Refresh(st, ids, level)
    st.available = {}
    st.listMax = st.listMax or {}
    for _, id in ipairs(ids) do
        local max = L.MaxCopies(id, level)
        if st.list[id] == nil or (st.listMax[id] and st.list[id] == st.listMax[id] and max > st.list[id]) then
            st.list[id] = max
        end
        st.listMax[id] = max
        st.available[id] = true
    end
end

function L.MinDeck(level)
    level = level or C.DEFAULT_LEVEL
    for _, band in ipairs(C.MIN_DECK_BANDS) do
        if level <= band.maxLevel then return band.size end
    end
    return C.MIN_DECK_BANDS[#C.MIN_DECK_BANDS].size
end

function L.SetCount(st, poolIds, id, n, level)
    if st.combat then return false, "in combat" end
    if not U.IndexOf(poolIds, id) then return false, "not in pool" end
    n = math.max(0, math.min(L.MaxCopies(id, level), math.floor(n)))
    local minimum = L.MinDeck(level)
    local size = L.AvailableSize(st) - (st.list[id] or 0) + n
    if size < minimum then return false, "deck would drop below " .. minimum end
    st.list[id] = n
    return true, n
end

return L
