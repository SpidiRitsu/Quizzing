# Check out https://hub.docker.com/_/node to select a new base image
FROM node:10-slim

# Set to a non-root built-in user `node`
USER node

# Create app directory (with user `node`)
RUN mkdir -p /home/node/app

WORKDIR /home/node/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY --chown=node package*.json ./

RUN npm install

# Bundle app source code
COPY --chown=node . .

# Makes the wait-for-it.sh script executable
RUN ["chmod", "+x", "./wait-for-it.sh"]

RUN npm run build

# Loopback tries to connect to the datasource at the start
# thus we have to wait for db to launch
# Docker wait-for-it.sh script was used to achieve that!
# CMD [ "node", "." ]

CMD ["./wait-for-it.sh", "db:3306", "-s", "-t", "120", "--", "node", "."]