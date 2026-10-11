# TC_ARC-0001 · Deceiver level 20 has no dead PassivesRemoved

- **Decision it informs:** close ARC-0001 or send it back to the Owner.
- **Hypothesis:** after the Toolkit edit, only the Deceiver level-20 row differs, and it has no
  `PassivesRemoved`.
- **Scenario:** static — no game session needed (level 20 is beyond the 1–12 core).
- **Steps and expected results (one assertion each):**
  1. `bash 80_TOOLS_AND_PIPELINE/82_Automation/sync_data.sh` → 51 refreshed.
  2. `perl 80_TOOLS_AND_PIPELINE/82_Automation/validate.pl` → `OK: 0 errors`.
  3. Same output, check 3 → no line `Deceiver level 20`.
  4. `git diff --stat 50_ENGINEERING/51_Mod_Source` → only the Deceiver progression file(s) changed.
  5. `grep -c 'new entry "Arcana_Passive_UnlockFriends"'` in `Passive.txt` → `1`.
- **Result:** _pending_
