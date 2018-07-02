FROM centos:latest

MAINTAINER Ilia Shakitko <ilia.shakitko@accenture.com>

# Java Env Variables
ENV JAVA_VERSION=1.6.0
ENV JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.41.x86_64/jre

# Making MyBatis version an argument (in case a snapshot version needs to be built)
# --------------------
ARG VERSION="3.3.2-SNAPSHOT"
ARG REPOSITORY="snapshots"
ARG PROTOCOL="https"
ARG USERNAME="##USE_ARGUMENTS##"
ARG PASSWORD="##USE_ARGUMENTS##"
ARG HOSTNAME="##USE_ARGUMENTS##"

RUN yum -y install net-utils ldap-utils htop telnet nc \
    git \
    wget \
    tar \
    zip \
    unzip \
    openldap-clients \
    openssl \
    python-pip \
    libxslt \
    java-1.6.0-openjdk \ 
    libaio1 \
    rlwrap && \
    yum clean all

#Adding the sqlplus dependencies

COPY basic-10.2.0.5.0-linux-x64.zip /
COPY sqlplus-10.2.0.5.0-linux-x64.zip / 
COPY sdk-10.2.0.5.0-linux-x64.zip /
COPY jdbc-10.2.0.5.0-linux-x64.zip /

RUN unzip basic-10.2.0.5.0-linux-x64.zip && unzip sqlplus-10.2.0.5.0-linux-x64.zip && unzip sdk-10.2.0.5.0-linux-x64.zip && unzip jdbc-10.2.0.5.0-linux-x64.zip

ENV LD_LIBRARY_PATH /instantclient_10_2

RUN export PATH=/instantclient_10_2:$PATH

# Adding (downloading) the archive
# --------------------
# ADD https://github.com/mybatis/migrations/releases/download/mybatis-migrations-"$VERSION"/mybatis-migrations-"$VERSION".zip /tmp/mybatis-migrations-"$VERSION".zip
ADD https://oss.sonatype.org/content/repositories/snapshots/org/mybatis/mybatis-migrations/3.3.2-SNAPSHOT/mybatis-migrations-3.3.2-20180118.183255-24-bundle.zip /tmp/mybatis-migrations-"$VERSION".zip


# Will store the binaries in "opt" for optional software
# --------------------
RUN mkdir -p /opt


# Unzipping, creating symlink to the migrations binaries
# --------------------
RUN unzip /tmp/mybatis-migrations-"$VERSION".zip -d /opt/ && \
	rm -f /tmp/mybatis-migrations-"$VERSION".zip && \
	chmod +x /opt/mybatis-migrations-"$VERSION"/bin/migrate && \
	ln -s /opt/mybatis-migrations-"$VERSION" /opt/mybatis-migrations


# Creating database workspace folders
# --------------------
RUN mkdir -p /migration/drivers && \
	mkdir -p /migration/environments && \
	mkdir -p /migration/scripts

# Add oracle jdbc driver
# --------------------
# ADD "$PROTOCOL"://"$USERNAME":"$PASSWORD"@"$HOSTNAME"/nexus/service/local/repositories/thirdparty/content/com/oracle/ojdbc7/12.1.0.1/ojdbc7-12.1.0.1.jar /migration/drivers/ojdbc7.jar
#ADD "$PROTOCOL"://"$USERNAME":"$PASSWORD"@"$HOSTNAME"/nexus/service/local/repositories/thirdparty/content/com/oracle/ojdbc14/10.2.0.5/ojdbc14-10.2.0.5.jar /migration/drivers/ojdbc14.jar
RUN cp /instantclient_10_2/ojdbc14.jar /migration/drivers/ojdbc14.jar

# Add script that builds migration environment file and launches the binary
ADD sql /migration/scripts
ADD container-scripts/migrate.sh /opt/migrate.sh
RUN chmod +x /opt/migrate.sh


# Setting up working directory to the folder with migration database (scripts, drivers, environments)
# --------------------
WORKDIR /migration

# Execute migrate.sh on "docker run"
# --------------------
ENTRYPOINT ["/opt/migrate.sh"]
