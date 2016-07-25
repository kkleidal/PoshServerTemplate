FROM node:argon
MAINTAINER Ken Leidal <ken@poshdevelopment.com>

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY app/package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY app /usr/src/app

# Copy certificates
COPY certs /usr/src/app/certs

# Copy database config
COPY config.json /usr/src/app/config/config.json

# Copy environment config
COPY env.conf /usr/src/app/env.conf
RUN chmod +x /usr/src/app/env.conf

RUN mkdir -p /usr/src/app/data
VOLUME /usr/src/app/data/persistent-storage
VOLUME /usr/src/app/data/usage-logs

EXPOSE 3000
EXPOSE 3001
CMD [ "bash", "startup.sh" ]

