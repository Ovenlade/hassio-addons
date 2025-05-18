# Basisimage van MediaTracker
FROM bonukai/mediatracker:latest

# Zet de werkdirectory naar de applicatiemap
WORKDIR /app

# Zorg dat de nodige tools aanwezig zijn
RUN apk add --no-cache bash jq

# Expose de standaard poort
EXPOSE 7481

# Kopieer het startscript naar de container
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# Start het script
CMD ["/bin/bash", "/app/run.sh"]
