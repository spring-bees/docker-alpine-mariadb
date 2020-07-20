FROM coolbeevip/docker-alpine:3.12

MAINTAINER coolbeevip <coolbeevip@gmail.com>

WORKDIR /app
VOLUME /app
COPY startup.sh /startup.sh
RUN apk add --update mysql mysql-client && rm -f /var/cache/apk/*
COPY my.cnf /etc/mysql/my.cnf

EXPOSE 3306
CMD ["/startup.sh"]
