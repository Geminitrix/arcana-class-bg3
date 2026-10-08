export default function WikiOverview() {
  return (
    <div className="prose prose-invert max-w-none text-gray-300">
      <h1 className="text-4xl font-display font-bold text-white mb-6 border-b border-white/10 pb-4">Chosen of Mystra</h1>
      
      <p className="text-lg leading-relaxed mb-6">
        Mystra, the Lady of Mysteries, keeps the <strong>Weave</strong>: the fabric that every spell in the Realms is cast through. Wizards spend their lives learning to touch it. The Arcana never had to. Mystra bound them to the Weave with her own hand, and they carry it in them as her chosen and her instruments.
      </p>
      <p className="mb-6">
        Being chosen gives sight before it gives power. An Arcana sees the threads running through a room, a lock, a lie or a fight, and pulls on them: a roll foreseen and replaced, a door sealed shut, a hidden creature laid bare. That sight is the class itself, the part every Arcana shares whatever their path.
      </p>
      <p className="mb-6">
        What an Arcana becomes in battle is a destiny. Mystra weaves each of her chosen from one of the <strong>Major Arcana</strong>, the great cards of the tarot that tell the turns of a life: the first step into the unknown, the veil over a secret, the light that remains after disaster, the ending that refuses to be final, the balance poured between two feelings. That card is drawn at level 1, when you choose your subclass, and it shapes the whole character, from armour and weapons to the second ability its magic leans on. In combat, each destiny can awaken its card's <strong>Aspect</strong>.
      </p>

      <div className="bg-[#12101E] border-l-4 border-arcana-gold p-6 my-10 rounded-r-xl shadow-lg">
        <h3 className="text-arcana-gold font-display font-bold text-xl mb-2">At a Glance</h3>
        <ul className="list-disc pl-5 space-y-2 text-sm text-gray-400">
          <li><strong className="text-gray-200">Role:</strong> set by your destiny; the base class adds divination, exploration and a few flexible spells.</li>
          <li><strong className="text-gray-200">Strengths:</strong> a large pool of Woven Spell Slots that all share your highest Slot Level; foreseen rolls with Portent; answers to locks, darkness, invisibility, lore and long distances; 4 skills and 2 Expertise at level 1.</li>
          <li><strong className="text-gray-200">Weaknesses:</strong> low hit points (6 at level 1, then 4 per level); most base class spells can't be cast in combat.</li>
          <li><strong className="text-gray-200">Tip:</strong> cast the matching Weave Knowledge before a conversation, a ruin or a wounded stranger. The next check of that skill is a Critical Success.</li>
        </ul>
      </div>
    </div>
  );
}
