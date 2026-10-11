import { useEffect } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { X, Sparkles } from 'lucide-react';
import CodexHtml from './CodexHtml';

export default function CardModal({ feature, onClose }) {
  useEffect(() => {
    if (!feature) return;
    const onKey = (e) => e.key === 'Escape' && onClose();
    window.addEventListener('keydown', onKey);
    const prev = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => {
      window.removeEventListener('keydown', onKey);
      document.body.style.overflow = prev;
    };
  }, [feature, onClose]);

  return (
    <AnimatePresence>
      {feature && (
        <motion.div
          key="backdrop"
          className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/75 backdrop-blur-sm"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onClick={onClose}
        >
          <motion.article
            key={feature.id ?? feature.name}
            role="dialog"
            aria-modal="true"
            aria-label={feature.name}
            onClick={(e) => e.stopPropagation()}
            initial={{ opacity: 0, y: 30, rotateX: 12, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, rotateX: 0, scale: 1 }}
            exit={{ opacity: 0, y: 20, scale: 0.97 }}
            transition={{ type: 'spring', stiffness: 260, damping: 24 }}
            className="relative w-full max-w-xl max-h-[88vh] overflow-y-auto custom-scrollbar rounded-2xl border border-[color-mix(in_srgb,var(--accent)_45%,transparent)] bg-[#15121f] shadow-[0_0_60px_color-mix(in_srgb,var(--accent)_25%,transparent)]"
          >
            <button onClick={onClose} aria-label="Close" className="absolute top-3 right-3 z-10 p-2 rounded-full text-[var(--ink-soft)] hover:text-white hover:bg-white/10">
              <X size={18} />
            </button>

            <header className="flex gap-5 items-center p-6 pb-4 bg-[radial-gradient(circle_at_15%_50%,var(--wash),transparent_70%)] border-b border-[var(--rule)]">
              <div className="w-20 h-20 shrink-0 rounded-xl border border-[color-mix(in_srgb,var(--gold)_35%,transparent)] bg-black/40 flex items-center justify-center">
                {feature.icon
                  ? <img src={feature.icon} alt="" className="w-16 h-16 object-contain" />
                  : <Sparkles className="text-[var(--accent)]" size={28} />}
              </div>
              <div className="min-w-0">
                {feature.level != null && (
                  <p className="text-[11px] uppercase tracking-[.2em] text-[var(--gold)] font-bold mb-1">Level {feature.level}</p>
                )}
                <h3 className="font-display font-bold text-2xl text-white leading-tight">{feature.name}</h3>
                <ul className="mt-2 flex flex-wrap gap-1.5">
                  {feature.chips.map((c) => (
                    <li
                      key={c.text}
                      className={`px-2 py-0.5 rounded text-[11px] font-semibold tracking-wide ${
                        c.kind
                          ? 'bg-[var(--accent)] text-[#14111b]'
                          : 'border border-[var(--rule)] text-[var(--ink-soft)]'
                      }`}
                    >
                      {c.text}
                    </li>
                  ))}
                </ul>
              </div>
            </header>

            {feature.stats.length > 0 && (
              <dl className="grid grid-cols-2 sm:grid-cols-4 gap-px bg-[var(--rule)] border-b border-[var(--rule)]">
                {feature.stats.map((s) => (
                  <div key={s.label} className="bg-[#15121f] px-4 py-2.5">
                    <dt className="text-[10px] uppercase tracking-[.15em] text-[var(--ink-soft)]">{s.label}</dt>
                    <dd className="text-sm font-semibold text-white">{s.value}</dd>
                  </div>
                ))}
              </dl>
            )}

            <div className="p-6">
              {feature.groupNote && <CodexHtml html={feature.groupNote} className="subtle mb-4 italic" />}
              <CodexHtml html={feature.bodyHtml} className="text-[15px]" />
            </div>
          </motion.article>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
