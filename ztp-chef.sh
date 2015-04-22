#!/bin/bash

# Allow Cumulus testing repo
#sed -i /etc/apt/sources.list -e 's/# deb http:\/\/repo.cumulusnetworks.com CumulusLinux-2.1 testing/deb http:\/\/repo.cumulusnetworks.com CumulusLinux-2.1 testing/'

function error() {
  echo -e "\e[0;33mERROR: Provisioning error running $BASH_COMMAND at line $BASH_LINENO of $(basename $0) \e[0m" >&2
}

# Log all output from this script
exec >/var/log/autoprovision 2>&1

trap error ERR

# push root & cumulus ssh keys
URL="http://wbench.lab.local/authorized_keys"

mkdir -p /root/.ssh
/usr/bin/wget -O /root/.ssh/authorized_keys $URL
mkdir -p /home/cumulus/.ssh
/usr/bin/wget -O /home/cumulus/.ssh/authorized_keys $URL
chown -R cumulus:cumulus /home/cumulus/.ssh

# Workaround for CM-3812; clean out the apt cache before we run apt-get update
$(rm -f /var/lib/apt/lists/partial/* /var/lib/apt/lists/* 2>/dev/null; true)

# Upgrade and install Chef
apt-get update -y

apt-get install curl chef -y

echo "Configuring Chef" | wall -n

[[ -d /etc/chef ]] || mkdir /etc/chef
curl http://192.168.0.1/chef-validator.pem >/etc/chef/validation.pem || echo "Failed to download validation certificate"
chmod 0400 /etc/chef/validation.pem

if [[ ! -f /etc/chef/client.rb ]]; then
  cat <<EOF >/etc/chef/client.rb
  log_level :info
  log_location STDOUT
  chef_server_url 'https://wbench.lab.local:443/'
  validation_client_name 'chef-validator'
  interval 300
EOF
fi

chef-client -o "recipe[cldemo_base::chef-client]" --once

# CUMULUS-AUTOPROVISIONING

exit 0
