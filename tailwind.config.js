const defaultTheme = require('daisyui/src/theming/themes.js')['[data-theme=light]']
const defaultTailwindTheme = require('tailwindcss/defaultTheme')

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
    fontFamily: {
      sans: ['Inter', ...defaultTailwindTheme.fontFamily.sans],
      serif: ['Nunito', ...defaultTailwindTheme.fontFamily.serif]
    },
    extend: {
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
    logs: false,
    themes: [
      {
        rubyvideoLight: {
          ...defaultTheme,
          '--btn-text-case': 'none',
          primary: '#DC143C',
          'primary-content': '#ffffff',
          secondary: '#FBEEEE',
          'secondary-content': '#7b6f72',
          accent: '#1C6EA4',
          'accent-content': '#ffffff',
          neutral: '#261B23',
          'base-100': '#F8F9FA'
          // 'neutral-content': '#ffffff',
          // 'base-content': '#2F2F2F'
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
    require('daisyui')
  ]
}
