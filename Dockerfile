# /home/youruser/wa-test/Dockerfile

# --- Build Stage ---
FROM node:20-slim AS builder

WORKDIR /usr/src/app

# Puppeteer/Chromium dependencies for Alpine Linux
RUN apk add --no-cache udev ttf-freefont chromium

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Set environment variable for Puppeteer to find Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# --- FIX: Change ownership of the app directory ---
# This allows the non-root user (specified in docker-compose) to create
# files and directories needed for the session auth strategy.
# 'node:node' is a standard user/group that exists in the base node image.
# We will dynamically override this with our host UID/GID at runtime,
# but this step ensures the directory is writable by a non-root user.
RUN chown -R node:node .

# Command to run the application
CMD ["npm", "start"]