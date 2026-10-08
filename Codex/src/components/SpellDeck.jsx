import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Layers } from 'lucide-react';

export default function SpellDeck({ spells }) {
  const [drawnCount, setDrawnCount] = useState(0);

  // Filter out anything beyond level 12 as requested
  const validSpells = spells.filter(s => s.level <= 12).sort((a, b) => a.level - b.level);
  
  const drawnSpells = validSpells.slice(0, drawnCount);
  const remainingCount = validSpells.length - drawnCount;

  const handleDraw = () => {
    if (drawnCount < validSpells.length) {
      setDrawnCount(prev => prev + 1);
    }
  };

  const handleReset = () => {
    setDrawnCount(0);
  };

  return (
    <div className="py-12 relative w-full">
      <div className="flex flex-col lg:flex-row gap-12 items-start">
        
        {/* Left Side: The Deck */}
        <div className="w-full lg:w-1/3 flex flex-col items-center">
          <div className="mb-6 text-center">
            <h3 className="text-2xl font-display font-bold text-white mb-2">Compre seu Destino</h3>
            <p className="text-arcana-textMuted text-sm font-sans">
              Clique no baralho para revelar as habilidades do Nível 1 ao 12.
            </p>
          </div>

          <div 
            className="relative w-64 aspect-[2/3] cursor-pointer perspective-1000 group"
            onClick={handleDraw}
          >
            {/* Render a stack of cards to look like a deck */}
            {[...Array(Math.min(5, remainingCount))].map((_, i) => (
              <motion.div
                key={`stack-${i}`}
                className="absolute inset-0 rounded-xl border border-arcana-gold/20 bg-arcana-cardBg shadow-lg overflow-hidden flex flex-col items-center justify-center bg-gradient-to-br from-[#1A0B2E] to-[#0B0F19]"
                style={{ 
                  zIndex: 5 - i,
                  transform: `translateY(${i * -4}px) translateZ(${i * -2}px)`
                }}
                whileHover={i === 0 ? { y: -10, transition: { duration: 0.2 } } : {}}
              >
                <div className="w-full h-full opacity-20 border-4 border-arcana-gold/10 m-2 rounded-lg pointer-events-none" />
                <Layers size={48} className="absolute text-arcana-gold/30" />
              </motion.div>
            ))}

            {remainingCount === 0 && (
              <div className="absolute inset-0 flex flex-col items-center justify-center border border-white/10 rounded-xl bg-white/5">
                <p className="text-gray-500 font-display mb-4">Baralho Vazio</p>
                <button 
                  onClick={(e) => { e.stopPropagation(); handleReset(); }}
                  className="px-4 py-2 bg-white/10 hover:bg-white/20 rounded text-white text-sm transition-colors"
                >
                  Embaralhar de Novo
                </button>
              </div>
            )}
          </div>
          
          <div className="mt-6 text-arcana-gold font-bold font-sans">
            {remainingCount} Cartas Restantes
          </div>
        </div>

        {/* Right Side: Drawn Cards (The Board) */}
        <div className="w-full lg:w-2/3 min-h-[500px] border border-white/5 bg-black/20 rounded-2xl p-8 relative overflow-hidden flex flex-wrap gap-6 items-start justify-center lg:justify-start content-start">
          <AnimatePresence>
            {drawnSpells.map((spell, idx) => (
              <motion.div
                key={spell.id}
                initial={{ opacity: 0, x: -100, y: 50, scale: 0.5, rotateY: 180 }}
                animate={{ opacity: 1, x: 0, y: 0, scale: 1, rotateY: 0 }}
                transition={{ type: "spring", stiffness: 200, damping: 20 }}
                className={`w-64 aspect-[2/3] flex-shrink-0 bg-[#0f172a] rounded-xl overflow-hidden border-2 ${spell.color || 'border-arcana-gold/50'} shadow-[0_0_20px_rgba(0,0,0,0.5)] flex flex-col relative group`}
              >
                {/* Level Badge */}
                <div className="absolute -top-3 -right-3 w-10 h-10 bg-arcana-gold text-black font-bold font-display rounded-full flex items-center justify-center z-20 shadow-lg border-2 border-[#0f172a]">
                  {spell.level}
                </div>

                <div className="h-32 flex-shrink-0 bg-gradient-to-br from-arcana-deepPurple to-black flex items-center justify-center relative border-b border-white/10 overflow-hidden">
                  <div className="absolute top-2 left-2 px-2 py-0.5 bg-black/60 rounded text-[10px] font-bold text-gray-300 uppercase tracking-wider z-10">
                    {spell.type}
                  </div>
                  {spell.image && (
                    <img 
                      src={spell.image} 
                      alt={spell.name} 
                      className="w-20 h-20 object-contain relative z-10 drop-shadow-2xl transition-transform duration-300 group-hover:scale-110" 
                    />
                  )}
                </div>
                
                <div className="p-4 flex flex-col flex-grow bg-gradient-to-b from-[#0f172a] to-[#0B0F19] overflow-y-auto custom-scrollbar">
                  <h3 className="font-display font-bold text-xl text-white mb-1">{spell.name}</h3>
                  <span className="text-[10px] font-sans text-arcana-neonCyan mb-3 block font-bold uppercase tracking-widest">{spell.cost}</span>
                  <div className="h-px w-full bg-gradient-to-r from-transparent via-white/20 to-transparent mb-3" />
                  <p className="font-sans text-xs text-gray-300 leading-relaxed">
                    {spell.desc}
                  </p>
                </div>
              </motion.div>
            ))}
          </AnimatePresence>
          
          {drawnCount === 0 && (
            <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
              <span className="text-gray-600 font-display text-xl">O campo está vazio. Compre uma carta.</span>
            </div>
          )}
        </div>

      </div>
    </div>
  );
}
