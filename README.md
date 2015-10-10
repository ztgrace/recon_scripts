# recon_scripts

Here are some scripts I use to automate initial recon steps using recon-ng.

* **arin.py** - This module grabs IPs from the hosts table and performs an ARIN query with them to identify their associated netblock and company.
* **axfr.py** - This module will perform a zone transfer against all the domains in the domains table.
* **recon-ng_enum.sh** - This is a wrapper script to kick off some basic reconnaissance using the recon-ng cli.

## Install

1. `cd /opt`
2. `git clone https://github.com/ztgrace/recon_scripts.git`
3. `mkdir -p ~/.recon-ng/modules/recon/ip-netblocks`
4. `ln -s /opt/recon_scripts/arin.py ~/.recon-ng/modules/recon/ip-netblocks/`
5. `mkdir -p ~/.recon-ng/modules/discovery/info_disclosure/`
6. `ln -s /opt/recon_scripts/axfr.py ~/.recon-ng/modules/discovery/info_disclosure/`
