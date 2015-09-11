SocialAuthConfig = require('../config/').get('/socialAuth')

exports.register = ( server, options, next ) ->
  cache = server.cache
    expiresIn: 1 * 24 * 3600 * 1000 # 1 day

  server.app.cache = cache

  server.bind
    cache: server.app.cache

  _validateFunc = ( request, session, callback ) ->
    cache.get session.sid, ( err, value, cached, log ) ->
      if( err )
        return callback err, false
      if( !cached )
        return callback null, false
      # console.log 'stiff', err, value, cached, log
      return callback null, true, cached.item.account

  _sessionManagement = ( request, reply ) ->
    account = request.auth.credentials
    sid = account.profile.id
    this.cache.set sid,
      account: account
    , 0, ( err ) ->
      if( err )
        reply( err )
      request.auth.session.set
        'sid': sid
      return reply.redirect '/'

  server.auth.strategy 'twitter', 'bell', SocialAuthConfig.twitter

  server.auth.strategy 'session', 'cookie',
    password: SocialAuthConfig.cookie.password
    cookie: 'sid-auth'
    redirectTo: '/login'
    isSecure: false
    validateFunc: _validateFunc

  server.route
    path: SocialAuthConfig.route.twitter.callbackURL
    method: 'GET'
    config:
      auth: 'twitter'
      handler: _sessionManagement

  next()

exports.register.attributes =
  name: 'auth'
  version: '0.1.0'
