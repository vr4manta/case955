FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7

LABEL maintainer="PIVOT DevOps <ocio-eas-fema-pivot-devops@ocio.usda.gov>"

ENV BUILD_LOGLEVEL="5"

#ARG http_proxy=http://10.76.225.15:80
#ARG https_proxy=http://10.76.225.15:80
#ARG ftp_proxy=http://10.76.225.15:80
ARG no_proxy=.edc.ds1.usda.gov,edc.usda.gov,fema.net,localhost

LABEL com.redhat.component="jenkins-pivot-maven-agent" \
      name="openshift3/jenkins-pivot-maven-agent" \
      version="3.10" \
      architecture="x86_64" \
      release="4" \
      io.k8s.display-name="Jenkins Pivot Agent Maven" \
      io.k8s.description="The jenkins pivot agent maven image has the maven and nodejs tools on top of the jenkins agent base image." \
      io.openshift.tags="openshift,jenkins,agent,maven,nodejs,pivot-services,pivot-ui,pivot-config"

RUN curl --silent --location https://rpm.nodesource.com/setup_10.x | bash - && \
    curl --silent --location -o /tmp/allure-2.9.0.zip https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.9.0/allure-commandline-2.9.0.zip && \
    unzip -o /tmp/allure-2.9.0.zip -d /opt && \
    rm /tmp/allure-2.9.0.zip && \
    curl -sO http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -ivh epel-release-latest-7.noarch.rpm && \
    yum update -y && \
    yum --enablerepo=rhel-7-server-extras-rpms --disablerepo=nodesource-source install -y \
        bzip2 \
        docker-client \
        gcc-c++ \
        java-1.8.0-openjdk-devel.x86_64 \
        java-1.8.0-openjdk-devel.i686 \
        jq \
        make \
        nodejs \
        openssl \
        wget \
        skopeo \
        ansible && \
    yum clean all && \
    rm -rf /var/cache/yum

ENV FORTIFY_HOME=/opt/Fortify
ENV JMETER_HOME=/opt/jmeter
ENV KATALON_HOME=/opt/Katalon

ENV MAVEN_HOME=$HOME/.m2 \
    MAVEN_VERSION=3.5.4 \
    NPM_CONFIG_PREFIX=${HOME}/node/.npm-global \
    PATH=$PATH:${HOME}/maven/bin:${HOME}/node/.npm-global/bin:${FORTIFY_HOME}/bin:${JMETER_HOME}/bin:${KATALON_HOME}

RUN wget https://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz && \
        tar -xkvf apache-maven-3.5.4-bin.tar.gz && \
        mv apache-maven-3.5.4 ${HOME}/maven && \
    rm -rf apache-maven-3.5.4-bin.tar.gz && \
    mkdir -p ${HOME}/.m2

COPY configuration/* ${NPM_CONFIG_PREFIX}/etc/
# This is sourced by the entrypoint
COPY configuration/configure-slave /usr/local/bin/configure-slave

# Copy Fortify SCA
COPY Fortify ${FORTIFY_HOME}

# Copy jMeter
COPY jmeter ${JMETER_HOME}

# Copy Katalon
COPY Katalon ${KATALON_HOME}

RUN chown -R 1001:0 ${HOME} && \
    chown -R 1001:0 ${NPM_CONFIG_PREFIX} && \
    chmod -R 777 ${HOME} && \
    chown -R 1001:0 ${FORTIFY_HOME} && \
    chown -R 1001:0 ${JMETER_HOME} && \
    chown -R 1001:0 ${KATALON_HOME}

USER 1001

RUN npm install -g @angular/cli && \
    chmod -R 777 ${NPM_CONFIG_PREFIX} && \
    chmod -R 777 ${HOME} && \
    chmod -R 777 ${FORTIFY_HOME} && \
    chmod -R 777 ${JMETER_HOME} && \
    chmod -R 777 ${KATALON_HOME}