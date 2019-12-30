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


