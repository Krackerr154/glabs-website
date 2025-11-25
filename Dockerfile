FROM node:20-alpine

WORKDIR /app

# 1) Install dependencies
COPY package*.json ./
RUN npm ci

# 2) Copy source code
COPY . .

# 3) Prisma: set database URL (SQLite file di dalam container)
ENV DATABASE_URL="file:./prisma/dev.db"

# Generate Prisma client dan sync schema
RUN npx prisma generate
RUN npx prisma db push
RUN npm run db:seed

# 4) Build Astro (SSR)
RUN npm run build

# 5) Runtime env
ENV NODE_ENV=production
ENV PORT=4321

EXPOSE 4321

# 6) Start Astro Node adapter
CMD ["node", "./dist/server/entry.mjs"]
