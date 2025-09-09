# Dockerfile

# Use the same base image as your production environment for consistency
FROM node:18-slim

WORKDIR /app

# Install the exact dependencies required by Puppeteer on Debian/Slim
# This is the critical step that fixes the browser launch error.
RUN apt-get update && apt-get install -y \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgconf-2-4 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    wget \
    xdg-utils \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group, just like in your production file.
RUN addgroup --system appgroup && adduser --system --group appuser

# Create the /data directory for session persistence and give ownership to our new user.
RUN mkdir /data && chown -R appuser:appgroup /data

# Switch to the non-root user for security.
USER appuser

# Copy package files and install dependencies as the non-root user.
# First, give the user permission to write to the current directory.
COPY --chown=appuser:appgroup package*.json ./
RUN npm install

# Copy the rest of the application code.
COPY --chown=appuser:appgroup . .

# No PUPPETEER_EXECUTABLE_PATH needed; it will be found automatically.

CMD ["npm", "start"]