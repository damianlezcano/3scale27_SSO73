#!/bin/bash

oc login https://openshift.ase.local -u admin -p redhat01

oc new-project 3scale --display-name="3scale API Management" --description="3scale API Management Platform"

oc project 3scale

oc create -f amp.yml -n 3scale

#oc create -f pv-3scale_backend-redis-storage.yaml -n 3scale
#oc create -f pv-3scale_mysql-storage.yaml -n 3scale
#oc create -f pv-3scale_system-redis-storage.yaml -n 3scale
#oc create -f pv-3scale_system-storage.yaml -n 3scale

oc new-app --template=3scale-api-management -p ADMIN_PASSWORD=redhat01 -p WILDCARD_DOMAIN=3scale.apps.openshift.ase.local -p WILDCARD_POLICY=Subdomain -n 3scale

#apicast dev

oc project sume-dev

oc create secret generic apicast-configuration-url-secret --from-literal=password=https://413bbfe4b486ee108c175b8856c043914d7e6eed934ec7271537562ef4d51879@sume-dev-admin.3scale.apps.openshift.ase.local  --type=kubernetes.io/basic-auth -n sume-dev

oc new-app -f apicast.yml -p APICAST_NAME=apicast-staging -e BACKEND_ENDPOINT_OVERRIDE=https://backend-3scale.3scale.apps.openshift.ase.local -p DEPLOYMENT_ENVIRONMENT=staging -p CONFIGURATION_LOADER=lazy -n sume-dev


#apicast test

oc project sume-test

oc create secret generic apicast-configuration-url-secret --from-literal=password=https://c595af72f3683fc18cced67b6710abdab309bf7027dc9e0252b18b3b38383566@sume-test-admin.3scale.apps.openshift.ase.local  --type=kubernetes.io/basic-auth -n sume-test

oc new-app -f apicast.yml -p APICAST_NAME=apicast-staging -e BACKEND_ENDPOINT_OVERRIDE=https://backend-3scale.3scale.apps.openshift.ase.local -p DEPLOYMENT_ENVIRONMENT=staging -p CONFIGURATION_LOADER=lazy -n sume-test


#apicast uat

oc project sume-uat

oc create secret generic apicast-configuration-url-secret --from-literal=password=https://9cf6c2ac29bb2594eefe3881df2ee8099518a6cc63d044280ddd3cca4f2fce56@sume-uat-admin.3scale.apps.openshift.ase.local  --type=kubernetes.io/basic-auth -n sume-uat

oc new-app -f apicast.yml -p APICAST_NAME=apicast-staging -e BACKEND_ENDPOINT_OVERRIDE=https://backend-3scale.3scale.apps.openshift.ase.local -p DEPLOYMENT_ENVIRONMENT=staging -p CONFIGURATION_LOADER=lazy -n sume-uat

oc new-app -f apicast.yml -p APICAST_NAME=apicast-production -e BACKEND_ENDPOINT_OVERRIDE=https://backend-3scale.3scale.apps.openshift.ase.local -p DEPLOYMENT_ENVIRONMENT=production -p CONFIGURATION_LOADER=lazy -n sume-uat


# apicast prod

#token: 63c452e8310794a64857d074b64fa51204045d1e0451369128108038e56a6407







#oc new-app -f https://raw.githubusercontent.com/3scale/3scale-amp-openshift-templates/2.4.0.GA/apicast-gateway/apicast.yml -p APICAST_NAME=apicast-demo -p DEPLOYMENT_ENVIRONMENT=staging -p OPENSSL_VERIFY=false -p BACKEND_ENDPOINT_OVERRIDE=https://backend-3scale.3scale.apps-4c22.generic.opentlc.com:443 -p APICAST_MANAGEMENT_API=status -p OPENSSL_VERIFY=false -p APICAST_RESPONSE_CODES=true -p APICAST_CONFIGURATION_LOADER=lazy -p APICAST_CONFIGURATION_CACHE=0 -p THREESCALE_DEPLOYMENT_ENV=staging -p REDIS_URL=redis://system-redis-3scale.apps-4c22.generic.opentlc.com/2 -n sume-demo

#oc new-app -f https://raw.githubusercontent.com/3scale/3scale-amp-openshift-templates/2.4.0.GA/apicast-gateway/apicast.yml -p APICAST_NAME=apicast-demo -p MANAGEMENT_API=status -p OPENSSL_VERIFY=false -p RESPONSE_CODES=true -p CONFIGURATION_CACHE=0 -p DEPLOYMENT_ENVIRONMENT=staging -p REDIS_URL=redis://system-redis-3scale.apps.openshift.ase.local:6379/12 -n sume-demo
