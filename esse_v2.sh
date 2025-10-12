#!/bin/bash

# This script automates the setup process for a new Linux (Debian/Ubuntu) server.
# It will performs the following actions:
# Updates and upgrades all system packages.
# Installs the latest version of Docker Engine and the Docker Compose plugin.
# Adds the current user to the 'docker' group to run Docker without sudo.
# Installs useful command-line tools: duf, tree, fzf, htop, and neofetch.
# Reboots the system to apply all changes.

# Exit immediately if a command exits with a non-zero status.
set -e

## Update System Packages 

echo "### Step 1: Updating and Upgrading System Packages... ###"
sudo apt update
sudo apt upgrade -y
echo "### System Updated and Upgraded Successfully. ###"
echo

## Install Docker Repo

echo "### Step 3: Installing Docker Repo... ###"
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

## Install Docker and Compose

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker run hello-world
sleep 15

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version
sleep 15


## Post-installation Steps for Docker

echo "### Step 4: Adding current user (${USER}) to the 'docker' group... ###"
sudo usermod -aG docker $USER
echo "### User added to docker group. You'll need to log out and log back in for this to take effect, but we are rebooting instead. ###"
echo

## Install Additional Tools

echo "### Step 5: Installing useful command-line tools... ###"
sudo apt install -y duf tree fzf htop neofetch
echo "### Additional tools installed successfully. ###"
echo

## Final Reboot

echo "##################################################"
echo "###          SETUP COMPLETE!                 ###"
echo "##################################################"
echo
echo "The system will now reboot in 15 seconds to apply all changes."
echo "Press Ctrl+C to cancel the reboot."
sleep 15
sudo reboot