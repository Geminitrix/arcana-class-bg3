// Extracts the player-facing content of the original HTML wiki (../Wiki/*.html)
// into JSON files under src/data/. Text is copied verbatim; only asset paths and
// cross-page links are rewritten, and content above MAX_LEVEL is dropped.
//
// Usage: npm run extract

import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { parse } from 'node-html-parser';

const MAX_LEVEL = 12;

const here = dirname(fileURLToPath(import.meta.url));
const WIKI_DIR = resolve(here, '../../Wiki');
const OUT_DIR = resolve(here, '../src/data');

// wiki file -> route slug
const PAGES = {
  index: 'arcana',
  unbound: 'unbound',
  deceiver: 'deceiver',
  starchild: 'starchild',
  eternal: 'eternal',
  heartweaver: 'heartweaver',
};

// ---------- helpers ----------

const clean = (s) => (s ?? '').replace(/\s+/g, ' ').trim();

function fixHtml(html) {
  return (html ?? '')
    .replace(/(src|href)="assets\/img\//g, '$1="/img/')
    .replace(/href="(index|unbound|deceiver|starchild|eternal|heartweaver)\.html(#[^"]*)?"/g,
      (_, page, hash = '') => `href="/${PAGES[page]}${hash}"`)
    .replace(/\s+\n/g, '\n')
    .trim();
}

const inner = (el) => fixHtml(el?.innerHTML);
const firstNum = (s) => {
  const m = clean(s).match(/^(\d+)/);
  return m ? Number(m[1]) : null;
};

// Drop rows / columns that describe levels above MAX_LEVEL.
function trimTableLevels(tableWrap) {
  for (const table of tableWrap.querySelectorAll('table')) {
    const headCells = table.querySelectorAll('thead th');
    const firstHead = clean(headCells[0]?.text).toLowerCase();

    // Column-oriented tables: first header is a label, the others are levels.
    if (headCells.length > 1 && /level/.test(firstHead) && headCells.slice(1).every((th) => firstNum(th.text) !== null)) {
      const drop = new Set();
      headCells.forEach((th, i) => { if (i > 0 && firstNum(th.text) > MAX_LEVEL) drop.add(i); });
      if (drop.size) {
        for (const row of table.querySelectorAll('tr')) {
          const cells = row.childNodes.filter((n) => n.tagName === 'TH' || n.tagName === 'TD');
          cells.forEach((c, i) => { if (drop.has(i)) c.remove(); });
        }
      }
      continue;
    }

    // Row-oriented tables: first column is a level number.
    if (/^level|^lvl/.test(firstHead)) {
      for (const row of table.querySelectorAll('tbody tr')) {
        const first = row.querySelector('td, th');
        if (first && firstNum(first.text) > MAX_LEVEL) row.remove();
      }
    }
  }
}

function parseFeature(article, level = null) {
  const icon = article.querySelector('.feature-icon img')?.getAttribute('src');
  return {
    id: article.getAttribute('id') ?? null,
    name: clean(article.querySelector('.feature-name')?.text),
    level,
    icon: icon ? fixHtml(`src="${icon}"`).slice(5, -1) : null,
    chips: article.querySelectorAll('.chips li').map((li) => ({
      text: clean(li.text),
      kind: li.classList.contains('chip-kind'),
    })),
    stats: article.querySelectorAll('.statline > div').map((d) => ({
      label: clean(d.querySelector('dt')?.text),
      value: clean(d.querySelector('dd')?.text),
    })),
    bodyHtml: inner(article.querySelector('.feature-body')),
  };
}

function parseReading(div) {
  const side = (el) => el && {
    title: clean(el.querySelector('h4')?.text),
    keywords: el.querySelectorAll('.keywords li').map((li) => clean(li.text)),
    html: inner(el.querySelector('p')),
  };
  return { type: 'reading', upright: side(div.querySelector('.upright')), reversed: side(div.querySelector('.reversed')) };
}

function parseTiers(div) {
  return {
    type: 'tiers',
    tiers: div.querySelectorAll('.tier').map((t) => ({
      label: clean(t.querySelector('.tier-label')?.text),
      goal: clean(t.querySelector('.tier-goal')?.text),
      level: firstNum(clean(t.querySelector('.tier-goal')?.text).replace(/^level\s*/i, '')),
      itemsHtml: t.querySelectorAll('li').map((li) => inner(li)),
    })),
  };
}

function parseBlock(el) {
  const cls = el.classList;
  const tag = el.tagName;
  if (tag === 'H3') return { type: 'heading', text: clean(el.text) };
  if (tag === 'ARTICLE' && cls.contains('feature')) return { type: 'feature', feature: parseFeature(el) };
  if (tag === 'ASIDE') {
    const title = el.querySelector('.aside-title');
    const titleText = clean(title?.text);
    title?.remove();
    return { type: 'aside', title: titleText, html: inner(el) };
  }
  if (cls.contains('prose')) return { type: 'prose', html: inner(el) };
  if (cls.contains('table-wrap')) { trimTableLevels(el); return { type: 'table', html: inner(el) }; }
  if (cls.contains('reading')) return parseReading(el);
  if (cls.contains('tiers')) return parseTiers(el);
  if (tag === 'DL' && cls.contains('glossary')) {
    const items = [];
    let term = null;
    for (const n of el.childNodes) {
      if (n.tagName === 'DT') term = clean(n.text);
      if (n.tagName === 'DD' && term) { items.push({ term, html: inner(n) }); term = null; }
    }
    return { type: 'glossary', items };
  }
  if (tag === 'P' && cls.contains('subtle')) return { type: 'note', html: inner(el) };
  return { type: 'html', html: fixHtml(el.outerHTML) };
}

