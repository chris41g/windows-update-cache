#!/bin/ash
  if [ -z "${1}" ]; then
    if [ ! -f "${APP_ROOT}/ssl/default.crt" ]; then
      elevenLogJSON info "create default SSL certificate"
      openssl req -x509 -newkey rsa:4096 -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=${APP_NAME}" \
        -keyout "${APP_ROOT}/ssl/default.key" \
        -out "${APP_ROOT}/ssl/default.crt" \
        -days 3650 -nodes -sha256 &> /dev/null
    fi

    if [ ! -f "/etc/nginx/nginx.conf" ]; then
      elevenLogJSON info "no config found, copy default config"
      cp /etc/nginx/.default/nginx.conf /etc/nginx/nginx.conf
      sed -i "s/\$CACHE_SIZE/${CACHE_SIZE:-256g}/g" /etc/nginx/nginx.conf
      sed -i "s/\$CACHE_MAX_AGE/${CACHE_MAX_AGE:-14d}/g" /etc/nginx/nginx.conf
      sed -i "s/\$CACHE_ACCESS_DENIED/${CACHE_ACCESS_DENIED:-127.0.0.1:8443}/g" /etc/nginx/nginx.conf
    fi

    elevenLogJSON info "starting ${APP_NAME}"
    set -- "nginx" \
      -g \
      'daemon off;'
  fi

  exec "$@"