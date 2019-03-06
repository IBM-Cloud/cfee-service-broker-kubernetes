#!/bin/bash

#
# login to IBM Cloud using the API key targeting a region and then target CFEE org and space.
#
echo "login to IBM Cloud using the API key targeting a region and then target CFEE org and space."
ibmcloud login --apikey "$API_KEY" 
ibmcloud target --cf-api "$CF_TARGET_URL" -o "$CF_ORG" -s "$CF_SPACE"


#
# create an alias in CFEE to the Cloudant services instance in public Cloud
#
ibmcloud cfee service-alias-create cfee-cloudant --service-instance-name cfee-cloudant


#
# deploy the GetStartedNode app
#
cd ./get-started-node
ibmcloud cf push

#
# bind Cloudant to this app
#
ibmcloud cf bind-service GetStartedNode cfee-cloudant

#
# bind the sample "welcome" service to this app
#
ibmcloud cf bind-service GetStartedNode welcome-service

#
# restart the service to load bindings
#
ibmcloud cf restart GetStartedNode
