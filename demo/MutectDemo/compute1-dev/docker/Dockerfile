FROM ubuntu:xenial
MAINTAINER Matthew A. Wyczalkowski <m.wyczalkowski@wustl.edu>
# Based on John Garza's https://github.com/johnegarza/docker-cromwell/blob/master/Dockerfile

LABEL \
    description="Packages necessary to run cromwell and CromwellRunner on LSF, and a few utility tools"

RUN apt-get update -y && apt-get install -y \
    apt-utils \
    curl \
    default-jdk \
    gettext-base \
    git \
    jq \
    libnss-sss \
    parallel \
    vim \
    wget

RUN mkdir -p /usr/local/cromwell && \
    cd /usr/local/cromwell && \
    wget https://github.com/broadinstitute/cromwell/releases/download/47/cromwell-47.jar

ENV LC_ALL="C"

# python-pip \
# RUN pip install --upgrade pip
# RUN pip install pyyaml
# RUN pip install unidecode
# RUN pip install 'setuptools>=18.5'
# RUN pip install cwltool
# RUN pip install 'ruamel.yaml==0.14.2'
