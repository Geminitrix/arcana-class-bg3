export default function WikiTraits() {
  return (
    <div className="prose prose-invert max-w-none">
      <h1 className="text-4xl font-display font-bold text-white mb-8 border-b border-white/10 pb-4">Core Arcana Traits</h1>
      
      <div className="bg-[#12101E] rounded-xl border border-white/10 overflow-hidden shadow-lg">
        <table className="w-full text-left text-sm text-gray-300">
          <tbody className="divide-y divide-white/10">
            <tr className="hover:bg-white/5 transition-colors">
              <th scope="row" className="px-6 py-4 font-semibold text-white w-1/4">Hit Points</th>
              <td className="px-6 py-4">6 + your Constitution modifier at level 1, then 4 + your Constitution modifier per level</td>
            </tr>
            <tr className="hover:bg-white/5 transition-colors">
              <th scope="row" className="px-6 py-4 font-semibold text-white">Spellcasting Ability</th>
              <td className="px-6 py-4">Intelligence, for every destiny</td>
            </tr>
            <tr className="hover:bg-white/5 transition-colors">
              <th scope="row" className="px-6 py-4 font-semibold text-white">Secondary Ability</th>
              <td className="px-6 py-4">
                Set by your subclass: Unbound Dexterity · Deceiver Charisma · Starchild Wisdom · Eternal Constitution · Heartweaver Wisdom
              </td>
            </tr>
            <tr className="hover:bg-white/5 transition-colors">
              <th scope="row" className="px-6 py-4 font-semibold text-white">Saving Throws</th>
              <td className="px-6 py-4 space-y-1">
                Set by your subclass:<br/>
                <strong className="text-arcana-gold">Unbound</strong> Dexterity, Wisdom<br/>
                <strong className="text-arcana-gold">Deceiver</strong> Charisma, Intelligence<br/>
                <strong className="text-arcana-gold">Starchild</strong> Wisdom, Constitution<br/>
                <strong className="text-arcana-gold">Eternal</strong> Constitution, Strength<br/>
                <strong className="text-arcana-gold">Heartweaver</strong> Wisdom, Charisma
              </td>
            </tr>
            <tr className="hover:bg-white/5 transition-colors">
              <th scope="row" className="px-6 py-4 font-semibold text-white">Armour</th>
              <td className="px-6 py-4 space-y-1">
                Set by your subclass:<br/>
                <strong className="text-arcana-gold">Unbound</strong> none<br/>
                <strong className="text-arcana-gold">Deceiver</strong> Light Armour<br/>
                <strong className="text-arcana-gold">Starchild</strong> Light Armour, Medium Armour, Shields<br/>
                <strong className="text-arcana-gold">Eternal</strong> Light Armour, Medium Armour, Heavy Armour, Shields<br/>
                <strong className="text-arcana-gold">Heartweaver</strong> Light Armour
              </td>
            </tr>
            <tr className="hover:bg-white/5 transition-colors">
              <th scope="row" className="px-6 py-4 font-semibold text-white">Weapons</th>
              <td className="px-6 py-4 space-y-1">
                Set by your subclass:<br/>
                <strong className="text-arcana-gold">Unbound</strong> none (unarmed strikes)<br/>
                <strong className="text-arcana-gold">Deceiver</strong> Daggers, Light Crossbows, Quarterstaffs; also Musical Instruments<br/>
                <strong className="text-arcana-gold">Starchild</strong> Clubs, Daggers, Javelins, Maces, Quarterstaffs, Sickles, Spears<br/>
                <strong className="text-arcana-gold">Eternal</strong> Light Hammers, Clubs, Maces, Greatclubs, Warhammers, Mauls<br/>
                <strong className="text-arcana-gold">Heartweaver</strong> Daggers, Quarterstaffs, Light Crossbows, Darts
              </td>
            </tr>
            <tr className="hover:bg-white/5 transition-colors">
              <th scope="row" className="px-6 py-4 font-semibold text-white">Skills</th>
              <td className="px-6 py-4 space-y-1">
                Choose 4 from your subclass's list, then gain Expertise in 2 of them.<br/>
                <strong className="text-arcana-gold">Unbound</strong> Acrobatics, Animal Handling, Arcana, Athletics, Nature, Perception, Sleight of Hand, Survival<br/>
                <strong className="text-arcana-gold">Deceiver</strong> Arcana, Deception, History, Insight, Investigation, Perception, Performance, Persuasion<br/>
                <strong className="text-arcana-gold">Starchild</strong> Animal Handling, Arcana, History, Medicine, Nature, Perception, Religion, Survival<br/>
                <strong className="text-arcana-gold">Eternal</strong> Arcana, Athletics, History, Intimidation, Medicine, Nature, Religion, Survival<br/>
                <strong className="text-arcana-gold">Heartweaver</strong> Animal Handling, Insight, Intimidation, Medicine, Perception, Performance, Persuasion, Religion
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}
