# Dockerfile (Simplified and Correct)

FROM node:18-slim

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

# Create a non-root user and group.
RUN addgroup --system appgroup && adduser --system --group appuser

# Create and set permissions for the persistent data directory.
RUN mkdir /data && chown -R appuser:appgroup /data

# Copy application files.
COPY --chown=appuser:appgroup . .

# Switch to the non-root user.
USER appuser

# --- THE DEFINITIVE FIX ---
# Run npm install and specify a local cache directory using the --cache flag.
# This avoids all global permission issues.
RUN npm install --cache /app/.npm
# --- END FIX ---

CMD ["npm", "start"]