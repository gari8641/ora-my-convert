#!/bin/sh

cd `dirname $0`

CONVERT=$PWD/table_record_oracle_to_mysql.sh


$CONVERT table1
$CONVERT table2
$CONVERT table3
