# Etapa 1: Build da aplicação
FROM node:18 AS build-stage

# Define o diretório de trabalho no contêiner
WORKDIR /app

# Copia o arquivo package.json e package-lock.json
COPY package*.json ./

# Instala as dependências da aplicação
RUN npm install

# Copia todo o código fonte da aplicação para o contêiner
COPY . .

# Compila a aplicação Vue 3 para produção
RUN npm run build

# Etapa 2: Servir a aplicação com Nginx
FROM nginx:alpine AS production-stage

# Copia o build da aplicação do estágio anterior para o diretório padrão do Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copia o arquivo de configuração do Nginx, se necessário
# COPY nginx.conf /etc/nginx/nginx.conf

# Expõe a porta padrão do Nginx
EXPOSE 80

# Comando padrão para rodar o Nginx
CMD ["nginx", "-g", "daemon off;"]
