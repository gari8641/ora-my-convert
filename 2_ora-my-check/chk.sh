#!/bin/bash

# CSVがあるディレクトリ
ORACLE_CSV_DIR=../1_ora-my-convert
MYSQL_CSV_DIR=.



# ファイルの中身から「"」削除
function koteshon_delete () {
    sed -i -e 's/\(^\)"/\1/g' $1
    sed -i -e 's/\(,\)"/\1/g' $1
    sed -i -e 's/"\(,\)/\1/g' $1
    sed -i -e 's/"\($\)/\1/g' $1
}


# ORACLE
rm -f ora/*
cp ${ORACLE_CSV_DIR}/*.csv ora/.

# ORACLEのCSVファイル処理
while read -d $'\0' file; do
    koteshon_delete $file
    sort $file -o $file
done < <(find ./ora/ -mindepth 1 -maxdepth 1 -print0)


# MySQL
rm -f my/*
cp ${MYSQL_CSV_DIR}/*.csv my/.

# MySQLのCSVファイル処理
while read -d $'\0' file; do
    # koteshon_delete $file
    sort $file -o $file
done < <(find ./my/ -mindepth 1 -maxdepth 1 -print0)




# ORACLEとMySQLのcsv比較
diff -qr --ignore-file-name-case ora/ my/
