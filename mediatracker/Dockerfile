ARG BUILD_FROM
FROM $BUILD_FROM

# Install Node.js and other necessary tools
RUN apk add --no-cache nodejs npm git

# Set working directory
WORKDIR /app

# Clone MediaTracker repository
RUN git clone https://github.com/bonukai/MediaTracker.git .

# Install dependencies and build MediaTracker
RUN npm install
RUN npm run build

# Copy run script
COPY run.sh /usr/bin/run.sh
RUN chmod a+x /usr/bin/run.sh

# Expose MediaTracker port (default is 7481)
EXPOSE 7481

# Command to run MediaTracker
CMD [ "/usr/bin/run.sh" ]
