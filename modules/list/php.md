# PHP

![](https://upload.wikimedia.org/wikipedia/commons/2/27/PHP-logo.svg)

## About

[PHP](https://secure.php.net/) is a popular general-purpose scripting language that is especially suited to web development.

## Installation

Change `enable` from `False` to `True` in the `php` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    php:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere php module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/php/defaults.yaml).
{% endhint %}

For more details read the [official documentation](https://code.visualstudio.com/docs/languages/php).

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### bmewburn.vscode-intelephense-client

This [extension](https://marketplace.visualstudio.com/items?itemName=bmewburn.vscode-intelephense-client) provides PHP IntelliSense for Visual Studio Code.

#### felixfbecker.php-debug

This [extension](https://marketplace.visualstudio.com/items?itemName=felixfbecker.php-debug) is a PHP debugger adapter for Visual Studio Code.

![](https://github.com/felixfbecker/vscode-php-debug/raw/master/images/demo.gif)

#### junstyle.php-cs-fixer

This [extension](https://marketplace.visualstudio.com/items?itemName=junstyle.php-cs-fixer) provides [PHP CS Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer) command.

This extension permit to [format](https://code.visualstudio.com/docs/editor/codebasics#_formatting) the PHP code.

![](https://github.com/felixfbecker/vscode-php-debug/raw/master/images/demo.gif)

#### ikappas.phpcs

This [extension](https://marketplace.visualstudio.com/items?itemName=ikappas.phpcs) is linter plugin for Visual Studio Code provides an interface to [phpcs](http://pear.php.net/package/PHP_CodeSniffer/).

#### MehediDracula.php-namespace-resolver

[PHP Namespace Resolver](https://marketplace.visualstudio.com/items?itemName=MehediDracula.php-namespace-resolver) can import and expand your class. You can also sort your imported classes by line length or in alphabetical order.

![](https://i.imgur.com/upEGtPa.gif)

#### brapifra.phpserver

This [extension](https://marketplace.visualstudio.com/items?itemName=brapifra.phpserver) allow to start / stop a PHP server in your current workspace \(or subfolder\).

![](https://github.com/brapifra/vscode-phpserver/raw/master/demo.gif)

#### ecodes.vscode-phpmd

This [extension](https://marketplace.visualstudio.com/items?itemName=ecodes.vscode-phpmd) analyze your PHP source code on save with PHP mess detector.

#### recca0120.vscode-phpunit

This [extension](https://marketplace.visualstudio.com/items?itemName=recca0120.vscode-phpunit) allow to run PHP tests.

![](https://github.com/recca0120/vscode-phpunit/raw/master/img/screenshot.png)

### VSCode settings

#### Global settings

```javascript
{
    "php.suggest.basic": false,
    "[php]": {
        "editor.defaultFormatter": "bmewburn.vscode-intelephense-client"
    }
}
```

#### Windows settings

```javascript
{
    "php.validate.executablePath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\php\\current\\php.exe",
    "phpserver.phpPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\php\\current\\php.exe",
    "php-cs-fixer.executablePathWindows": "C:\\VSCode-Anywhere\\apps\\scoop\\\persist\\composer\\install\\vendor\\bin\\php-cs-fixer.bat",
    "phpcs.executablePath": "C:\\VSCode-Anywhere\\apps\\scoop\\persist\\composer\\install\\vendor\\bin\\phpcs.bat",
    "phpunit.php": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\php\\current\\php.exe",
    "phpunit.phpunit": "C:\\VSCode-Anywhere\\apps\\scoop\\persist\\composer\\install\\vendor\\bin\\phpunit.bat"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux settings

```javascript
{
    "php.validate.executablePath": "/home/linuxbrew/.linuxbrew/bin/php",
    "phpserver.phpPath": "/home/linuxbrew/.linuxbrew/bin/php",
    "php-cs-fixer.executablePath": "/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/php/composer/install/vendor/bin/php-cs-fixer",
    "phpcs.executablePath": "/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/php/composer/install/vendor/bin/phpcs",
    "phpunit.php": "/home/linuxbrew/.linuxbrew/bin/php",
    "phpunit.phpunit": "/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/php/composer/install/vendor/bin/phpunit"
}
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

#### scoop

* [php](https://github.com/ScoopInstaller/Main/blob/master/bucket/php.json)
* [php-xdebug](https://github.com/lukesampson/scoop-extras/blob/master/bucket/php-xdebug.json)
* [composer](https://github.com/ScoopInstaller/Main/blob/master/bucket/composer.json)

### Linux software

#### nix

* [nixpkgs.dotnetPackages.NUnitConsole](https://nixos.org/nixos/packages.html?attr=dotnetPackages.NUnitConsole&channel=nixpkgs-unstable)
* [nixpkgs.dotnet-sdk\_3](https://nixos.org/nixos/packages.html?attr=dotnet-sdk_3&channel=nixpkgs-unstable)

### MacOS software

#### brew

* [make](https://formulae.brew.sh/formula/make)
* [gcc](https://formulae.brew.sh/formula/gcc)
* [php](https://formulae.brew.sh/formula/php)
* [composer](https://formulae.brew.sh/formula/composer)

## Documentation

* [PHP](https://github.com/Kapeli/feeds/blob/master/PHP.xml)

## VSCode-Anywhere

### Environment

#### Windows environment

```yaml
PATH: C:\VSCode-Anywhere\apps\scoop\apps\composer\current\home\vendor\bin
COMPOSER_HOME: C:\VSCode-Anywhere\apps\scoop\persist\composer\home
PHP_INI_SCAN_DIR: C:\VSCode-Anywhere\apps\scoop\apps\php\current\cli;C:\VSCode-Anywhere\apps\scoop\apps\php\current\cli\conf.d
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux environment

```yaml
    PATH: /home/myuser/VSCode-Anywhere/apps/vscode-anywhere/php/composer/home/vendor/bin
    COMPOSER_HOME: /home/myuser/VSCode-Anywhere/apps/vscode-anywhere/php/composer/home
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

### Specific settings

#### extensions

Allow to manage [PHP extensions](https://www.php.net/manual/extensions.php) in [php.ini ](https://www.php.net/manual/configuration.file.php)file.

This is a simple list of extensions to enable in PHP.

* Windows

```yaml
  vscode-anywhere:
    php:
      extensions:
        - openssl
```

#### composer

Allow to install packages with [composer](https://packagist.org).



* **`pkgs`**: name of the packages to install
  * `enabled`: `True` to `enable`, `False` to skip \(default to `False`\)
  * `version`: version of the composer package



* **`opts`**

`opts` is not mandatory but allows to pass additional arguments.

Extra args can be arguments described in the [saltstack composer states](https://docs.saltstack.com/en/master/ref/states/all/salt.states.composer.html) or can be [global saltstack arguments](https://docs.saltstack.com/en/latest/ref/states/requisites.html).



Global `opts` packages settings:

* `composer:pkgs:opts:global`: allow to pass arguments **to all composer packages** when **installing**, **updating**, or **uninstalling** a package
*  `pm:pkgs:opts:install`: allow to pass arguments **to all composer packages** when **installing** a package \(cf [states.composer.installed](https://docs.saltstack.com/en/master/ref/states/all/salt.states.composer.html#salt.states.composer.installed)\)
* `composer:pkgs:opts:update`: allow to pass arguments **to all composer packages** when **updating** a package \(cf [states.composer.update](https://docs.saltstack.com/en/master/ref/states/all/salt.states.composer.html#salt.states.composer.update)\)
* `composer:pkgs:opts:uninstall`: not yet implemented

#### 

Specific `opts` packages settings:

* `composer:pkgs:<mypkg>:opts:global`: allow to pass arguments **to** `<mypkg>` **composer package** when **installing**, **updating**, or **uninstalling** the package
*  `composer:pkgs:<mypkg>:opts:install`: allow to pass arguments **to** `<mypkg>` **composer packages** when **installing** the package \(cf [states.composer.installed](https://docs.saltstack.com/en/master/ref/states/all/salt.states.composer.html#salt.states.composer.installed)\)
* `composer:pkgs:<mypkg>:opts:update`: allow to pass arguments **to** `<mypkg>` **composer packages** when **updating** the package \(cf [states.composer.update](https://docs.saltstack.com/en/master/ref/states/all/salt.states.composer.html#salt.states.composer.update)\)
* `composer:pkgs:<mypkg>:opts:uninstall`: not yet implemented



* global:

```yaml
vscode-anywhere:
  php:
    enabled: True
    composer:
      opts:
        global: {}
        install: {}
        update: {}
      pkgs:
        squizlabs/php_codesniffer:
          enabled: True
          version: '@stable'
        phpunit/phpunit:
          enabled: True
          version: '@stable'
        friendsofphp/php-cs-fixer:
          enabled: True
          version: '@stable'
```

* Windows:

```yaml
vscode-anywhere:
  php:
    enabled: True
    composer:
      json: C:\VSCode-Anywhere\apps\scoop\persist\composer\install\composer.json
      opts:
        global:
          php: C:\VSCode-Anywhere\apps\scoop\scoop\apps\php\current\php.exe
          composer: C:\VSCode-Anywhere\apps\scoop\apps\composer\current\composer.phar
          composer_home: C:\VSCode-Anywhere\apps\scoop\persist\composer\home
          env:
            - PHP_INI_SCAN_DIR: C:\VSCode-Anywhere\apps\scoop\apps\php\current\cli;C:\VSCode-Anywhere\apps\scoop\apps\php\current\cli\conf.d
        install: {}
        update: {}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

* Linux:

```yaml
vscode-anywhere:
  php:
    composer:
      json: /home/myuser/VSCode-Anywhere/apps/vscode-anywhere/php/composer/install/composer.json
      opts:
        global:
          composer: /home/linuxbrew/.linuxbrew/bin/composer
          composer_home: /home/myuser/VSCode-Anywhere/apps/vscode-anywhere/php/composer/home
        install: {}
        update: {}
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

#### pecl

[PECL](https://pecl.php.net) allows to install php extensions.

* **`pkgs`**: name of the extension to install
  * `enabled`: `True` to `enable`, `False` to skip \(default to `False`\)
  * `version`: version of the pecl extension



* **`opts`**

`opts` is not mandatory but allows to pass additional arguments.

Extra args can be arguments described in the [saltstack pecl states](https://docs.saltstack.com/en/master/ref/states/all/salt.states.pecl.html) or can be [global saltstack arguments](https://docs.saltstack.com/en/latest/ref/states/requisites.html).



Global `opts` packages settings:

* `pecl:pkgs:opts:global`: allow to pass arguments **to all pecl packages** when **installing**, **updating**, or **uninstalling** a package
*  `pm:pkgs:opts:install`: allow to pass arguments **to all pecl packages** when **installing** a package \(cf [states.pecl.installed](https://docs.saltstack.com/en/master/ref/states/all/salt.states.pecl.html#salt.states.pecl.installed)\)
* `pecl:pkgs:opts:update`: not yet implemented
* `pecl:pkgs:opts:uninstall`: not yet implemented

#### 

Specific `opts` packages settings:

* `pecl:pkgs:<mypkg>:opts:global`: allow to pass arguments **to** `<mypkg>` **pecl package** when **installing**, **updating**, or **uninstalling** the package
*  `pecl:pkgs:<mypkg>:opts:install`: allow to pass arguments **to** `<mypkg>` **pecl packages** when **installing** the package \(cf [states.pecl.installed](https://docs.saltstack.com/en/master/ref/states/all/salt.states.pecl.html#salt.states.pecl.installed)\)
* `pecl:pkgs:<mypkg>:opts:update`: not yet implemented
* `pecl:pkgs:<mypkg>:opts:uninstall`: not yet implemented

{% hint style="info" %}
Replace `<mypkg>` by the name of the package to install.
{% endhint %}



* global:

```yaml
vscode-anywhere:
  php:
    enabled: True
    pecl:
      opts:
        global: {}
        install: {}
        update: {}
      pkgs: {}
```

* Linux:

```yaml
vscode-anywhere:
  php:
    enabled: True
    pecl:
      pkgs:
        xdebug:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
```

