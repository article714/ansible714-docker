#!/bin/bash

# set -x

apt-get update

# Generate French locales
localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

export LANG=en_US.utf8

# Install some basic deps
apt-get update

apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    dialog \
    gcc \
    git \
    gnupg \
    inetutils-ping \
    iproute2 \
    openssh-client \
    sudo

# Install docker-cli

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

echo 'deb [arch=amd64] https://download.docker.com/linux/debian  buster  stable' >etc/apt/sources.list.d/docker.list

apt-get update
apt-get install docker-ce-cli

# Install pip dependencies
pip3 install --upgrade pip
pip3 install --upgrade cryptography

# ANSIBLE user should have a > 1000 gid to ease uid/gid mapping in docker
addgroup --gid 6666 ansible

adduser --system --home /home/ansible --gid 6666 --uid 6666 --quiet ansible

# Setup configuration
ln -f -s /container/config /etc/ansible

# set /container/logs to belong to ansible user
mkdir /container/logs
chown -R ansible. /container/logs
chmod -R 775 /container/logs

# Clone ansible714 Tooling
cd /home/ansible
sudo -u ansible mkdir -p foreign
sudo -u ansible mkdir -p playbooks
sudo -u ansible git clone https://gitlab.com/article714/ansible714.git

# install ansible 714 Dependencies
pip3 install -r /home/ansible/ansible714/requirements.txt

cd ansible714
sudo -u ansible /home/ansible/ansible714/scripts/init_dependencies.sh /home/ansible
cd /

#--
# Cleaning

apt-get purge gcc python3-dev
apt-get -yq clean
apt-get -yq autoremove
rm -rf /var/lib/apt/lists/*
