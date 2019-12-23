# jenkins-slave-3scale-toolbox

Inicialmente de debe construir la imagen desde alguno de los nodos subscriptos.

1) Ejecutar el comando para construir la imagen

> docker build -name jenkins-slave-3scale_toolbox .

2) Acceder al projecto jenkins "openshift" y hacer un import-image

> oc project cicd

> oc import-image jenkins-slave-3scale_toolbox --confirm

* Si genera un error de permisos, ignorarlo.

3) Hay que etiquetar la imagen de la siguiente forma:

> oc label is jenkins-slave-3scale_toolbox role=jenkins-slave -n np-apicast

4) Le damos permiso al proyecto para correr pipelines de jenkins

> oc adm policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n sume-dev

5) Creamos los pipelines

> oc create -f sume-dev/3scale-copy-service-pipeline-bc.yaml -n sume-dev
> oc create -f sume-dev/3scale-update-service-pipeline-bc.yaml -n sume-dev

> oc create -f sume-test/3scale-copy-service-pipeline-bc.yaml -n sume-test
> oc create -f sume-test/3scale-update-service-pipeline-bc.yaml -n sume-test

> oc create -f sume-uat/3scale-copy-service-pipeline-bc.yaml -n sume-uat
> oc create -f sume-uat/3scale-update-service-pipeline-bc.yaml -n sume-uat

6) Registramos el slave en Jenkins

> Acceder a Administrar Jenkins > Configurar el Sistema > Registrar un nuevo Kubernates Pod Templates

Kubernates Pod Templates
------------------------
- Name: 3scale_toolbox
- Label: 3scale_toolbox

- Container Template
  ------------------
-- Name: jnlp
-- Docker Image: docker-registry.default.svc:5000/openshift/jenkins-slave-3scale_toolbox
-- Working Directory: /tmp
-- Arguments to pass to the command: ${computer.jnlpmac} ${computer.name}

7) Asegurarse de tener cargado la lib en jenkins, para esto ir a Administrar Jenkins > Configurar el Sistema > Registrar/Verificar Global Pipeline Libraries

- Name: openshift-pipeline-library
- Default version: master
- Load implicitly: true
- Allow default version to be overridden: true
- Include @Library changes in job recent change: true
- Retrieval method -> Modern SCM
- Source Code Management -> GIT (completar los datos de conexión)

8) Ejecutar el pipeline