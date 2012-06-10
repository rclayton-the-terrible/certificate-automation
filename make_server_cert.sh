#!/bin/bash

hr="-------------------------------------------"
br=""
strength=1024
valid=365

message="Usage:  sh make_server_cert.sh [your_server_name@yourdomain.com]"

if [ $# -ne 1 ];
then
	echo $message
	exit 2
fi

if [ $1 = "--help" ];
then
	echo $message
	exit 2
fi

if [ ! -d ./server/ ];
then
	echo "Creating Server folder: server/"
	mkdir ./server/
	mkdir ./server/keys/
	mkdir ./server/certificates/
	mkdir ./server/requests/
fi

export OPENSSL_CONF=./conf/server_openssl.cnf

server=$1
sk=./server/keys/$server.key
sr=./server/requests/$server.csr
sc=./server/certificates/$server.crt

echo $br
echo $hr
echo "CREATING SERVER KEY"
echo $hr

openssl genrsa -des3 -out $sk $strength

echo $br
echo $hr
echo "CREATING SERVER CERTIFICATE REQUEST"
echo $hr

openssl req -new -key $sk -out $sr

echo $br
echo $hr
echo "CA SIGNING AND ISSUING SERVER CERTIFICATE"
echo $hr

openssl x509 -req -in $sr -out $sc -CA ./ca/ca.crt -CAkey ./ca/ca.key -CAcreateserial -days $valid

echo $br
echo $hr
echo "DUMPING CERTIFICATE TO CONSOLE"
echo $hr

openssl x509 -in $sc -text -noout