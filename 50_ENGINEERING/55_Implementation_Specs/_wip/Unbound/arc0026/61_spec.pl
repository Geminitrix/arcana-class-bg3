#!/usr/bin/perl
# ARC-0026 — rewrites SPEC_ARC-0026.md the Kingmaker way (SPEC_ARC-0008): one stage per level, each with its item index
# (read from TOOLKIT_ARC-0026_L<nn>.md), how each rule is built (the Notes of the guide) and its tests (GUIDE_ARC-0026.json).
# Run after 60_toolkit_guides.pl and 62_test_guide.pl. The patch-build text of 2026-10-17 is kept at the end as history.
#   perl 61_spec.pl
use strict; use warnings; use utf8; use JSON::PP;
my $ROOT = 'C:/Lumox Studios/Arcana Class';
my $OUTD = "$ROOT/50_ENGINEERING/55_Implementation_Specs";
my $SPEC = "$OUTD/SPEC_ARC-0026.md";
sub slurp { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; utf8::decode($s); $s =~ s/\r\n/\n/g; $s }
my $old = slurp($SPEC);
my ($hist) = $old =~ /\n(## Global constraints\n.*)\z/s or die "old spec: no body\n";
$hist = $1 if $old =~ /\n## History — the patch build \(2026-10-17, superseded\)\n\n(.*)\z/s;   # rerun: keep the first history only
my $guide = decode_json(do { open my $h, '<:raw', "$ROOT/60_QA_AND_TESTING/61_Test_Plan/61.02_Test_Cases/Unbound/GUIDE_ARC-0026.json" or die; local $/; <$h> });
my %tests = map { ($_->{level} // 0) => $_ } @{$guide->{sessions}};
my %HEAD; for (split /\n/, slurp("$ROOT/20_GAME_DESIGN/21_GDD_Arcana_Class/21.04_Subclasses/Unbound/DESIGN.md")) { $HEAD{$1} = [$2, $3] if /^\| (\d+) \| (.+?) \| "(.+?)" \|/ }

my $o = <<'EOT';
---
id: SPEC_ARC-0026
ticket: ARC-0026
status: draft
implementation: owner
author: Mod Engineer
updated: __TODAY__
---

# SPEC_ARC-0026 · The Windborn — implementation plan

> Technical source for building the Windborn (internal name *Unbound*) level by level. The Owner enters it **by hand in
> the BG3 Toolkit** from the twelve typing guides **`TOOLKIT_ARC-0026_L01.md` … `_L12.md`** (the typing view of this
> spec, ADR-0008). **One level at a time**: type it, compile, tell Claude, play its tests, then the next level.
> Claude writes no game file for this build (2026-10-17) except the PC deck (`CardDB.lua`) and the generated families,
> after each level is saved.

**Intent:** the game plays the Windborn as `21.04/Unbound/DESIGN.md` describes it (WB0–WB50), in both editions.

**Design:** `21.04/Unbound/DESIGN.md` · **Decisions:** `21.04/Unbound/DECISIONS.md` (WB0–WB50) · **Numbers:** `25`
(`*_Unbound_*.yaml`, blocks `pending_build`) · **Texts:** `32.01/Unbound.md`, `_wip/Unbound/arc0026/00_texts.md`
(approved) · **Tests:** `61.02/Unbound/GUIDE_ARC-0026.json` (the Arcana Test Guides page, tab Windborn) ·
**Balance:** `22.05/Unbound.md`.

## Global constraints

- Everything in Stats / LSX / Osiris; the Script Extender only in the PC deck (`CardDB.lua`, written by Claude after
  each level). Internal ids keep their names (ADR-0002): `Unbound`, `Fool`, `TwinkleToes`, `Weightless`,
  `FlowingStrikeZephyr`. Fixed prefixes: `<Type>_Arcana_Card_Spell_*`, `<Type>_Arcana_Created_*`, `Arcana_Passive_*`,
  `ARCANA_` statuses, Osiris `ARCANA_` / `DB_ARCANA_` / `PROC_ARCANA_`.
- Every Windborn passive, card and status keeps the armour rule (`not WearingArmor() and not HasShieldEquipped()`).
  A card carries `not HasPassive('ARCANA_IS_CARD', context.Source)` in `TargetConditions`. Visible statuses carry
  `ForceOverhead`, visible passives `Highlighted`. Every player-cast spell has a Spell Animation and a `CastTextEvent`
  (ARC-0026 probe P1; `82_Automation/stats/check_castable.pl`).
- Numbers come only from `25`; each guide lists them under their block with their origin and its `derived_from`.
- **Retired, not deleted** (OR-10): an entry that leaves the Windborn stays in the mod with nothing pointing to it; each
  guide lists them under *RETIRE*.
- **The guides are generated**, never edited by hand: `_wip/Unbound/arc0026/60_toolkit_guides.pl` reads the build patches
  (`10_core`, `20_bag_awakening`, `30_ranks_cards`, `40_capstone_names`: the technical source of every entry), the goal
  `22_goal_fool.txt`, the game as it was before ARC-0026 (commit `09f30e0`) and vanilla, and writes the twelve guides in
  the template's rules (Toolkit field order from the Toolkit's own `StatObjectDefinitions.sod`, parents resolved,
  look fields copied from the parent). Change a patch or a `25` file → rerun it, then
  `61_spec.pl` (this file) and `62_test_guide.pl` (the tests).
- Upcast variants: the generator keeps fields edited by hand, so the variants whose fields change are typed (Gale
  Burst `_3`–`_6`, Flow State `_3`–`_6`, Storm Fists `_5`–`_6`); the rest is generated after each level.
- Level 1 is typed **as new** (Owner, 2026-10-17): a first version of part of it was put in the game by patch on
  2026-10-17 (the old stage 2); step 00 of the level-1 guide clears it.

## Stages — one per level

| Stage | Level | What arrives (DESIGN §9.1) | Typing guide | Tests |
|---|---|---|---|---|
EOT
my $today = do { my @t = localtime; sprintf '%04d-%02d-%02d', $t[5] + 1900, $t[4] + 1, $t[3] }; $o =~ s/__TODAY__/$today/;
for my $lv (1 .. 12) { my $s = $tests{$lv}; $o .= "| **$lv** | $lv | $HEAD{$lv}[0] | `TOOLKIT_ARC-0026_" . sprintf('L%02d', $lv) . ".md` | $s->{id} (" . scalar(@{$s->{tests}}) . ") |\n" }
$o .= "| 13 | — | Close: `25` (`pending_build` → `values`), `05.02`, catalogs, docs; delete the goal `ARCANA_Probe_ARC0026`; update the FOOL entry of `gen_awakening_progress.pl` (still Wanderlust) | — | ANY (2) |\n\n---\n";

for my $lv (1 .. 12) {
    my $LL = sprintf 'L%02d', $lv; my $g = slurp("$OUTD/TOOLKIT_ARC-0026_$LL.md");
    my ($idx) = $g =~ /\n(\| # \| Area \|.*?)\n\n/s or die "$LL: no order table\n";
    $idx =~ s/ \| ☐ \|$/ |/mg; $idx =~ s/^\| # \| Area \| File \| Entry \| Action \| Needs \| ☐ \|$/| # | Area | File | Entry | Action | Needs |/m; $idx =~ s/^\|---\|---\|---\|---\|---\|---\|---\|$/|---|---|---|---|---|---|/m;
    my %why; my @why; while ($g =~ /^Notes — `([^`]+)`[^\n]*\n((?:- [^\n]*\n(?:  [^\n]*\n)*)+)/mg) { my ($n, $b) = ($1, $2);
        for my $l (split /\n(?=- )/, $b) { $l =~ s/\n\s+/ /g; $l =~ s/\n$//; next if $l =~ /^- (\*\*(Copy from|From the parent|Ours|Clears)|`Using` stays|The Icon is|A variant:|MemoryCost)/;
            $l =~ s/^- //; next if $why{$l}++; push @why, "- `$n`: $l" } }
    my $s = $tests{$lv};
    $o .= "\n## Stage $lv — level $lv: $HEAD{$lv}[0]\n\n*\"$HEAD{$lv}[1]\"* Typing view: **`TOOLKIT_ARC-0026_$LL.md`**.\n\n### Item index — enter top to bottom\n\n$idx\n";
    $o .= "\n### How each rule is built\n\n" . (@why ? join("\n", @why) : '- Every change is a list, progression or text change; see the guide.') . "\n";
    $o .= "\n### Tests — the Owner plays these after level $lv (session $s->{id} of `GUIDE_ARC-0026.json`)\n\n| # | Do | Proves it works |\n|---|---|---|\n";
    for my $t (@{$s->{tests}}) { (my $d = $t->{steps}) =~ s/\|/\\|/g; (my $e = $t->{expected}) =~ s/\|/\\|/g; $o .= "| $t->{id} | $d | $e |\n" }
    $o .= "\n---\n" }
$o .= "\n## History — the patch build (2026-10-17, superseded)\n\n> Until 2026-10-17 this spec built the Windborn by patches applied by Claude (stages 0–6 below). Stage 0\n"
    . "> (patches, goal, texts) and stage 1 (probes P1–P9, all pass, QA-0004) are done and feed the stages above; the patch\n"
    . "> stage 2 is in the game and is cleared by step 00 of level 1; stages 3–6 were never applied. Kept for the record.\n\n$hist";
open my $h, '>:raw:encoding(UTF-8)', $SPEC or die; print $h $o; close $h;
my $lines = () = $o =~ /\n/g; print "SPEC_ARC-0026.md: $lines lines\n";
