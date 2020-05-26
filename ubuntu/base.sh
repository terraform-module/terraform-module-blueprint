#!/bin/bash

ARCH="$(uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|')"
# Install Prereq Packages
export DEBIAN_PRIORITY=critical
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
APT_OPTS="--assume-yes --no-install-suggests --no-install-recommends -o Dpkg::Options::=\"--force-confdef\" \
  -o Dpkg::Options::=\"--force-confold\""
echo "adding repositories ..."
chown -R _apt:root /var/lib/apt/lists
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
echo "upgrading packages ..."
apt-get update ${APT_OPTS}
apt-get dist-upgrade ${APT_OPTS}
echo "install packages ..."
apt-get install -qqy  \
  apt-utils apt-transport-https gcc openssh-client bash-completion gnupg gnupg2 netcat \
  build-essential curl git-core lsb-core lsb-release build-essential \
  mercurial pkg-config zip \
  file vim ruby wget python3 code

apt-get install -y python3-pip libpcre3-dev

curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash

echo "Updated"
echo 'export PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"' >> ~/.bash_profile
chown -R vagrant /usr/local/bin

ln -sfn /usr/bin/python3 /usr/bin/python
ln -sfn /usr/bin/pip3 /usr/bin/pip
