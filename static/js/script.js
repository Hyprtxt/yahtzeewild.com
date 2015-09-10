console.log( 'script.js is delta' );
var socket = io('http://localhost:8000');

socket.on('news', function (data) {
  console.log(data);
  socket.emit('client_event', { my: 'data' });
});
