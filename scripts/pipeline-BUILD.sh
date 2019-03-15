#!/bin/bash
export PATH=/opt/IBM/node-v6.7.0/bin:$PATH

# target the resource group where the cluster was created
ibmcloud target -g $TARGET_RESOURCE_GROUP

#
# get the URL to the CFEE instance
#
CFEE_URL=$(ibmcloud ks cluster-get $TARGET_CLUSTER_NAME --json | jq -r .ingressHostname)
echo "CFEE_URL=$CFEE_URL"

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

# 
# update get-started-node with calls to the "welcome" service
#
INDEX_HTML=./get-started-node/views/index.html
sed "s|<h1 data-i18n=\"welcome\"></h1>|<h1 id=\"welcome\"></h1>|" ${INDEX_HTML} > ${INDEX_HTML}.tmp
echo "<script>\$(document).ready(() => { $.get('./api/welcome').done(data => document.getElementById('welcome').innerHTML= data); });</script>" >> ${INDEX_HTML}.tmp
mv ${INDEX_HTML}.tmp ${INDEX_HTML}
#cat ${INDEX_HTML}

SERVER_JS=./get-started-node/server.js
sed "s_var port = process.env.PORT || 3000_const request = require('request'); \
const testService = appEnv.services['testnoderesourceservicebrokername']; \
\
if (testService) { \
  const { credentials: { url} } = testService[0]; \
  app.get('/api/welcome', (req, res) => request(url, (e, r, b) => res.send(b))); \
} else { \
  app.get('/api/welcome', (req, res) => res.send('Welcome')); \
} \
\
var port = process.env.PORT || 3000_" ${SERVER_JS} > ${SERVER_JS}.tmp
mv ${SERVER_JS}.tmp ${SERVER_JS}
#cat ${SERVER_JS}

cd get-started-node
npm i request -S
cd ..

# 
# re-use github.com/open-toolchain/commons to build image
# env vars must be set: ARCHIVE_DIR, BUILD_NUMBER, REGISTRY_URL, REGISTRY_NAMESPACE, IMAGE_NAME
#
source <(curl -sSL "https://raw.githubusercontent.com/open-toolchain/commons/dd99d4caa84a90404961d6e80e38874af057c8c8/scripts/build_image.sh")
