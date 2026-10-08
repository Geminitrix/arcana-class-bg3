import { motion } from 'framer-motion';
import SpellDeck from '../components/SpellDeck';

const UNBOUND_SPELLS = [
  {
    id: 'flowing-strikes',
    name: 'Flowing Strikes: Agility',
    level: 1,
    type: 'Passive',
    cost: 'Passive',
    image: '/img/emblems/unbound.png',
    color: 'border-emerald-500/50',
    desc: 'Seus ataques desarmados usam Destreza em vez de Força. Requer que não use armadura ou escudo.'
  },
  {
    id: 'flowing-strikes-precision',
    name: 'Flowing Strikes: Precision',
    level: 1,
    type: 'Passive',
    cost: 'Passive',
    image: '/img/emblems/unbound.png',
    color: 'border-emerald-400/50',
    desc: 'O dano dos seus ataques desarmados escala com seu nível, começando em 1d4 e chegando a 1d10 no Nível 12.'
  },
  {
    id: 'be-the-leaf',
    name: 'Be the Leaf',
    level: 1,
    type: 'Passive',
    cost: 'Passive',
    image: '/img/emblems/unbound.png',
    color: 'border-cyan-400/50',
    desc: 'Sua Classe de Armadura passa a ser 10 + Modificador de Destreza + Modificador de Sabedoria. (Sem armadura)'
  },
  {
    id: 'zephyr-strike',
    name: 'Zephyr Strike',
    level: 3,
    type: 'Feature',
    cost: 'Bonus Action',
    image: '/img/emblems/unbound.png',
    color: 'border-emerald-300/50',
    desc: 'Sempre que você fizer um ataque desarmado, conjurar um feitiço Arcano ou True Strike, você pode realizar um ataque desarmado extra usando uma Ação Bônus.'
  },
  {
    id: 'flow-state',
    name: 'Flow State',
    level: 3,
    type: 'Spell',
    cost: 'Action / Woven Slot',
    image: '/img/icons/unbound/3-flow-state.webp',
    color: 'border-cyan-500/50',
    desc: 'Garante uma Ação Bônus adicional a cada turno. Magias Unbound geram este estado.'
  },
  {
    id: 'gale-deflection',
    name: 'Gale Deflection',
    level: 3,
    type: 'Reaction',
    cost: 'Reaction',
    image: '/img/emblems/unbound.png',
    color: 'border-blue-400/50',
    desc: 'Reduza o dano de ataques à distância em 1d10 + Mod Destreza + Nível. Se reduzir a 0, atire o projétil de volta.'
  },
  {
    id: 'wind-whispers',
    name: 'Wind Whispers',
    level: 5,
    type: 'Spell',
    cost: 'Bonus Action / Woven Slot',
    image: '/img/emblems/unbound.png',
    color: 'border-teal-400/50',
    desc: 'Ataques contra você têm Desvantagem até seu próximo turno. Erros corpo-a-corpo engatilham um contra-ataque.'
  },
  {
    id: 'empty-state',
    name: 'Empty State',
    level: 12,
    type: 'Passive',
    cost: 'Passive',
    image: '/img/emblems/unbound.png',
    color: 'border-emerald-200/50',
    desc: 'Receba apenas metade do dano de ataques que acertam. Não receba dano em testes de resistência de Destreza bem-sucedidos.'
  }
];

export default function Unbound() {
  return (
    <div className="pt-24 pb-12 min-h-screen bg-arcana-darkBlue">
      <div className="container mx-auto px-6">
        
        {/* Header Header */}
        <div className="flex flex-col md:flex-row items-center gap-12 mb-16">
          <motion.img 
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            src="/img/emblems/unbound.png" 
            alt="The Unbound" 
            className="w-48 h-48 drop-shadow-[0_0_30px_rgba(16,185,129,0.4)]"
          />
          <div>
            <motion.h1 
              initial={{ opacity: 0, x: -30 }}
              animate={{ opacity: 1, x: 0 }}
              className="text-5xl md:text-7xl font-display font-bold text-white mb-4"
            >
              The Unbound
            </motion.h1>
            <motion.p 
              initial={{ opacity: 0, x: -30 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.1 }}
              className="text-xl text-emerald-100 font-sans max-w-3xl leading-relaxed"
            >
              0 — The Fool. Agilidade do vento e o fluxo constante. Como a carta do Louco, você dá o primeiro passo no desconhecido carregando nada que possa prendê-lo. Sem armadura. Sem escudos. Apenas a tempestade física.
            </motion.p>
          </div>
        </div>

        {/* The Aspect Awakening Section for this specific Subclass */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.15 }}
          className="bg-gradient-to-r from-[#12101E] to-[#0A1929] rounded-2xl border border-emerald-500/20 p-8 shadow-lg mb-12"
        >
          <h2 className="text-2xl font-display font-bold text-emerald-400 mb-2">The Aspect Awakening: Curiosity</h2>
          <p className="text-gray-300 font-sans mb-4">
            Em combate, o aspecto místico do Unbound desperta através da Curiosidade.
          </p>
          <ul className="list-disc pl-5 space-y-2 text-sm text-gray-400 font-sans">
            <li><strong className="text-white">O Objetivo:</strong> Acerte <strong>inimigos diferentes</strong> com ataques dentro do mesmo turno (3, 4 ou 5 inimigos).</li>
            <li><strong className="text-emerald-300">Tier I (Wanderlust):</strong> Desperto ao bater em 3 inimigos.</li>
            <li><strong className="text-emerald-300">Tier II (Restless Wind):</strong> A partir do Nível 7. Uma vez por turno, um Zephyr Strike não custa Ação Bônus.</li>
            <li><strong className="text-emerald-300">Tier III (Aspect of Curiosity):</strong> A partir do Nível 12. +3 em Destreza. O primeiro ataque contra você em cada rodada erra automaticamente (Fool's Luck).</li>
          </ul>
        </motion.div>

        {/* Specific Traits Section */}
        <motion.div 
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-[#12101E] rounded-2xl border border-white/10 p-8 shadow-lg mb-20"
        >
          <h2 className="text-3xl font-display font-bold text-arcana-gold mb-6 border-b border-white/10 pb-4">Especialidades do Destino</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 font-sans text-gray-300">
            <div>
              <p className="mb-2"><strong className="text-white">Habilidade Secundária:</strong> Destreza (Dexterity)</p>
              <p className="mb-2"><strong className="text-white">Armadura & Escudos:</strong> Nenhuma. Passivas são desligadas se equipadas.</p>
              <p className="mb-2"><strong className="text-white">Armas:</strong> Nenhuma. Foco exclusivo em Ataques Desarmados.</p>
            </div>
            <div>
              <p className="mb-2"><strong className="text-white">Salvaguardas:</strong> Dexterity, Wisdom.</p>
              <p className="mb-2"><strong className="text-white">Movimentação (Twinkle Toes):</strong> Velocidade passiva aumentada radicalmente ao longo dos níveis (+3m no Nível 1 até imunes à queda no Nível 12).</p>
            </div>
          </div>
        </motion.div>

        {/* Interactive Deck Builder */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
        >
          <div className="mb-8">
            <h2 className="text-4xl font-display font-bold text-white mb-2">Cartas do Unbound</h2>
            <p className="text-gray-400 font-sans">
              Compre suas habilidades do Nível 1 ao 12. O poder cresce e o vento te obedece.
            </p>
          </div>
          
          <SpellDeck spells={UNBOUND_SPELLS} />
        </motion.div>

      </div>
    </div>
  );
}
