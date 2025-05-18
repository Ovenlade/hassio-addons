#!/usr/bin/env bash

# Maak de map aan als die nog niet bestaat
if [ ! -d "/data/mediatracker" ]; then
    mkdir -p /data/mediatracker
    echo "Directory /data/mediatracker aangemaakt."
fi


# Start MediaTracker op de gewenste poort en sla data op in /data
/app/MediaTracker --host 0.0.0.0 --port 7481 --dataPath /data/mediatracker
