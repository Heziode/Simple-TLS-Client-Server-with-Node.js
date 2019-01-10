#!/usr/bin/env node
'use strict';

const tls = require('tls');
const fs = require('fs');
const port = 8000;

const options = {
  key: fs.readFileSync('certs/server/server.key'),
  cert: fs.readFileSync('certs/server/server.crt'),
  ca: fs.readFileSync('certs/ca/ca.crt'), // authority chain for the clients
  requestCert: true, // ask for a client cert
  //rejectUnauthorized: false, // act on unauthorized clients at the app level
};

const server = tls.createServer(options, (socket) => {
  socket.write('welcome!\n');
  socket.setEncoding('utf8');
  socket.pipe(socket);
})
  .on('connection', () => {
    console.log('insecure connection');
  })

  .on('secureConnection', (socket) => {
    // c.authorized will be true if the client cert presented validates with our CA
    console.log('secure connection; client authorized: ', socket.authorized);
  })

  .listen(port, () => {
    console.log('server listening on port ' + port + '\n');
  });
