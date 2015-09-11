SocialAuthConfig = require('../../config/').get('/socialAuth')

console.log SocialAuthConfig

exports.register = ( plugin, options, next ) ->
  cache = plugin.cache
    expiresIn: 1 * 24 * 3600 * 1000 # 1 day

  plugin.app.cache = cache

  plugin.bind
    cache: plugin.app.cache

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
        'sid': account
      return reply.redirect '/'

  plugin.auth.strategy 'twitter', 'bell', SocialAuthConfig.twitter

  plugin.auth.strategy 'session', 'cookie',
    password: SocialAuthConfig.cookie.password
    cookie: 'sid-auth'
    redirectTo: '/login'
    isSecure: false
    validateFunc: _validateFunc

  plugin.route
    path: SocialAuthConfig.route.twitter.callbackURL
    method: 'GET'
    config:
      auth: 'twitter'
      handler: _sessionManagement

  next()

exports.register.attributes =
  name: 'auth'
  version: '0.1.0'
