import { motion } from 'framer-motion';

const SAMPLE_SPELLS = [
  {
    id: 'portent',
    name: 'Portent',
    type: 'Feature',
    subclass: 'Base Class',
    cost: 'Recharge: Long Rest',
    image: '/img/icons/arcana/2-portent.webp',
    color: 'border-arcana-neonCyan/50',
    desc: 'Ao terminar um Descanso Longo, role dois d20s e anote os resultados. Você pode substituir qualquer jogada de ataque ou teste de resistência feito perto de você por um desses resultados premonitórios.'
  },
  {
    id: 'flow-state',
    name: 'Flow State',
    type: 'Passive',
    subclass: 'Unbound',
    cost: 'Passive Feature',
    image: '/img/icons/unbound/3-flow-state.webp',
    color: 'border-emerald-500/50',
    desc: 'Quando você não está usando armadura nem escudos, sua Classe de Armadura inclui seu Modificador de Sabedoria. Além disso, golpear com ataques desarmados gera Momentum.'
  },
  {
    id: 'mirror-image',
    name: 'Mirror Image',
    type: 'Spell',
    subclass: 'Deceiver',
    cost: 'Action / Woven Spell Slot',
    image: '/img/icons/deceiver/mirror-image.webp',
    color: 'border-purple-500/50',
    desc: 'Crie 3 ilusões duplicatas de você mesmo. Cada duplicata aumenta sua Classe de Armadura em 3. Sempre que um ataque falhar contra você, uma das ilusões é destruída.'
  },
  {
    id: 'blood-reaper',
    name: 'Blood Reaper',
    type: 'Spell',
    subclass: 'Eternal',
    cost: 'Action / Woven Spell Slot',
    image: '/img/icons/eternal/blood-reaper.webp',
    color: 'border-red-600/50',
    desc: 'Roube a essência vital de um inimigo vulnerável. Causa 4d6 de Dano Necrótico e você recupera Pontos de Vida iguais à metade do dano causado.'
  }
];

export default function SpellPreview() {
  return (
    <section className="py-24 bg-arcana-midnight relative">
      <div className="container mx-auto px-6">
        
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-display font-bold text-white mb-4">
            Grimório e Habilidades
          </h2>
          <p className="text-lg text-arcana-textMuted max-w-2xl mx-auto font-sans mb-12">
            Cada habilidade, feitiço e característica de classe é apresentada visualmente como uma carta no seu arsenal.
            Abaixo estão alguns exemplos de como a interface reflete as mecânicas precisas de Baldur's Gate 3.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {SAMPLE_SPELLS.map((spell, idx) => {
            return (
              <motion.div
                key={spell.id}
                initial={{ opacity: 0, scale: 0.9 }}
                whileInView={{ opacity: 1, scale: 1 }}
                viewport={{ once: true, margin: "-50px" }}
                transition={{ duration: 0.4, delay: idx * 0.1 }}
                whileHover={{ y: -10 }}
                className={`bg-[#0f172a] rounded-xl overflow-hidden border-2 ${spell.color} shadow-lg flex flex-col group`}
              >
                {/* Card Art / Icon Header */}
                <div className="h-48 bg-gradient-to-br from-arcana-deepPurple to-[#0f172a] flex items-center justify-center relative border-b border-white/10 overflow-hidden">
                  <div className="absolute inset-0 bg-cover bg-center opacity-30 group-hover:opacity-50 transition-opacity duration-500" style={{ backgroundImage: `url(${spell.image})` }} />
                  
                  <div className="absolute top-2 left-2 px-2 py-1 bg-black/60 rounded text-[10px] font-bold text-gray-300 uppercase tracking-wider z-10 backdrop-blur-sm border border-white/10">
                    {spell.type}
                  </div>
                  <div className="absolute top-2 right-2 px-2 py-1 bg-black/60 rounded text-[10px] font-bold text-arcana-gold uppercase tracking-wider z-10 backdrop-blur-sm border border-white/10">
                    {spell.subclass}
                  </div>
                  
                  <img 
                    src={spell.image} 
                    alt={spell.name} 
                    className="w-24 h-24 object-contain relative z-10 drop-shadow-2xl transition-transform duration-300 group-hover:scale-110" 
                  />
                </div>
                
                {/* Card Body */}
                <div className="p-5 flex flex-col flex-grow bg-gradient-to-b from-[#0f172a] to-[#0B0F19]">
                  <h3 className="font-display font-bold text-2xl text-white mb-1">{spell.name}</h3>
                  <span className="text-xs font-sans text-arcana-neonCyan mb-4 block font-bold uppercase tracking-widest">{spell.cost}</span>
                  
                  <div className="h-px w-full bg-gradient-to-r from-transparent via-white/20 to-transparent mb-4" />
                  
                  <p className="font-sans text-sm text-gray-300 leading-relaxed flex-grow">
                    {spell.desc}
                  </p>
                </div>
              </motion.div>
            );
          })}
        </div>

      </div>
    </section>
  );
}
