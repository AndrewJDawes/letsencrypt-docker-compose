#!/bin/bash

set -e

trap exit INT TERM

cd /workdir

if [ -z "$DOMAINS" ]; then
  echo "DOMAINS environment variable is not set"
  exit 1;
fi

# until nc -z nginx 80; do
#   echo "Waiting for nginx to start..."
#   sleep 5s & wait ${!}
# done

if [ "$CERTBOT_TEST_CERT" != "0" ]; then
  test_cert_arg="--test-cert"
fi
should_nginx_reload=0
domains_fixed=$(echo "$DOMAINS" | tr -d \")
domain_list=($domains_fixed)
emails_fixed=$(echo "$CERTBOT_EMAILS" | tr -d \")
emails_list=($emails_fixed)
for i in "${!domain_list[@]}"; do
  domain="${domain_list[i]}"

  mkdir -p "/var/www/certbot/$domain"

  # If cert already exists, copy over to overwrite nginx dummy certs
  if [ -d "/etc/letsencrypt/live/$domain" ]; then
    echo "Let's Encrypt certificate for $domain already exists"
    echo "Copying /etc/letsencrypt/live/${domain}/fullchain.pem to /etc/nginx/site_certs/${domain}/fullchain.pem"
    cp -f "/etc/letsencrypt/live/${domain}/fullchain.pem" "/etc/nginx/site_certs/${domain}/fullchain.pem";
    echo "Copying /etc/letsencrypt/live/${domain}/privkey.pem to /etc/nginx/site_certs/${domain}/privkey.pem"
    cp -f "/etc/letsencrypt/live/${domain}/privkey.pem";
    echo "Will reload nginx"
    should_nginx_reload=1
    continue
  fi

  email="${emails_list[i]}"
  if [ -z "$email" ]; then
    email_arg="--register-unsafely-without-email"
    echo "Obtaining the certificate for $domain without email"
  else
    email_arg="--email $email"
    echo "Obtaining the certificate for $domain with email $email"
  fi

  certbot certonly \
    --webroot \
    -w "/var/www/certbot/$domain" \
    -d "$domain" \
    $test_cert_arg \
    $email_arg \
    --rsa-key-size "${CERTBOT_RSA_KEY_SIZE:-4096}" \
    --agree-tos \
    --noninteractive \
    --verbose || true
done

if [ $should_nginx_reload -eq 1 ]; then
  docker compose exec --no-TTY nginx nginx -s reload
fi