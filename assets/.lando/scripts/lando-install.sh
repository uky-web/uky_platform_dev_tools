#!/bin/bash

if [ "$(which lando)" ]; then
  LANDO='lando'
else
  LANDO=''
fi

$LANDO composer install

if [ -f "reference/sanitized.sql" ]
  then
    echo "Reference database found. Importing..."
    $LANDO db-import reference/sanitized.sql
    if ! [ -f "web/sites/default/settings.php" ]
      then
        echo "Generating settings.php file..."
        cp web/sites/default/default.settings.php web/sites/default/settings.php
    fi
  else
    echo "No reference database found."
    read -r -p "Run drush site-install? (y/N)? " answer
    case ${answer:0:1} in
        y|Y )
            $LANDO drush site-install -y
        ;;
        * )
            :
        ;;
    esac
fi

if [ -d './config/sync/' ] && [ "$(ls ./config/sync)" ]; then
  echo "Site config found. Importing..."
  $LANDO drush cim -y
else
  echo "Directory 'config/sync' is empty or not found; not running import."
fi

$LANDO drush cr

$LANDO drush user:password admin "admin"
$LANDO drush sql-query "UPDATE users_field_data SET name='admin' WHERE uid=1";
$LANDO drush user:password admin "admin"