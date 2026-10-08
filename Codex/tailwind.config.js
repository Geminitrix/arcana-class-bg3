/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        arcana: {
          midnight: '#0B0F19',
          deepPurple: '#1A0B2E',
          gold: '#D4AF37',
          neonCyan: '#00F0FF',
          cardBg: '#12101E',
          textMuted: '#9CA3AF',
        }
      },
      fontFamily: {
        sans: ['Alegreya Sans', 'sans-serif'],
        serif: ['Alegreya', 'serif'],
        display: ['Alegreya SC', 'serif'],
      },
      backgroundImage: {
        'mystic-gradient': 'linear-gradient(to bottom right, #0B0F19, #1A0B2E, #0f172a)',
        'card-gradient': 'linear-gradient(to bottom right, rgba(26,11,46,0.8), rgba(11,15,25,0.95))',
      },
      boxShadow: {
        'neon': '0 0 10px rgba(0, 240, 255, 0.5), 0 0 20px rgba(0, 240, 255, 0.3)',
        'gold': '0 0 15px rgba(212, 175, 55, 0.4)',
      }
    },
  },
  plugins: [],
}
