#!/bin/bash

function error() {
  echo -e "\e[0;33mERROR: Provisioning error running $BASH_COMMAND at line $BASH_LINENO of $(basename $0) \e[0m" >&2
}

# Log all output from this script
exec >/var/log/autoprovision 2>&1

trap error ERR

# Workaround for CM-3812; clean out the apt cache before we run apt-get update
$(rm -f /var/lib/apt/lists/partial/* /var/lib/apt/lists/* 2>/dev/null; true)

URL="http://wbench.lab.local/authorized_keys"

mkdir -p /root/.ssh
/usr/bin/wget -O /root/.ssh/authorized_keys $URL
mkdir -p /home/cumulus/.ssh
/usr/bin/wget -O /home/cumulus/.ssh/authorized_keys $URL
chown -R cumulus:cumulus /home/cumulus/.ssh

#CUMULUS-AUTOPROVISIONING

exit 0
