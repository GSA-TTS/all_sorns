#!/bin/bash

# This script runs prior to the start-command on Cloud Foundry

# See if we're bound to a service called "outbound-proxy"
proxy_url=$(echo "$VCAP_SERVICES" | jq --raw-output --arg service_name "outbound-proxy" ".[]
[] | select(.name == \$service_name) | .credentials.proxy_url")

# If so, then set https_proxy to the URL provided
if [ "${proxy_url}" != "" ] ; then
    https_proxy="${proxy_url}"
    export https_proxy
fi
