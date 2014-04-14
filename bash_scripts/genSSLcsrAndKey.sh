#!/bin/bash
 
#
# This script was written by James Coyle 
# http://www.jamescoyle.net/how-to/1073-bash-script-to-create-an-ssl-certificate-key-and-request-csr
#
# Stashed here on Github so that I don't have to remember where it is the next time I need it.
#  
# Modified to remove the passphrase generation and removal since it's unnecessary, and can be
# generated without a password to begin with - James Andrews
#
 
#Required
domain=$1
quiet=$2
commonname=$domain
 
#Change to your company details
country=GB
state=Nottingham
locality=Nottinghamshire
organization=Jamescoyle.net
organizationalunit=IT
email=administrator@jamescoyle.net
 
if [ -z "$domain" ]
then
    echo "Argument not present."
    echo "Useage $0 [common name]"
 
    exit 99
fi

if [ $quiet -eq "-q"]
then    
    quiet=true
fi
 
echo "Generating key request for $domain"
openssl genrsa -out $domain.key 2048

#Create the request
echo "Creating CSR"
openssl req -new -key $domain.key -out $domain.csr \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
 
echo "Creating self signed certificate good for 365 days"
openssl x509 -req -days 365 -in $domain.csr -signkey $domain.key -out $domain.crt

if [ ! $quiet ]
then    
echo "-----------------------------------------"
echo "-----       Below is your CSR       -----"
echo "-----------------------------------------"
echo
cat $domain.csr
fi
 
if [ ! $quiet ]
then    
echo
echo "-----------------------------------------"
echo "-----       Below is your Key       -----"
echo "-----------------------------------------"
echo
cat $domain.key
fi

if [ ! $quiet ]
then    
echo
echo "-----------------------------------------"
echo "----- Below is your self signed CRT -----"
echo "-----------------------------------------"
echo
cat $domain.crt
fi