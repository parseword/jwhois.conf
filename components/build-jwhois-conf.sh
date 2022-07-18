#!/usr/bin/bash

# Set file paths
outfile="jwhois.conf"
infile="jwhois.conf.stub"
if [ -f ./jwhois.conf.stub.local ]; then
    infile+=".local"
fi

# Replace the timestamp in the stub
sed "s/%TIMESTAMP_GOES_HERE%/$(date -u +'%Y-%m-%dT%R:%SZ')/g" "${infile}" > "${outfile}"

# Merge TLD/SLD records into the stub
sed -i -e '/#%TLDSLDIDN_RECORDS_GO_HERE%/ {' -e 'r records-tlds-slds.txt' -e 'd' -e '}' "${outfile}"

# Merge CIDR records into the stub
sed -i -e '/#%IPV4_CIDR_RECORDS_GO_HERE%/ {' -e 'r records-ipv4-cidrs.txt' -e 'd' -e '}' "${outfile}"