FROM node:20-alpine

WORKDIR /app

# 1) Install dependencies
COPY package*.json ./
RUN npm ci

# 2) Copy source code
COPY . .

# 3) Prisma: Generate client
RUN npx prisma generate

# 4) Build Astro (SSR)
RUN npm run build

# 5) Runtime env
ENV NODE_ENV=production
ENV PORT=4321
ENV DATABASE_URL="file:/data/dev.db"

# 6) Create volume for persistent database
VOLUME /data

EXPOSE 4321

# 7) Initialize database on first run and start server
CMD sh -c "npx prisma db push --accept-data-loss && npm run db:seed && node ./dist/server/entry.mjs"
