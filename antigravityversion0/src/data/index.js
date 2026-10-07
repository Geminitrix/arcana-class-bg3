// Registry of the codex pages. The JSON files are generated from the original
// wiki by `npm run extract` — edit the wiki HTML (or the JSON), not this file.
import arcana from './arcana.json';
import unbound from './unbound.json';
import deceiver from './deceiver.json';
import starchild from './starchild.json';
import eternal from './eternal.json';
import heartweaver from './heartweaver.json';

export const PAGES = { arcana, unbound, deceiver, starchild, eternal, heartweaver };

// Navigation order: base class first, then the destinies in Major Arcana order.
export const ORDER = ['arcana', 'unbound', 'deceiver', 'starchild', 'eternal', 'heartweaver'];
export const DESTINIES = ORDER.slice(1);

// Accent colours from the original wiki (dark theme values).
export const ACCENT = {
  arcana: '#c993e0',
  unbound: '#f2c939',
  deceiver: '#f77cbf',
  starchild: '#8cc4fa',
  eternal: '#7fd197',
  heartweaver: '#f39a78',
};

// Short label for the navbar.
export const NAV_LABEL = {
  arcana: 'The Arcana',
  unbound: 'Unbound',
  deceiver: 'Deceiver',
  starchild: 'Starchild',
  eternal: 'Eternal',
  heartweaver: 'Heartweaver',
};

/** All deck cards of a page, in level order (levels above 12 are already excluded). */
export function deckOf(page) {
  const features = page.sections.find((s) => s.kind === 'features');
  if (!features) return [];
  return features.levels.flatMap((lvl) =>
    lvl.groups.flatMap((g) => g.features.map((f) => ({ ...f, groupNote: g.note }))),
  );
}

/** Every feature on a page (deck + Aspect spells), indexed by id, for in-text links. */
export function featureIndex(page) {
  const map = new Map();
  for (const f of deckOf(page)) if (f.id) map.set(f.id, f);
  for (const s of page.sections) {
    for (const b of s.blocks ?? []) if (b.type === 'feature' && b.feature.id) map.set(b.feature.id, b.feature);
  }
  return map;
}

/** Plain-text version of an HTML snippet (for short previews). */
export const plain = (html) => (html ?? '').replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
