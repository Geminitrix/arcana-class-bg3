import { Link } from 'react-router-dom';
import CodexHtml from './CodexHtml';
import { DESTINIES, NAV_LABEL } from '../../data';

function Block({ block }) {
  if (block.type === 'prose' || block.type === 'html' || block.type === 'note') {
    return <CodexHtml html={block.html} className={block.type === 'note' ? 'subtle' : ''} />;
  }
  if (block.type === 'heading') {
    return <h3 className="font-display font-bold text-2xl text-white mt-12 mb-4">{block.text}</h3>;
  }
  if (block.type === 'aside') {
    return (
      <aside className="my-10 bg-[var(--paper-2)] border-l-4 border-[var(--gold)] p-6 rounded-r-xl shadow-lg">
        {block.title && <h4 className="text-[var(--gold)] font-display font-bold text-xl mb-3">{block.title}</h4>}
        <CodexHtml html={block.html} />
      </aside>
    );
  }
  if (block.type === 'table') {
    return (
      <div className="codex-table my-8">
        <CodexHtml html={block.html} as="div" />
      </div>
    );
  }
  if (block.type === 'reading') {
    return (
      <div className="grid md:grid-cols-2 gap-4 my-10">
        {[block.upright, block.reversed].map((side, i) => side && (
          <div key={i} className="bg-[var(--paper-2)] border border-[var(--rule)] rounded-xl p-6">
            <h4 className={`font-display text-lg tracking-widest uppercase mb-3 ${i === 0 ? 'text-[var(--accent)]' : 'text-[var(--ink-soft)]'}`}>
              {side.title}{i === 1 && ' ?'}
            </h4>
            <ul className="flex flex-wrap gap-2 mb-4">
              {side.keywords.map(kw => (
                <li key={kw} className="px-2 py-0.5 rounded border border-[var(--rule)] text-[var(--ink-soft)] text-xs font-semibold uppercase tracking-wider">
                  {kw}
                </li>
              ))}
            </ul>
            <CodexHtml html={side.html} className="subtle" />
          </div>
        ))}
      </div>
    );
  }
  if (block.type === 'tiers') {
    return (
      <div className="grid md:grid-cols-3 gap-4 my-8">
        {block.tiers.map((t, i) => (
          <div key={i} className={`p-5 rounded-xl border border-[var(--rule)] flex flex-col gap-3 ${i === 2 ? 'bg-[var(--wash)] border-[var(--accent)]/30' : 'bg-[var(--paper-2)]'}`}>
            <div>
              <p className="font-display text-xl text-[var(--accent)] leading-tight">{t.label}</p>
              <p className="font-sans text-xs font-bold text-white mt-1">{t.goal}</p>
            </div>
            <ul className="grid gap-2 text-sm text-[var(--ink-soft)] list-disc pl-4">
              {t.itemsHtml.map((html, j) => (
                <li key={j} dangerouslySetInnerHTML={{ __html: html }} />
              ))}
            </ul>
          </div>
        ))}
      </div>
    );
  }
  if (block.type === 'glossary') {
    return (
      <dl className="grid md:grid-cols-[140px_1fr] gap-x-6 gap-y-4 my-8">
        {block.items.map((item, i) => (
          <div key={i} className="contents group">
            <dt className="font-display text-lg text-[var(--accent)]">{item.term}</dt>
            <dd className="font-sans text-sm text-[var(--ink-soft)] pb-4 border-b border-[var(--rule)] group-last:border-0"><CodexHtml html={item.html} /></dd>
          </div>
        ))}
      </dl>
    );
  }
  return null;
}

export function BlocksRenderer({ blocks }) {
  if (!blocks?.length) return null;
  return (
    <div className="mb-16 max-w-4xl">
      {blocks.map((b, i) => <Block key={i} block={b} />)}
    </div>
  );
}

export function ProgressionTable({ section }) {
  return (
    <div className="mb-16 max-w-5xl">
      <h2 className="text-3xl font-display font-bold text-[var(--accent)] mb-6 border-b border-[var(--rule)] pb-4">{section.title}</h2>
      <BlocksRenderer blocks={section.intro} />
      <div className="codex-table my-8">
        <table>
          <thead>
            <tr>
              {section.columns.map((c, i) => <th key={i} className={i < 2 ? 'num' : ''}>{c}</th>)}
            </tr>
          </thead>
          <tbody>
            {section.rows.map((r, i) => (
              <tr key={i} className={r.subclass ? 'bg-[color-mix(in_srgb,var(--accent)_6%,transparent)]' : ''}>
                {r.cells.map((c, j) => (
                  <td key={j} className={j < 2 ? 'num' : ''}><CodexHtml html={c} as="span" /></td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export function TraitsTable({ section }) {
  return (
    <div className="mb-16 max-w-4xl">
      <h2 className="text-3xl font-display font-bold text-[var(--accent)] mb-6 border-b border-[var(--rule)] pb-4">{section.title}</h2>
      <div className="codex-table">
        <table>
          <tbody>
            {section.rows.map((r, i) => (
              <tr key={i}>
                <th scope="row" className="w-1/4">{r.label}</th>
                <td><CodexHtml html={r.html} as="span" /></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export function DestiniesGrid({ section }) {
  return (
    <div className="mb-16 max-w-5xl">
      <h2 className="text-3xl font-display font-bold text-[var(--accent)] mb-6 border-b border-[var(--rule)] pb-4">{section.title}</h2>
      <BlocksRenderer blocks={section.blocks} />
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 my-8">
        {DESTINIES.map((slug) => (
          <Link key={slug} to={`/${slug}`} className="flex items-center p-4 rounded-xl border border-[var(--rule)] bg-[var(--paper-2)] hover:-translate-y-1 hover:border-[var(--accent)]/50 transition-all shadow-lg group">
            <span className="font-display font-bold text-xl text-white group-hover:text-[var(--accent)] transition-colors">{NAV_LABEL[slug]}</span>
          </Link>
        ))}
      </div>
    </div>
  );
}
