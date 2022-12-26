FROM node:16-bullseye-slim
WORKDIR /app
COPY . .
RUN npm install &&  npm run build
EXPOSE 3000
CMD ["/bin/sh", "-c" ,"npm run start"] 
