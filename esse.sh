#!/bin/bash

# This script automates the setup process for a new Linux (Debian/Ubuntu) server.
# It performs the following actions:
# 1. Updates and upgrades all system packages.
# 2. Installs the latest version of Docker Engine and the Docker Compose plugin.
# 3. Adds the current user to the 'docker' group to run Docker without sudo.
# 4. Reboots the system to apply all changes.

# Exit immediately if a command exits with a non-zero status.
set -e

# --- 1. Update System Packages ---
echo "### Step 1: Updating and Upgrading System Packages... ###"
sudo apt-get update
sudo apt-get upgrade -y
echo "### System Updated and Upgraded Successfully. ###"
echo

# --- 2. Install Docker Engine and Compose ---
echo "### Step 2: Installing Docker Engine and Docker Compose... ###"

# Uninstall old versions if they exist
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get remove -y $pkg
done

# Add Docker's official GPG key
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the latest Docker packages, including the Compose plugin
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "### Docker Engine and Compose Installed Successfully. ###"
echo

# --- 3. Post-installation Steps for Docker ---
echo "### Step 3: Adding current user (${USER}) to the 'docker' group... ###"
# This allows running docker commands without sudo
sudo usermod -aG docker $USER
echo "### User added to docker group. You will need to log out and log back in for this to take effect, but we are rebooting instead. ###"
echo

# --- 4. Final Reboot ---
echo "##################################################"
echo "###          SETUP COMPLETE!                 ###"
echo "##################################################"
echo
echo "The system will now reboot in 15 seconds to apply all changes."
echo "Press Ctrl+C to cancel the reboot."
sleep 15
sudo reboot

