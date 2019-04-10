#!/bin/bash

if test $# -eq 0; then
    echo "Usage: ./genkey.sh <path to store certs directory>"
    exit 0
elif test $# -ne 1; then
    echo "Invalid number of arguments"
    exit 1
fi

ROOTPATH="$1"

# make directories to work from
mkdir -p $ROOTPATH/certs/{server,client,ca,tmp}

PATH_CA=$ROOTPATH/certs/ca
PATH_SERVER=$ROOTPATH/certs/server
PATH_CLIENT=$ROOTPATH/certs/client
PATH_TMP=$ROOTPATH/certs/tmp

echo "###############################################################################"
echo -e "#\033[33m     _____      _  __        _____ _                      _                  \033[0m#"
echo -e "#\033[33m    /  ___|    | |/ _|      /  ___(_)                    | |                 \033[0m#"
echo -e "#\033[33m    \ \`--.  ___| | |_ ______\ \`--. _  __ _ _ __   ___  __| |                 \033[0m#"
echo -e "#\033[33m     \`--. \/ _ \ |  _|______|\`--. \ |/ _\` | '_ \ / _ \/ _\` |                 \033[0m#"
echo -e "#\033[33m    /\__/ /  __/ | |        /\__/ / | (_| | | | |  __/ (_| |                 \033[0m#"
echo -e "#\033[33m    \____/ \___|_|_|        \____/|_|\__, |_| |_|\___|\__,_|                 \033[0m#"
echo -e "#\033[33m                                      __/ |                                  \033[0m#"
echo -e "#\033[33m                                     |___/                                   \033[0m#"
echo -e "#\033[33m   _____           _         _____                           _               \033[0m#"
echo -e "#\033[33m  /  __ \         | |       |  __ \                         | |              \033[0m#"
echo -e "#\033[33m  | /  \/ ___ _ __| |_ ___  | |  \/ ___ _ __   ___ _ __ __ _| |_ ___  _ __   \033[0m#"
echo -e "#\033[33m  | |    / _ \ '__| __/ __| | | __ / _ \ '_ \ / _ \ '__/ _\` | __/ _ \| '__|  \033[0m#"
echo -e "#\033[33m  | \__/\  __/ |  | |_\__ \ | |_\ \  __/ | | |  __/ | | (_| | || (_) | |     \033[0m#"
echo -e "#\033[33m   \____/\___|_|   \__|___/  \____/\___|_| |_|\___|_|  \__,_|\__\___/|_|     \033[0m#"
echo -e "#\033[33m                                                                             \033[0m#"
echo -e "###############################################################################\n"

echo -e "###############"
echo -e "# Global conf #"
echo -e "###############\n"

RSABITS=4096

echo -n "RSA bit length [$RSABITS]:"
read RSABITS

