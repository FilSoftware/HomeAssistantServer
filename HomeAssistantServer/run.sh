#!/usr/bin/with-contenv bashio 

bashio::log.info EXECUTE: /usr/dotnet-install.sh --runtime aspnetcore
#/usr/dotnet-install.sh --runtime aspnetcore

#bashio::log.info EXECUTE: printenv
#printenv

bashio::log.info EXECUTE: export DOTNET + PATH
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$HOME/.dotnet

#bashio::log.info EXECUTE: ifconfig
#ifconfig
 
#bashio::log.info dotnet --info
#dotnet --info

bashio::log.info BEFORE Hello world!
cd /usr/web
dotnet HomeAssistantServer.dll --urls "http://*:5000"
bashio::log.info AFTER Hello world!
