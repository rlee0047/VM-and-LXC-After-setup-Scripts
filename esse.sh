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
#echo "### Step 1: Updating and Upgrading System Packages... ###"
#sudo apt-get update
#sudo apt-get upgrade -y
#echo "### System Updated and Upgraded Successfully. ###"
#echo

# --- 2. Install Docker Repo ---
echo "### Step 2: Installing Docker Repo... ###"
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# --- 3. Install Docker and Compose ---
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker run hello-world
sleep 15

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo docker-compose --version
sleep 15

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

