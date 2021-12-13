#!/bin/ash
#https://raw.githubusercontent.com/jsorling/miscscripts/main/alpine/machine/get-dotnetsdk.sh
#Target directory for .Net
[ ! -d /opt/dotnet ] && mkdir /opt/dotnet

apk add --no-cache wget

#Install reuired packages for .Net
apk add --no-cache \
	icu-libs \
	krb5-libs \
	libgcc \
	libintl \
	libssl1.1 \
	libstdc++ \
	zlib

#Fetch and extract latest .Net sdk
#https://github.com/dotnet/arcade/issues/5757#issue-653403623
wget https://aka.ms/dotnet/6.0/dotnet-sdk-linux-musl-x64.tar.gz
	  
tar xvzf dotnet-sdk-linux-musl-x64.tar.gz -C /opt/dotnet
rm dotnet-sdk-linux-musl-x64.tar.gz

#Create symolic link
ln -s /opt/dotnet/dotnet /usr/bin/dotnet

chmod +x "$0"