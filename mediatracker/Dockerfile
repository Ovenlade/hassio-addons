ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:9.6.3
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install dependencies
RUN apk add --no-cache nodejs npm bash

# Copy addon files
COPY run.sh /app/run.sh
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
COPY . /app

WORKDIR /app

RUN npm install

RUN chmod +x /app/run.sh

CMD [ "/bin/bash", "/app/run.sh" ]
