import { Link, useLocation } from 'react-router-dom';
import { Sparkles } from 'lucide-react';
import { ORDER, NAV_LABEL } from '../data';

export default function Navbar() {
  const location = useLocation();

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-[#0B0F19]/90 backdrop-blur-md border-b border-white/10">
      <div className="container mx-auto px-6 h-16 flex items-center justify-between">
        <Link to="/" className="flex items-center gap-2 text-[var(--gold, #D4AF37)] font-display font-bold text-xl hover:text-white transition-colors">
          <Sparkles size={20} />
          MYSTRA'S CHOSEN
        </Link>
        
        <div className="hidden md:flex gap-2">
          {ORDER.map((slug) => {
            const isActive = location.pathname === `/${slug}`;
            return (
              <Link 
                key={slug}
                to={`/${slug}`} 
                className={`px-4 py-2 rounded-md font-sans text-sm font-semibold transition-colors ${
                  isActive 
                    ? 'bg-[var(--accent)]/20 text-[var(--accent)]' 
                    : 'text-gray-300 hover:text-white hover:bg-white/5'
                }`}
              >
                {NAV_LABEL[slug]}
              </Link>
            );
          })}
        </div>
      </div>
    </nav>
  );
}
