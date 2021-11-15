
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
    ddev drush cr
    ddev drush cim -y
    ddev drush cr
    ddev drush user:create admin --password="admin"
    ddev drush urol "administrator" admin

  else
    echo "No reference database found. Running site-install..."
     ddev drush si -y --account-pass=admin --site-name='ddev_gitpod' uky_base
fi
