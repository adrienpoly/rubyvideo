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
      fontSize: {
        xs: ['0.75rem', { lineHeight: '1rem' }],
        sm: ['0.875rem', { lineHeight: 'rfs(1.25rem)' }],
        base: ['rfs(1rem)', { lineHeight: 'rfs(1.5rem)' }],
        lg: ['rfs(1.125rem)', { lineHeight: 'rfs(1.75rem)' }],
        xl: ['rfs(1.25rem)', { lineHeight: 'rfs(1.75rem)' }],
        '2xl': ['rfs(1.5rem)', { lineHeight: 'rfs(2rem)' }],
        '3xl': ['rfs(1.875rem)', { lineHeight: 'rfs(2.25rem)' }],
        '4xl': ['rfs(2.25rem)', { lineHeight: 'rfs(2.5rem)' }],
        '5xl': ['rfs(3rem)', { lineHeight: '1' }],
        '6xl': ['rfs(3.75rem)', { lineHeight: '1' }],
        '7xl': ['rfs(4.5rem)', { lineHeight: '1' }],
        '8xl': ['rfs(6rem)', { lineHeight: '1' }],
        '9xl': ['rfs(8rem)', { lineHeight: '1' }]
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
    logs: false,
    themes: [
      {
        rubyvideoLight: {
          ...defaultTheme,
          '--btn-text-case': 'none',
          primary: '#DC143C',
          'primary-content': '#ffffff',
          secondary: '#7A4EC2',
          'secondary-content': '#ffffff',
          accent: '#1DA1F2',
          'accent-content': '#ffffff',
          neutral: '#261B23',
          'neutral-content': '#ffffff',
          'base-100': '#F8F9FA'
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
