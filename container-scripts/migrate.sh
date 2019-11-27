#!/bin/bash
#: ${DB_DRIVER:=oracle.jdbc.OracleDriver}
#: ${DB_CONNECTION_URL:=jdbc:oracle:thin:@localhost:1521/locdb}

#env

echo "DB_TYPE		    : $DB_TYPE"
echo "DB_HOST	        : $DB_HOST"
echo "DB_PORT		    : $DB_PORT"
echo "DB_NAME           : $DB_NAME"
echo "DB_USER           : $DB_USER"

CHANGELOG_TABLE="CHANGELOG"
if [[ ! -z "$MODULE_NAME" ]] ; then
    CHANGELOG_TABLE="CHANGELOG_$MODULE_NAME"

    echo "MODULE_NAME           : $MODULE_NAME"
    echo "CHANGELOG_TABLE       : $CHANGELOG_TABLE"
fi

if [ "$DB_TYPE" == "Oracle" ] ; then
	echo "> Oracle Databse"
	
	DB_DRIVER="oracle.jdbc.OracleDriver"
	DB_CONNECTION_URL="jdbc:oracle:thin:@$DB_HOST:$DB_PORT/$DB_NAME"
fi

echo "DB_DRIVER			: $DB_DRIVER"
echo "DB_CONNECTION_URL : $DB_CONNECTION_URL"
echo 


#- Create mybatis properties file
#--------------------------------
cat <<CONF > /migration/environments/development.properties
time_zone=CET

driver=$DB_DRIVER
url=$DB_CONNECTION_URL
username=$DB_USER
password=$DB_PASSWORD

script_char_set=UTF-8
send_full_script=false
delimiter=;
full_line_delimiter=false
auto_commit=true
changelog=$CHANGELOG_TABLE
ignore_warnings=true

ORACLE_SID=$ORACLE_SID
ARBORENV=$ARBORENV
ARBORDATA=$ARBORDATA
module_name=$MODULE_NAME
LOGNAME=$LOGNAME
CONF


#- Check / Wait for Database connection
#--------------------------------------
DB_CONNECTION_OK=true
TRIES=0

# echo "- Check / Wait for Database connection (10 tries)"
# echo "   > Waiting for database connection"

# while ! $DB_CONNECTION_OK; do
#     echo "    Try: $TRIES"

#     nc -z $DB_HOST $DB_PORT </dev/null
#     if [ "$?" -eq "0" ]; then
#         echo "  Database connection Ok"
#         DB_CONNECTION_OK=true
#         break
#     fi

#     if [ $TRIES -gt 9 ]; then
#        echo "Timeout"
#        exit 1
#     fi

#     TRIES=$(( $TRIES + 1))

#     sleep 2
# done

# echo


#- Create mybatis properties file
#--------------------------------
echo "- Run Mybatis"

#: ${MYBATIS_CMD:='up'}
#echo "  MYBATIS_CMD: $MYBATIS_CMD"

cd "/migration"
/opt/mybatis-migrations/bin/migrate "$@"
