FROM node:20-slim

# Build dependencies for better-sqlite3 native module
RUN apt-get update && apt-get install -y --no-install-recommends python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install server dependencies first (layer-cached)
COPY server/package*.json ./server/
RUN cd server && npm ci --omit=dev

# Copy application files
COPY server/server.js server/config.example.json ./server/
COPY web/ ./web/

# Writable data directory for SQLite DB, thumbnails, and runtime config
RUN mkdir -p /app/data /tmp/tv_uploads /tmp/tv_cache && chmod -R 777 /app/data /tmp/tv_uploads /tmp/tv_cache

ENV NODE_ENV=production
ENV PORT=7860
ENV DATA_DIR=/app/data

EXPOSE 7860

CMD ["node", "server/server.js"]
