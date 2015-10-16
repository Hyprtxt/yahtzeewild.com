module.exports =
  title: 'Wild Yacht Dice | Hyprtxt'
  javascripts: [
    '/nginx/js/jquery/jquery.min.js'
    '/nginx/js/underscore/underscore-min.js'
    '/nginx/js/backbone/backbone-min.js'
    '/nginx/js/random/random.min.js'
    '/nginx/js/vex/vex.min.js'
    '/nginx/js/vex/vex.dialog.min.js'
    '/nginx/js/dice.js'
    '/nginx/js/backbone.js'
    '/nginx/js/game.js'
    '/nginx/js/script.js'
  ]
  stylesheets: [
    '/nginx/css/style.css'
  ]
  navbarBrand:
    title: 'Wild Yacht Dice'
    link: '/'
  navigation: [
    # title: 'A Link'
    # link: '#somewhere'
  ]
  timestamp: new Date()
  env: process.env.NODE_ENV
