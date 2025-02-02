FROM node:16

WORKDIR /app
COPY angular-app/backend/package*.json ./
RUN npm install
COPY angular-app/backend/ ./
EXPOSE 3000
# Start the application
CMD ["node", "server.js"]
