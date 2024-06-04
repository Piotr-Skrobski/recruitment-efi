# Alpine's the most common choice
FROM node:16-alpine AS build

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./
RUN npm i --silent

COPY . .

CMD ["npm", "start"]
