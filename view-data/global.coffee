module.exports =
  title: 'Hypr-Hapi'
  javascripts: [
    '/nginx/js/jquery/jquery.min.js'
    '/nginx/js/script.js'
  ]
  stylesheets: [
    '/nginx/css/style.css'
  ]
  navbarBrand:
    title: 'Hyprtxt'
    link: '/'
  navigation: [
    title: 'A Link'
    link: '#somewhere'
  ]
  timestamp: new Date()
  env: process.env.NODE_ENV
