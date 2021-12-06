# UKY Platform Dev Tools

This composer package will skaffold all the necesary files to work with the UKY Web Platform utilizing either Gitpod.io/DDEV or a local lando environment.

This package is already default when utilizing the [UKY Web Platform Project Template](https://gitlab.com/uky-web/university-web-platform/drupal-8/drupal-8-project-template).  

## Customize the contents of this package

If you need to modify any of the skaffolded files this package implements then you will need to modify the require-dev section in the root composer.json file from 

`    "require-dev": {
	"uky-web/uky_platform_dev_tools": "v1.0.0"
    },
`

to 

`    "require-dev": {
	"uky-web/uky_platform_dev_tools": "v1.0.0-custom"
    },
`

This will prevent any further overwriting of the skaffolded files with the exception of the default.settings.php file and the development.services.yml allowing you to customize your development enviroment files.






