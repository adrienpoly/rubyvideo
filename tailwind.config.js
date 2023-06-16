const colors = require("tailwindcss/colors");

module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./config/initializers/heroicon.rb",
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
    extend: {
      colors: {
        transparent: "transparent",
        current: "currentColor",
        gray: "#7b6f72",
        "gray-light": "#A39E9E",
        "gray-lightest": "#f9fafb",
        green: "#F0E7E9",
        white: colors.white,
        dark: "#261B23",
        brand: {
          DEFAULT: "#D74C47",
          lighter: "#FBEEEE",
        },
      },
      keyframes: {
        "fade-in": {
          "0%": { opacity: "0" },
          "100%": { opacity: "1" },
        },
        "fade-out": {
          "0%": { opacity: "1" },
          "100%": { opacity: "0" },
        },
      },
    },
  },
  plugins: [require("@tailwindcss/line-clamp"), require("@tailwindcss/forms")],
};
