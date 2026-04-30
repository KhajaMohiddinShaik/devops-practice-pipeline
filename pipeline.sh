#!/bin/bash

set -e
echo "[INFO] Starting pipeline..."

ENV=$1
STATUS=$2
VERSION=$3

if [ -z "$ENV" ]; then
	echo "[ERROR] Usage: ./pipeline.sh <env> [pass|fail] [version]"
	exit 1
fi

# Default values
STATUS=${STATUS:-pass}
VERSION=${VERSION:-1.0.0}

echo "[CI] Pulling latest code..."
sleep 1
#git pull

echo "[CI] Building..."
sleep 2

echo "[CI] Testing..."
if [ "$STATUS" == "fail" ]; then
	echo "[ERROR] tests failed"
	exit 1
fi
sleep 1
echo "[SUCCESS] Tests passed"

if [ "$ENV" == "prod" ]; then
	echo "[DEPLOY] Deploying to Prod..."
	sleep 2
else
	echo "[DEPLOY] Deploying to Dev..."
	sleep 2
fi
echo "[SUCCESS] Successfully deployed v$VERSION"

echo "[SUCCESS] Pipeline ran successfully."
