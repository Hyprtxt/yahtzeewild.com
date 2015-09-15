# modules
Hapi = require('hapi')
Path = require('path')

# functions
setupTmp = require('./functions/setupTmp')
throwErr = require('./functions/throwErr')

# server
server = new Hapi.Server()

server.connection require('./config/connection').get('/connectionConfig')

setupTmp() # creates `./logs/good.log` if needed

server.register require('./config/plugins'), throwErr

server.views require('./config/views').get('/viewConfig')

# Homepage
server.route
  method: 'GET'
  path: '/'
  config:
    auth: 'session'
    pre: [ server.plugins['jadeHelper'].jadeRouteSetup ]
    handler: ( request, reply ) ->
      reply.view 'index', request.pre
      return

# Start the server
server.start ->
  console.log 'Server running at:', server.info.uri
  return
