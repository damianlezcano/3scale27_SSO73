
En el SSO
==========

1) crear client
---------------

kie
openid-connect
http://rhpam5-rhpamcentr-prueba-rhpam.apps.openshift.ase.local
secret: 79b1de95-21af-4856-8b32-642d7cc3a153


kie-execution-server
openid-connect
http://rhpam5-kieserver-prueba-rhpam.apps.openshift.ase.local
secret: 4b4056a0-5dfb-475a-9aab-d6ac61845f18

kie-remote


2) crear roles
--------------

admin,analyst,developer,guest,kie-server,manager,process-admin,rest-all,user


3) crear usuarios
-----------------

KIE_ADMIN_USER: default user name adminUser, roles: kie-server,rest-all,admin

KIE_SERVER_CONTROLLER_USER: default user name controllerUser, roles: kie-server,rest-all,guest

BUSINESS_CENTRAL_MAVEN_USERNAME (not needed if you configure the use of an external Maven repository): default user name mavenUser. No roles are required.

KIE_SERVER_USER: default user name executionUser, roles kie-server,rest-all,guest

En Openshift
============

4) creamos el proyecto

oc new-project rhpam --display-name="Process Automation Manager" --description="Red Hat Process Automation Manager"


5) creamos los secrets con la keystore https

#este keystore lo descargue del openshift (creado por jhonatan madrigale)
oc create secret generic businesscentral-app-secret --from-file=keystore.jks
oc create secret generic kieserver-app-secret --from-file=keystore.jks


6) creamos la aplicacion

oc new-app -f rhpam73-authoring.yaml -p APPLICATION_NAME=rhpam5 -p BUSINESS_CENTRAL_HTTPS_SECRET=businesscentral-app-secret -p KIE_SERVER_HTTPS_SECRET=kieserver-app-secret -p BUSINESS_CENTRAL_HTTPS_PASSWORD=M3d1f32019 -p KIE_SERVER_HTTPS_PASSWORD=M3d1f32019 -e HTTPS_NAME=medife-desa -e HTTPS_PASSWORD=M3d1f32019 -p SSO_URL=https://sso-sso.apps.openshift.ase.local/auth -p SSO_REALM=medife-realm -p BUSINESS_CENTRAL_SSO_CLIENT=kie -p BUSINESS_CENTRAL_SSO_SECRET=79b1de95-21af-4856-8b32-642d7cc3a153 -p KIE_SERVER_SSO_CLIENT=kie-execution-server -p KIE_SERVER_SSO_SECRET=4b4056a0-5dfb-475a-9aab-d6ac61845f18 -p KIE_ADMIN_PWD=redhat01 -p KIE_SERVER_CONTROLLER_PWD=redhat01 -p KIE_SERVER_PWD=redhat01 -e RHPAMCENTR_MAVEN_REPO_PASSWORD=redhat01 -p SSO_DISABLE_SSL_CERTIFICATE_VALIDATION=true -p SSO_USERNAME=adminUser -p SSO_PASSWORD=redhat01 -n rhpam


7) creamos los apicast's

oc new-app -f rhpam73-kieserver-externaldb.yaml -p APPLICATION_NAME=kie-dev -p MAVEN_REPO_URL=http://nexus-cicd.apps.openshift.ase.local -p KIE_SERVER_EXTERNALDB_DIALECT=org.hibernate.dialect.Oracle12cDialect -p KIE_SERVER_EXTERNALDB_DRIVER=oracle -p KIE_SERVER_EXTERNALDB_USER=MF_SUMERHPAM -p KIE_SERVER_EXTERNALDB_PWD=SXJ9pBxmxXkDcd5q -p KIE_SERVER_HTTPS_SECRET=kieserver-app-secret -e KIE_SERVER_EXTERNALDB_HOST=10.3.5.134 -e KIE_SERVER_EXTERNALDB_PORT=1521 -p KIE_SERVER_EXTERNALDB_DB=MF_SUMERHPAM -p KIE_SERVER_HTTPS_PASSWORD=M3d1f32019 -e RHPAM_URL=jdbc:oracle:thin:@10.3.5.134:1521/sume12c -e HTTPS_NAME=medife-desa -e HTTPS_PASSWORD=M3d1f32019 -p SSO_URL=https://sso-sso.apps.openshift.ase.local/auth -p SSO_REALM=medife-realm -p KIE_SERVER_SSO_CLIENT=kie-execution-server -p KIE_SERVER_SSO_SECRET=4b4056a0-5dfb-475a-9aab-d6ac61845f18 -p KIE_ADMIN_PWD=redhat01 -p KIE_SERVER_CONTROLLER_PWD=redhat01 -p KIE_SERVER_PWD=redhat01 -e RHPAMCENTR_MAVEN_REPO_PASSWORD=redhat01 -p SSO_DISABLE_SSL_CERTIFICATE_VALIDATION=true -p SSO_USERNAME=adminUser -p SSO_PASSWORD=redhat01


#despues cambiar la imagen manualmente desde openshift-console por rhpam73-kieserver-oracle-openshift:1.1


Documentación y comandos útiles
===============================

https://access.redhat.com/documentation/en-us/red_hat_process_automation_manager/7.3/

https://access.redhat.com/documentation/en-us/red_hat_process_automation_manager/7.2/html-single/integrating_red_hat_process_automation_manager_with_red_hat_single_sign-on/index

https://access.redhat.com/documentation/en-us/red_hat_process_automation_manager/7.2/html-single/installing_and_configuring_red_hat_process_automation_manager_on_red_hat_jboss_eap_7.2/roles-users-con#roles-users-con

https://access.redhat.com/documentation/en-us/red_hat_process_automation_manager/7.2/html-single/deploying_a_red_hat_process_automation_manager_authoring_environment_on_red_hat_openshift_container_platform/index

https://access.redhat.com/documentation/en-us/red_hat_process_automation_manager/7.3/html-single/deploying_a_red_hat_process_automation_manager_authoring_environment_on_red_hat_openshift_container_platform/index

# construir nueva imagen con driver oracle para kie-server
https://access.redhat.com/documentation/en-us/red_hat_process_automation_manager/7.3/html-single/deploying_a_red_hat_process_automation_manager_authoring_environment_on_red_hat_openshift_container_platform/index#externaldb-build-proc

cd rhpam/jdbc/oracle-driver-image
scp -r jdbc consultor_redhat@srv940closb01.ase.local:/home/consultor_redhat
../build.sh --artifact-repo=http://nexus-cicd.apps.openshift.ase.local/nexus/content/groups/public --registry=docker-registry-default.apps.openshift.ase.local:443



# oc rsync nexus-1-bz2c7:/sonatype-work/storage/public/com/oracle/ojdbc7/12.1.0.1 .

# docker pull registry.redhat.io/rhpam-7/rhpam73-kieserver-openshift
# docker pull registry.redhat.io/rhpam-7/rhpam73-businesscentral-openshift

# docker login -u admin -p $token https://docker-registry-default.apps.openshift.ase.local

# docker tag registry.redhat.io/rhpam-7/rhpam73-businesscentral-openshift:latest docker-registry-default.apps.openshift.ase.local/openshift/rhpam73-businesscentral-openshift:1.1
# docker push docker-registry-default.apps.openshift.ase.local/openshift/rhpam73-businesscentral-openshift:1.1

# docker tag registry.redhat.io/rhpam-7/rhpam73-kieserver-openshift:latest docker-registry-default.apps.openshift.ase.local/openshift/rhpam73-kieserver-openshift:1.1
# docker push docker-registry-default.apps.openshift.ase.local/openshift/rhpam73-kieserver-openshift:1.1
