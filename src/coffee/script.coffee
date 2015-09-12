socket = io 'http://localhost:8000'

socket
  .on 'connect', ->
    console.log 'ID', socket.io.engine.id
    return
  .on 'disconnect', ->
    console.log 'disconnected'
    return
  .on 'news', ( data ) ->
    console.log data
    socket.emit 'client_event', my: 'data is good'
    # socket.emit session.sid, data: 'from specific client'
    return
