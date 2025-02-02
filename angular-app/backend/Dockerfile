FROM node:16

WORKDIR /app
COPY backend/package*.json ./
RUN npm install
COPY ./backend/ ./
EXPOSE 3000
# Start the application
CMD ["node", "server.js"]
