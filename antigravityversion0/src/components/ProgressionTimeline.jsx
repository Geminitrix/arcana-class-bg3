import { motion } from 'framer-motion';

const MILESTONES = [
  {
    level: 1,
    title: 'O Início do Fio',
    desc: 'Ao nível 1, você recebe os cantrips e magias de Weaver Hand, o Arcane Familiar (para reconhecimento), e o recurso principal da sua subclasse (Destiny).',
    color: 'border-arcana-neonCyan text-arcana-neonCyan',
  },
  {
    level: 2,
    title: 'Manipulação e Conhecimento',
    desc: 'Acesso a Portent (substitua rolagens por dados pré-rolados), Weave Knowledge (sucesso crítico garantido em perícias), e Arcane Recovery.',
    color: 'border-blue-400 text-blue-400',
  },
  {
    level: 4,
    title: 'Domínio Arcano',
    desc: 'Expert Divination expande seus usos do Portent. Ganhe também Arcane Lock e Arcane Unlock para maestria sobre o campo e portas.',
    color: 'border-purple-400 text-purple-400',
  },
  {
    level: 8,
    title: 'O Terceiro Olho',
    desc: 'Desbloqueia a passiva Third Eye, permitindo enxergar através de escuridão mágica e detectar invisibilidade.',
    color: 'border-pink-500 text-pink-500',
  },
  {
    level: 12,
    title: 'Mestre da Trama',
    desc: 'Arcane Gate se torna disponível, permitindo carregar o grupo através de fendas dimensionais, e seu Aspecto final alcança o Tier III.',
    color: 'border-arcana-gold text-arcana-gold',
  }
];

export default function ProgressionTimeline() {
  return (
    <section className="py-24 bg-[#0B0F19] relative">
      <div className="container mx-auto px-6 max-w-4xl">
        
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-display font-bold text-white mb-4">
            Jornada de Poder
          </h2>
          <p className="text-lg text-arcana-textMuted font-sans max-w-2xl mx-auto">
            A progressão da classe The Arcana do Nível 1 ao 12 em Baldur's Gate 3. Os níveis em que as subclasses também progridem não estão listados aqui.
          </p>
        </div>

        <div className="relative border-l-2 border-white/10 ml-4 md:ml-0 md:border-none">
          {/* Central Line for Desktop */}
          <div className="hidden md:block absolute left-1/2 top-0 bottom-0 w-px bg-white/10 -translate-x-1/2" />

          {MILESTONES.map((item, index) => {
            const isLeft = index % 2 === 0;
            return (
              <motion.div 
                key={item.level}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true, margin: "-100px" }}
                transition={{ duration: 0.6 }}
                className={`relative flex flex-col md:flex-row items-center mb-12 last:mb-0 ${isLeft ? 'md:flex-row-reverse' : ''}`}
              >
                {/* Connector Dot */}
                <div className={`absolute left-[-21px] md:left-1/2 md:-translate-x-1/2 w-10 h-10 rounded-full border-2 bg-arcana-midnight flex items-center justify-center font-display font-bold text-lg z-10 ${item.color}`}>
                  {item.level}
                </div>

                {/* Content Card */}
                <div className={`ml-8 md:ml-0 md:w-1/2 ${isLeft ? 'md:pr-12 md:text-right' : 'md:pl-12 text-left'}`}>
                  <div className="bg-[#12101E] border border-white/5 p-6 rounded-xl shadow-lg hover:border-white/10 transition-colors">
                    <h4 className="font-display font-bold text-2xl text-white mb-2">{item.title}</h4>
                    <p className="font-sans text-gray-400 text-sm leading-relaxed">{item.desc}</p>
                  </div>
                </div>
              </motion.div>
            );
          })}
        </div>

      </div>
    </section>
  );
}
