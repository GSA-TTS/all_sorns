#!/bin/sh
#
# This script installs the cloud foundry cli
#
sudo apt-get update
sudo apt-get install wget gnupg2 apt-transport-https
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update
sudo apt-get install cf-cli
cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
cf install-plugin blue-green-deploy -r CF-Community -f