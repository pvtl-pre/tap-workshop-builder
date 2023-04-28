#!/bin/bash
set -e -o pipefail
shopt -s nocasematch

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Carvel
wget -O- https://carvel.dev/install.sh | sudo bash

# Helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg >/dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# jq
sudo apt-get --assume-yes install jq

# kubectl
sudo snap install kubectl --classic

# pivnet
wget https://github.com/pivotal-cf/pivnet-cli/releases/download/v3.0.1/pivnet-linux-amd64-3.0.1
sudo install pivnet-linux-amd64-3.0.1 /usr/local/bin/pivnet

# yq
sudo snap install yq
