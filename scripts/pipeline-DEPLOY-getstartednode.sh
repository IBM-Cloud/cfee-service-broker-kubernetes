#!/bin/bash

#
# login the ibmcloud CLI to perform resource command below
#
REGION=$(echo $CF_TARGET_URL | cut -d'.' -f3)
if [[ "${REGION}" == "us-south" ]]
then
  bx login -a api.ng.bluemix.net --apikey "${API_KEY}"
else
  bx login -a "api.${REGION}.bluemix.net" --apikey "${API_KEY}"
fi
bx target --cf-api "${CF_TARGET_URL}" -o "${CF_ORG}" -s "${CF_SPACE}"

#
# create an alias in CFEE to the Cloudant services instance in public Cloud
#
if ! bx resource service-alias cfee-cloudant; then
  echo "Creating service alias 'cfee-cloudant'"
  bx resource service-alias-create cfee-cloudant --instance-name cfee-cloudant
else
  echo "cfee-cloudant alias already exists"
fi

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
