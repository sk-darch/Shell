#!/bin/bash
# Shell script to backup MySQL database

# Set these variables
DB_HOST=$1
DB_USER=$2
echo "Enter the Password"
read -s DB_PASS

# Linux bin paths
MYSQL="$(command -v mysql)"
MYSQLDUMP="$(command -v mysqldump)"

# Get date in dd-mm-yyyy format
NOW="$(date +"%d-%m-%Y")"

# Backup Destination directory
BKP_DEST="/u01/database_backups"
check_bkp_dir() {

    if [ ! -d $BKP_DEST ]
    then
        install -d $BKP_DEST
        else
            echo "Directory already exist"
    fi
}

# Create Backup sub-directories
MYSQL_BKP_DIR="$BKP_DEST"/MYSQL_"$NOW"

check_sub_dir() {

    if [ ! -d "$MYSQL_BKP_DIR" ]
    then
        install -d "$MYSQL_BKP_DIR"
        else
            echo "Directory already exist"
    fi
}

# DB skip list
SKIP_DB="information_schema
mysql
performance_schema
sys"

# Get all databases
DBS="$($MYSQL -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -Bse 'show databases')"

# Archive database dumps
archive_db() {

    for db in $DBS
    do
        skip_db=-1
        if [ "$SKIP_DB" != "" ];
        then
            for i in $SKIP_DB
            do
                [ "$db" == "$i" ] && skip_db=1 || :
            done
        fi

        if [ "$skip_db" == "-1" ] ; then
            FILE="$MYSQL_BKP_DIR"/"$db".sql
        $MYSQLDUMP -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$db" --all-databases --triggers --routines --events > "$FILE"
        fi
    done
}

check_bkp_dir
check_sub_dir
archive_db
