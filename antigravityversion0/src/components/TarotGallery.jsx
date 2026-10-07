import { motion, useMotionValue, useSpring, useTransform } from 'framer-motion';
import { useRef } from 'react';
import { Sparkles } from 'lucide-react';

const SUBCLASSES = [
  {
    id: 'unbound',
    title: 'Unbound',
    numeral: '0',
    archetype: 'The Fool',
    image: '/img/emblems/unbound.png',
    color: 'from-emerald-400 to-cyan-500',
    desc: 'Agilidade do vento e fluxo constante. Desvie de ataques e golpei com tempestades físicas.',
  },
  {
    id: 'deceiver',
    title: 'Deceiver',
    numeral: 'II',
    archetype: 'The High Priestess',
    image: '/img/emblems/deceiver.png',
    color: 'from-purple-500 to-pink-500',
    desc: 'Ilusão, subterfúgio e controle mental. Crie duplicatas e vire os inimigos contra si mesmos.',
  },
  {
    id: 'starchild',
    title: 'Starchild',
    numeral: 'XVII',
    archetype: 'The Star',
    image: '/img/emblems/starchild.png',
    color: 'from-yellow-200 to-amber-500',
    desc: 'Luz celestial e cura cósmica. Canalize a energia das estrelas para purificar o campo de batalha.',
  },
  {
    id: 'eternal',
    title: 'Eternal',
    numeral: 'XIII',
    archetype: 'Death',
    image: '/img/emblems/eternal.png',
    color: 'from-red-600 to-slate-900',
    desc: 'Magia de sangue e controle sobre a vida e a morte. Roube a essência vital de quem ousar cruzar seu caminho.',
  },
  {
    id: 'heartweaver',
    title: 'Heartweaver',
    numeral: 'XIV',
    archetype: 'Temperance',
    // Fallback since heartweaver.png emblem might not exist yet; we'll try loading it, if it breaks we could handle it via onError, but let's assume it exists or will exist.
    image: '/img/emblems/heartweaver.png',
    color: 'from-rose-400 to-orange-400',
    desc: 'Empatia e harmonia. Manipule as emoções para balancear curas no grupo e maldições nos inimigos.',
  },
];

function TarotCard({ card }) {
  const ref = useRef(null);
  
  const x = useMotionValue(0);
  const y = useMotionValue(0);

  const mouseXSpring = useSpring(x, { stiffness: 300, damping: 20 });
  const mouseYSpring = useSpring(y, { stiffness: 300, damping: 20 });

  const rotateX = useTransform(mouseYSpring, [-0.5, 0.5], ["15deg", "-15deg"]);
  const rotateY = useTransform(mouseXSpring, [-0.5, 0.5], ["-15deg", "15deg"]);

  const handleMouseMove = (e) => {
    if (!ref.current) return;
    const rect = ref.current.getBoundingClientRect();
    const width = rect.width;
    const height = rect.height;
    const mouseX = e.clientX - rect.left;
    const mouseY = e.clientY - rect.top;
    const xPct = mouseX / width - 0.5;
    const yPct = mouseY / height - 0.5;
    x.set(xPct);
    y.set(yPct);
  };

  const handleMouseLeave = () => {
    x.set(0);
    y.set(0);
  };

  return (
    <motion.div
      ref={ref}
      onMouseMove={handleMouseMove}
      onMouseLeave={handleMouseLeave}
      style={{ rotateX, rotateY, transformStyle: "preserve-3d" }}
      className="relative w-full aspect-[2/3] rounded-xl cursor-pointer group [perspective:1000px]"
    >
      <div 
        className="absolute inset-0 rounded-xl border border-white/10 bg-arcana-cardBg overflow-hidden transition-colors group-hover:border-white/30 shadow-lg"
        style={{ transform: "translateZ(30px)" }}
      >
        <div className="absolute top-4 w-full flex justify-between px-4 z-10">
          <span className="font-display font-bold text-arcana-gold text-lg">{card.numeral}</span>
          <Sparkles className="text-arcana-gold opacity-50" size={16} />
        </div>

        <div className={`absolute inset-0 opacity-10 group-hover:opacity-20 transition-opacity bg-gradient-to-br ${card.color}`} />
        
        <div className="absolute inset-0 flex flex-col items-center justify-center p-4 text-center">
          <div className="mb-4 mt-6 h-28 w-28 flex items-center justify-center transition-transform duration-500 group-hover:scale-110">
            {/* The Emblem Image */}
            <img 
              src={card.image} 
              alt={card.title}
              onError={(e) => {
                // If Heartweaver emblem is not yet imported, show a default visual
                e.target.style.display = 'none';
                e.target.parentElement.innerHTML = `<div class="w-full h-full rounded-full bg-gradient-to-br ${card.color} opacity-40"></div>`;
              }}
              className="object-contain w-full h-full drop-shadow-[0_0_15px_rgba(255,255,255,0.2)]"
            />
          </div>
          
          <h3 className="font-display font-bold text-2xl text-white tracking-wider uppercase mb-1">
            {card.title}
          </h3>
          <p className="font-serif italic text-arcana-gold mb-4 text-sm">
            {card.archetype}
          </p>
          
          <div className="w-12 h-[1px] bg-arcana-gold/30 mb-2" />
          
          <p className="font-sans text-xs text-gray-300 opacity-0 translate-y-4 group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300 px-2 leading-relaxed">
            {card.desc}
          </p>
        </div>

        <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none" />
      </div>
    </motion.div>
  );
}

export default function TarotGallery() {
  return (
    <section className="py-24 bg-arcana-midnight relative overflow-hidden">
      <div className="container mx-auto px-6 relative z-10">
        <div className="text-center mb-16">
          <motion.h2 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-4xl md:text-5xl font-display font-bold text-white mb-4"
          >
            Os Cinco Destinos
          </motion.h2>
          <motion.p 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.2 }}
            className="text-lg text-arcana-textMuted max-w-2xl mx-auto font-sans"
          >
            No nível 1, você escolhe o seu Destino: uma das cinco cartas dos Arcanos Maiores. Essa escolha define o que o Arcana se torna em batalha, mudando suas magias passivas e até sua habilidade secundária.
          </motion.p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-6">
          {SUBCLASSES.map((card, idx) => (
            <motion.div
              key={card.id}
              initial={{ opacity: 0, y: 40 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-100px" }}
              transition={{ duration: 0.5, delay: idx * 0.1 }}
            >
              <TarotCard card={card} />
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