if [ ${#RSABITS} -eq 0 ]; then
    RSABITS=4096
fi

EXPIREDAYS=365

echo -n "Expire days [$EXPIREDAYS]:"
read EXPIREDAYS

if [ ${#EXPIREDAYS} -eq 0 ]; then
    EXPIREDAYS=365
fi

while [ ${#PASSWORD} -lt 4 ]; do
    echo -n "Password for certs []:"
    read -s PASSWORD
    echo
    if [ ${#PASSWORD} -lt 4 ]; then
        echo "Password length cannot be lower than 4 chars"
    fi
done

echo -e "\n################"
echo -e "# OpenSSL conf #"
echo -e "################\n"

# Classic openssl prompt
GK_C="FR"
echo -n "(C) Country Name (2 letter code) [$GK_C]:"
read GK_C

if [ ${#GK_C} -eq 0 ]; then
GK_C="FR"
fi

echo -n "(ST) State or Province Name (full name) []:"
read GK_ST

if [ ${#GK_ST} -eq 0 ]; then
GK_ST="."
fi

echo -n "(L) Locality Name (eg, city) []:"
read GK_L

if [ ${#GK_L} -eq 0 ]; then
GK_L="."
fi

GK_O="ACME Signing Authority Inc"
echo -n "(O) Organization Name (eg, company) [$GK_O]:"
read GK_O

if [ ${#GK_O} -eq 0 ]; then
GK_O="ACME Signing Authority Inc"
fi

echo -n "(OU) Organizational Unit Name (eg, section) []:"
read GK_OU

if [ ${#GK_OU} -eq 0 ]; then
GK_OU="."
fi

echo -n "(CN) Common Name (eg, your name or your server's hostname) []:"
read GK_CN

if [ ${#GK_CN} -eq 0 ]; then
    GK_CN="."
fi

echo -n "(emailAddress) Email Address []:"
read GK_emailAddress

if [ ${#GK_emailAddress} -gt 0 ]; then
    GK_emailAddress="/emailAddress=$GK_emailAddress"
fi

echo
echo "Please enter the following 'extra' attributes"
echo "to be sent with your certificate request"
echo -n "(unstructuredName) An optional company name []:"
read GK_unstructuredName

if [ ${#GK_unstructuredName} -gt 0 ]; then
GK_unstructuredName="/unstructuredName=$GK_unstructuredName"
fi

echo

OTHER_FIELDS=""
ADD_OTHER_FIELD="Y"
while [ "$ADD_OTHER_FIELD" = "y" ] || [ "$ADD_OTHER_FIELD" = "Y" ]; do
    ADD_OTHER_FIELD="N"
    echo -n "Add other field [y/N] ? "
    read ADD_OTHER_FIELD

    if [ "$ADD_OTHER_FIELD" = "y" ] || [ "$ADD_OTHER_FIELD" = "Y" ]; then
        echo -n "Field name: "
        read OTHER_FIELD_NAME

        echo -n "Field value: "
        read OTHER_FIELD_VALUE

        if [ ${#OTHER_FIELD_VALUE} -eq 0 ]; then
            OTHER_FIELD_VALUE="."
        fi

        OTHER_FIELDS="$OTHER_FIELDS/$OTHER_FIELD_NAME=$OTHER_FIELD_VALUE"
    fi
done

echo -e "\n##################"
echo -e "# Generate certs #"
echo -e "##################\n"

######
# CA #
######

echo -e "# CA\n"

openssl genrsa -des3 -passout pass:$PASSWORD -out $PATH_CA/ca.key $RSABITS

# Create Authority Certificate
openssl req -new -x509 -days $EXPIREDAYS -key $PATH_CA/ca.key -out $PATH_CA/ca.crt -passin pass:$PASSWORD -subj "/C=$GK_C/ST=$GK_ST/L=$GK_L/O=$GK_O/OU=$GK_OU/CN=.$GK_unstructuredName$GK_emailAddress$GK_subjectAltName$OTHER_FIELDS"

##########
# SERVER #
##########

echo -e "\n# Server\n"

# Generate server key
openssl genrsa -out $PATH_SERVER/server.key $RSABITS

# Generate server cert
openssl req -new -key $PATH_SERVER/server.key -out $PATH_TMP/server.csr -passout pass:$PASSWORD -subj "/C=$GK_C/ST=$GK_ST/L=$GK_L/O=$GK_O/OU=$GK_OU/CN=$GK_CN$GK_unstructuredName$GK_emailAddress$GK_subjectAltName$OTHER_FIELDS"

# Sign server cert with self-signed cert
openssl x509 -req -days $EXPIREDAYS -passin pass:$PASSWORD -in $PATH_TMP/server.csr -CA $PATH_CA/ca.crt -CAkey $PATH_CA/ca.key -set_serial 01 -out $PATH_SERVER/server.crt

##########
# CLIENT #
##########

echo -e "\n# Client\n"

openssl genrsa -out $PATH_CLIENT/client.key $RSABITS

openssl req -new -key $PATH_CLIENT/client.key -out $PATH_TMP/client.csr -passout pass:$PASSWORD -subj "/C=$GK_C/ST=$GK_ST/L=$GK_L/O=$GK_O/OU=$GK_OU/CN=CLIENT$GK_unstructuredName$GK_emailAddress$GK_subjectAltName$OTHER_FIELDS"

openssl x509 -req -days 365 -passin pass:$PASSWORD -in $PATH_TMP/client.csr -CA $PATH_CA/ca.crt -CAkey $PATH_CA/ca.key -set_serial 01 -out $PATH_CLIENT/client.crt

# Clean tmp dir

rm -rf $PATH_TMP

echo -e "\nDone !"

exit 0
