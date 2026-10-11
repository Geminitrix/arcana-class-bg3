import Hero from '../components/Hero'
import TarotGallery from '../components/TarotGallery'
import ClassFeatures from '../components/WeaveMechanics'
import AspectAwakening from '../components/AspectAwakening'
import ProgressionTimeline from '../components/ProgressionTimeline'
import SpellPreview from '../components/SpellPreview'

export default function Home() {
  return (
    <div className="pt-16">
      <Hero />
      <TarotGallery />
      <ClassFeatures />
      <AspectAwakening />
      <ProgressionTimeline />
      <SpellPreview />
      
      <footer className="bg-[#0B0F19] border-t border-white/10 py-12 text-center">
        <p className="text-gray-500 font-sans text-sm mb-4">
          The Arcana Class Mod for Baldur's Gate 3. Criado por <span className="text-arcana-gold">Lumox</span>.
        </p>
        <p className="text-gray-600 text-xs max-w-md mx-auto px-6">
          Baldur's Gate 3 é © Larian Studios. Esta é uma modificação de fã não oficial.
        </p>
      </footer>
    </div>
  )
}
