FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7

USER root

RUN yum repolist > /dev/null && \
	yum clean all && \
    INSTALL_PKGS="3scale_toolbox" && \
    yum install -y --enablerepo=rhel-server-rhscl-7-rpms --enablerepo=rhel-7-server-3scale-amp-2.4-rpms --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

USER 1001