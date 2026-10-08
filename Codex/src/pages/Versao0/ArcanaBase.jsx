import { motion } from 'framer-motion';
import SpellDeck from '../components/SpellDeck';

const BASE_SPELLS = [
  {
    id: 'familiar',
    name: 'Arcane Familiar',
    level: 1,
    type: 'Feature',
    cost: 'Action (Ritual)',
    image: '/img/emblems/arcana.png',
    color: 'border-arcana-neonCyan/50',
    desc: 'Invoca um familiar feito puramente de Trama. Ele possui visão superior, perfeito para reconhecimento.'
  },
  {
    id: 'weaver-hand',
    name: 'Weaver Hand',
    level: 1,
    type: 'Cantrips & Spells',
    cost: 'Action / Woven Slot',
    image: '/img/emblems/arcana.png',
    color: 'border-blue-500/50',
    desc: 'Um arsenal de feitiços utilitários sempre preparados, como manipular a Trama para criar chamas ou transmutar aliados.'
  },
  {
    id: 'portent',
    name: 'Portent',
    level: 2,
    type: 'Feature',
    cost: 'Recharge: Long Rest',
    image: '/img/emblems/arcana.png',
    color: 'border-purple-500/50',
    desc: 'Role dois d20s no início do dia. Troque qualquer rolagem de ataque ou resistência de aliados e inimigos por esses valores pré-determinados.'
  },
  {
    id: 'weave-knowledge',
    name: 'Weave Knowledge',
    level: 2,
    type: 'Feature',
    cost: 'Action (Out of Combat)',
    image: '/img/emblems/arcana.png',
    color: 'border-emerald-500/50',
    desc: 'Canalize a Trama antes de uma interação. Sua próxima rolagem na perícia correspondente será automaticamente um Sucesso Crítico.'
  },
  {
    id: 'expert-divination',
    name: 'Expert Divination',
    level: 4,
    type: 'Feature',
    cost: 'Passive',
    image: '/img/emblems/arcana.png',
    color: 'border-arcana-gold/50',
    desc: 'Recupera o uso de um dado do Portent gasto toda vez que você realiza um Descanso Curto.'
  },
  {
    id: 'third-eye',
    name: 'Third Eye',
    level: 8,
    type: 'Feature',
    cost: 'Action',
    image: '/img/emblems/arcana.png',
    color: 'border-pink-500/50',
    desc: 'Você pode enxergar através da escuridão mágica e detectar criaturas invisíveis sem penalidades.'
  },
  {
    id: 'arcane-gate',
    name: 'Arcane Gate',
    level: 12,
    type: 'Spell',
    cost: 'Action / Woven Slot',
    image: '/img/emblems/arcana.png',
    color: 'border-arcana-neonCyan/50',
    desc: 'Cria portais dimensionais conectados, permitindo transportar você e seus aliados através de grandes distâncias.'
  }
];

export default function ArcanaBase() {
  return (
    <div className="pt-24 pb-12 min-h-screen bg-arcana-darkBlue">
      <div className="container mx-auto px-6">
        
        {/* Header Header */}
        <div className="flex flex-col md:flex-row items-center gap-12 mb-16">
          <motion.img 
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            src="/img/emblems/arcana.png" 
            alt="The Arcana" 
            className="w-48 h-48 drop-shadow-[0_0_30px_rgba(212,175,55,0.4)]"
          />
          <div>
            <motion.h1 
              initial={{ opacity: 0, x: -30 }}
              animate={{ opacity: 1, x: 0 }}
              className="text-5xl md:text-7xl font-display font-bold text-white mb-4"
            >
              The Arcana
            </motion.h1>
            <motion.p 
              initial={{ opacity: 0, x: -30 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.1 }}
              className="text-xl text-gray-300 font-sans max-w-3xl leading-relaxed"
            >
              O vidente implacável. Uma classe que enxerga as linhas correndo através de uma sala, de uma mentira ou de um combate. Essa é a Classe Base compartilhada por todos os Destinos, focada em utilidade suprema e controle do fluxo da magia.
            </motion.p>
          </div>
        </div>

        {/* Traits Section */}
        <motion.div 
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-[#12101E] rounded-2xl border border-white/10 p-8 shadow-lg mb-20"
        >
          <h2 className="text-3xl font-display font-bold text-arcana-gold mb-6 border-b border-white/10 pb-4">Características Principais</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 font-sans text-gray-300">
            <div>
              <p className="mb-2"><strong className="text-white">Pontos de Vida:</strong> 6 + Mod. Constituição (Nível 1), 4 + Mod. Const. por nível.</p>
              <p className="mb-2"><strong className="text-white">Habilidade de Magia:</strong> Inteligência.</p>
              <p className="mb-2"><strong className="text-white">Habilidade Secundária:</strong> Definida pela Subclasse (Destino).</p>
            </div>
            <div>
              <p className="mb-2"><strong className="text-white">Proficiência em Salvaguarda:</strong> Definida pela Subclasse.</p>
              <p className="mb-2"><strong className="text-white">Proficiência em Armas/Armaduras:</strong> Definida pela Subclasse.</p>
              <p className="mb-2"><strong className="text-white">Perícias:</strong> Escolha 4 da lista da Subclasse e ganhe Expertise (Dobro da proficiência) em 2 delas no Nível 1.</p>
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
            <h2 className="text-4xl font-display font-bold text-white mb-2">Grimório Base</h2>
            <p className="text-gray-400 font-sans">
              As habilidades ganhas por todos os Arcanas. Role as cartas do seu baralho para ver a progressão do nível 1 ao 12.
            </p>
          </div>
          
          <SpellDeck spells={BASE_SPELLS} />
        </motion.div>

      </div>
    </div>
  );
}
