FROM registry.access.redhat.com/ubi8/nodejs-18

# Create application directory

WORKDIR /usr/src/app

COPY package.json ./

RUN npm install -g npm@9.2.0

COPY . .

EXPOSE 8080
CMD [ "node", "app.js" ]


