socket = io 'http://localhost:8000'

socket
  .on 'connect', ->
    console.log 'conneted'
  .on 'disconnect', ->
    console.log 'disconnected'
  .on 'news', ( data ) ->
    console.log data
    socket.emit 'client_event', my: 'data is good'
