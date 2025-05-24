#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: MediaTracker
# This script starts MediaTracker with options from Home Assistant.
# ==============================================================================

# Read configuration from options.json
bashio::log.info "Starting MediaTracker add-on..."

# Set MediaTracker environment variables based on add-on options
export SERVER_LANG="$(bashio::config 'server_lang')"
export TMDB_LANG="$(bashio::config 'tmdb_lang')"
export AUDIBLE_LANG="$(bashio::config 'audible_lang')"
export TZ="$(bashio::config 'tz')"
export DATABASE_CLIENT="$(bashio::config 'database_client')"

# Handle database path for sqlite
if [ "$(bashio::config 'database_client')" = "better-sqlite3" ]; then
    DATABASE_PATH_RAW="$(bashio::config 'database_path')"
    if [ -z "$DATABASE_PATH_RAW" ]; then
        bashio::log.fatal "database_path is required when database_client is better-sqlite3"
        exit 1
    fi
    # Get filename only to ensure it always goes into /data/
    DB_FILE="${DATABASE_PATH_RAW##*/}"
    export DATABASE_PATH="/data/${DB_FILE}"
fi

# Handle database URL for postgres
if [ "$(bashio::config 'database_client')" = "pg" ]; then
    DATABASE_URL="$(bashio::config 'database_url')"
    if [ -z "$DATABASE_URL" ]; then
        bashio::log.fatal "database_url is required when database_client is pg"
        exit 1
    fi
    export DATABASE_URL
fi

# Set log level
export LOG_LEVEL="$(bashio::config 'log_level')"

# Start MediaTracker
bashio::log.info "Starting MediaTracker with the following configuration:"
bashio::log.info "  SERVER_LANG: ${SERVER_LANG}"
bashio::log.info "  TMDB_LANG: ${TMDB_LANG}"
bashio::log.info "  AUDIBLE_LANG: ${AUDIBLE_LANG}"
bashio::log.info "  TZ: ${TZ}"
bashio::log.info "  DATABASE_CLIENT: ${DATABASE_CLIENT}"
if [ "$(bashio::config 'database_client')" = "better-sqlite3" ]; then
    bashio::log.info "  DATABASE_PATH: ${DATABASE_PATH}"
else
    bashio::log.info "  DATABASE_URL: (set)"
fi
bashio::log.info "  LOG_LEVEL: ${LOG_LEVEL}"

# Set NODE_ENV to production as per MediaTracker's package.json
export NODE_ENV=production

# Change directory to the 'server' folder and execute the actual Node.js command
cd /app/server || { bashio::log.fatal "Failed to change directory to /app/server"; exit 1; }
exec node build/index.js
