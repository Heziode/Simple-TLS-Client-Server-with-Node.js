# Simple TLS Client/Server with Node.js

This project it's just a simple example of client/server app with Node.js

## How to use

### Initialisation

Just clone this repo and run **genkey.sh** (sorry for Windows users) for create all certificates and keys.
It take only one parameter that should be the location where you want to store keys and certs. (for this repo example, just run with '**.**')

Example: `./genkey.sh .`

should show something like that:

```
###############################################################################
#     _____      _  __        _____ _                      _                  #
#    /  ___|    | |/ _|      /  ___(_)                    | |                 #
#    \ `--.  ___| | |_ ______\ `--. _  __ _ _ __   ___  __| |                 #
#     `--. \/ _ \ |  _|______|`--. \ |/ _` | '_ \ / _ \/ _` |                 #
#    /\__/ /  __/ | |        /\__/ / | (_| | | | |  __/ (_| |                 #
#    \____/ \___|_|_|        \____/|_|\__, |_| |_|\___|\__,_|                 #
#                                      __/ |                                  #
#                                     |___/                                   #
#   _____           _         _____                           _               #
#  /  __ \         | |       |  __ \                         | |              #
#  | /  \/ ___ _ __| |_ ___  | |  \/ ___ _ __   ___ _ __ __ _| |_ ___  _ __   #
#  | |    / _ \ '__| __/ __| | | __ / _ \ '_ \ / _ \ '__/ _` | __/ _ \| '__|  #
#  | \__/\  __/ |  | |_\__ \ | |_\ \  __/ | | |  __/ | | (_| | || (_) | |     #
#   \____/\___|_|   \__|___/  \____/\___|_| |_|\___|_|  \__,_|\__\___/|_|     #
#                                                                             #
###############################################################################

###############
# Global conf #
###############

RSA bit length [4096]:
Expire days [365]:
Password for certs []:
Password length cannot be lower than 4 chars
Password for certs []:

################
# OpenSSL conf #
################

(C) Country Name (2 letter code) [FR]:
(ST) State or Province Name (full name) []:
(L) Locality Name (eg, city) []:
(O) Organization Name (eg, company) [ACME Signing Authority Inc]:
(OU) Organizational Unit Name (eg, section) []:
(CN) Common Name (eg, your name or your server's hostname) []:localhost
(emailAddress) Email Address []:a@b.c

Please enter the following 'extra' attributes
to be sent with your certificate request
(unstructuredName) An optional company name []:

Add other field [y/N] ? y
Field name: subjectAltName
Field value: DNS:localhost,DNS:www.localhost.com      
Add other field [y/N] ? 

##################
# Generate certs #
##################

# CA

Generating RSA private key, 4096 bit long modulus (2 primes)
.............................................................................................................................................................................................++++
................................................++++
e is 65537 (0x010001)

# Server

Generating RSA private key, 4096 bit long modulus (2 primes)
...............................................++++
.....................................................................................................................................................................................++++
e is 65537 (0x010001)
Signature ok
subject=C = FR, ST = ., L = ., O = ACME Signing Authority Inc, OU = ., CN = localhost, emailAddress = a@b.c, subjectAltName = "DNS:localhost,DNS:www.localhost.com"
Getting CA Private Key

# Client

Generating RSA private key, 4096 bit long modulus (2 primes)
.....................++++
..........................................................................................................................................................................................................................++++
e is 65537 (0x010001)
Signature ok
subject=C = FR, ST = ., L = ., O = ACME Signing Authority Inc, OU = ., CN = CLIENT, emailAddress = a@b.c, subjectAltName = "DNS:localhost,DNS:www.localhost.com"
Getting CA Private Key

Done !
```

### How does it work ?

Execute `node tls-server` to run the server.

And then run (in another terminal) the client with `node tls-client`.

### Traceback

Server side, the terminal should displays :

```
server listening on port 8000

insecure connection
secure connection; client authorized:  true
```

And on the client side :

```
client connected authorized
End connection
```

## Credits

Thanks [ceejbot](https://github.com/ceejbot), the script for key and certs generation it's based on the topic [Using client certs in node.js
](http://ceejbot.tumblr.com/post/39969163196/using-client-certs-in-nodejs)

## Licence

MIT
