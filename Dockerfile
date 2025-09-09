# Dockerfile (Final Corrected Version)

FROM node:18-slim

WORKDIR /app

# 1. Install system dependencies as root
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

# 2. Create the non-root user and group
RUN addgroup --system appgroup && adduser --system --group appuser

# 3. Create the data directory for volumes
RUN mkdir /data

# 4. Copy package files and install dependencies AS ROOT.
# This avoids all npm permission issues during the build.
COPY package*.json ./
RUN npm install

# 5. Copy the rest of the application source code
COPY . .

# 6. THE CRUCIAL STEP: After all files are in place, change ownership
# of the application and data directories to the non-root user.
RUN chown -R appuser:appgroup /app /data

# 7. Now, switch to the non-root user for runtime
USER appuser

# 8. Run the application
CMD ["npm", "start"]