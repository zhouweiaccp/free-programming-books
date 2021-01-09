#!/bin/bash


cat /etc/resolv.conf | while read line;do echo $line;done