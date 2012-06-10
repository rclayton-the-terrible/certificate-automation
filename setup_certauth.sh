#!/bin/bash

hr="-------------------------------------------"
br=""
strength=1024
valid=365	

mkdir ca
mkdir server
mkdir server/certificates
mkdir server/requests
mkdir server/keys
mkdir user
mkdir user/certificates
mkdir user/requests
mkdir user/keys
mkdir user/p12

echo "01" > serial

touch index.txt

export OPENSSL_CONF=./conf/ca_openssl.cnf

echo $br
echo $hr
echo "CREATING CERTIFICATE AUTHORITY KEY"
echo $hr

openssl genrsa -des3 -out ./ca/ca.key $strength

echo $br
echo $hr
echo "CREATING CERTIFICATE REQUEST FOR CA"
echo $hr

openssl req -new -key ./ca/ca.key -out ./ca/ca.csr

echo $br
echo $hr
echo "CA SELF-SIGNING AND ISSUING CERTIFICATE"
echo $hr

openssl x509 -req -days $valid -in ./ca/ca.csr -out ./ca/ca.crt -signkey ./ca/ca.key 

echo $br
echo $hr
echo "DUMPING CERTIFICATE TO CONSOLE"
echo $hr

openssl x509 -in ./ca/ca.crt -text