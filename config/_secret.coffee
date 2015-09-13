# This is an example file. Add your secrets and rename it to secret.coffee
Confidence = require('confidence')

store = new Confidence.Store
  socialAuth:
    $filter: 'env'
    $base:
      cookie:
        password: 'hapiauth0'
      route:
        twitter:
          callbackURL: '/login/twitter'
        google:
          callbackURL: '/login/google'
      twitter:
        provider: 'twitter'
        password: 'hapiauth1'
      google:
        provider: 'google'
        password: 'hapiauth2'
    production:
      twitter:
        clientId: ''
        clientSecret: ''
        isSecure: true
      google:
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
      database: ''
      debug: false

criteria =
  # https://docs.npmjs.com/misc/config#production
  env: process.env.NODE_ENV

exports.get = ( key ) ->
  return store.get key, criteria
