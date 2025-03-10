ARG VERSION=20

# Production dependencies
FROM amazon/aws-lambda-nodejs:${VERSION} AS depends
WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

# Build
FROM amazon/aws-lambda-nodejs:${VERSION} AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . ./
RUN npm run build

# Running Image
FROM amazon/aws-lambda-nodejs:${VERSION}

ENV NODE_ENV=production
WORKDIR /var/task

COPY --from=depends /app/node_modules/ ./node_modules
COPY --from=depends /app/package*.json ./
COPY --from=builder /app/dist/ ./dist/

CMD ["./dist/app/lambda.handler"]
