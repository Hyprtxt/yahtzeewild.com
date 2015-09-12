# modules
Hapi = require('hapi')
Path = require('path')

# functions
setupTmp = require('./functions/setupTmp')
throwErr = require('./functions/throwErr')

# server
server = new Hapi.Server require('./config/server')

server.connection require('./config/connection')

setupTmp() # creates `./logs/good.log` if needed

server.register require('./config/plugins'), throwErr

server.views require('./config/views')

_jadeRouteSetup = ( request, reply ) ->
  request.pre = require './config/frontend'
  request.pre.auth = request.auth
  request.pre.session = request.auth.artifacts
  return reply()

# Homepage
server.route
  method: 'GET'
  path: '/'
  config:
    auth: 'session'
    pre: [ _jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'index', request.pre
      return

server.route
  method: 'GET'
  path: '/login'
  config:
    auth:
      strategy: 'session'
      mode: 'try'
    plugins:
      'hapi-auth-cookie':
        redirectTo: false
    pre: [ _jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'login', request.pre
      return

server.route
  method: 'GET'
  path: '/logout'
  config:
    auth: 'session'
    handler: ( request, reply ) ->
      request.auth.session.clear()
      return reply.redirect('/login')

# Static
server.route
  method: 'GET'
  path: '/{param*}'
  handler:
    directory:
      path: '.'
      redirectToSlash: true
      listing: true

# Start the server
server.start ->
  console.log 'Server running at:', server.info.uri
  return
