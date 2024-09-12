#!/bin/bash
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

if [ -f "${LANDO_MOUNT}/reference/${REF_FILE}" ]
  then
    echo "Reference database found. Importing..."
    if [ $IN_CONTAINER -eq 1 ]; then
      # Run container's built-in import helper
      /helpers/sql-import.sh "${LANDO_MOUNT}/reference/${REF_FILE}"
    else
      # Call the lando script to import the database
      $LANDO db-import "${LANDO_MOUNT}/reference/${REF_FILE}"
    fi
    if ! [ -f "web/sites/default/settings.php" ]
      then
        echo "Generating settings.php file..."
        cp "web/sites/default/default.settings.php" "web/sites/default/settings.php"
    fi
  else
    echo "No reference database found."
    if [ $IN_CONTAINER -eq 1 ]; then
      # We can't access the appserver service from here,
      # direct the user towards next steps
      echo "Please run .lando/scripts/site-install.sh from the host machine or appserver service."
    else
      # We can access all lando services from the host machine,
      # go ahead and call the script
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
fi
