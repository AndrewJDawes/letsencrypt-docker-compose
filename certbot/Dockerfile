FROM certbot/certbot:v1.7.0

RUN apk update && \
    apk add --no-cache bash --no-cache docker-cli docker-cli-compose

COPY certbot.sh /opt/

RUN chmod +x /opt/certbot.sh

RUN apk update && \
    apk add --no-cache docker-cli docker-cli-compose

WORKDIR /workdir

COPY cronfile /cronfile
RUN chmod 0644 /cronfile
RUN /usr/bin/crontab /cronfile

# ENTRYPOINT ["/opt/certbot.sh"]
ENTRYPOINT ["crond", "-f", "-l", "0"]
