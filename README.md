# Zero touch provisioning scripts


## Overview

This repo contains example zero touch provisioning (ZTP) scripts for Cumulus Linux, these can assist with [data center automation](http://cumulusnetworks.com/solutions/data-center-automation/).

Documentation on how the ZTP process works in Cumulus Linux is available here: http://docs.cumulusnetworks.com/display/CL25/Zero+Touch+Provisioning

Scripts are included for these tools:

* Ansible
* Chef
* Puppet

## Usage

### In your own network

Clone or copy these scripts to your management webserver.

Edit the paths to specify the location of your SSH public keys.

### Within the Cumulus Workbench


In the [workbench](http://cumulusnetworks.com/cumulus-workbench/) during the setup process this git repo is cloned to /home/cumulus/example-ztp-scripts.

Then the relevant script is symlink to /var/www/provision.sh 

```
root@wbench:/var/www# ls -l
total 871960
lrwxrwxrwx 1 root root        33 Mar 20 03:37 provision.sh -> /home/cumulus/example-ztp-scripts/ztp-puppet.sh
```
---

![Cumulus icon](http://cumulusnetworks.com/static/cumulus/img/logo_2014.png)

### Cumulus Linux

Cumulus Linux is a software distribution that runs on top of industry standard 
networking hardware. It enables the latest Linux applications and automation 
tools on networking gear while delivering new levels of innovation and 
ﬂexibility to the data center.

For further details please see: [cumulusnetworks.com](http://www.cumulusnetworks.com)
