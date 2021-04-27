module.exports = {
  purge: ['./pages/**/*.js', './pages/*.js', './styles/**/*.css', './styles/*.css'],
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
};