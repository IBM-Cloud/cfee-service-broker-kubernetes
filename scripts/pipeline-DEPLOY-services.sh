#!/bin/bash

#
# login to IBM Cloud (public) to provision public services like Cloudant
#
# echo Login IBM Cloud api=$CF_TARGET_URL org=$CF_ORG space=$CF_SPACE
# ibmcloud login -a "$CF_TARGET_URL" --apikey "$API_KEY" 

REGION=$(ibmcloud target | grep Region | awk '{ print $2 }')
echo ${REGION}

# create an instance of the cloudant service
  echo "Creating service instance 'cfee-cloudant'"
  ibmcloud resource service-instance-create cfee-cloudant cloudantnosqldb lite ${REGION}

