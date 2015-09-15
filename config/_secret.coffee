Confidence = require('confidence')

store = new Confidence.Store
  socialAuth:
    $filter: 'env'
    $base:
      cookie:
        password: 'hapiauth'
      route:
        twitter:
          callbackURL: '/login/twitter'
        google:
          callbackURL: '/login/google'
        github:
          callbackURL: '/login/github'
        facebook:
          callbackURL: '/login/facebook'
    production:
      twitter:
        clientId: ''
        clientSecret: ''
        isSecure: true
      google:
        clientId: ''
        clientSecret: ''
        isSecure: true
      github:
        clientId: ''
        clientSecret: ''
        isSecure: true
      facebook:
        clientId: ''
        clientSecret: ''
        isSecure: true
    $default: # for devs
      twitter:
        clientId: ''
        clientSecret: ''
        isSecure: false # Bad Idea, get HTTPS for prodcution
      google:
        clientId: ''
        clientSecret: ''
        isSecure: false # Bad Idea, get HTTPS for prodcution
      github:
        clientId: ''
        clientSecret: ''
        isSecure: false # Bad Idea, get HTTPS for prodcution
      facebook:
        clientId: ''
        clientSecret: ''
        isSecure: false # Bad Idea, get HTTPS for prodcution
  mysql:
    $filter: 'env'
    production:
      connectionLimit: 100
      host: 'localhost'
      user: ''
      password: ''
      database: ''
      debug: false
    $default: # for devs
      connectionLimit: 10
      host: 'localhost'
      user: 'root'
      password: ''
      database: 'hapi'
      debug: false

criteria =
  # https://docs.npmjs.com/misc/config#production
  env: process.env.NODE_ENV

exports.get = ( key ) ->
  return store.get key, criteria
