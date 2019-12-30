FROM nginx:perl
RUN mkdir -p /www
COPY NginxTest.pm /etc/nginx/NginxTest.pm
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /www
