#!/bin/bash

 mkdir /usr/share/dotnet
wget https://download.visualstudio.microsoft.com/download/pr/f0b6c052-2f5d-42b9-8ffa-870ea2a60d11/90c1d5b4a2548c1beaeacff0a39a459c/aspnetcore-runtime-2.2.7-linux-x64.tar.gz &&  tar -zxvf aspnetcore-runtime-2.2.7-linux-x64.tar.gz -C /usr/share/dotnet/ && rm -f aspnetcore-runtime-2.2.7-linux-x64.tar.gz
 ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
