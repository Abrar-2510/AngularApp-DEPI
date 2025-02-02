# Stage 1: Build the Angular app
FROM node:18 AS build

WORKDIR /app
COPY ./frontend/package*.json ./
RUN npm install
COPY ./frontend ./
RUN npm run build --prod

# Stage 2: Serve the app using Nginx
FROM nginx:alpine


# Copy built frontend from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for external access
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
