#!/bin/bash
NAME=jmcarbo/openerp-ooor
TAG=latest
sudo docker build $@ -t $NAME:$TAG . 
#docker push $NAME
