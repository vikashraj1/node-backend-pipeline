FROM node:lts-alpine
ENV NODE_ENV=production

USER node
WORKDIR /app

COPY --chown=node:node . .
# COPY . .

RUN npm ci
RUN npm audit fix

EXPOSE 8080

# RUN chown -R node /app
# USER node
CMD ["npm", "start"]