module.exports =
  title: 'Yahtzee Wild | Hyprtxt'
  javascripts: [
    '/nginx/js/jquery/jquery.min.js'
    '/nginx/js/underscore/underscore-min.js'
    '/nginx/js/backbone/backbone-min.js'
    '/nginx/js/script.js'
  ]
  stylesheets: [
    '/nginx/css/style.css'
  ]
  navbarBrand:
    title: 'Yahtzee Wild'
    link: '/'
  navigation: [
    # title: 'A Link'
    # link: '#somewhere'
  ]
  timestamp: new Date()
  env: process.env.NODE_ENV
