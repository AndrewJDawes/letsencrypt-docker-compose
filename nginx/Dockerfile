ARG ARCH=
FROM ${ARCH}/nginx:1.23.2-alpine

RUN apk add --no-cache openssl

COPY includes /etc/nginx/includes
COPY nginx.sh /customization/

RUN chmod +x /customization/nginx.sh

EXPOSE 80

CMD ["/customization/nginx.sh"]
