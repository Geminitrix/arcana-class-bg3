import { useEffect, useRef } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { Eye, Layers, BookOpen } from 'lucide-react';

gsap.registerPlugin(ScrollTrigger);

export default function ClassFeatures() {
  const containerRef = useRef(null);
  const cardsRef = useRef([]);

  useEffect(() => {
    const ctx = gsap.context(() => {
      ScrollTrigger.create({
        trigger: containerRef.current,
        start: "top top",
        end: "bottom bottom",
        pin: ".lore-sticky",
      });

      cardsRef.current.forEach((card) => {
        gsap.fromTo(card,
          { opacity: 0, y: 100 },
          {
            opacity: 1,
            y: 0,
            duration: 1,
            ease: "power3.out",
            scrollTrigger: {
              trigger: card,
              start: "top 80%",
              toggleActions: "play none none reverse",
            }
          }
        );
      });
    }, containerRef);

    return () => ctx.revert();
  }, []);

  const addToRefs = (el) => {
    if (el && !cardsRef.current.includes(el)) {
      cardsRef.current.push(el);
    }
  };

  return (
    <section ref={containerRef} className="bg-arcana-darkBlue py-32 relative">
      <div className="container mx-auto px-6 relative z-10 flex flex-col lg:flex-row gap-16 lg:gap-24 items-start">
        
        {/* Left Side: Lore (Sticky) */}
        <div className="lore-sticky lg:w-1/2 pt-10">
          <h2 className="text-sm font-sans uppercase tracking-widest text-arcana-neonCyan mb-2">Características Base</h2>
          <h3 className="text-4xl md:text-6xl font-display font-bold text-white mb-6">
            O Vidente Implacável
          </h3>
          <p className="text-xl text-gray-300 font-serif italic mb-6">
            "Ser o escolhido concede visão antes mesmo de conceder poder. The Arcana vê as linhas que correm através de uma sala, de uma mentira ou de um combate."
          </p>
          <p className="text-gray-400 font-sans text-lg mb-8">
            The Arcana é, acima de tudo, um vidente. Suas características base oferecem ferramentas inigualáveis para exploração 
            e adivinhação: abrir fechos trancados, ver através de invisibilidade, liderar conversas e prever resultados críticos.
          </p>
        </div>

        {/* Right Side: Mechanics Cards */}
        <div className="lg:w-1/2 flex flex-col gap-10 mt-10 lg:mt-0">
          
          {/* Card 1 */}
          <div ref={addToRefs} className="bg-arcana-cardBg border border-white/10 p-8 rounded-2xl shadow-lg relative overflow-hidden group hover:border-arcana-neonCyan/40 transition-colors">
            <div className="absolute top-0 right-0 p-6 opacity-10 group-hover:opacity-20 transition-opacity">
              <Layers size={100} className="text-arcana-neonCyan" />
            </div>
            <div className="relative z-10">
              <div className="w-12 h-12 rounded-full bg-arcana-neonCyan/20 flex items-center justify-center mb-6 text-arcana-neonCyan">
                <Layers size={24} />
              </div>
              <h4 className="text-2xl font-display font-bold text-white mb-3">Woven Spell Slots</h4>
              <p className="text-gray-400 font-sans">
                Todo feitiço arcano utiliza <strong className="text-gray-200">Woven Spell Slots</strong>. Todos os seus slots compartilham de um único nível, que sobe 
                automaticamente conforme seu nível geral aumenta (chegando até o Nível 6). Um feitiço de nível 1 conjurado no endgame terá a força devastadora de um feitiço de nível 5 ou 6.
              </p>
            </div>
          </div>

          {/* Card 2 */}
          <div ref={addToRefs} className="bg-arcana-cardBg border border-white/10 p-8 rounded-2xl shadow-lg relative overflow-hidden group hover:border-arcana-gold/40 transition-colors">
            <div className="absolute top-0 right-0 p-6 opacity-10 group-hover:opacity-20 transition-opacity">
              <Eye size={100} className="text-arcana-gold" />
            </div>
            <div className="relative z-10">
              <div className="w-12 h-12 rounded-full bg-arcana-gold/20 flex items-center justify-center mb-6 text-arcana-gold">
                <Eye size={24} />
              </div>
              <h4 className="text-2xl font-display font-bold text-white mb-3">Portent</h4>
              <p className="text-gray-400 font-sans">
                A partir do Nível 2, sua visão lhe permite prever o futuro. Após um Descanso Longo, você rola dados de d20 
                (Portent Dice). Durante os combates, você pode <strong>substituir</strong> rolagens de ataque ou testes de resistência feitos perto de você pelos resultados que previu.
              </p>
            </div>
          </div>

          {/* Card 3 */}
          <div ref={addToRefs} className="bg-arcana-cardBg border border-white/10 p-8 rounded-2xl shadow-lg relative overflow-hidden group hover:border-purple-500/40 transition-colors">
            <div className="absolute top-0 right-0 p-6 opacity-10 group-hover:opacity-20 transition-opacity">
              <BookOpen size={100} className="text-purple-500" />
            </div>
            <div className="relative z-10">
              <div className="w-12 h-12 rounded-full bg-purple-500/20 flex items-center justify-center mb-6 text-purple-400">
                <BookOpen size={24} />
              </div>
              <h4 className="text-2xl font-display font-bold text-white mb-3">Weave Knowledge</h4>
              <p className="text-gray-400 font-sans">
                Um conjunto de magias que você pode conjurar antes de uma conversa, exploração de ruínas ou cura de um aliado. 
                Elas garantem que a sua próxima rolagem na perícia correspondente seja um absoluto <strong>Sucesso Crítico</strong>.
              </p>
            </div>
          </div>

        </div>
      </div>
    </section>
  );
}
