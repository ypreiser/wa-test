# Dockerfile (Final Version with NPM Cache Fix)

FROM node:18-slim

RUN addgroup --system appgroup && adduser --system --group appuser

WORKDIR /app

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

RUN mkdir /data && chown -R appuser:appgroup /data

COPY package*.json ./

RUN chown -R appuser:appgroup /app

USER appuser

# --- THE DEFINITIVE FIX for NPM permissions ---
# Tell npm to use a cache directory inside our app directory, which we know is writable.
# This prevents it from trying to write to a non-existent home directory.
RUN npm config set cache /app/.npm --global

# Now, npm install will succeed.
RUN npm install
# --- END FIX ---

COPY . .

CMD ["npm", "start"]