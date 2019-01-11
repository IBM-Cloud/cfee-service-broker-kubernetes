#!/bin/bash

# 
# remove and clone the sample-resource-service-brokers repo
#
echo "Cloning sample service broker repository"
rm -rf ./sample-resource-service-brokers
git clone https://github.com/IBM/sample-resource-service-brokers.git

# 
# update the broker impl with a URL to the sample service
#
export BROKER_JS=./sample-resource-service-brokers/node-resource-service-broker/testresourceservicebroker.js
export SERVICE_URL=https://welcome.cfee-tutorial-cluster.us-south.containers.appdomain.cloud
echo "Injecting additional code ${BROKER_JS}"
sed -i "s|password : generatedPassword|password : generatedPassword,url : '${SERVICE_URL}'|" $BROKER_JS > BROKER_JS

# 
# re-use github.com/open-toolchain/commons to build image
# env vars must be set: ARCHIVE_DIR, BUILD_NUMBER, REGISTRY_URL, REGISTRY_NAMESPACE, IMAGE_NAME
#
source <(curl -sSL "https://raw.githubusercontent.com/open-toolchain/commons/master/scripts/build_image_kubectl.sh")
#source ./scripts/build_image_kubectl.sh
