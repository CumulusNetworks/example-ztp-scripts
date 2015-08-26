#!/bin/bash


function error() {
  echo -e "\e[0;33mERROR: Provisioning error running $BASH_COMMAND at line $BASH_LINENO of $(basename $0) \e[0m" >&2
}

# Log all output from this script
exec >/var/log/autoprovision 2>&1

trap error ERR

# Allow Cumulus 3rdparty repo
echo -e "deb http://cldemo.cumulusnetworks.com/3rdparty-testing 3rdparty workbench" >> /etc/apt/sources.list

# push root & cumulus ssh keys
URL="http://wbench.lab.local/authorized_keys"

mkdir -p /root/.ssh
/usr/bin/wget -O /root/.ssh/authorized_keys $URL
mkdir -p /home/cumulus/.ssh
/usr/bin/wget -O /home/cumulus/.ssh/authorized_keys $URL
chown -R cumulus:cumulus /home/cumulus/.ssh

# Upgrade and install Chef
apt-get update -y
apt-get install curl -y
# Force chef to install Chef12 instead of Chef11
apt-get -y --force-yes -t 3rdparty install chef

echo "Configuring Chef" | wall -n

[[ -d /etc/chef ]] || mkdir /etc/chef
curl http://192.168.0.1/chef-validator.pem > /etc/chef/validation.pem || echo "Failed to download validation certificate"
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
