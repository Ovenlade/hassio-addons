#!/usr/bin/env bash
set -e

PORT=${PORT:-4020}

echo "✅ MediaTracker wordt gestart op poort $PORT..."

# Start MediaTracker
npm start -- --port $PORT
