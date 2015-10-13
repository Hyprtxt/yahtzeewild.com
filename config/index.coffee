Confidence = require 'confidence'
Path = require 'path'

store = new Confidence.Store

  connection:
    $filter: 'env'
    production:
      host: 'localhost'
      port: 8011
    $default: # for devs
      host: 'nginx.hyprtxt.dev'
      port: 8011

  view:
    $filter: 'env'
    $base:
      engines:
        jade: require 'jade'
      path: Path.join( __dirname , '../views' )
    production:
      compileOptions:
        pretty: false
      isCached: true
    $default:
      compileOptions:
        pretty: true
      isCached: false

  plugin: [
    # static file serving
      register: require 'inert'
    ,
    # view serving
      register: require 'vision'
    ,
    # jade helper
      register: require '../plugins/jade'
    ,
    # social login
      register: require 'bell'
    ,
    # sessions
      register: require 'hapi-auth-cookie'
    ,
    # event logging
      register: require 'good'
      options:
        opsInterval: 1000
        reporters:[
          reporter: require 'good-console'
          events:
            log: '*'
            response: '*'
        ,
          reporter: require 'good-file'
          events:
            log: '*'
            response: '*'
          config: Path.join( __dirname, '../log', 'good.log' )
        ]
  ]
  auth:
    $filter: 'env'
    $base:
      cookie:
        password: 'hapiauth'
      route:
        facebook:
          callbackURL: '/login/facebook'
          btn: 'btn-primary-outline'
          icon: 'fa-facebook'
          name: 'Facebook'
    production:
      facebook:
        clientId: '1633329656917471'
        clientSecret: 'abc589dc42fc4ffc74ed1c979aa10ab5'
        isSecure: false
    $default: # for devs
      facebook:
        clientId: '1633329963584107'
        clientSecret: 'f25da49b468bafe838d4a7939e2d360f'
        isSecure: false # Bad Idea, get HTTPS for prodcution

criteria =
  # https://docs.npmjs.com/misc/config#production
  env: process.env.NODE_ENV

exports.get = ( key ) ->
  return store.get key, criteria
