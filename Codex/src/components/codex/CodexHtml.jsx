import { createContext, useContext } from 'react';
import { useNavigate } from 'react-router-dom';

/** Provided by DestinyPage: opens a feature card by id. Returns false if unknown. */
export const CodexContext = createContext({ openFeature: () => false });

/**
 * Renders verbatim wiki HTML. Links are intercepted so that:
 *  - "#feature-id" opens that feature's card,
 *  - "#section-id" scrolls to the section,
 *  - "/unbound#x" navigates inside the SPA.
 */
export default function CodexHtml({ html, as: Tag = 'div', className = '' }) {
  const { openFeature } = useContext(CodexContext);
  const navigate = useNavigate();

  const onClick = (e) => {
    const a = e.target.closest('a');
    if (!a) return;
    const href = a.getAttribute('href') ?? '';
    if (href.startsWith('#')) {
      e.preventDefault();
      const id = href.slice(1);
      if (openFeature(id)) return;
      document.getElementById(id)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } else if (href.startsWith('/')) {
      e.preventDefault();
      navigate(href);
    }
  };

  return <Tag className={`codex-html ${className}`} onClick={onClick} dangerouslySetInnerHTML={{ __html: html }} />;
}
