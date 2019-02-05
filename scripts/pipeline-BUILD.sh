#!/bin/bash
export PATH=/opt/IBM/node-v6.7.0/bin:$PATH

#
# get the URL to the CFEE instance
#
CFEE_URL=$(bx cs cluster-get ${PIPELINE_KUBERNETES_CLUSTER_NAME} | grep "Ingress Subdomain:" | awk '{ print $3 }')

# 
# remove and clone the sample-resource-service-brokers repo
#
REPO=https://github.com/IBM/sample-resource-service-brokers.git
echo "Cloning ${REPO}"
rm -rf ./sample-resource-service-brokers
git clone ${REPO}

# 
# update the broker impl with a URL to the sample service
#
BROKER_JS=./sample-resource-service-brokers/node-resource-service-broker/testresourceservicebroker.js
echo "Injecting additional code into ${BROKER_JS}"
sed "s|password : generatedPassword|password : generatedPassword,url : 'https://welcome.${CFEE_URL}'|" ${BROKER_JS} > ${BROKER_JS}.tmp
mv ${BROKER_JS}.tmp ${BROKER_JS}
#cat ${BROKER_JS}

#
# remove and clone the get-started-node repo
#
REPO=https://github.com/IBM-Cloud/get-started-node.git
echo "Cloning ${REPO}"
rm -rf ./get-started-node
git clone ${REPO}

