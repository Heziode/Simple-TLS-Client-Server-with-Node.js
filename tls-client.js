#!/usr/bin/env node
'use strict';

const port = 8000;
const hostname = 'localhost';

const tls = require('tls');
const fs = require('fs');

const options = {
  host: hostname,
  port: port,

  // Necessary only if using the client certificate authentication
  key: fs.readFileSync('certs/client/client.key'),
  cert: fs.readFileSync('certs/client/client.crt'),

  // Necessary only if the server uses the self-signed certificate
  ca: fs.readFileSync('certs/ca/ca.crt')
};

const socket = tls.connect(options, () => {
  console.log('client connected', socket.authorized ? 'authorized' : 'unauthorized');
  if (!socket.authorized) {
    console.log("Error: ", client.authorizationError());
    socket.end();
  }
})
  .setEncoding('utf8')
  .on('data', (data) => {
    console.log("Received: ", data);

    // Close after receive data
    socket.end();
  })
  .on('close', () => {
    console.log("Connection closed");
  })
  .on('end', () => {
    console.log("End connection");
  })
  .on('error', (error) => {
    console.error(error);
    socket.destroy();
  });
