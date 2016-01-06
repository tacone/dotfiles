#!/usr/bin/env zsh

function mysql-import() {

  IMPORT_FILE=$1
  DATABASE=$2;
  DATE=`date +%Y-%m-%d-%H-%M-%S`
  BACKUP_FILE="/tmp/$DATABASE-$DATE.sql";
  OPTS=${@:3}
  USAGE="Usage: mysql-import [FILE] [DATABASE] [other mysql options...]"

  if [[ $1 == '--help' || -z "$DATABASE" || -z "$IMPORT_FILE" ]]; then
    echo $USAGE
    return 1;
  fi

  if [ ! -f "$IMPORT_FILE" ]; then
    echo "File $IMPORT_FILE has not been found. Please review the usage:";
    echo ;
    echo $USAGE;
    return 1;
  fi


  echo "Before being replaced current database will be backupped to:"
  echo $BACKUP_FILE
  echo
  ask-yn "Do you want to proceed?" 0;
  if [ $? -gt 0 ]; then
    echo;
    echo "Import aborted.";
    return 1;
  fi;

  echo;
  echo "Backing up database..."
  mysqldump $DATABASE ${=OPTS} > $BACKUP_FILE
  if [ $? -gt 0 ]; then
    echo;
    echo "Backup failed.";
    return 1;
  fi;
  echo "done"

  echo "dropping existing database..."
  mysql ${=OPTS} -e"DROP DATABASE IF EXISTS $DATABASE; CREATE DATABASE $DATABASE";
  if [ $? -gt 0 ]; then
    echo;
    echo "Error! Your database may now be in an inconsistent state.";
    echo "Please try again or manually import the backup file at: $BACKUP_FILE"
    return 1;
  fi;
  echo "done"

  echo;
  echo "importing the new database"
  mysql ${=OPTS} $DATABASE < $IMPORT_FILE
  if [ $? -gt 0 ]; then
    echo;
    echo "Error! Your database may now be in an inconsistent state.";
    echo "Please try again or manually import the backup file at: $BACKUP_FILE"
    return 1;
  fi;
  echo "done"
}

function mysql-export() {
  FOLDER=$1
  OPTS=${@:2}
  USAGE="Usage: mysql-export [FOLDER] [other mysql options...]"

  if [ ! -d "$FOLDER" ]; then
    echo "Folder \"$FOLDER\" has not been found. Please review the usage:";
    echo ;
    echo $USAGE;
    return 1;
  fi

  TIMESTAMP=`date +%Y-%m-%d_%H-%M-%S`;
  echo "Starting MySQL backup";
  echo ;

  databases=($(mysql ${=OPTS} -e "SHOW DATABASES;" | tr -d "| " | grep -Ev "(Database|information_schema|performance_schema)"));

  for DB in $databases; do
    echo "- backing up $DB to $FOLDER/$DB-$TIMESTAMP.sql.gz"
          mysqldump ${=OPTS} $DB > $FOLDER/$DB-$TIMESTAMP.sql
          gzip $FOLDER/$DB-$TIMESTAMP.sql
  done
  echo ;
  echo "done";
}
