# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile and 
# https://github.com/justb4/docker-jmeter/blob/master/Dockerfile
FROM alpine:3.6

LABEL maintainer=Kartik

ARG JMETER_VERSION="4.0"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  http://mirrors.ocf.berkeley.edu/apache/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

# Install extra packages
# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

# Get python
RUN  apk add --update \
    python \
    python-dev \
    py-pip \
    build-base 

# Get aws cli 
RUN pip install awscli

# TODO: plugins (later)
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Make repots directory
RUN mkdir ${JMETER_HOME}/reports

#put index into reports dir
COPY index.html ${JMETER_HOME}/reports/index.html

# cp src to ipayroll
COPY src ${JMETER_HOME}/ipayroll

# cp runAll sh 
COPY runAll.sh ${JMETER_HOME}/runAll.sh

# cp putreports  
COPY putReports.sh ${JMETER_HOME}/putReports.sh

#set work dir
WORKDIR	${JMETER_HOME}
