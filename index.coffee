Hapi = require 'hapi'

server = new Hapi.Server()

server.connection require('./config').get '/connection'

server.register require('./config').get('/plugin'), ( err ) ->
  if( err )
    throw err
  return

server.views require('./config').get '/view'

fs = require 'fs'
exec = require('child_process').exec

nginx_dir = '/usr/local/etc/nginx'

# Homepage
server.route
  method: 'GET'
  path: '/'
  config:
    pre: [ server.plugins['jade'].global ]
    handler: ( request, reply ) ->
      return fs.readdir nginx_dir + '/available', ( err, available ) ->
        request.pre.dirs = available
        # return fs.readdir nginx_dir + '/enabled', ( err, enabled ) ->
          # console.log files
        return reply.view 'index', request.pre

server.route
  method: 'GET'
  path: '/restart'
  config:
    handler: ( request, reply ) ->
      exec 'nginx -s reload', ( err, stdout, stderr ) ->
        if err
          throw err
        console.log stdout
        console.log stderr
        return reply stdout

server.route
  method: 'GET'
  path: '/developer'
  config:
    pre: [ server.plugins['jade'].global ]
    handler: ( request, reply ) ->
      return fs.readdir nginx_dir + '/developer', ( err, files ) ->
        request.pre.dirs = files
        console.log files
        return reply.view 'index', request.pre

server.start ->
  return console.log 'Server running at:', server.info.uri
