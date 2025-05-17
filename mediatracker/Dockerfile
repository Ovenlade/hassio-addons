# Dockerfile voor MediaTracker Add-on
FROM bonukai/mediatracker:latest

# Zet de werkdirectory
WORKDIR /app

# Exporteer de standaardpoort
EXPOSE 8080

# Start het script en geef de poort mee
CMD ["sh", "-c", "npm start -- --port ${PORT:-8080}"]
