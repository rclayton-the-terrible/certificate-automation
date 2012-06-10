#!/bin/bash

rm -R ca
rm -R user
rm -R server
rm index.txt
rm serial

if [ -f ./.srl ];
then
	rm ./.srl
fi