function parseFeatures(section) {
  const levels = [];
  for (const lvl of section.querySelectorAll('.level')) {
    const level = Number(lvl.getAttribute('id')?.replace('lvl-', ''));
    if (!level || level > MAX_LEVEL) continue;
    const groups = [];
    let loose = null;
    for (const child of lvl.childNodes) {
      if (!child.tagName) continue;
      if (child.classList.contains('level-head')) continue;
      if (child.classList.contains('feature-group')) {
        groups.push({
          id: child.getAttribute('id') ?? null,
          note: inner(child.querySelector('.choice-note')),
          features: child.querySelectorAll('article.feature').map((a) => parseFeature(a, level)),
        });
        loose = null;
      } else if (child.tagName === 'ARTICLE') {
        if (!loose) { loose = { id: null, note: null, features: [] }; groups.push(loose); }
        loose.features.push(parseFeature(child, level));
      } else if (child.tagName === 'P') {
        loose = { id: null, note: inner(child), features: [] };
        groups.push(loose);
      }
    }
    levels.push({ level, groups: groups.filter((g) => g.features.length) });
  }
  const intro = section.childNodes
    .filter((n) => n.tagName && n.tagName !== 'H2' && !n.classList.contains('level'))
    .map(parseBlock);
  return { intro, levels };
}

function parseProgression(section) {
  const intro = [];
  let columns = [];
  let rows = [];
  for (const child of section.childNodes) {
    if (!child.tagName || child.tagName === 'H2') continue;
    if (child.classList.contains('table-wrap')) {
      const table = child.querySelector('table');
      columns = table.querySelectorAll('thead th').map((th) => clean(th.text));
      rows = table.querySelectorAll('tbody tr')
        .map((tr) => ({
          subclass: tr.classList.contains('is-subclass'),
          cells: tr.querySelectorAll('td').map((td) => inner(td)),
        }))
        .filter((r) => (firstNum(r.cells[0].replace(/<[^>]+>/g, '')) ?? 0) <= MAX_LEVEL);
    } else {
      intro.push(parseBlock(child));
    }
  }
  return { intro, columns, rows };
}

function parseTraits(section) {
  return section.querySelectorAll('table.traits tr').map((tr) => ({
    label: clean(tr.querySelector('th')?.text),
    html: inner(tr.querySelector('td')),
  }));
}

// ---------- main ----------

mkdirSync(OUT_DIR, { recursive: true });
const summary = [];

for (const [file, slug] of Object.entries(PAGES)) {
  const root = parse(readFileSync(resolve(WIKI_DIR, `${file}.html`), 'utf8'));
  const art = root.querySelector('.tarot-art img');

  const page = {
    slug,
    title: clean(root.querySelector('.hero-text h1')?.text),
    hero: {
      numeral: clean(root.querySelector('.tarot-num')?.text),
      cardName: clean(root.querySelector('.tarot-name')?.text),
      emblem: art ? fixHtml(`src="${art.getAttribute('src')}"`).slice(5, -1) : null,
      emblemAlt: art?.getAttribute('alt') ?? '',
      emblemSvg: art ? null : fixHtml(root.querySelector('.tarot-art svg')?.outerHTML) || null,
      eyebrow: clean(root.querySelector('.hero-text .eyebrow')?.text),
      epigraph: {
        html: inner(root.querySelector('.epigraph p')),
        cite: clean(root.querySelector('.epigraph cite')?.text),
      },
      ledeHtml: inner(root.querySelector('.hero-text .lede')),
    },
    sections: [],
  };

  let featureCount = 0;
  for (const section of root.querySelectorAll('section.chapter')) {
    const id = section.getAttribute('id');
    const title = clean(section.querySelector('h2')?.text);
    const base = { id, title };

    if (id === 'features') {
      const f = parseFeatures(section);
      featureCount = f.levels.reduce((n, l) => n + l.groups.reduce((m, g) => m + g.features.length, 0), 0);
      page.sections.push({ ...base, kind: 'features', ...f });
    } else if (id === 'progression') {
      page.sections.push({ ...base, kind: 'progression', ...parseProgression(section) });
    } else if (id === 'traits') {
      page.sections.push({ ...base, kind: 'traits', rows: parseTraits(section) });
    } else {
      const blocks = section.childNodes
        .filter((n) => n.tagName && n.tagName !== 'H2')
        .map(parseBlock);
      page.sections.push({ ...base, kind: id === 'destinies' ? 'destinies' : 'blocks', blocks });
    }
  }

  writeFileSync(resolve(OUT_DIR, `${slug}.json`), JSON.stringify(page, null, 2));
  summary.push(`${slug.padEnd(12)} sections: ${page.sections.length}  cards (lvl<=${MAX_LEVEL}): ${featureCount}`);
}

console.log(summary.join('\n'));
