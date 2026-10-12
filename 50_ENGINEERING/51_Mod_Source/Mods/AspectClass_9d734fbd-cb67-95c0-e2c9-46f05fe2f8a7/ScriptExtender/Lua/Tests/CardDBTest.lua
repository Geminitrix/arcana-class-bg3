local T = Req("Tests/T.lua")
local U = Req("Server/Core/Util.lua")
local D = Req("Server/Cards/CardDB.lua")

return {
    name = "CardDB",
    cases = {
        ["CostOf le o Level da magia, nao a tabela"] = function()
            local saved = D.io.spellLevel
            D.io.spellLevel = function(id) return id == "NV2" and 2 or nil end
            T.eq(D.CostOf("NV2"), 2, "o Level manda -- era isso que fazia o Olhar Hipnotico dizer 1")
            D.io.spellLevel = function() return nil end
            T.eq(D.CostOf("Projectile_Arcana_Card_Spell_SigilofMalice"), 1, "sem Level, cai na tabela")
            D.io.spellLevel = saved
        end,
        ["CostOf falls back to the default"] = function()
            T.eq(D.CostOf("Unknown_Spell"), 1)
            T.eq(D.CostOf("Shout_Arcana_Card_Spell_DEBUG_Tangler"), 2)
        end,
        ["A card costs its level, with no once-per-rest discount"] = function()
            T.eq(D.CostOf("Projectile_Arcana_Card_Spell_SigilofMalice"), 1)
            T.eq(D.CostOf("Target_Arcana_Card_Spell_EtherealChains"), 2)
            T.eq(D.CostOf("Target_Arcana_Card_Spell_Distortion"), 3)
            T.eq(D.CostOf("Zone_Arcana_Card_Spell_FinalSpark"), 6, "level 6, once per short rest")
            T.eq(D.CostOf("Shout_Arcana_Created_Withdraw"), 1)
            T.eq(D.CostOf("Target_Arcana_Created_MimicDistortion"), 2)
        end,
        ["Container children the deck ignores are skipped"] = function()
            T.eq(D.Skipped("Shout_Arcana_Util_Faceless_Elf_Male"), true)
            T.eq(D.Skipped("Target_Arcana_Util_Faceless_Copy"), true)
            T.eq(D.Skipped("Shout_Arcana_Util_Faceless"), false, "the container itself stays")
            T.eq(D.Skipped("Target_Arcana_Card_Spell_Distortion"), false)
        end,
        ["A cantrip costs 1 Thread: nothing to zero, the status only adds"] = function()
            T.eq(D.CostOf("Target_Arcana_Card_Spell_MaliciousWhispers"), 1)
            T.eq(D.CostOf("Shout_Arcana_Card_Spell_HowlOfTheDead"), 1)
        end,
        ["Every reaction card is a Passive card; only the once-a-round ones are Unique"] = function()
            local n = 0
            for id, r in pairs(D.reactions) do
                n = n + 1
                T.eq(U.Category(id), "Passive", id)
                T.eq(D.Has(id, "Unique"), r.perRound == 1, id .. " Unique iff once a round")
                T.eq(D.reactionByUsed[r.used], id, r.used)
            end
            T.eq(n, 3, "three reaction cards: Gale Deflection, Which One? and Compassion")
            T.eq(D.reactions["Shout_Arcana_Card_Passive_GaleDeflection"].perRound, 3)
        end,
        ["The Resonant (ARC-0002): costs, Unique, the reaction, the conjured cards"] = function()
            T.eq(D.CostOf("Target_Arcana_Card_Spell_Heartstring"), 1, "a cantrip card: 1 Thread")
            T.eq(D.CostOf("Target_Arcana_Card_Spell_Temper"), 1, "level 0: 1 Thread, as every level-0 card (R45)")
            T.eq(D.Has("Shout_Arcana_Card_Spell_SharedHeart", "Unique"), true, "the capstone, once per long rest (R43)")
            local r = D.reactions["Shout_Arcana_Card_Passive_Compassion"]
            T.ok(r ~= nil, "Compassion is a reaction card")
            T.eq(r.ready, "COMPASSION_READY")
            T.eq(r.resource, "ArcanaReactCompassion")
            T.eq(r.used, "COMPASSION_USED_TECH")
            T.eq(r.perRound, 1)
            T.eq(D.statusConjures.ASPECT_AWAKENED_TEMPERANCE.id, "Shout_Arcana_Created_Aspect_TwoCups", "the Aspect card at Tier I")
            T.eq(D.statusConjures.RESONANT_OVERLOAD_FULL.id, "Target_Arcana_Created_EmotionalOverload", "the ultimate while Overloaded (a Created spell is locked unless in hand)")
            T.eq(D.CostOf("Target_Arcana_Created_EmotionalOverload"), 0, "no slot, no Thread (R22)")
            for _, id in ipairs({ "Target_Arcana_Card_Spell_Heartstring", "Target_Arcana_Card_Spell_Temper", "Shout_Arcana_Card_Spell_SharedHeart",
                    "Shout_Arcana_Card_Passive_Compassion", "Shout_Arcana_Created_Aspect_TwoCups", "Target_Arcana_Created_EmotionalOverload" }) do
                T.eq(D.Get(id).aspect, "Resonant", id)
            end
        end,
        ["Has reads keyword flags"] = function()
            T.eq(D.Has("Shout_Arcana_Card_Spell_DEBUG_Fated", "Fated"), true)
            T.eq(D.Has("Shout_Arcana_Card_Spell_DEBUG_Fated", "Unique"), false)
            T.eq(D.Has("Unknown_Spell", "Fated"), false)
        end,
        ["ConjuresOn lists the Distortion tokens"] = function()
            local c = D.ConjuresOn("Target_Arcana_Card_Spell_Distortion")
            T.eq(#c, 2)
            T.eq(c[1].id, "Shout_Arcana_Created_Withdraw")
            T.eq(c[1].lasts, 2)
            T.eq(#D.ConjuresOn("Unknown_Spell"), 0)
        end,
        ["Every conjured card is a Token"] = function()
            for _, card in pairs(D.cards) do
                for _, c in ipairs(card.conjures or {}) do T.eq(U.Category(c.id), "Created", c.id) end
            end
            -- a reaction card conjured by an Awakening (Which One?) stays a Passive card: the reaction system reads it
            for _, c in pairs(D.statusConjures) do T.eq(U.Category(c.id), D.reactions[c.id] and "Passive" or "Created", c.id) end
            -- a container is either a Created card (Mimic) or a deck card whose Choose options
            -- are Created (Hemoplague); the children are always Created
            for container, subs in pairs(D.containers) do
                local cat = U.Category(container)
                T.ok(cat == "Created" or cat == "Card", container .. " category " .. tostring(cat))
                for _, id in ipairs(subs) do
                    T.eq(U.Category(id), "Created", id)
                    T.eq(D.parentOf[id], container, id .. " points back at its container")
                end
            end
        end,
    },
}
