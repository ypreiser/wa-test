# Dockerfile

FROM node:18-alpine

WORKDIR /usr/src/app

RUN apk add --no-cache udev ttf-freefont chromium

# --- THE DEFINITIVE FIX ---
# Create the /data directory.
# Then, use 'chmod 777' to make it world-writable. This means that ANY user
# (including the one we pass in from the host, like 1001) will have
# permission to read, write, and execute files within this directory.
# This solves the permission error regardless of the host user's specific UID.
RUN mkdir /data && chmod 777 /data

COPY package*.json ./
RUN npm install
COPY . .

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# We still chown the app directory, as it's good practice.
RUN chown -R node:node .

CMD ["npm", "start"]