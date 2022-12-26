FROM node:16 AS build
WORKDIR /app
COPY . .
RUN npm install &&  npm run build

FROM nginx:alpine AS prod
WORKDIR /usr/share/nginx/html
COPY --from=build /app/dist .
EXPOSE 80
# run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]
