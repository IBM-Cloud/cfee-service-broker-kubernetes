#!/bin/bash

#
# login to IBM Cloud using the API key targeting a region and then target CFEE org and space.
#
echo "login to IBM Cloud using the API key targeting a region and then target CFEE org and space."
# ibmcloud login --apikey "$API_KEY" -region "$REGION"
ibmcloud login --apikey "$API_KEY" -r "us-south"
ibmcloud target --cf-api "$CF_TARGET_URL" -o "$CF_ORG" -s "$CF_SPACE"

#
# register the service broker and sample service with CFEE (done here because this is run as a Cloud Foundry deployer type)
#
BROKER_STATUS=$(cf service-brokers | grep my-company-broker)
if [[ "${BROKER_STATUS}" == "" ]]
then
  echo "Creating service broker"
  ibmcloud cf create-service-broker my-company-broker TestServiceBrokerUser TestServiceBrokerPassword http://tutorial-broker-service.default.svc.cluster.local
  echo "Enabling 'testnoderesourceservicebrokername' service"
  ibmcloud cf enable-service-access testnoderesourceservicebrokername
else
  echo "my-company-broker already exists"
fi

#
# create an instance of the "welcome" service (must be done as part of the CFEE deployer type)
#
echo "Checking for service instance 'welcome-service'"
if ! ibmcloud cf service welcome-service; then
  echo "Creating service instance 'welcome-service'"
  ibmcloud cf create-service testnoderesourceservicebrokername lite welcome-service
else
  echo "welcome-service already exists"
fi

#
# update the ASG IP range to include the service broker (assumes the default public_networks ASG is set)
#
ibmcloud cf security-group public_networks | sed '8,33!d' | sed "s|172.32.0.0-192.167.255.255|172.1.0.0-192.167.255.255|" > public_networks.json
echo "Modified public_networks ASG to the following:"
cat public_networks.json
echo "Updating public_networks ASG"
ibmcloud cf update-security-group public_networks ./public_networks.json

#
# deploy the "welcome" service app to receive service requests from other apps
# in a real-world usage, deployment of the app might occur automatically when the service is provisioned
#
echo "Deploying welcome service app"
cd ./sample-resource-service
ibmcloud cf push