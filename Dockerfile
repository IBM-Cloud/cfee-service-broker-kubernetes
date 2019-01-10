FROM node:8

# copy the nodejs implementation to the image
COPY sample-resource-service-brokers/node-resource-service-broker .

# build the nodejs app
WORKDIR .
RUN npm install
EXPOSE 3000

# run the nodejs app
CMD ["node","testresourceservicebroker.js"]