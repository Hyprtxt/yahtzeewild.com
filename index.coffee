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

server.register([
  { register: require('inert') }
  { register: require('bell') }
  { register: require('vision') }
  {
    register: require('good')
    options:
      opsInterval: 1000
      reporters:[
        reporter: require('good-console')
        events:
          log: '*'
          response: '*'
      ]
  }
], ( err ) ->
  if (err)
    throw err
  return
)

server.auth.strategy 'twitter', 'bell',
  provider: 'twitter'
  password: config.cookie.password
  clientId: config.twitter.clientId
  clientSecret:  config.twitter.clientSecret
  isSecure: false

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
  handler: (request, reply) ->
    data = require('./config/views')
    reply.view 'index', data
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

# Twitter Login
server.route
  method: [ 'GET', 'POST' ]
  path: config.twitter.callbackURL
  config:
    auth: 'twitter'
    handler: (request, reply) ->
      console.log request.auth
      # Perform any account lookup or registration, setup local session,
      # and redirect to the application. The third-party credentials are
      # stored in request.auth.credentials. Any query parameters from
      # the initial request are passed back via request.auth.credentials.query.
      reply.redirect '/'
      return

# Start the server
server.start ->
  console.log 'Server running at:', server.info.uri
  return
