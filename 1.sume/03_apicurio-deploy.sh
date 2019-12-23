#!/bin/bash

oc login https://prod-ocp-api.bue299.comafi.com.ar --token=vESXQ742ygSZsW95kxhNlFpHRrL6UcF_cn43D_MEs8o

oc new-project apicurio-studio --display-name="Apicurio Studio" --description="Web-Based Open Source API Design via the OpenAPI specification."

#----------------------------------

oc project default

oc port-forward docker-registry-18-n6cq4 5000:5000

oc whoami -t
docker login -u admin -p DUbCgsoMZJzMP0xDo7M5XufdOGB1XnG2LCZlluwvbmc localhost:5000

docker pull apicurio/apicurio-studio-api:0.2.27.Final
docker pull apicurio/apicurio-studio-ui:0.2.27.Final
docker pull apicurio/apicurio-studio-ws:0.2.27.Final

docker tag apicurio/apicurio-studio-api:0.2.27.Final localhost:5000/apicurio-studio/apicurio-studio-api:latest-snapshot
docker push localhost:5000/apicurio-studio/apicurio-studio-api:latest-snapshot

docker tag apicurio/apicurio-studio-ui:0.2.27.Final localhost:5000/apicurio-studio/ui:latest-snapshot
docker push localhost:5000/apicurio-studio/ui:latest-snapshot

docker tag apicurio/apicurio-studio-ws:0.2.27.Final localhost:5000/apicurio-studio/ws:latest-snapshot
docker push localhost:5000/apicurio-studio/ws:latest-snapshot

docker pull registry.redhat.io/fuse7/fuse-apicurito
docker pull registry.redhat.io/fuse7/fuse-apicurito-generator

docker tag registry.redhat.io/fuse7/fuse-apicurito localhost:5000/apicurio-studio/fuse-apicurito:1.3
docker push localhost:5000/apicurio-studio/fuse-apicurito:1.3

docker tag registry.redhat.io/fuse7/fuse-apicurito-generator localhost:5000/apicurio-studio/fuse-apicurito-generator:1.3
docker push localhost:5000/apicurio-studio/fuse-apicurito-generator:1.3

#----------------------------------

oc project apicurio-studio

oc create -f apicurio-standalone-template.yml

oc new-app --template=apicurio-studio -p UI_ROUTE=apicurio-studio-ui-apicurio-studio.apps.bue299.comafi.com.ar -p API_ROUTE=apicurio-studio-api-apicurio-studio.apps.bue299.comafi.com.ar -p WS_ROUTE=apicurio-studio-ws-apicurio-studio.apps.bue299.comafi.com.ar -p AUTH_ROUTE=sso-prod-comafi-sso.apps.bue299.comafi.com.ar
#oc new-app --template=apicurio-studio-standalone -p UI_ROUTE=apicurio-studio-ui-apicurio-studio.apps.bue299.comafi.com.ar -p API_ROUTE=apicurio-studio-api-apicurio-studio.apps.bue299.comafi.com.ar -p WS_ROUTE=apicurio-studio-ws-apicurio-studio.apps.bue299.comafi.com.ar -p AUTH_ROUTE=keycloak-microcks.apps.bue299.comafi.com.ar