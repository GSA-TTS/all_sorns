#!/bin/sh

#
# This script will deploy apps to spaces where services are already configured
# The script assumes that the calling user is already authenticated and
# targeting the intended space
#

set -e 

CF_ORG=${CF_ORG:-gsa-tts-identity-prototyping}

# This is the hostname for the route set for the app
CGHOSTNAME="${CGHOSTNAME:-all-sorns}"

echo "$CGHOSTNAME"

# launch the app
if [ "$1" = "rolling" ] ; then
	# Do a zero downtime deploy.  This requires enough memory for
	# two apps to exist in the org/space at one time.
	cf push all_sorns -f ".cloud-gov/manifest-${CF_SPACE}.yml" --no-route --strategy rolling || exit 1
else
	cf push all_sorns -f ".cloud-gov/manifest-${CF_SPACE}.yml" --no-route
fi
cf map-route all_sorns app.cloud.gov --hostname "$CGHOSTNAME"

# Extra route-mapping, only for the production deployment
if [ "${CF_SPACE}" = "all-sorn-prod" ] ; then
    cf map-route all_sorns sorndashboard.fpc.gov
fi
# tell people where to go
echo
echo "To log into the site, go to https://${CGHOSTNAME}.app.cloud.gov/"
echo

