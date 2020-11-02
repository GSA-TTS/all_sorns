#!/bin/sh
#
# This script will attempt to create the services required
# and then launch everything.
#

# This is the hostname for the route set for the
CGHOSTNAME="${CGHOSTNAME:-all-sorns}"

echo "$CGHOSTNAME"


cf api https://api.fr.cloud.gov
cf auth "$CF_USERNAME" "$CF_PASSWORD"
cf target -o "$CF_ORG" -s "$CF_SPACE"

# function to check if a service exists
service_exists()
{
  cf service "$1" >/dev/null 2>&1
}

if [ "$1" = "setup" ] ; then  echo
	# create services (if needed)

	if service_exists "all-sorns-deployer" ; then
	  echo all-sorns-deployer already created
	else
	  cf create-service cloud-gov-service-account space-deployer all-sorns-keys
	  cf create-service-key all-sorns-keys deployer
	  echo "to get the CF_USERNAME and CF_PASSWORD, execute 'cf service-key all-sorns-keys deployer'"
	fi

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
		cf apply-manifest -f manifest.yml
	fi
fi

# launch the app
if [ "$1" = "rolling" ] ; then
	# Do a zero downtime deploy.  This requires enough memory for
	# two apps to exist in the org/space at one time.
	cf push all_sorns --no-route -f manifest.yml --strategy rolling || exit 1
else
	cf push all_sorns -f manifest.yml --no-route
fi
cf map-route all_sorns app.cloud.gov --hostname "$CGHOSTNAME"

# tell people where to go
echo
echo
echo "to log into the site, you will want to go to https://${CGHOSTNAME}.app.cloud.gov/"
echo 'Have fun!'