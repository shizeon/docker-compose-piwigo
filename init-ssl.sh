#!/bin/bash
DOMAIN="home.bridgetek.com"
RSA_KEY_SIZE=4096
DATA_PATH="./piwigo-data/certbot"
EMAIL="sean@bridgetek.com" # Adding a valid email is recommended by Let's Encrypt
STAGING=0 # Set to 1 if you are testing to avoid rate limits

if [ -d "$DATA_PATH/conf/live/$DOMAIN" ]; then
  echo "Existing certificate data found. Skipping dummy certificate generation."
else
  echo "### Creating dummy certificate for $DOMAIN ..."
  echo "Make dir $DATA_PATH/conf/live/$DOMAIN"

  docker compose run --rm --entrypoint "\
    mkdir -p '/etc/letsencrypt/live/home.bridgetek.com'" certbot

  docker compose run --rm --entrypoint "\
    openssl req -x509 -nodes -newkey rsa:$RSA_KEY_SIZE -days 1 \
    -keyout '/etc/letsencrypt/live/$DOMAIN/privkey.pem' \
    -out '/etc/letsencrypt/live/$DOMAIN/fullchain.pem' \
    -subj '/CN=localhost'" certbot
  echo "### Starting nginx ..."
  docker compose up --force-recreate -d nginx
fi

echo "### Deleting dummy certificate for $DOMAIN ..."
docker compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$DOMAIN && \
  rm -Rf /etc/letsencrypt/archive/$DOMAIN && \
  rm -Rf /etc/letsencrypt/renewal/$DOMAIN.conf" certbot

echo "### Requesting Let's Encrypt certificate for $DOMAIN ..."
# Join $DOMAIN to -d args
DOMAIN_ARGS=""
for i in $(echo $DOMAIN | tr " " "\n"); do
  DOMAIN_ARGS="$DOMAIN_ARGS -d $i"
done

# Select appropriate email arg
if [ -n "$EMAIL" ]; then
  EMAIL_ARG="--email $EMAIL"
else
  EMAIL_ARG="--register-unsafely-without-email"
fi

# Enable staging mode if needed (for testing)
if [ $STAGING != "0" ]; then
  STAGING_ARG="--staging"
fi

docker compose run --rm --entrypoint "\
  certbot certonly --dns-route53 \
  $EMAIL_ARG \
  $DOMAIN_ARGS \
  --rsa-key-size $RSA_KEY_SIZE \
  --agree-tos \
  \
  --force-renewal " certbot

echo "### Reloading nginx ..."
docker compose exec nginx nginx -s reload
