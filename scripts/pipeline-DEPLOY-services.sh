#!/bin/bash

#
# Login to IBM Cloud (public) to provision public services like Cloudant
# -> Kubernetes deployment is used, meaning no need to login, the state inside inside toolchain Kubernetes is already logged into the account
# -> echo Login IBM Cloud api=$CF_TARGET_URL org=$CF_ORG space=$CF_SPACE
# ibmcloud login -a "$CF_TARGET_URL" --apikey "$API_KEY" 

# Get region and store inside ${REGION}
REGION=$(ibmcloud target | grep Region | awk '{ print $2 }')

# create an instance of the cloudant service
echo "Checking for service instance 'cfee-cloudant'"
if ! ibmcloud resource service-instance cfee-cloudant; then
    echo "Creating service instance 'cfee-cloudant'"  
    ibmcloud resource service-instance-create cfee-cloudant cloudantnosqldb lite ${REGION}
else
    echo "cfee-cloudant already exists"
fi

