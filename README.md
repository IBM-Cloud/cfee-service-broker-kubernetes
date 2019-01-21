🚧 UNDER CONSTRUCTION 🚧

# CFEE Service Broker on Kubernetes

This repository is a companion to the Isolated [Cloud Foundry Enterprise Environment](https://cloud.ibm.com/cfadmin/create) (CFEE) solution tutorial. It will deploy a Node.js service broker to an IBM Kubernetes Service cluster. A sample service can also be deployed to demonstrate binding with the [get-started-node](https://github.com/IBM-Cloud/get-started-node) sample.

Refer to this tutorial for instructions.

## Deploy with a toolchain

This project comes with a partially automated toolchain capable of deploying the service broker and service to IBM Cloud.

### Prerequisites

1. Create a [Cloud Foundry Enterprise Environment](https://cloud.ibm.com/cfadmin/create) service instance.
2. A CFEE org and space name will be needed for the toolchain. Create them using the instructions below.
    ```sh
    ibmcloud target --cf
    <choose your CFEE instance name>
    ibmcloud cf create-org cfee-tutorial
    ibmcloud target -o cfee-tutorial
    ibmcloud cf create-space dev
    ibmcloud target -s dev
    ```

### And then

[![Create toolchain](https://console.bluemix.net/devops/graphics/create_toolchain_button.png)](https://cloud.ibm.com/devops/setup/deploy/?repository=https%3A//github.com/IBM-Cloud/cfee-service-broker-kubernetes)

Once the toolchain has completed: 
- The application will be available at `https://getstartednode.<your-cluster-ingress-domain>`.
- The service broker will be available at `https://welcome.<your-cluster-ingress-domain>`.

The following artifacts will be available.

| Artifact | Description |
| -------- | ----------- |
| Service Broker | Provides an additional mock service to the Cloud Foundry marketplace in CFEE |
| Welcome Service | Sample service that provides welcome text in several languages |
| GetStartedNode | Modified [get-started-node](https://github.com/IBM-Cloud/get-started-node) app using the Welcome Service |

## Usage

See the solution tutorial.