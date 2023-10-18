#!/bin/bash
#
# This script will create the services required and then launch everything. It
# is idempotent; it can be run again with the same arguments.

# It's expected that the target space and corresponding -public space exist.
# It's expected to be run by someone with the SpaceDeveloper role on both spaces.

# Error out if anything goes wrong.
set -e 

CF_ORG="${CF_ORG:-gsa-tts-identity-prototyping}"
CF_SPACE="${1:-all-sorn-test}"

echo "Setting up ${CF_ORG}/${CF_SPACE}..."

# function to check if a service exists
service_exists()
{
  cf service "$1" >/dev/null 2>&1
}

if service_exists "all-sorns-deployer" ; then
    echo all-sorns-deployer already created
else
    cf create-service cloud-gov-service-account space-deployer all-sorns-keys
    cf create-service-key all-sorns-keys deployer
    deployeruser=$(cf service-key all-sorns-keys deployer | tail -n +3 | jq -r .credentials.username)
    cf set-space-role ${deployeruser} ${CF_ORG} ${CF_SPACE}-public SpaceDeveloper
    echo "To get the CF_USERNAME and CF_PASSWORD, execute 'cf service-key all-sorns-keys deployer'"
    echo "You will want to include these secrets in your CI/CD pipeline"
    echo
fi

# Remove public egress from the target space while running
cf unbind-security-group public_networks_egress ${CF_ORG} ${CF_SPACE} --lifecycle running

# Add public egress to the corresponding -public space while running
cf bind-security-group public_networks_egress ${CF_ORG} --space ${CF_SPACE}-public --lifecycle running 

exit

if service_exists "all-sorns-db" ; then
    echo all-sorns-db DB already created
else
    cf create-service aws-rds small-psql all-sorns-db
        echo sleeping until db is awake
        for i in 1 2 3 ; do
            sleep 60
            echo $i minutes...
        done
fi



# set up app
if cf app all_sorns >/dev/null 2>&1 ; then
    echo all_sorns app already set up
else
    cf create-app all_sorns
    cf apply-manifest -f ".cloud-gov/manifest-${CF_SPACE}.yml"
fi
