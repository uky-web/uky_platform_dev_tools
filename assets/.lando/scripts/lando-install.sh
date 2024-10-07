#!/bin/bash

# File name of the reference database
REF_FILE="sanitized.sql.gz"

# Check if we are running this script from within the lando container
# (e.g. via `lando site-install` or after entering `lando ssh`)
# or from the host machine.
if [ "$(which lando)" ]; then
  LANDO='lando'
  IN_CONTAINER=0
else
  LANDO=''
  IN_CONTAINER=1
fi

$LANDO composer install

if [ -f "${LANDO_MOUNT}/reference/${REF_FILE}" ]
  then
    # If running the script directly from the host, direct the user to
    # import the reference database first.
    if [ $IN_CONTAINER -eq 0 ]; then
      echo "Reference database found. Please make sure to run .lando/scripts/lando-install-db.sh"
      echo "and then re-run this script."
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

# Attempt config import
if [ -d './config/sync/' ] && [ "$(ls ./config/sync)" ]; then
  echo "Site config found. Importing..."
  $LANDO drush cim -y
else
  echo "Directory 'config/sync' is empty or not found; not running import."
fi

# Set admin credentials to "admin:admin" for dev
$LANDO drush cr
$LANDO drush sql-query "UPDATE users_field_data SET name='admin' WHERE uid=1";
$LANDO drush user:password admin "admin"
