#!/bin/bash

#
# login to IBM Cloud (public) to provision public services like Cloudant
#
echo Login IBM Cloud api=$CF_TARGET_URL org=$CF_ORG space=$CF_SPACE
bx login -a "$CF_TARGET_URL" --apikey "$API_KEY" -o "$CF_ORG" -s "$CF_SPACE"

REGION=$(bx target | grep Region | awk '{ print $2 }')

#
# create an instance of the cloudant service
#
echo "Checking for service instance 'cfee-cloudant'"
if ! cf service cfee-cloudant; then
  echo "Creating service instance 'cfee-cloudant'"
  bx resource service-instance-create cfee-cloudant cloudantnosqldb lite ${REGION}
else
  echo "cfee-cloudant already exists"
fi