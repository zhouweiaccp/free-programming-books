#!/bin/bash

wget https://dl.google.com/go/go1.13.5.src.tar.gz
tar -xf go1.13.5.src.tar.gz
cd  go/src
CGO_ENABLED=1 GOOS=linux GOARCH=arm GOARM=7 ./make.bash