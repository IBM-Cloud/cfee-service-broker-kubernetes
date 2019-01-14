#!/bin/bash

#
# ensure org and space exist
#
source ./cf_create_org_space.sh

#
# deploy the GetStartedNode app
#
cd ./get-started-node
cf push

#
# bind Cloudant to this app
#
cf bind-service GetStartedNode cfee-cloudant

#
# bind the sample "welcome" service to this app
#
cf bind-service GetStartedNode welcome-service

#
# restart the service to load bindings
#
cf restart GetStartedNode
