#!/usr/bin/env bash
set -e

# Poort instellen vanuit de configuratie, standaard 4020 als niets is opgegeven
PORT=${PORT:-4020}

echo "✅ MediaTracker wordt gestart op poort $PORT..."

# Start MediaTracker
npm start -- --port $PORT
