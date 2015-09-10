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
    register: require('inert')
  ,
    register: require('bell')
  ,
    register: require('vision')
  ,
    register: require('hapi-auth-cookie')
  ,
    register: require('./plugins/auth')
  ,
    register: require('good')
    options:
      opsInterval: 1000
      reporters:[
        reporter: require('good-console')
        events:
          log: '*'
          response: '*'
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
