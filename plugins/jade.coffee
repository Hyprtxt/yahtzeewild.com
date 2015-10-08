exports.register = ( server, options, next ) ->

  server.expose 'global', ( request, reply ) ->
    request.pre = require '../view-data/global'
    return reply()

  server.expose 'session', ( request, reply ) ->
    # request.pre.auth = request.auth
    request.pre.session = request.auth.artifacts
    return reply()

  return next()

exports.register.attributes =
  name: 'jade'
  version: '0.1.0'
