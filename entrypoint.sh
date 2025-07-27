#!/bin/sh

# Define um valor padrão para a variável se ela não for fornecida
export BACKEND_URL=${BACKEND_URL:-http://localhost:8080}

# Substitui o placeholder no template e cria o arquivo .conf final
# O comando 'envsubst' substitui as variáveis ($VAR) no template
envsubst '$BACKEND_URL' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf

# Inicia o Nginx com a configuração gerada
exec nginx -g 'daemon off;'