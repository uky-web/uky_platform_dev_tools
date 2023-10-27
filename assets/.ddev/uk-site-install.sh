#!/bin/bash
set -e
# Unzip the reference DB
gunzip reference/sanitized.sql
# Import the reference DB
if [ -f "reference/sanitized.sql" ]
  then
    echo "Reference database found. Importing..."
    ddev import-db --src=reference/sanitized.sql
    if ! [ -f "web/sites/default/settings.php" ]
      then
        echo "Generating settings.php file..."
        cp web/sites/default/default.settings.php web/sites/default/settings.php
    fi
    mv config/sync/stage_file_proxy.settings.yml config/
    ddev drush cr
    ddev drush cim -y
    ddev drush cr
    ddev drush en stage_file_proxy
    ddev drush cex -y
    mv config/stage_file_proxy.settings.yml config/sync/
    ddev drush cr
    ddev drush cim -y
    file="reference/.siteurl"
    siteurl=$(cat "$file")
    ddev drush config-set stage_file_proxy.settings origin $siteurl -y
    ddev drush cr
    echo "Stage File Proxy enabled and configured..."
    #if [ -f "reference/.siteurl" ]
    #  then
    #    file="reference/.siteurl"
    #    siteurl=$(cat "$file")
    #    ddev drush cr
    #    ddev drush en stage_file_proxy
    #    ddev drush cex
    #    ddev drush cr
    #    ddev drush config-set stage_file_proxy.settings origin $siteurl -y
    #    #ddev drush config-set stage_file_proxy.settings hotlink true -y
    #    ddev drush cr
    #    echo "Stage File Proxy enabled and configured..."
    #fi
    ddev drush cr
    ddev drush user:create admin --password="admin"
    ddev drush urol "administrator" admin
  else
    echo "No reference database found. Running site-install..."
     ddev drush si -y --account-pass=admin --site-name='ddev_gitpod' uky_base
fi
