#!/usr/bin/env bash

set -eu

if [ "$(id -u)" != "0" ]
then
    echo "Must run with sudo"
    exit 1
fi

DOCKERD_PATH="$(which dockerd)"
DOCKERD_BACKUP="${DOCKERD_PATH}.backup"

cd "${0%/*}"

echo "Building dockerd..."
go build -o dockerd ./cmd/dockerd

echo "Stopping dockerd system service..."
systemctl stop docker

echo "Replacing dockerd with built binary..."
mv "${DOCKERD_PATH}" "${DOCKERD_BACKUP}"
mv dockerd "${DOCKERD_PATH}"

echo "Starting dockerd system service..."
systemctl start docker

echo "Done."
echo "To revert, run:"
echo "    mv ${DOCKERD_BACKUP} ${DOCKERD_PATH}"
