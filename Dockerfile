FROM node:18 AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
# Estágio de Produção
FROM nginx:stable-alpine

# Copia a configuração personalizada do Nginx que criamos
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia os arquivos da aplicação Vue construídos
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 80

# O comando padrão do Nginx já é suficiente
CMD ["nginx", "-g", "daemon off;"]