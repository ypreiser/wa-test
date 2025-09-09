# Dockerfile (Corrected Order of Operations)

FROM node:18-slim

# Create a non-root user and group FIRST.
RUN addgroup --system appgroup && adduser --system --group appuser

# Set the working directory. It will be created and owned by root.
WORKDIR /app

# Install system dependencies needed for Puppeteer.
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

# Create and set permissions for the persistent data directory.
RUN mkdir /data && chown -R appuser:appgroup /data

# --- THE DEFINITIVE FIX ---
# Copy package files first, still as root.
COPY package*.json ./

# Change ownership of the ENTIRE /app directory to our non-root user.
# This MUST be done before switching the user.
RUN chown -R appuser:appgroup /app

# Now, switch to the non-root user.
USER appuser

# As appuser, we can now run npm install, which will create node_modules inside /app.
RUN npm install

# Copy the rest of the application source code.
COPY . .
# --- END FIX ---

CMD ["npm", "start"]