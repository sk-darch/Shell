#!/bin/bash
#converting pem to jks file
openssl pkcs12 -export -in fullchain.pem -inkey privkey.pem -out fullchain.pkcs12 -password pass:<password>
echo -e "**************************\nGenrating Keystore file\n**************************"
keytool -v -importkeystore -srckeystore fullchain.pkcs12 -srcstorepass <password> -destkeystore server.keystore.jks -deststoretype JKS -storepass <password>
echo -e "**************************\nChanging Keystore Alias Name\n**************************"
keytool -keystore server.keystore.jks -changealias -alias 1 -destalias <aliasname> -storepass <password>
echo -e "**************************\nGenrating Truststore file\n**************************"
keytool -v -importkeystore -srckeystore fullchain.pkcs12 -srcstorepass <password> -destkeystore server.truststore.jks -deststoretype JKS -storepass <password>
echo -e "**************************\nChanging Truststore Alias Name\n**************************"
keytool -keystore server.truststore.jks -changealias -alias 1 -destalias <aliasname> -storepass <password>
echo "Done"
