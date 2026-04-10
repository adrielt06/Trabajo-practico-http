FROM httpd:latest

RUN apt-get update && \
    apt-get install -y openssl && \
    rm -rf /var/lib/apt/lists/*

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /usr/local/apache2/conf/server.key \
    -out /usr/local/apache2/conf/server.crt \
    -subj "/CN=localhost"

RUN sed -i \
    -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_http2.so\)/\1/' \
    conf/httpd.conf

RUN echo "Include conf/custom.conf" >> conf/httpd.conf

COPY ./custom.conf /usr/local/apache2/conf/custom.conf
COPY ./home.html /usr/local/apache2/htdocs/home.html