# /home/youruser/wa-test/Dockerfile

# --- Build Stage ---
FROM node:20-slim AS builder
WORKDIR /usr/src/app
COPY package*.json ./
# Install dependencies
RUN npm install

# --- Production Stage ---
FROM node:18-alpine
WORKDIR /usr/src/app

# Puppeteer requires specific dependencies to be installed.
# This is a critical step for whatsapp-web.js to work on Alpine Linux.
RUN apk add --no-cache udev ttf-freefont chromium

COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY . .

# Tell Puppeteer to use the Chromium package we installed
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Run the app
CMD ["npm", "start"]