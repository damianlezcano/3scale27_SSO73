#!/bin/bash

oc login https://openshift.ase.local -u admin -p redhat01

oc new-project sso --display-name="Single Sign-On" --description="Single Sign-On"

oc project sso

#oc policy add-role-to-user view system:serviceaccount:sso:default

template=sso72-x509-postgresql-persistent

oc new-app ${template} \
 -p SSO_ADMIN_USERNAME="admin" \
 -p SSO_ADMIN_PASSWORD="redhat01" \
 -p SSO_REALM="medife-realm"
 
 sleep 1
 route_name=$(oc get routes -l app=${template} | { read line1 ; read line2 ; echo "$line2" ; } | awk '{print $2;}')
 
 # config map is used by clients to connect to rh-sso and database
 oc create configmap ntier-config \
    --from-literal=AUTH_URL=https:\/\/${route_name}/auth \
    --from-literal=KEYCLOAK=true \
    --from-literal=PUBLIC_KEY=changeme \
    --from-literal=PG_CONNECTION_URL=jdbc:postgresql:\/\/postgresql\/jboss \
    --from-literal=PG_USERNAME=pguser \
    --from-literal=PG_PASSWORD=pgpass