SocialAuthConfig = require('../config/secret').get('/socialAuth')

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
    if !request.auth.isAuthenticated
      return reply('Authentication failed due to: ' + request.auth.error.message);
    account = request.auth.credentials
    sid = '' + account.profile.id
    this.cache.set sid,
      account: account
    , null, ( err ) ->
      if( err )
        reply( err )
      request.auth.session.set
        'sid': sid
      return reply.redirect '/'

  server.auth.strategy 'session', 'cookie',
    password: SocialAuthConfig.cookie.password
    cookie: 'sid-hapiauth'
    redirectTo: '/login'
    isSecure: false
    validateFunc: _validateFunc

  for provider of SocialAuthConfig.route
    config = SocialAuthConfig[provider]
    config.provider = provider
    config.password = SocialAuthConfig.cookie.password

    server.auth.strategy provider, 'bell', config

    server.route
      path: SocialAuthConfig.route[provider].callbackURL
      method: 'GET'
      config:
        auth: provider
        handler: _sessionManagement

  next()

exports.register.attributes =
  name: 'auth'
  version: '0.1.0'
