import { NavLink, Outlet } from 'react-router-dom';

export default function Wiki() {
  return (
    <div className="pt-16 min-h-screen bg-arcana-darkBlue flex">
      {/* Sidebar Navigation */}
      <aside className="w-64 fixed top-16 bottom-0 left-0 overflow-y-auto bg-[#0B0F19] border-r border-white/10 p-6 hidden md:block">
        <h2 className="font-display font-bold text-xl text-white mb-6">Codex / Wiki</h2>
        <nav className="space-y-1 font-sans text-sm">
          <NavLink to="/wiki/overview" className={({isActive}) => `block px-3 py-2 rounded-md ${isActive ? 'bg-arcana-gold/10 text-arcana-gold' : 'text-gray-400 hover:text-white hover:bg-white/5'}`}>Visão Geral</NavLink>
          <NavLink to="/wiki/traits" className={({isActive}) => `block px-3 py-2 rounded-md ${isActive ? 'bg-arcana-gold/10 text-arcana-gold' : 'text-gray-400 hover:text-white hover:bg-white/5'}`}>Características Base (Traits)</NavLink>
          <NavLink to="/wiki/progression" className={({isActive}) => `block px-3 py-2 rounded-md ${isActive ? 'bg-arcana-gold/10 text-arcana-gold' : 'text-gray-400 hover:text-white hover:bg-white/5'}`}>Tabela de Progressão</NavLink>
          <NavLink to="/wiki/spellcasting" className={({isActive}) => `block px-3 py-2 rounded-md ${isActive ? 'bg-arcana-gold/10 text-arcana-gold' : 'text-gray-400 hover:text-white hover:bg-white/5'}`}>Feitiçaria (Spellcasting)</NavLink>
          <NavLink to="/wiki/destinies" className={({isActive}) => `block px-3 py-2 rounded-md ${isActive ? 'bg-arcana-gold/10 text-arcana-gold' : 'text-gray-400 hover:text-white hover:bg-white/5'}`}>Os Destinos (Subclasses)</NavLink>
        </nav>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1 md:ml-64 p-8 lg:p-12 text-gray-300 font-sans max-w-5xl">
        <Outlet />
      </main>
    </div>
  );
}
