FROM node:10

#Create app directory
WORKDIR /usr/src/app

# Install App Dependencies
COPY package*.json ./
RUN npm install

# If production, RUN npm ci --only=production

#Bundle app source for docker
COPY . .

EXPOSE 8080

CMD [ "node", "server.js"]
