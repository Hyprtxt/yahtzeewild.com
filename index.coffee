Hapi = require('hapi')
Path = require('path')
config = require('./config/secret')

server = new Hapi.Server(
  connections:
    routes:
      files:
        relativeTo: Path.join( __dirname, 'static' )
)

server.connection
  host: 'localhost'
  port: 8000

io = require('socket.io')(server.listener)

io.on 'connection', ( socket ) ->
  socket.emit 'news', hello: 'world'
  socket.on 'client_event', ( data ) ->
    console.log data

server.register [
  # static file serving
    register: require('inert')
  ,
  # view serving
    register: require('vision')
  ,
  # social login
    register: require('bell')
  ,
  # sessions
    register: require('hapi-auth-cookie')
  ,
  # combines social login with sessions
    register: require('./plugins/auth')
  ,
  # event logging
    register: require('good')
    options:
      opsInterval: 1000
      reporters:[
        reporter: require('good-console')
        events:
          log: '*'
          response: '*'
      ,
        reporter: require('good-file')
        events:
          log: '*'
          response: '*'
        config: Path.join( __dirname, 'log', 'good.log' )
      ]
], ( err ) ->
  if (err)
    throw err
  return

server.views
  engines:
    jade: require('jade')
  path: Path.join( __dirname , 'views' )
  compileOptions:
    pretty: true

# Error Routing
# server.ext('onPreResponse', ( request, reply ) ->
#   if !request.response.isBoom
#     reply.continue();
#   else
#     reply.view('error', request.response)
# )

# Routes

# Homepage
server.route
  method: 'GET'
  path: '/'
  config:
    auth: 'session'
    handler: (request, reply) ->
      data = require('./config/views')
      console.log request.auth
      data.auth = request.auth
      data.session = request.session
      reply.view 'index', data
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
    handler: (request, reply) ->
      data = require('./config/views')
      # console.log request.auth
      data.auth = request.auth
      reply.view 'login', data
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
