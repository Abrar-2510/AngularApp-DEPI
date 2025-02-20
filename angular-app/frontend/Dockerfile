
# Stage 1: Build the Angular App
FROM node:18 AS build-stage

WORKDIR /app
COPY angular-app/frontend/package*.json ./
RUN npm install
COPY angular-app/frontend ./

RUN npm run build -- --configuration production --project=my-angular-app

# Stage 2: Serve the app using Nginx
FROM nginx:alpine
COPY --from=build-stage /app/dist/my-angular-app/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
