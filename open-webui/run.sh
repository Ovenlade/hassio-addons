#!/usr/bin/env bash
set -e

echo "Starting Open WebUI..."
# The environment variables from config.yaml are automatically available.
# We just need to execute the original startup command.
exec /usr/bin/tini -g -- bash /app/backend/start.sh