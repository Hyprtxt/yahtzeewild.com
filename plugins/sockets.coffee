exports.register = ( server, options, next ) ->
  io = require('socket.io')(server.listener)

  io.on 'connection', ( socket ) ->
    socket
      .emit 'news', hello: 'world'
      .on 'client_event', ( data ) ->
        console.log data
        return
    return

  next()
  return

exports.register.attributes =
  name: 'sockets'
  version: '0.1.0'
