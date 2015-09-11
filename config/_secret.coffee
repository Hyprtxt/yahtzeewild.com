# This is an example file. Add your secrets and rename it to secret.coffee
Confidence = require('confidence')

store = new Confidence.Store(
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
)

criteria =
  # https://docs.npmjs.com/misc/config#production
  env: process.env.NODE_ENV

exports.get = ( key ) ->
  return store.get key, criteria
