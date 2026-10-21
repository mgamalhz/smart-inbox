/** @type {import('tailwindcss').Config} */
// Same brand settings as mgamalhz.com, so the page looks like part of the site.
export default {
  darkMode: 'class',
  content: ['../site/index.html'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
    },
  },
};
