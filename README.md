# nginx-perl (Docker)

Extension of official Nginx Perl (Docker) from https://hub.docker.com/_/nginx
with some perl test code. You can access this from the public repo
visago/nginx-perl

# Setup

```
docker run -d -p 80:80 --restart=always --name nginx visago/nginx-perl
```

Mount your own /www folder using -v if needed. 

# CGI URLs

There's a few sample URLs you can use

```
$ curl http://127.0.0.1/ip
172.17.0.1
```

```
$ curl http://127.0.0.1/debug
Host=127.0.0.1
request_method=GET
remote_addr=172.17.0.1
ip=172.17.0.1
```

# Speed test URLs 

WARNING: This can be abused if someone decides to requests this too often ! (Bandwidth abuse)

The webserver serves static content via /www. You can mount to a local
folder via -v.

```
docker run -d -p 80:80 --restart=always --name nginx -v /www:/www visago/nginx-perl 
```

Assuming there's a test.dat binary file in /www, you can do rate limited
tests via a special url of /XXX/test.dat

```
curl http://127.0.0.1/8/test.dat
```
Will get the file test.dat with a speed rate limit of 8k/s

Available speeds are 1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384

There's also an endpoint called /random which will generate X bytes from
/dev/urandom

```
curl http://127.0.0.1/random/16/1024000
```
Will get a random file of size 1024000 bytes at a speed of 16k/s
