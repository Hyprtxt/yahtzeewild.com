console.log 'dev tools never so cool'
socket = io 'http://localhost:8000'

socket.on 'news', ( data ) ->
  console.log data
  socket.emit 'client_event', my: 'data is good'
