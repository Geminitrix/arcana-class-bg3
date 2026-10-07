import { useState, useMemo, useEffect } from 'react';
import { useParams, Navigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { PAGES, featureIndex } from '../data';
import { CodexContext } from '../components/codex/CodexHtml';
import CardModal from '../components/codex/CardModal';
import SpellDeck from '../components/codex/SpellDeck';
import { BlocksRenderer, ProgressionTable, TraitsTable, DestiniesGrid } from '../components/codex/Renderers';
import CodexHtml from '../components/codex/CodexHtml';

export default function DestinyPage({ slug }) {
  const page = PAGES[slug];
  const [modalFeature, setModalFeature] = useState(null);

  // Sync the accent color to the document root based on the active arcanum
  useEffect(() => {
    if (page) {
      document.documentElement.setAttribute('data-arcanum', page.slug);
    }
  }, [page]);

  const fIndex = useMemo(() => page ? featureIndex(page) : new Map(), [page]);

  if (!page) {
    return <Navigate to="/arcana" replace />;
  }

  const openFeature = (id) => {
    const f = fIndex.get(id);
    if (f) {
      setModalFeature(f);
      return true;
    }
    return false;
  };

  return (
    <CodexContext.Provider value={{ openFeature }}>
      <div className={`codex pt-24 pb-12 min-h-screen bg-[var(--paper)]`} data-arcanum={page.slug}>
        <div className="container mx-auto px-6">
          
          {/* Hero Section */}
          <div className="flex flex-col md:flex-row items-center gap-10 md:gap-16 mb-24 max-w-5xl">
            <motion.div 
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              className="relative w-64 aspect-[2/3] shrink-0 rounded-xl overflow-hidden border border-[var(--gold)]/30 bg-[#120f1c] shadow-[0_0_40px_var(--wash)] flex flex-col items-center p-6"
            >
              <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_35%,color-mix(in_srgb,var(--accent)_20%,transparent),transparent_65%)]" />
              <div className="absolute inset-2 rounded-lg border border-[var(--gold)]/20" />
              <div className="relative z-10 w-full text-center flex-1 flex flex-col">
                <span className="font-display font-bold text-3xl text-[var(--gold)]">{page.hero.numeral}</span>
                <div className="flex-1 min-h-0 flex items-center justify-center py-4">
                  {page.hero.emblem && (
                    <img src={page.hero.emblem} alt={page.hero.emblemAlt} className="w-full h-full object-contain drop-shadow-[0_4px_12px_rgba(0,0,0,.6)]" />
                  )}
                  {!page.hero.emblem && page.hero.emblemSvg && (
                    <div className="w-full h-full [&>svg]:w-full [&>svg]:h-full [&>svg]:drop-shadow-[0_4px_12px_rgba(0,0,0,.6)]" dangerouslySetInnerHTML={{ __html: page.hero.emblemSvg }} />
                  )}
                </div>
                <span className="font-display font-bold text-[var(--accent)] tracking-[.25em] uppercase text-sm leading-tight">
                  {page.hero.cardName}
                </span>
              </div>
            </motion.div>

            <div>
              <motion.p 
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                className="text-[var(--gold)] font-display uppercase tracking-widest text-sm mb-4"
              >
                {page.hero.eyebrow}
              </motion.p>
              <motion.h1 
                initial={{ opacity: 0, x: -30 }}
                animate={{ opacity: 1, x: 0 }}
                className="text-5xl md:text-7xl font-display font-bold text-white mb-8"
              >
                {page.title}
              </motion.h1>
              
              <motion.blockquote 
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.1 }}
                className="border-l-2 border-[var(--accent)] pl-6 mb-8 font-body italic text-[1.1rem] text-[var(--ink-soft)]"
              >
                <CodexHtml html={page.hero.epigraph.html} as="span" />
                <footer className="mt-2 text-sm not-italic font-bold tracking-widest text-[var(--ink)] uppercase">
                  — {page.hero.epigraph.cite}
                </footer>
              </motion.blockquote>

              <motion.div 
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2 }}
                className="text-lg text-[var(--ink-soft)] font-sans leading-relaxed"
              >
                <CodexHtml html={page.hero.ledeHtml} as="div" />
              </motion.div>
            </div>
          </div>

          {/* Render Extracted Sections dynamically */}
          {page.sections.map((section, idx) => {
            const isFirst = idx === 0;
            return (
              <motion.section 
                key={section.id} 
                id={section.id}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true, margin: "-100px" }}
              >
                {section.kind === 'features' ? (
                  <div className="mb-24">
                    <h2 className="text-4xl font-display font-bold text-white mb-2">{section.title}</h2>
                    <SpellDeck page={page} />
                  </div>
                ) : section.kind === 'progression' ? (
                  <ProgressionTable section={section} />
                ) : section.kind === 'traits' ? (
                  <TraitsTable section={section} />
                ) : section.kind === 'destinies' ? (
                  <DestiniesGrid section={section} />
                ) : (
                  <div className="mb-16 max-w-4xl">
                    {!isFirst && <h2 className="text-3xl font-display font-bold text-[var(--accent)] mb-6 border-b border-[var(--rule)] pb-4">{section.title}</h2>}
                    <BlocksRenderer blocks={section.blocks} />
                  </div>
                )}
              </motion.section>
            );
          })}

        </div>
      </div>
      
      {/* Global Card Modal for this page */}
      <CardModal feature={modalFeature} onClose={() => setModalFeature(null)} />
    </CodexContext.Provider>
  );
}
