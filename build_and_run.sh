#!/bin/bash
#
docker build -t visago/nginx-perl .
docker stop nginx
docker rm nginx
docker run -d -p 80:80 --restart=always --name nginx visago/nginx-perl
