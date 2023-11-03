const colors = require('tailwindcss/colors')
const defaultTheme = require('daisyui/src/theming/themes.js')['[data-theme=light]']

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/components/**/*',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './config/initializers/heroicon.rb'
  ],
  theme: {
    container: {
      center: true,
      padding: {
        DEFAULT: '1rem',
        sm: '1rem'
        // lg: "4rem",
        // xl: "5rem",
        // "2xl": "6rem",
      }
    },
    extend: {
      // this is legacy tailwind config, we will try to replace it by the daisyui theme
      colors: {
        transparent: 'transparent',
        current: 'currentColor',
        gray: '#7b6f72',
        'gray-light': '#A39E9E',
        'gray-lightest': '#f9fafb',
        green: '#F0E7E9',
        white: colors.white,
        dark: '#261B23',
        brand: {
          DEFAULT: '#D74C47',
          lighter: '#FBEEEE'
        }
      },
      keyframes: {
        'fade-in': {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' }
        },
        'fade-out': {
          '0%': { opacity: '1' },
          '100%': { opacity: '0' }
        }
      }
    }
  },
  daisyui: {
    themes: [
      {
        rubyvideoLight: {
          ...defaultTheme,
          '--btn-text-case': 'none',
          primary: '#D74C47',
          'primary-content': '#ffffff',
          secondary: '#FBEEEE',
          'secondary-content': '#261B23',
          accent: '#593db1',
          'accent-content': '#ffffff',
          neutral: '#261B23',
          'neutral-content': '#ffffff'
          // 'base-100': '#ffffff',
          // info: '#3abff8',
          // success: '#36d399',
          // warning: '#fbbd23',
          // error: '#f87272'
        }
      }
    ]
  },
  plugins: [
    require('@tailwindcss/forms'), require('daisyui')
  ]
}
