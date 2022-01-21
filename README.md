# UKY Platform Dev Tools

This composer package will skaffold all the necesary files to work with the UKY Web Platform utilizing either Gitpod.io/DDEV or a local lando environment.

This package is already default when utilizing the [UKY Web Platform Project Template](https://gitlab.com/uky-web/university-web-platform/drupal-8/drupal-8-project-template).  


## Customize the contents of this package

If you need to modify any of the skaffolded files this package implements then you will need to modify the require-dev section in the root composer.json file from 

`    "require-dev": {
	"uky-web/uky_platform_dev_tools": "^1.0.0"
    },
`

to 

`    "require-dev": {
	"uky-web/uky_platform_dev_tools": "dev-custom"
    },
`

This will prevent any further overwriting of the skaffolded files with the exception of the default.settings.php file and the development.services.yml allowing you to customize your development enviroment files.




---

## Local Composer Package Development ('local_packages')
The included `local_packages.sh` script uses [Composer path repositories](https://getcomposer.org/doc/05-repositories.md#path) to allow you to work with source repos of composer dependencies of your project (kind of like a very simple monorepo). This is useful if you're developing an installation profile, base theme, or other modules that aren't included in your site repository.

__NOTE: The local_packages.sh script assumes you are using ddev.__

### 1. Add the package info to ./scripts/local_packages/local_packages.yaml:
Enter the git repo, branch, and version aliases into this yaml config file for each package you want to work on locally. UK's composer packages are all included in the file by default (comment out or modify as needed). See the yaml file for more detail about each required property. For example:

```
 -
    package: "uky-web/uky_base"
    git: "https://gitlab.com/uky-web/university-web-platform/drupal-8/uky_base.git"
    branch: "2.0.x"
    composername: "2.0.x-dev"
    version: 1.99
```

### 2. Run the local_packages.sh script:
`$ ./scripts/local_packages/local_packages.sh`

This script will:
1. Clone the projects listed in local_packages.yaml into `./packages`
2. Create symlinks in the locations composer is instructed to install the packages (e.g `/web/themes/custom`).
3. In `composer.json`, add each composer package repo as a path repository.json.
4. In `composer.json`, replace any existing requirement of the listed packages with a require-dev of the package.

### 3. After reviewing changes to composer.json, run composer install:
`$ ddev composer install`


### Troubleshooting local_packages.sh
* Be sure the script has proper permissions (`chmod +x ./scripts/local_packages/local_packages.sh`)
* If composer isn't installing the local version of your packages, try removing your `composer.lock` file, which can retain the old composer repository configuration and prevent the new path repositories from taking precedence.
* Try removing your `./vendor` directory, or the root of the package giving you trouble if it was installed elsewhere in the project filesystem.

---


