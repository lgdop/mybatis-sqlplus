# Docker Image for DB Migration Tool (MyBatis)

Use to run Mybatis sql scripts without installing Mybatis on the environment.


## Create Docker image
To create the docker image use

$ docker build -t mybatis-migrations-docker:latest .

Specify build arguments:
- PROTOCOL Protocol http(s) to access your Nexus instance
- HOSTNAME Hostname of the website where Nexus is hosted
- USERNAME User for Nexus http_auth
- PASSWORD Password for Nexus user

$ docker build -t mybatis-migrations-docker:latest --build-arg HOSTNAME=adop.mydomain.com --build-arg USERNAME=nexus-viewer --build-arg PASSWORD=ViWerPass . 

## Run Docker image
To run the docker image use the docker .env file with the following variables.
- DB_TYPE=Oracle The Database Type (Oracle, MySql, MSSql) Now only Oracle works
- DB_HOST=127.0.0.1 The database Host address
- DB_PORT=1521 The database Port
- DB_NAME=locdb The database Name (or SID)
- DB_USER=system The database system user (or other user with the right permissions to execute the scripts)
- DB_PASSWORD=oracle The Password of the DB user
- SCHEMA_NAME=FOO Name of the schema to use, in scripts available as ${schema_name}
- SCHEMA_PASS=fooTest Password of the schema (used for creation), in scripts available as ${schema_pass}
    
Also a volume with de SQL scripts must be mount to the mountpoint /migration/scripts in the container

docker run --env-file .env --rm -v <local folder>:/migration/scripts --name=mybatis-migrations-docker mybatis-migrations-docker:latest <myBatis cmd>

--env-file location of the .env file
--rm removes the container after excution is done
-v <local folder>:<container folder> mounts a volume
--name name of the container
mybatis-migrations-docker:latest name and version of the image


$ docker run --env-file .env --rm -v /tmp/migration/scripts:/migration/scripts --name=mybatis-migrations-docker mybatis-migrations-docker:latest status


## Bootstrap a database
This is used to setup the database schema from scratsh.
It requires a bootstrap.sql script.

$ docker run --env-file .env --rm -v /tmp/migration/scripts:/migration/scripts --name=mybatis-migrations-docker mybatis-migrations-docker:latest bootstrap


## Upgrade a database
This is used to upgrate the database schema.
It requires update scripts in the scripts folder.

Default required file is the create changelog script like: '20170106000000_create_changelog.sql'

$ docker run --env-file .env --rm -v /tmp/migration/scripts:/migration/scripts --name=mybatis-migrations-docker mybatis-migrations-docker:latest up


## Downgrade a database
This is used to downgrade the database schema.
It requires downgrade scripts in the scripts folder.

$ docker run --env-file .env --rm -v /tmp/migration/scripts:/migration/scripts --name=mybatis-migrations-docker mybatis-migrations-docker:latest down
