#!/bin/bash
set -e

# Generate SSH host keys if they don't exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "Generating SSH host keys..."
    sudo ssh-keygen -A
fi

# Start sshd in the background
echo "Starting sshd"
/usr/sbin/sshd &

# Start m2web
echo "Starting m2web"
cd /opt/Macaulay2Web
npm start local