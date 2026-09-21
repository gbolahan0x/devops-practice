FROM node:22-alpine

WORKDIR /usr/src/app

COPY --chown=node:node package*.json ./
RUN npm ci --omit=dev

COPY --chown=node:node app.js ./

ENV NODE_ENV=production
EXPOSE 3000

USER node
CMD ["npm", "start"]
