FROM node:16.19.0-alpine3.17 as app_node

WORKDIR /srv/app

COPY --link assets/ ./

COPY --link assets/package*.json ./

COPY --link assets/*.config.js ./

COPY --link assets/tsconfig*.json ./

COPY --link client.env ./

RUN npm install

EXPOSE 5173
