---
id: ARC-0031
title: "Windborn localization: the 14 languages catch up with the English"
type: chore
epic: EPIC_Rework_Subclasses
subclass: unbound
status: backlog
owner: Lore Writer
implementation: pending
priority: should
value: 3
effort: 4
inputs: [33.02/LOCALIZATION_WORKFLOW.md, 33.03/MOD_TERMINOLOGY.md, 33.03/VANILLA_TERMS_GLOSSARY.md, 32.01/Unbound.md, 05.02/Unbound.md, game loca English/english.xml]
outputs: [game loca (the 14 language files), 33.03/MOD_TERMINOLOGY.md]
blocked_by: []
sprint:
created: 2026-11-16
---

# ARC-0031 · Windborn localization: the 14 languages catch up with the English

**Goal:** translate every Windborn text the game shows into the 14 languages the mod ships besides English, and bring
the outdated ones up to the English version.
**Intent:** a player in any of the 15 languages reads the Windborn in their own language instead of English fallbacks.

## Acceptance criteria

- [ ] In each of the 14 languages, every Windborn text the game references (a handle used by a Windborn Stats entry or
      LSX node) exists at the English `version`: diff by `contentuid` + `version` shows 0 missing and 0 outdated.
      Measured 2026-11-16 on the 51 copy: 161 Windborn texts; in every language 123 missing and 22 outdated.
- [ ] Orphan handles (in `english.xml` but used by nothing) are not translated (`33.02` "Confirming a string is real").
- [ ] Terms follow `33.03`: vanilla terms with Larian's own translation (VANILLA_TERMS_GLOSSARY), mod terms as in
      MOD_TERMINOLOGY; the new Windborn terms (Windswept, Aeolus' Bag, Tailwind / Headwind, Zephyr, Tethered, Earthly
      Ties, the Aspect tiers) added there for every language.
- [ ] Placeholders `[n]` and LSTag `Type=` / `Tooltip=` are identical to the English for each `contentuid`; declining
      languages follow the measure-word rule (`33.02`, "Declining languages").
- [ ] Files keep the vanilla format (UTF-8 with BOM, CRLF, `encoding="utf-8"`); each file backed up as
      `<file>.xml.bak-YYYYMMDD` first; written under a `[fechado] ARC-0031` message (OR-11).
- [ ] `sync_data`, then `validate.pl` 0 errors; the Owner spot-checks one language in game (`reloadLoca` or a restart).

## Notes

- **Timing:** the English polish of every subclass waits for the end of the rework (Owner, 2026-10-12). Texts it
  changes will need this pass again for those handles; translating the Windborn now gives the other languages the
  current texts until then.
- The subclass name is settled (ARC-0021: Windborn), so it does not block.

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15) — n/a, no feature changes
- [ ] Narrative gate (`32.04`) — terms checked against `33.03` and the official Larian translations
- [ ] DoD (`00.03`)

## Log

- 2026-11-16 — created at the Owner's request after ARC-0026 closed (the Windborn is done except its localization).
