#!/bin/bash

function error() {
  echo -e "\e[0;33mERROR: Provisioning error running $BASH_COMMAND at line $BASH_LINENO of $(basename $0) \e[0m" >&2
}

# Log all output from this script
exec >/var/log/autoprovision 2>&1

trap error ERR

# Allow Cumulus testing repo
sed -i /etc/apt/sources.list -e 's/^#\s*\(deb.*testing.*\)$/\1/g'

# push root & cumulus ssh keys
URL="http://wbench.lab.local/authorized_keys"

mkdir -p /root/.ssh 
/usr/bin/wget -O /root/.ssh/authorized_keys $URL
mkdir -p /home/cumulus/.ssh
/usr/bin/wget -O /home/cumulus/.ssh/authorized_keys $URL
chown -R cumulus:cumulus /home/cumulus/.ssh

# Upgrade and install Puppet
apt-get update -y
apt-get install puppet -y

echo "Configuring puppet" | wall -n
#comment out templatedir in puppet 
sed -i /etc/puppet/puppet.conf -e 's/^template/# template/'
sed -i /etc/hosts -e "s/127.0.1.1  `hostname`/127.0.1.1   `hostname`   `hostname`.lab.local/"
sed -i /etc/default/puppet -e 's/START=no/START=yes/'

service puppet restart

# CUMULUS-AUTOPROVISIONING

exit 0
