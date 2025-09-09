# Dockerfile

FROM node:18-alpine

WORKDIR /usr/src/app

RUN apk add --no-cache udev ttf-freefont chromium

# --- FIX: Create a dedicated data directory and set permissions ---
# Create the /data directory and make the 'node' user its owner.
# When a volume is mounted to /data at runtime, Docker will ensure
# the volume's initial permissions match this directory's permissions.
RUN mkdir /data && chown node:node /data

COPY package*.json ./
RUN npm install
COPY . .

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Change ownership of the app directory itself for good measure
RUN chown -R node:node .

CMD ["npm", "start"]