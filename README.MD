# Simble TLS Client/Server with Node.js

This project it's just a simple example of client/server app with Node.js

## How to use

### Initialisation

Juste clone this repo and run **genkey.sh** (sorry for Windows users) for create all certificates and keys.

- The first param it's the location where you want to the keys and certs was created. (for this exemple, just '**.**')
- The second param it's the server hostname, exemble : myWebSite.com (for this exemple, just '**localhost**')
- The third arguments is the CA password

### Working

Next, execute `node tls-server` for run the server.

And then run the client with `node tls-client`.

### Traceback

Server side, the terminal displays :

```
server listening on port 8000

insecure connection
secure connection; client authorized:  true
```

And client side :

```
client connected authorized
End connection
```

## Credits

Thanks [ceejbot](https://github.com/ceejbot), the script for key and certs generation it's based on the topic [Using client certs in node.js
](http://ceejbot.tumblr.com/post/39969163196/using-client-certs-in-nodejs)

## Licence

MIT
