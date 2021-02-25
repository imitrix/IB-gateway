#!/bin/bash
# apt install docker.io
# systemctl enable --now docker

# Bash "strict mode", to help catch problems and bugs in the shell See
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

# Set apt-get to work without manual feedback:
export DEBIAN_FRONTEND=noninteractive

# Update the package listing:
apt-get update

# Install latest security updates:
apt-get -y upgrade

# Install packages without unnecessary recommended packages:
apt-get install -y --no-install-recommends git curl wget unzip xvfb libxtst6 libxrender1 libxi6 x11vnc socat software-properties-common dos2unix python3-pip

# Delete cached files we don't need anymore:
apt-get clean
rm -rf /var/lib/apt/lists/*