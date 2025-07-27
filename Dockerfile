# Estágio de Build
FROM node:18 AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Estágio de Produção
FROM nginx:stable-alpine

# Instala 'gettext' para ter acesso ao comando 'envsubst'
RUN apk update && apk add gettext

# Copia os arquivos da aplicação Vue construídos no primeiro estágio para o diretório do Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Cria o diretório para os templates do Nginx
RUN mkdir -p /etc/nginx/templates

# Copia o nosso template de configuração para o diretório de templates
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template

# Copia e dá permissão ao nosso script de entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

# Define o script como o ponto de entrada do contêiner
ENTRYPOINT ["/entrypoint.sh"]