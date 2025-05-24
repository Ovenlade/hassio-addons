ARG BUILD_FROM
FROM $BUILD_FROM

# Install Node.js and other necessary tools
# Gebruik --update om zeker te zijn van de nieuwste pakketten
RUN apk add --no-cache --update nodejs npm git

# Set working directory
WORKDIR /app

# Clone MediaTracker repository
# Gebruik --depth 1 om de kloon kleiner en sneller te maken
RUN git clone https://github.com/bonukai/MediaTracker.git . --depth 1

# Install dependencies and build MediaTracker
# Voer npm install uit in zowel de root als de server/client dirs
RUN npm install
RUN npm run build --prefix server
RUN npm run build --prefix client

# Copy run script
COPY run.sh /usr/bin/run.sh
RUN chmod a+x /usr/bin/run.sh

# Expose MediaTracker port (default is 7481)
EXPOSE 7481

# Command to run MediaTracker
# Zorg dat dit precies zo is, geen extra spaties, geen aanhalingstekens eromheen
CMD [ "/usr/bin/run.sh" ]
