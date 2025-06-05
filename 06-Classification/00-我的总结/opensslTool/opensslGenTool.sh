#!/bin/sh

#CA证书名
CAName = "ca"

#签发证书名
OutPutCertificateName = "server"

#CA证书配置信息


#签发证书配置信息
printf "[req]
prompt                  = no
default_bits            = 4096
default_md              = sha256
encrypt_key             = no
string_mask             = utf8only

distinguished_name      = cert_distinguished_name
req_extensions          = req_x509v3_extensions
x509_extensions         = req_x509v3_extensions

[cert_distinguished_name]
C  = CN
ST = BJ
L  = BJ
O  = HomeLab
OU = HomeLab
CN = www.kedacom.com

[req_x509v3_extensions]
basicConstraints        = critical,CA:true
subjectKeyIdentifier    = hash
keyUsage                = critical,digitalSignature,keyCertSign,cRLSign #,keyEncipherment
extendedKeyUsage        = critical,serverAuth #, clientAuth
subjectAltName          = @alt_names

[alt_names]
DNS.1 = 10.67.76.7
DNS.2 = 10.67.76.8

">ssl/${OutPutCertificateName}.conf

#openssl req -x509 -newkey rsa:2048 -keyout ssl/$OutPutCertificateName.key -out ssl/$OutPutCertificateName.crt -days 3600 -nodes -config ssl/${OutPutCertificateName}.conf


#生成CA

case $1 in
	"CAKey")
	#生成CA根证书及CA签名文件
	openssl req -x509 -newkey rsa:2048 -nodes -keyout $CAName.key -out $CAName.crt -days 3650 -subj "/C=CN/ST=jiangsu/L=suzhou/O=kedacom/OU=mpu/CN=www.kedacom.com"
		;;
	"ServerKey")
	#生成跟证书及签名请求文件
	openssl req -new -newkey rsa:2048 -nodes -keyout $OutPutCertificateName.key -out $OutPutCertificateName.csr -subj "/C=CN/ST=shanghai/L=shanghai/O=example/OU=it/CN=domain1/CN=domain2"
		;;
	"Sign")
	#签名
	openssl x509 -req -in $OutPutCertificateName.csr -CA $CAName.crt -CAkey $CAName.key -CAcreateserial -out $OutPutCertificateName.crt -days 3650	
		;;
	#校验是否有CA证书签发
	"Verify")
	openssl verify -CAfile $CAName.crt $OutPutCertificateName.crt	
		;;
	esac;
