import { motion } from 'framer-motion';
import { Sparkles, Swords, Zap } from 'lucide-react';

export default function AspectAwakening() {
  return (
    <section className="py-24 bg-gradient-to-b from-arcana-darkBlue to-arcana-midnight relative overflow-hidden">
      {/* Background Glow */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-arcana-gold/5 rounded-full blur-[150px] pointer-events-none" />

      <div className="container mx-auto px-6 relative z-10 flex flex-col lg:flex-row items-center gap-16">
        
        {/* Left Side: Visual Representation */}
        <div className="lg:w-1/2 flex justify-center relative">
          <motion.div 
            className="relative w-80 h-[500px] rounded-2xl border-2 border-arcana-gold/30 bg-black/50 shadow-[0_0_50px_rgba(212,175,55,0.15)] overflow-hidden flex items-center justify-center"
            initial={{ opacity: 0, x: -50 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
          >
            {/* Inner mystical aura */}
            <motion.div 
              className="absolute inset-0 bg-gradient-to-t from-arcana-gold/20 via-transparent to-transparent"
              animate={{ opacity: [0.3, 0.6, 0.3] }}
              transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
            />
            
            {/* Glowing Core */}
            <motion.div 
              className="w-32 h-32 bg-arcana-gold/30 rounded-full blur-2xl absolute"
              animate={{ scale: [1, 1.5, 1], opacity: [0.5, 1, 0.5] }}
              transition={{ duration: 3, repeat: Infinity, ease: "easeInOut" }}
            />

            <div className="text-center relative z-10">
              <Sparkles size={64} className="text-arcana-gold mx-auto mb-6" />
              <h3 className="font-display font-bold text-3xl text-white tracking-widest uppercase mb-2">Ascensão</h3>
              <p className="font-serif italic text-arcana-gold">O Despertar da Carta</p>
            </div>
          </motion.div>
        </div>

        {/* Right Side: Text Content */}
        <div className="lg:w-1/2">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
          >
            <h2 className="text-sm font-sans uppercase tracking-widest text-arcana-gold mb-2">Mecânica de Combate</h2>
            <h3 className="text-4xl md:text-5xl font-display font-bold text-white mb-6">
              The Aspect Awakening
            </h3>
            
            <p className="text-lg text-gray-300 font-sans leading-relaxed mb-6">
              A partir do <strong className="text-white">Nível 3</strong>, sua subclasse ganha uma passiva com o nome da sua carta. 
              Ela define um <strong>Objetivo</strong>: algo que o seu destino faz de melhor, contabilizado enquanto a luta se desenrola. Ao alcançar a meta, o Aspecto desperta!
            </p>

            <ul className="space-y-6">
              <li className="flex gap-4 items-start">
                <div className="p-3 rounded-lg bg-arcana-gold/10 text-arcana-gold shrink-0">
                  <Swords size={24} />
                </div>
                <div>
                  <h4 className="font-display font-bold text-xl text-white mb-1">Objetivos Dinâmicos</h4>
                  <p className="font-sans text-gray-400 text-sm">Por exemplo, o aspecto <em>Curiosity</em> (The Fool) exige que você acerte diferentes inimigos no mesmo turno. O aspecto <em>Doubt</em> (High Priestess) desperta ao aplicar acúmulos de dúvida mental.</p>
                </div>
              </li>

              <li className="flex gap-4 items-start">
                <div className="p-3 rounded-lg bg-arcana-neonCyan/10 text-arcana-neonCyan shrink-0">
                  <Zap size={24} />
                </div>
                <div>
                  <h4 className="font-display font-bold text-xl text-white mb-1">Despertar em Três Estágios (Tiers)</h4>
                  <p className="font-sans text-gray-400 text-sm">O despertar possui três Tiers (desbloqueados nos Níveis 3, 7 e 12). Cada meta atingida acumula os bônus do Tier. No Tier 3, seu <em>Aspect</em> concede inclusive +3 na sua habilidade secundária!</p>
                </div>
              </li>
            </ul>
          </motion.div>
        </div>

      </div>
    </section>
  );
}
