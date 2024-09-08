module.exports = {
  plugins: {
    'postcss-import': {},
    'tailwindcss/nesting': {},
    tailwindcss: {},
    rfs: {
      twoDimensional: false,
      baseValue: 14,
      unit: 'rem',
      breakpoint: 1200,
      breakpointUnit: 'px',
      factor: 5,
      safariIframeResizeBugFix: false
    },
    autoprefixer: {}
  }
}
