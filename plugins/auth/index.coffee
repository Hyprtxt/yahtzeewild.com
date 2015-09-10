Config = require('../../config').get('/provider')

_sessionHandler = ( request, reply ) ->
  account = request.auth.credentials
  sid = account.profile.id
  this.cache.set sid,
    account: account
  , 0, ( err ) ->
    if( err )
      reply( err )
    request.auth.session.set
      sid: sid
    return reply.redirect '/'

exports.register = ( plugin, options, next ) ->
  cache = plugin.cache
    expiresIn: 1 * 24 * 3600 * 1000 # 1 day

  plugin.app.cache = cache

  plugin.bind
    cache: plugin.app.cache

  plugin.auth.strategy 'twitter', 'bell', Config.twitter

  plugin.auth.strategy 'session', 'cookie',
    password: Config.cookie.password
    cookie: 'sid-auth'
    redirectTo: '/login'
    isSecure: false
    validateFunc: ( request, session, callback ) ->
      cache.get session.sid, ( err, cached ) ->
        if( err )
          return callback err, false
        if( !cached )
          return callback null, false
        return callback null, true, cached.account

  plugin.route
    path: Config.route.twitter.callbackURL
    method: 'GET'
    config:
      auth: 'twitter'
      handler: _sessionHandler

  next()

exports.register.attributes =
  name: 'auth'
  version: '0.1.0'
