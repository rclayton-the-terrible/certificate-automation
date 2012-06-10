#!/bin/bash

hr="-------------------------------------------"
br=""
strength=1024
valid=365

message="Usage:  sh new_client_cert.sh [client_name@yourdomain.com]"

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

if [ ! -d ./user/ ];
then
	echo "Creating User folder: user/"
	mkdir ./user/
	mkdir ./user/keys/
	mkdir ./user/requests/
	mkdir ./user/certificates/
	mkdir ./user/p12/
fi

export OPENSSL_CONF=./conf/client_openssl.cnf

user=$1
uk=./user/keys/$user.key
ur=./user/requests/$user.csr
uc=./user/certificates/$user.crt
up=./user/p12/$user.p12

echo $br
echo $hr
echo "CREATING CLIENT KEY"
echo $hr

openssl genrsa -des3 -out $uk $strength

echo $br
echo $hr
echo "CREATING CLIENT CERTIFICATE REQUEST"
echo $hr

openssl req -new -key $uk -out $ur

echo $br
echo $hr
echo "CA SIGNING AND ISSUING CLIENT CERTIFICATE"
echo $hr

openssl x509 -req -in $ur -out $uc -CA ./ca/ca.crt -CAkey ./ca/ca.key -CAcreateserial -days $valid

echo $br
echo $hr
echo "CREATING A PKCS#12 CERTIFICATE FOR BROWSER"
echo $hr

openssl pkcs12 -export -clcerts -in $uc -inkey $uk -out $up

echo $br
echo $hr
echo "DUMPING CERTIFICATE TO CONSOLE"
echo $hr

openssl x509 -in $uc -text -noout