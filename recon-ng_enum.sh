#!/bin/bash
# Copyright 2015 Zach Grace @ztgrace

if [ -z $1 ] || [ -z $2 ]; then
    echo "Usage: $0 workspace domains.txt"
    exit 1
fi

workspace=$1
filename=$2

# change the list below to point to your dns brute forcing lists
wordlists=(subbrute_names.txt big.txt)

# I use a cloned repo to work from
rng_path=/opt/recon-ng
cli="$rng_path/recon-cli -x -w $workspace "

# Customize database
$cli -C "query ALTER TABLE hosts ADD COLUMN netblock TEXT"
$cli -C "query ALTER TABLE hosts ADD COLUMN company TEXT"

# Import known domains
$cli -m import/list -o TABLE=domains -o COLUMN=domain -o FILENAME="$filename"

# Attempt a zone transfer
$cli -m discovery/info_disclosure/axfr

# brute subdomains
$cli -m recon/domains-hosts/brute_hosts 
for list in $wordlists; do
    if [ -f $list ]; then
        $cli -m recon/domains-hosts/brute_hosts -o WORDLIST=$list
    else
        echo "Error: $list not found"
    fi
done

# ssl_san
$cli -m recon/domains-hosts/ssl_san -o SOURCE="query select distinct host from hosts where host is not null"

# google
$cli -m recon/domains-hosts/google_site_web

# netcraft
$cli -m recon/domains-hosts/netcraft

# resolve
$cli -m recon/hosts-hosts/resolve

# Grab ARIN data
$cli -m recon/ip-netblocks/arin

# Export to CSV
$cli -m reporting/csv
