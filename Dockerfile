FROM openjdk:alpine

MAINTAINER Ilia Shakitko <ilia.shakitko@accenture.com>

RUN apk add --update bash && rm -rf /var/cache/apk/*


# Making MyBatis version an argument (in case a snapshot version needs to be built)
# --------------------
ARG VERSION="3.2.1"


# Adding (downloading) the archive
# --------------------
ADD https://github.com/mybatis/migrations/releases/download/mybatis-migrations-"$VERSION"/mybatis-migrations-"$VERSION".zip /tmp/mybatis-migrations-"$VERSION".zip


# Will store the binaries in "opt" for optional software
# --------------------
RUN mkdir /opt


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
ADD http://34.252.76.112/nexus/service/local/repositories/thirdparty/content/com/oracle/ojdbc7/12.0.0.1/ojdbc7-12.0.0.1.jar /migration/drivers


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
