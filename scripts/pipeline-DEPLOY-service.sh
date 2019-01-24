#!/bin/bash

#
# register the service broker and sample service with CFEE (done here because this is run as a Cloud Foundry deployer type)
#
BROKER_STATUS=$(cf service-brokers | grep my-company-broker)
if [[ "${BROKER_STATUS}" == "" ]]; then
  cf create-service-broker my-company-broker TestServiceBrokerUser TestServiceBrokerPassword http://tutorial-broker-service.default.svc.cluster.local
  cf enable-service-access testnoderesourceservicebrokername
else
  echo "my-company-broker already exists"
fi

#
# update the ASG IP range to include the service broker (assumes the default public_networks ASG is set)
#
cf security-group public_networks | sed '6,28!d' | sed "s|172.32.0.0-192.167.255.255|172.1.0.0-192.167.255.255|" > public_networks.json
cat public_networks.json
cf update-security-group public_networks ./public_networks.json

#
# ensure org and space exist
#
#source ./cf_create_org_space.sh

#
# deploy the "welcome" service app
#
cd ./sample-resource-service
cf push

#
# create an instance of the "welcome" service
#
SERVICE_STATUS=$(cf services | grep testnoderesourceservicebrokername)
if [[ "${SERVICE_STATUS}" == "" ]]; then
  cf create-service testnoderesourceservicebrokername lite welcome-service
else
  echo "welcome-service already exists"
fi