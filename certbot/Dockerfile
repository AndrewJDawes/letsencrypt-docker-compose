FROM certbot/certbot:latest

RUN apk update && \
    apk add --no-cache bash --no-cache docker-cli docker-cli-compose

COPY certbot.sh /opt/

RUN chmod 755 /opt/certbot.sh

RUN apk update && \
    apk add --no-cache docker-cli docker-cli-compose

WORKDIR /workdir

COPY cronfile /cronfile
RUN chmod 0644 /cronfile
RUN /usr/bin/crontab /cronfile

# ENTRYPOINT ["/opt/certbot.sh"]
ENTRYPOINT ["crond", "-f", "-l", "0"]
