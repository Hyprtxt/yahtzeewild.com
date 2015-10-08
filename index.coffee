Hapi = require 'hapi'
Boom = require 'boom'

setupDir = require './modules/setup-dir'
throwErr = require './modules/throw-err'

setupDir() # creates `./logs/good.log` if needed

server = new Hapi.Server()

server.connection require('./config').get '/connection'

server.register require('./config').get('/plugin'), throwErr

server.views require('./config').get '/view'

# Homepage
server.route
  method: 'GET'
  path: '/'
  config:
    pre: [ server.plugins['jade'].global ]
    handler: ( request, reply ) ->
      return reply.view 'index', request.pre

# Static
server.route
  method: 'GET'
  path: '/{param*}'
  handler:
    directory:
      path: [
        './static/'
        './static_generated/'
      ]
      redirectToSlash: true
      listing: true

server.route
  method: 'GET'
  path: '/{jade}/'
  config:
    pre: [ server.plugins['jade'].global ]
    handler: ( request, reply ) ->
      console.log 'try' + request.params.jade
      request.render request.params.jade, request.pre, ( err, rendered, config ) ->
        if err
          return reply Boom.badRequest 'template not found', 404
        else
          return reply rendered

server.start ->
  return console.log 'Server running at:', server.info.uri
