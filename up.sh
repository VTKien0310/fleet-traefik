#!/bin/bash

echo "Creating fleet network"
if docker network inspect fleet >/dev/null 2>&1; then
  echo "Network fleet already exists, skipping creation."
else
  echo "Creating network fleet..."
  docker network create fleet
fi

echo "Running compose up in fleet-traefik"
docker compose up -d