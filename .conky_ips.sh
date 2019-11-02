#!/bin/bash

INTERFACE=$1
TYPE=$2

ipv6_addresses=$(ip addr show dev eno1 | sed -e 's/^.*inet6 \([^ ]*\).*$/\1/;t;d')
ipv4_address=$(ip addr show dev eno1 | sed -e 's/^.*inet \([^ ]*\).*$/\1/;t;d')

echo "\${template1 $TYPE\ IPv4}       \${template3}\${addr $INTERFACE}"

while read -r ipv6_address; do
    echo "\${template1 $TYPE\ IPv6}   \${template3}$ipv6_address"
done <<< "$ipv6_addresses"




