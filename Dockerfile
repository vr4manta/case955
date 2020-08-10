FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7
ENV BUILD_LOGLEVEL=5 \
    HTTP_PROXY=http://10.76.225.15:80 \
    HTTPS_PROXY=http://10.76.225.15:80 \
    NO_PROXY=.cluster.local,.edc.ds1.usda.gov,.edc.usda.gov,.fema.net,.svc,10.0.0.0/8,10.178.81.25,10.178.81.26,10.178.81.27,169.254.169.254,172.30.0.1,fmapivt0095.edc.ds1.usda.gov,fmapivt0096.edc.ds1.usda.gov,fmapivt0097.edc.ds1.usda.gov,fmapivt0098.edc.ds1.usda.gov,fmapivt0099.edc.ds1.usda.gov,fmapivt0100.edc.ds1.usda.gov,fmapivt0101.edc.ds1.usda.gov,fmapivt0102.edc.ds1.usda.gov,fmapivt0103.edc.ds1.usda.gov,fmapivt0104.edc.ds1.usda.gov,fmapivt0105.edc.ds1.usda.gov,fmapivt0106.edc.ds1.usda.gov,fmapivt0107.edc.ds1.usda.gov,pivot-ppd-oscp.fema.net \
    http_proxy=http://10.76.225.15:80 \
    https_proxy=http://10.76.225.15:80 \
    no_proxy=.cluster.local,.edc.ds1.usda.gov,.edc.usda.gov,.fema.net,.svc,10.0.0.0/8,10.178.81.25,10.178.81.26,10.178.81.27,169.254.169.254,172.30.0.1,fmapivt0095.edc.ds1.usda.gov,fmapivt0096.edc.ds1.usda.gov,fmapivt0097.edc.ds1.usda.gov,fmapivt0098.edc.ds1.usda.gov,fmapivt0099.edc.ds1.usda.gov,fmapivt0100.edc.ds1.usda.gov,fmapivt0101.edc.ds1.usda.gov,fmapivt0102.edc.ds1.usda.gov,fmapivt0103.edc.ds1.usda.gov,fmapivt0104.edc.ds1.usda.gov,fmapivt0105.edc.ds1.usda.gov,fmapivt0106.edc.ds1.usda.gov,fmapivt0107.edc.ds1.usda.gov,pivot-ppd-oscp.fema.net
LABEL maintainer PIVOT DevOps <ocio-eas-fema-pivot-devops@ocio.usda.gov>
ARG http_proxy=http://10.76.225.15:80 
ARG https_proxy=http://10.76.225.15:80
ARG ftp_proxy=http://10.76.225.15:80
ARG no_proxy=.edc.ds1.usda.gov,edc.usda.gov,fema.net,localhost
LABEL com.redhat.component="jenkins-pivot-maven-agent" \
      name="openshift3/jenkins-pivot-maven-agent" \
      version="3.10" \
      architecture="x86_64" \
      release="4" \
      io.k8s.display-name="Jenkins Pivot Agent Maven" \
      io.k8s.description="The jenkins pivot agent maven image has the maven and nodejs tools on top of the jenkins agent base image." \
      io.openshift.tags="openshift,jenkins,agent,maven,nodejs,pivot-services,pivot-ui,pivot-config"
RUN curl --silent --location https://rpm.nodesource.com/setup_10.x  | bash - && \
    curl --silent --location -o /tmp/allure-2.9.0.zip https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.9.0/allure-commandline-2.9.0.zip  && \
    unzip -o /tmp/allure-2.9.0.zip -d /opt && \
    rm /tmp/allure-2.9.0.zip && \
    curl -sO http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm  && \
    rpm -ivh epel-release-latest-7.noarch.rpm && \
    yum update -y && \
    yum --enablerepo=rhel-7-server-extras-rpms --disablerepo=nodesource-source install -y         bzip2         docker-client         gcc-c++         java-1.8.0-openjdk-devel.x86_64         java-1.8.0-openjdk-devel.i686         jq         make         nodejs         openssl         wget         skopeo         ansible &&     yum clean all &&     rm -rf /var/cache/yum
