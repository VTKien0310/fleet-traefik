#!/bin/bash

echo "Creating fleet network"
docker network create fleet

echo "Running compose up in fleet-traefik"
docker compose up -d