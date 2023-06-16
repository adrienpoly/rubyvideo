const colors = require("tailwindcss/colors");

module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./config/initializers/heroicon.rb",
  ],
  safelist: [
    {
      pattern: /view-transition/,
    },
  ],
  theme: {
    container: {
      center: true,
      padding: {
        DEFAULT: "1rem",
        sm: "1rem",
        // lg: "4rem",
        // xl: "5rem",
        // "2xl": "6rem",
      },
    },
    colors: {
      transparent: "transparent",
      current: "currentColor",
      gray: "#7b6f72",
      "gray-light": "#A39E9E",
      green: "#F0E7E9",
      white: colors.white,
      dark: "#261B23",
      brand: {
        DEFAULT: "#D74C47",
        lighter: "#FBEEEE",
      },
    },
    extend: {
      keyframes: {
        "fade-in": {
          "0%": { opacity: "0" },
          "100%": { opacity: "1" },
        },
        "slide-from-right": {
          "0%": { transform: "translateX(300px)" },
        },

        "slide-to-left": {
          "0%": { transform: "translateX(0px)" },
          "100%": { transform: "translateX(-300px)" },
        },
      },
    },
  },
  plugins: [require("@tailwindcss/line-clamp")],
};
