#!/bin/sh
# entrypoint.sh

ROOT_DIR=/usr/share/nginx/html
INDEX_FILE=$(find $ROOT_DIR -name "index.html")

# Usa a variável de ambiente VITE_API_URL ou um valor padrão se ela não for definida
URL_TO_USE=${VITE_API_URL:-http://localhost:8080}

# Substitui o placeholder no arquivo index.html
sed -i "s|__VITE_API_URL__|${URL_TO_USE}|g" $INDEX_FILE

echo "API URL configurada para: ${URL_TO_USE}"

exec nginx -g 'daemon off;'