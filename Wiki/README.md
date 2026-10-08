# Arcana Player's Guide

A static website for players: one page for the base class and one per subclass. Plain HTML and CSS,
no build step. Host it anywhere that serves static files (GitHub Pages, Netlify, Cloudflare Pages, itch.io).

| Page | File |
|---|---|
| The Arcana (home) | `index.html` |
| The Unbound | `unbound.html` |
| The Deceiver | `deceiver.html` |
| The Starchild | `starchild.html` |
| The Eternal | `eternal.html` |
| The Resonant | `resonant.html` |

Shared look and behaviour: `assets/css/guide.css`, `assets/js/guide.js`. Images: `assets/img/`.

## Preview locally

```bash
node "Wiki/_work/serve.js"
```

Then open http://localhost:8765/.

## Editing

- Content rules, section order, component classes and sources: `_work/STYLE.md`. Start new pages from
  `_work/template.html`.
- The pages describe the mod **as it is**, for players: no change history, no development terms, no
  named inspirations. Numbers come from the mod files (`_work/progression_dump.txt` is regenerated with
  `perl Context/tools/dump_progression.pl`).
- After editing, run the consistency check (section ids, links, progression rows, slot totals, banned
  words):

  ```bash
  node "Wiki/_work/check.js"
  ```

## Publishing

`_work/` holds working files only. GitHub Pages (Jekyll) skips folders that start with `_`; on other
hosts, upload everything except `_work/` and this README.
