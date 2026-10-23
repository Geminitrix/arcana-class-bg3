local T = Req("Tests/T.lua")
local S = Req("Server/Core/State.lua")
local E = Req("Server/Core/Events.lua")
local P = Req("Server/Core/Piles.lua")
local F = Req("Server/Core/Flow.lua")
local R = Req("Server/Economy/Reactions.lua")

local CHAR = "char-reactions"
-- Gale Deflection left the reaction cards on 2026-10-23 (WB63: one use a turn, a normal Unique card). No
-- reaction card goes three times a round any more, but the stack rules stay under test: this fixture puts the old
-- three-a-round entry back for the length of the suite.
local GALE = "Shout_Arcana_Card_Passive_GaleDeflection"
local D = Req("Server/Cards/CardDB.lua")
local FIXTURE = {
    ready = "GALE_DEFLECTION_READY", resource = "ArcanaReactGaleDeflection",
    used = "GALE_DEFLECTION_USED_TECH", perRound = 3,
}
local world, savedIo, savedReaction, savedUsed

local function inCombat(list)
    local st = S.New()
    st.list = list or {}
    st.combat = { id = "c1", turn = 1, binds = 0, leftover = 0, startBonus = 0, level = 7, counters = {} }
    st.hand, st.frayed, st.unraveled = {}, {}, {}
    return st
end

local function hold(st, id, n)
    for _ = 1, n do P.AddToHand(CHAR, st, id) end
end

-- what the interrupt does: the engine takes the charge, then the Properties apply the status
local function react(st, id)
    local r = Req("Server/Cards/CardDB.lua").reactions[id]
    world.res[r.resource] = world.res[r.resource] - 1
    F.StatusApplied(CHAR, st, r.used)
end

return {
    name = "Reactions",
    before = function()
        savedReaction, savedUsed = D.reactions[GALE], D.reactionByUsed[FIXTURE.used]
        D.reactions[GALE], D.reactionByUsed[FIXTURE.used] = FIXTURE, GALE
        savedIo = R.io
        world = { status = {}, res = {}, sets = 0 }
        R.io = {
            hasStatus = function(_, s) return world.status[s] == true end,
            apply = function(_, s) world.status[s] = true end,
            remove = function(_, s) world.status[s] = nil end,
            get = function(_, r) return world.res[r] or 0 end,
            set = function(_, r, v) world.res[r] = v; world.sets = world.sets + 1 end,
        }
    end,
    after = function()
        R.io = savedIo
        D.reactions[GALE], D.reactionByUsed[FIXTURE.used] = savedReaction, savedUsed
    end,
    cases = {
        ["Each Gale Deflection in hand is one charge, and the reaction is ready"] = function()
            local st = inCombat({ [GALE] = 3 })
            hold(st, GALE, 2)
            T.eq(world.status.GALE_DEFLECTION_READY, true, "ready")
            T.eq(world.res.ArcanaReactGaleDeflection, 2, "two copies, two charges")
        end,
        ["A use discards one copy and leaves the charge to the engine"] = function()
            local st = inCombat({ [GALE] = 3 })
            hold(st, GALE, 3)
            local sets = world.sets
            react(st, GALE)
            T.eq(#st.hand, 2, "one copy spent")
            T.eq(st.frayed[1], GALE, "to the discard")
            T.eq(world.res.ArcanaReactGaleDeflection, 2, "the engine's own subtraction, not a second one")
            T.eq(world.sets, sets, "no write after a use")
            T.eq(world.status.GALE_DEFLECTION_READY, true, "still ready")
        end,
        ["Gale Deflection can go three times in one round, and no more"] = function()
            local st = inCombat({ [GALE] = 3 })
            hold(st, GALE, 4)
            T.eq(world.res.ArcanaReactGaleDeflection, 3, "capped at the round's limit")
            react(st, GALE); react(st, GALE); react(st, GALE)
            T.eq(world.res.ArcanaReactGaleDeflection, 0, "limit reached")
            T.eq(#st.hand, 1, "a fourth copy waits")
            P.AddToHand(CHAR, st, "Some_Other_Card")
            T.eq(world.res.ArcanaReactGaleDeflection, 0, "a resync does not hand it back")
            E.Emit("TurnStarted", { char = CHAR, state = st, turn = 2 })
            T.eq(world.res.ArcanaReactGaleDeflection, 1, "the owner's turn resets the limit")
        end,
        ["The last copy used switches the reaction off"] = function()
            local st = inCombat({ [GALE] = 3 })
            hold(st, GALE, 1)
            react(st, GALE)
            T.eq(world.status.GALE_DEFLECTION_READY, nil, "not ready without a card")
        end,
        ["A character without the card is left alone"] = function()
            local st = inCombat({})
            P.AddToHand(CHAR, st, "Some_Other_Card")
            T.eq(world.sets, 0, "no resource written")
            T.eq(next(world.status), nil, "no status touched")
        end,
        ["The fight ending clears the charges"] = function()
            local st = inCombat({ [GALE] = 3 })
            hold(st, GALE, 2)
            F.EndCombat(CHAR, st)
            T.eq(world.status.GALE_DEFLECTION_READY, nil, "off")
            T.eq(world.res.ArcanaReactGaleDeflection, 0, "no charge left over")
        end,
    },
}
