#!/bin/bash

#set -x

apt-get update

# Generate French locales
localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8

export LANG=en_US.utf8

# Install some basic deps
apt-get update

apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    dialog \
    python3-pip \
    python3-pyldap \
    python3-setuptools \
    python3-watchdog \
    python3-wheel

# Install pip dependencies
pip3 install ansible==${ANSIBLE_VERSION}

# ANSIBLE user should have a > 1000 gid to ease uid/gid mapping in docker
addgroup --gid 6666 ansible

adduser --system --home /home/ansible --gid 6666 --uid 6666 --quiet ansible

#--
# Cleaning

apt-get -yq clean
apt-get -yq autoremove
rm -rf /var/lib/apt/lists/*