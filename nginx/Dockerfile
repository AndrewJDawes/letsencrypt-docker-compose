FROM nginx:1.23-alpine

RUN apk add --no-cache openssl

COPY includes /etc/nginx/includes
COPY nginx.sh /customization/

RUN chmod +x /customization/nginx.sh

EXPOSE 80

CMD ["/customization/nginx.sh"]