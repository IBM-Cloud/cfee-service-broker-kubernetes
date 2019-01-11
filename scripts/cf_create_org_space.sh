#!/bin/bash
# uncomment to debug the script
#set -x
#CF_TRACE=true

echo "=========================================================="
echo "CHECKING if CF org ${CF_ORG} exists"
ORG_STATUS=$(ibmcloud cf org ${CF_ORG} | tail -1)

if [[ "${ORG_STATUS}" == "FAILED" ]]; then
  echo "creating ${CF_ORG}"
  cf create-org ${CF_ORG}
else
  echo "${CF_ORG} exists"
fi

cf target -o ${CF_ORG}
echo "=========================================================="

echo "=========================================================="
echo "CHECKING if CF space ${CF_SPACE} exists"
SPACE_STATUS=$(ibmcloud cf space ${CF_SPACE} | tail -1)

if [[ "${SPACE_STATUS}" == "FAILED" ]]; then
  echo "creating ${CF_SPACE}"
  cf create-space ${CF_SPACE}
else
  echo "${CF_ORG} exists"
fi

cf target -s ${CF_SPACE}
echo "=========================================================="