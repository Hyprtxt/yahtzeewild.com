Hapi = require('hapi')

config = require('./config/secret')

# Create a server with a host and port
server = new (Hapi.Server)

server.connection
  host: 'localhost'
  port: 8000

# Register bell with the server
server.register require('bell'), (err) ->
  server.auth.strategy 'twitter', 'bell',
    provider: 'twitter'
    password: config.cookie.password
    clientId: config.twitter.clientId
    clientSecret:  config.twitter.clientSecret
    isSecure: false
  return

# Add the route
server.route
  method: 'GET'
  path: '/'
  handler: (request, reply) ->
    reply 'hello world'
    return

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
