cd /tmp/hassio-addons/open-webui

cat > run.sh << 'EOF'
#!/bin/bash
set -e

echo "Starting Open WebUI with custom settings..."
echo "JWT_EXPIRES_IN: ${JWT_EXPIRES_IN}"

# Export environment variables
export JWT_EXPIRES_IN="${JWT_EXPIRES_IN:-5m}"
export DATA_DIR="${DATA_DIR:-/data}"

# Start Open WebUI
exec bash /app/backend/start.sh
EOF

chmod +x run.sh
