#!/bin/bash

oc login https://prod-ocp-api.bue299.comafi.com.ar --token=vESXQ742ygSZsW95kxhNlFpHRrL6UcF_cn43D_MEs8o

oc new-project microcks --display-name="Microcks" --description="A communication and runtime tool for API mocks"

oc project microcks

#-----------------------------------

docker pull microcks/microcks
docker pull microcks/microcks-postman-runtime
docker pull mongo:3.2
docker pull jboss/keycloak-openshift:3.4.0.Final
docker pull jimmidyson/pemtokeystore:v0.2.0

docker tag microcks/microcks localhost:5000/microcks/microcks:latest
docker push localhost:5000/microcks/microcks:latest

docker tag microcks/microcks-postman-runtime localhost:5000/microcks/microcks-postman-runtime:latest
docker push localhost:5000/microcks/microcks-postman-runtime:latest

docker tag mongo:3.2 localhost:5000/microcks/mongo:3.2
docker push localhost:5000/microcks/mongo:3.2

docker tag jboss/keycloak-openshift:3.4.0.Final localhost:5000/microcks/keycloak-openshift:3.4.0.Final
docker push localhost:5000/microcks/keycloak-openshift:3.4.0.Final

docker tag jimmidyson/pemtokeystore:v0.2.0 localhost:5000/microcks/pemtokeystore:v0.2.0
docker push localhost:5000/microcks/pemtokeystore:v0.2.0



oc create -f microcks-openshift-persistent-full-template.yml

oc new-app --template=microcks-persistent --param=APP_ROUTE_HOSTNAME="microcks-microcks.apps.openshift.ase.local" --param=KEYCLOAK_ROUTE_HOSTNAME="https://sso-sso.apps.openshift.ase.local" --param=OPENSHIFT_MASTER="https://openshift.ase.local" --param=OPENSHIFT_OAUTH_CLIENT_NAME=microcks-client


openssl s_client -connect sso-sso.apps.openshift.ase.local:443 -servername sso-sso-rh -showcerts

oc create configmap customCA --from-file=./customCA.pem