#!/bin/bash

if [ ! -f "/app/my.cnf" ]; then
    cp /etc/mysql/my.cnf /app/my.cnf
fi

if [ -d /app/mysql ]; then
  echo "[i] MySQL directory already present, skipping creation"
  if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
  fi
else
  echo "[i] MySQL data directory not found, creating initial DBs"

  mysql_install_db --user=root > /dev/null

  if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
    MYSQL_ROOT_PASSWORD=111111
    echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
  fi

  MYSQL_DATABASE=${MYSQL_DATABASE:-""}
  MYSQL_USER=${MYSQL_USER:-""}
  MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

  if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
  fi

  tfile=`mktemp`
  if [ ! -f "$tfile" ]; then
      return 1
  fi

  cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
EOF

  if [ "$MYSQL_DATABASE" != "" ]; then
    echo "[i] Creating database: $MYSQL_DATABASE"

    # 支持创建多个数据库实例
    IFS=', ' read -r -a MYSQL_DATABASE_ARRAY <<< $MYSQL_DATABASE
    IFS=', ' read -r -a MYSQL_USER_ARRAY <<< $MYSQL_USER
    IFS=', ' read -r -a MYSQL_PASSWORD_ARRAY <<< $MYSQL_PASSWORD

    for index in "${!MYSQL_DATABASE_ARRAY[@]}"
    do
        DATABASE=${MYSQL_DATABASE_ARRAY[index]}
        USER=${MYSQL_USER_ARRAY[index]}
        PASSWORD=${MYSQL_PASSWORD_ARRAY[index]}
        echo $DATABASE $USER $PASSWORD
        echo "CREATE DATABASE IF NOT EXISTS \`$DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
        echo "[i] Creating user: $USER with password $PASSWORD"
        echo "GRANT ALL ON \`$DATABASE\`.* to '$USER'@'%' IDENTIFIED BY '$PASSWORD';" >> $tfile
    done

#    for DATABASE in $MYSQL_DATABASE; do
#        echo "CREATE DATABASE IF NOT EXISTS \`$DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
#    done

#    if [ "$MYSQL_USER" != "" ]; then
#      echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
#      echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
#    fi
  fi

  cat $tfile
  /usr/bin/mysqld --defaults-file=/app/my.cnf --innodb-flush-method=fsync --user=root --bootstrap --verbose=0 < $tfile
  rm -f $tfile
fi


exec /usr/bin/mysqld --defaults-file=/app/my.cnf --innodb-flush-method=fsync --user=root --console
