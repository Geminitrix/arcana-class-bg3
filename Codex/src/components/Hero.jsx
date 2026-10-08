import { motion } from 'framer-motion';
import { Download, MessageCircle, Heart, Sparkles } from 'lucide-react';

export default function Hero() {
  return (
    <section className="relative min-h-screen flex flex-col lg:flex-row items-center justify-center overflow-hidden bg-mystic-gradient pt-20 px-6">
      {/* Background magical effects */}
      <motion.div 
        className="absolute w-[500px] h-[500px] bg-arcana-deepPurple/50 rounded-full blur-[120px] top-1/4 -left-32 pointer-events-none"
        animate={{ x: [0, 50, 0], y: [0, -50, 0] }}
        transition={{ duration: 15, repeat: Infinity, ease: "easeInOut" }}
      />
      <motion.div 
        className="absolute w-[400px] h-[400px] bg-arcana-neonCyan/10 rounded-full blur-[100px] bottom-1/4 -right-20 pointer-events-none"
        animate={{ x: [0, -50, 0], y: [0, 50, 0] }}
        transition={{ duration: 12, repeat: Infinity, ease: "easeInOut", delay: 2 }}
      />
      
      {/* Main Content - Split into 2 columns for large screens */}
      <div className="container mx-auto flex flex-col-reverse lg:flex-row items-center justify-between gap-12 relative z-10">
        
        {/* Left text column */}
        <div className="lg:w-1/2 text-center lg:text-left">
          {/* Badge */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/5 border border-arcana-neonCyan/30 text-arcana-neonCyan text-sm font-semibold mb-8 shadow-neon"
          >
            <Sparkles size={16} />
            <span>Baldur's Gate 3 Mod • Patch 7 Compatible</span>
          </motion.div>

          {/* Title */}
          <motion.h1 
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="text-6xl md:text-8xl font-display font-bold text-transparent bg-clip-text bg-gradient-to-br from-white to-gray-400 mb-6 drop-shadow-lg"
          >
            THE ARCANA
          </motion.h1>

          {/* Subtitle */}
          <motion.p 
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.4 }}
            className="text-lg md:text-2xl text-arcana-textMuted max-w-2xl mx-auto lg:mx-0 font-serif italic mb-10"
          >
            "We were chosen by the Lady of Mysteries, and the Weave answers when we pull on its threads." <br/>
            <span className="text-gray-300 font-sans not-italic text-base md:text-xl block mt-4">
              Uma classe revolucionária de videntes focada na manipulação do destino. Preveja e altere as rolagens de dados, 
              veja através de ilusões e comande a Trama sob a proteção de uma das cartas dos Arcanos Maiores.
            </span>
          </motion.p>

          {/* CTAs */}
          <motion.div 
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.6 }}
            className="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4"
          >
            <button className="group relative px-8 py-4 bg-arcana-gold text-arcana-midnight font-bold font-sans rounded-lg overflow-hidden flex items-center gap-3 transition-all hover:scale-105 hover:shadow-gold w-full sm:w-auto justify-center">
              <div className="absolute inset-0 bg-white/20 translate-y-full group-hover:translate-y-0 transition-transform duration-300 ease-out" />
              <Download size={20} className="relative z-10" />
              <span className="relative z-10">Download do Mod</span>
            </button>

            <button className="flex items-center gap-3 px-6 py-4 bg-white/5 hover:bg-white/10 text-white font-semibold font-sans rounded-lg border border-white/10 transition-all hover:border-white/30 w-full sm:w-auto justify-center">
              <MessageCircle size={20} className="text-[#5865F2]" />
              <span>Discord</span>
            </button>

            <button className="flex items-center gap-3 px-6 py-4 bg-white/5 hover:bg-white/10 text-white font-semibold font-sans rounded-lg border border-white/10 transition-all hover:border-white/30 hover:text-pink-400 w-full sm:w-auto justify-center">
              <Heart size={20} />
              <span>Apoiar</span>
            </button>
          </motion.div>
        </div>

        {/* Right Art column (Main Tarot Card) */}
        <motion.div 
          initial={{ opacity: 0, scale: 0.9, rotateY: -15 }}
          animate={{ opacity: 1, scale: 1, rotateY: 0 }}
          transition={{ duration: 1, delay: 0.5, ease: "easeOut" }}
          className="lg:w-1/2 flex justify-center perspective-1000"
        >
          {/* Main Tarot Card visually floating */}
          <motion.div
            animate={{ y: [-10, 10, -10] }}
            transition={{ duration: 6, repeat: Infinity, ease: "easeInOut" }}
            className="relative w-72 md:w-96 aspect-[2/3] rounded-xl border border-white/20 bg-arcana-cardBg shadow-neon overflow-hidden"
          >
            <div className="absolute top-4 w-full flex justify-between px-6 z-10">
              <span className="font-display font-bold text-arcana-gold text-2xl">✦</span>
              <Sparkles className="text-arcana-gold opacity-50" size={24} />
            </div>
            <div className="absolute inset-0 opacity-20 bg-gradient-to-t from-arcana-gold/20 to-transparent" />
            <div className="absolute inset-0 flex flex-col items-center justify-center p-8 text-center pt-16">
              <img src="/img/emblems/arcana.png" alt="Chosen of Mystra" className="w-48 h-auto drop-shadow-2xl mb-8" />
              <div className="w-16 h-px bg-arcana-gold/50 mb-4" />
              <h3 className="font-display font-bold text-3xl text-arcana-gold tracking-widest uppercase">
                CHOSEN OF MYSTRA
              </h3>
            </div>
          </motion.div>
        </motion.div>
        
      </div>
    </section>
  );
}
