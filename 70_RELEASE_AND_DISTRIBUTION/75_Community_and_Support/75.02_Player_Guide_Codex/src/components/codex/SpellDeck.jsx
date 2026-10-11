import { useState, useContext } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Layers } from 'lucide-react';
import { CardFace, CardBack, CARD_SIZE } from './Card';
import { deckOf } from '../../data';
import { CodexContext } from './CodexHtml';

export default function SpellDeck({ page }) {
  const [drawnCount, setDrawnCount] = useState(0);
  const { openFeature } = useContext(CodexContext);

  const deck = deckOf(page);
  const drawnSpells = deck.slice(0, drawnCount);
  const remainingCount = deck.length - drawnCount;

  const handleDraw = () => {
    if (drawnCount < deck.length) {
      setDrawnCount((prev) => prev + 1);
    }
  };

  const handleReset = () => {
    setDrawnCount(0);
  };

  if (!deck.length) return null;

  return (
    <div className="py-12 relative w-full">
      <div className="flex flex-col lg:flex-row gap-12 items-start">
        
        {/* Left Side: The Deck */}
        <div className="w-full lg:w-1/3 flex flex-col items-center">
          <div className="mb-8 text-center">
            <h3 className="text-3xl font-display font-bold text-white mb-2">Compre seu Destino</h3>
            <p className="text-[var(--ink-soft)] text-sm font-sans max-w-[250px] mx-auto">
              Clique no baralho para revelar as habilidades do Nível 1 ao 12.
            </p>
          </div>

          <div 
            className={`relative ${CARD_SIZE} cursor-pointer perspective-1000 group`}
            onClick={handleDraw}
          >
            {[...Array(Math.min(5, remainingCount))].map((_, i) => (
              <motion.div
                key={`stack-${i}`}
                className="absolute inset-0"
                style={{ 
                  zIndex: 5 - i,
                  transform: `translateY(${i * -4}px) translateZ(${i * -2}px)`
                }}
                whileHover={i === 0 ? { y: -10, transition: { duration: 0.2 } } : {}}
              >
                <CardBack label={i === 0 ? page.hero.cardName : null} />
              </motion.div>
            ))}

            {remainingCount === 0 && (
              <div className="absolute inset-0 flex flex-col items-center justify-center border border-[var(--rule)] rounded-xl bg-white/5">
                <p className="text-[var(--ink-soft)] font-display text-lg mb-4">Baralho Vazio</p>
                <button 
                  onClick={(e) => { e.stopPropagation(); handleReset(); }}
                  className="px-5 py-2.5 bg-[var(--accent)] hover:bg-white text-[#14111b] font-bold rounded text-sm transition-colors"
                >
                  Embaralhar de Novo
                </button>
              </div>
            )}
          </div>
          
          <div className="mt-8 text-[var(--gold)] font-bold font-sans tracking-wide">
            {remainingCount} Cartas Restantes
          </div>
        </div>

        {/* Right Side: Drawn Cards (The Board) */}
        <div className="w-full lg:w-2/3 min-h-[500px] border border-[var(--rule)] bg-black/20 rounded-2xl p-8 relative overflow-hidden flex flex-wrap gap-6 items-start justify-center lg:justify-start content-start">
          <AnimatePresence>
            {drawnSpells.map((spell, idx) => (
              <motion.div
                key={`${spell.id}-${idx}`}
                initial={{ opacity: 0, x: -100, y: 50, scale: 0.5, rotateY: 180 }}
                animate={{ opacity: 1, x: 0, y: 0, scale: 1, rotateY: 0 }}
                transition={{ type: "spring", stiffness: 200, damping: 20 }}
              >
                <CardFace 
                  feature={spell} 
                  emblem={page.hero.emblem} 
                  emblemSvg={page.hero.emblemSvg}
                  onOpen={openFeature} 
                />
              </motion.div>
            ))}
          </AnimatePresence>
          
          {drawnCount === 0 && (
            <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
              <span className="text-[var(--ink-soft)] font-display text-2xl">O campo está vazio. Compre uma carta.</span>
            </div>
          )}
        </div>

      </div>
    </div>
  );
}
