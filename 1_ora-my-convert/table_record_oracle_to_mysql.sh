#!/bin/sh -u
	# settei file yomikomi
	. ./env.txt

	# hikisuu
	export tableName=$1

echo 'export oracle record'
echo table:${tableName}


	export NLS_DATE_FORMAT="YYYY-MM-DD HH24:MI:SS"

	$SQLPLUS -S -M 'csv on' ${ORACLE_USER}/${ORACLE_PASSWORD}@//${ORACLE_HOST}:${ORACLE_PORT}/${ORACLE_SERVER_NAME} <<-SQL > ${tableName}.csv
	SET HEADING OFF FEEDBACK OFF
	SET NULL NULL
	SELECT * FROM ${tableName};
	SQL

	export csvCount=`cat ${tableName}.csv | grep ',' | wc -l`

	if [[ ${csvCount} -lt 2 ]]; then
	  echo ${csvCount}
	  end
	fi


echo 'NULL rewrite'

	sed -i -e 's/"NULL"/NULL/g' ${tableName}.csv


echo 'import mysql record'

	MYSQL_PWD=${MYSQL_PASSWORD} mysql -u ${MYSQL_USERNAME} -A -h ${MYSQL_HOST} --local-infile=1 <<-SQL
	use ${MYSQL_DBNAME};
	set foreign_key_checks = 0;
	truncate ${tableName};
	LOAD DATA LOCAL INFILE './${tableName}.csv' INTO TABLE ${tableName} FIELDS TERMINATED BY ',' ENCLOSED BY '"';
	set foreign_key_checks = 1;
	SQL



echo '------'
