FROM ubuntu:14.04.4
# RUN apt-get update && \
#     apt-get install -y git software-properties-common python-software-properties \
#     libexpat1-dev libgd-dev && \
#     add-apt-repository -y ppa:nginx/stable && \
#     git clone https://github.com/anomalizer/ngx_aws_auth.git /tmp/ngx_aws_auth && \
#     echo 'deb-src http://ppa.launchpad.net/nginx/stable/ubuntu trusty main' >> /etc/apt/sources.list.d/nginx-stable-trusty.list && \
#     apt-get update && \
#     apt-get install -y dpkg-dev nginx && \
#     mkdir /tmp/rebuildingnginx
#
# WORKDIR /tmp/rebuildingnginx
#
# RUN apt-get source -y nginx && \
#     apt-get build-dep -y nginx
#
# ADD rules /tmp/rebuildingnginx/nginx-1.8.1/debian/rules
#
# WORKDIR /tmp/rebuildingnginx/nginx-1.8.1
#
# RUN dpkg-buildpackage -b && \
#     dpkg -i /tmp/rebuildingnginx/nginx-full_1.8.1-1+trusty0_amd64.deb && \
#     apt-get clean && \
#     update-rc.d -f nginx remove && \
#     echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
#     chown -R www-data:www-data /var/lib/nginx && \
#     rm -f /etc/nginx/sites-enabled/default && \
#     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && \
    apt-get -y install nginx curl build-essential libpcre3 libpcre3-dev zlib1g-dev libssl-dev git && \
    curl -LO http://nginx.org/download/nginx-1.9.12.tar.gz && \
    tar zxf nginx-1.9.12.tar.gz && \
    cd nginx-1.9.12 && \
    git clone https://github.com/anomalizer/ngx_aws_auth.git && \
    ./configure --with-http_ssl_module --add-module=ngx_aws_auth && \
    make install && \
    cd /tmp && \
    rm -f nginx-1.9.12.tar.gz && \
    rm -rf nginx-1.9.12 && \
    apt-get purge -y curl git && \
    apt-get autoremove -y && \
    update-rc.d -f nginx remove && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    chown -R www-data:www-data /var/lib/nginx && \
    rm -f /etc/nginx/sites-enabled/default && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

WORKDIR /etc/nginx

EXPOSE 80
EXPOSE 443

CMD /usr/sbin/nginx
