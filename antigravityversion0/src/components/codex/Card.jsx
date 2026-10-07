import { Sparkles } from 'lucide-react';
import CodexHtml from './CodexHtml';

// One size for every card (deck back, drawn face) so they always match.
export const CARD_SIZE = 'w-56 aspect-[2/3]';

const kindOf = (f) => f.chips.find((c) => c.kind)?.text ?? 'Feature';

/** Placeholder art for features that don't have their icon yet. */
function Placeholder({ emblem, emblemSvg }) {
  return (
    <div className="relative w-16 h-16 flex items-center justify-center">
      {emblem && <img src={emblem} alt="" className="absolute inset-0 w-full h-full object-contain opacity-25" />}
      {!emblem && emblemSvg && (
        <div className="absolute inset-0 opacity-30 [&>svg]:w-full [&>svg]:h-full" dangerouslySetInnerHTML={{ __html: emblemSvg }} />
      )}
      <Sparkles size={22} className="relative text-[var(--accent)]" />
    </div>
  );
}

export function CardFace({ feature, emblem, emblemSvg, onOpen }) {
  const kind = kindOf(feature);
  const tags = feature.chips.filter((c) => !c.kind).map((c) => c.text);
  const stats = feature.stats.filter((s) => ['Cast', 'Range', 'Recharge'].includes(s.label)).slice(0, 2);

  return (
    <button
      type="button"
      onClick={() => onOpen?.(feature)}
      className={`${CARD_SIZE} group relative flex flex-col text-left rounded-xl overflow-hidden border border-[color-mix(in_srgb,var(--accent)_45%,transparent)] bg-[#15121f] shadow-[0_10px_30px_rgba(0,0,0,.45)] hover:shadow-[0_0_28px_color-mix(in_srgb,var(--accent)_35%,transparent)] transition-shadow`}
    >
      {/* inner frame */}
      <div className="pointer-events-none absolute inset-1.5 rounded-lg border border-[color-mix(in_srgb,var(--gold)_25%,transparent)] z-10" />

      {/* art */}
      <div className="relative h-[34%] shrink-0 flex items-center justify-center bg-[radial-gradient(circle_at_50%_60%,var(--wash),#0b0912_75%)]">
        <span className="absolute top-2.5 left-2.5 z-20 px-1.5 py-0.5 rounded bg-[var(--accent)] text-[#14111b] text-[9px] font-bold uppercase tracking-wider">
          {kind}
        </span>
        {feature.level != null && (
          <span className="absolute top-2 right-2 z-20 w-7 h-7 rounded-full border border-[var(--gold)] bg-[#14111b] text-[var(--gold)] font-display font-bold text-sm flex items-center justify-center">
            {feature.level}
          </span>
        )}
        {feature.icon ? (
          <img src={feature.icon} alt="" className="w-16 h-16 object-contain drop-shadow-[0_4px_12px_rgba(0,0,0,.8)] group-hover:scale-110 transition-transform duration-300" />
        ) : (
          <Placeholder emblem={emblem} emblemSvg={emblemSvg} />
        )}
      </div>

      {/* text */}
      <div className="flex-1 min-h-0 flex flex-col px-3.5 pt-2.5 pb-3">
        <h4 className="font-display font-bold text-[15px] leading-tight text-white">{feature.name}</h4>
        {tags.length > 0 && (
          <p className="mt-0.5 text-[10px] uppercase tracking-wider text-[var(--ink-soft)] truncate">{tags.join(' · ')}</p>
        )}
        {stats.length > 0 && (
          <p className="mt-1 text-[10px] text-[var(--accent)] font-semibold truncate">
            {stats.map((s) => `${s.label}: ${s.value}`).join('  ·  ')}
          </p>
        )}
        <div className="my-2 h-px bg-gradient-to-r from-transparent via-[color-mix(in_srgb,var(--gold)_40%,transparent)] to-transparent" />
        <CodexHtml html={feature.bodyHtml} className="card-clamp text-[11px] leading-snug" />
        <span className="mt-auto pt-1 text-[9px] uppercase tracking-[.2em] text-[var(--ink-soft)] group-hover:text-[var(--accent)] transition-colors">
          Read card ›
        </span>
      </div>
    </button>
  );
}

export function CardBack({ label }) {
  return (
    <div className={`${CARD_SIZE} relative rounded-xl overflow-hidden border border-[color-mix(in_srgb,var(--gold)_45%,transparent)] bg-[#120f1c] shadow-[0_10px_30px_rgba(0,0,0,.5)]`}>
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_45%,color-mix(in_srgb,var(--accent)_22%,transparent),transparent_60%)]" />
      <div className="absolute inset-0 opacity-[.07] bg-[repeating-linear-gradient(45deg,var(--gold)_0_1px,transparent_1px_12px),repeating-linear-gradient(-45deg,var(--gold)_0_1px,transparent_1px_12px)]" />
      <div className="absolute inset-2 rounded-lg border border-[color-mix(in_srgb,var(--gold)_35%,transparent)]" />
      <div className="absolute inset-4 rounded-md border border-[color-mix(in_srgb,var(--gold)_15%,transparent)]" />
      <div className="absolute inset-0 flex flex-col items-center justify-center gap-3">
        <span className="text-5xl text-[var(--gold)] drop-shadow-[0_0_14px_color-mix(in_srgb,var(--gold)_60%,transparent)]">✦</span>
        {label && <span className="font-display text-[var(--gold)] tracking-[.25em] text-xs uppercase">{label}</span>}
      </div>
    </div>
  );
}
