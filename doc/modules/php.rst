.. _module_php:

===
PHP
===

.. image:: https://upload.wikimedia.org/wikipedia/commons/2/27/PHP-logo.svg
    :alt: PHP
    :height: 250px

About
#####

`PHP <https://secure.php.net>`__ is a popular general-purpose scripting
language that is especially suited to web development.

Use case
########

Windows use case
################

You can also use `UwAmp <https://www.uwamp.com>`_ to have a full stack
software environment with Windows.

But you must configure it yourself.

To install it, simply add in your VSCode-Anywhere configuration file:

.. code-block:: yaml

    php:
        enabled: True
        scoop:
            pkgs:
                uwamp:
                    enabled: True
                    version: null

Then you must configure your VSCode settings to use it.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

For more details read the `official documentation <https://code.visualstudio.com/docs/languages/php>`_.

bmewburn.vscode-intelephense-client
***********************************

This `extension <https://marketplace.visualstudio.com/items?itemName=bmewburn.vscode-intelephense-client>`__
provides PHP IntelliSense for Visual Studio Code.

.. .. image:: https://github.com/felixfbecker/vscode-php-intellisense/raw/master/images/completion.gif
    :alt: PHP IntelliSense

felixfbecker.php-debug
**********************

This `extension <https://marketplace.visualstudio.com/items?itemName=felixfbecker.php-debug>`__
is a PHP debugger adapter for Visual Studio Code.

.. image:: https://github.com/felixfbecker/vscode-php-debug/raw/master/images/demo.gif
    :alt: PHP debugger

junstyle.php-cs-fixer
*********************

This `extension <https://marketplace.visualstudio.com/items?itemName=junstyle.php-cs-fixer>`__
provides `PHP CS Fixer <https://github.com/FriendsOfPHP/PHP-CS-Fixer>`_ command.

This extension permit to `format <https://code.visualstudio.com/docs/editor/codebasics#_formatting>`_
the PHP code.

.. image:: https://github.com/felixfbecker/vscode-php-debug/raw/master/images/demo.gif
    :alt: PHP CS fixer

ikappas.phpcs
*************

This `extension <https://marketplace.visualstudio.com/items?itemName=ikappas.phpcs>`__
is linter plugin for Visual Studio Code provides an interface to
`phpcs <http://pear.php.net/package/PHP_CodeSniffer/>`_.

MehediDracula.php-namespace-resolver
************************************

`PHP Namespace Resolver <https://marketplace.visualstudio.com/items?itemName=MehediDracula.php-namespace-resolver>`__
can import and expand your class. You can also sort your imported classes by
line length or in alphabetical order.

.. image:: https://i.imgur.com/upEGtPa.gif
    :alt: PHP namespace resolver

brapifra.phpserver
******************

This `extension <https://marketplace.visualstudio.com/items?itemName=brapifra.phpserver>`__
allow to start / stop a PHP server in your current workspace (or subfolder).

.. image:: https://github.com/brapifra/vscode-phpserver/raw/master/demo.gif
    :alt: PHP server

ecodes.vscode-phpmd
*******************

This `extension <https://marketplace.visualstudio.com/items?itemName=ecodes.vscode-phpmd>`__
analyze your PHP source code on save with PHP mess detector.

recca0120.vscode-phpunit
************************

This `extension <https://marketplace.visualstudio.com/items?itemName=recca0120.vscode-phpunit>`__
allow to run PHP tests.

.. image:: https://github.com/recca0120/vscode-phpunit/raw/master/img/screenshot.png
    :alt: PHPUnit

VSCode settings
###############

VSCode settings configuration for ``php``.

Global settings
***************

No global settings.

Windows settings
****************

.. code-block:: json

    {
        "php.suggest.basic": false,
        "php.validate.executablePath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\php\\current\\php.exe",
        "phpserver.phpPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\php\\current\\php.exe",
        "phpcs.executablePath": "C:\\VSCode-Anywhere\\apps\\scoop\\persist\\composer\\install\\vendor\\bin\\phpcs.bat",
        "php-cs-fixer.executablePath": "C:\\VSCode-Anywhere\\apps\\scoop\\persist\\composer\\install\\vendor\\bin\\php-cs-fixer.bat",
        "phpunit.php": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\php\\current\\php.exe",
        "phpunit.phpunit": "C:\\VSCode-Anywhere\\apps\\scoop\\persist\\composer\\install\\vendor\\bin\\phpunit.bat",
        "[php]": {
            "editor.defaultFormatter": "bmewburn.vscode-intelephense-client"
        }
    }

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Software
########

Windows software
****************

scoop
=====

- `php <https://github.com/ScoopInstaller/Main/blob/master/bucket/php.json>`__
- `php-xdebug <https://github.com/lukesampson/scoop-extras/blob/master/bucket/php-xdebug.json>`__
- `composer <https://github.com/ScoopInstaller/Main/blob/master/bucket/composer.json>`__

Docsets
#######

1 docsets will be installed:

- `PHP <https://github.com/Kapeli/feeds/blob/master/PHP.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    php:
        enabled: True

Environment
***********

Windows environment
===================

.. code-block:: yaml

    php:
        env:
            PATH: C:\VSCode-Anywhere\apps\scoop\apps\composer\current\home\vendor\bin
            COMPOSER_HOME: C:\VSCode-Anywhere\apps\scoop\persist\composer\home
            PHP_INI_SCAN_DIR: C:\VSCode-Anywhere\apps\scoop\apps\php\current\cli;C:\VSCode-Anywhere\apps\scoop\apps\php\current\cli\conf.d

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Specific module settings
************************

extensions
==========

This section allow to enable some PHP extensions.

You must use the ``extensions`` directive.

.. note::

    Extension ``openssl`` is enabled because composer required it.

Example:

.. code-block:: yaml

    php:
        extensions:
            - openssl

.. danger::

    If you override ``extensions``, it is advisable to add ``openssl`` to the list.

composer
========

`composer <https://getcomposer.org>`__ is used to install some PHP `packages <https://packagist.org>`_.

To interact with composer, use the ``composer`` directive.

composer packages
-----------------

Note that composer install by default the following packages:

- `squizlabs/php_codesniffer <https://packagist.org/packages/squizlabs/php_codesniffer>`_
- `phpunit/phpunit <https://packagist.org/packages/phpunit/phpunit>`_

To install some packages use the ``pkgs`` directive. By default:

.. code-block:: yaml

    php:
        composer:
            pkgs:
                squizlabs/php_codesniffer:
                    enabled: True
                    version: '@stable'
                phpunit/phpunit:
                    enabled: True
                    version: '@stable'

.. .. note::

..    When you specify the version, you must respect the following syntax
    ``<vendor>/<package>:<version>``.

composer options
----------------

You can pass some options with ``opts`` directive to the ``composer`` binary,
as described below:

.. code-block:: yaml

    php:
        composer:
            opts:
                global:
                    option: value # will be applied to all packages (install and update)
                install:
                    option: value # will be applied to all packages (install only)
                update:
                    option: value # will be applied to all packages (update only)
            pkgs:
                mypackage: # package name
                    enabled: True # install this package
                    opts:
                        install:
                            option: value # will be applied only to mypackage (install only)
                        update:
                            option: value # will be applied only to mypackage (update only)

All options are referenced on the saltstack site :

- `composer.installed <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.composer.html#salt.states.composer.installed>`_
  *(called during the installation process)*
- `composer.update <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.composer.html#salt.states.composer.update>`_
  *(called during the update process)*

Example:

.. code-block:: yaml

    php:
        opts:
            global:
                optimize: True
            install:
                no_scripts: True
            update:
                no_plugins: True
        composer:
            squizlabs/php_codesniffer:
                enabled: True
                opts:
                    install:
                        always_check: True

.. note::

    Note that this code is just an example and has no interest.

    Also, don't add the ``name`` option because it is already set!

composer Windows options
^^^^^^^^^^^^^^^^^^^^^^^^

Windows default VSCode-Anywhere settings:

.. code-block:: yaml

    php:
        composer:
            json: C:\VSCode-Anywhere\apps\scoop\persist\composer\install\composer.json
            opts:
                global:
                    php: C:\VSCode-Anywhere\apps\scoop\apps\php\current\php.exe
                    composer: C:\VSCode-Anywhere\apps\scoop\apps\composer\current\composer.phar
                    composer_home: C:\VSCode-Anywhere\apps\scoop\persist\composer\home
                    env:
                        - PHP_INI_SCAN_DIR: C:\VSCode-Anywhere\apps\scoop\apps\php\current\cli;C:\VSCode-Anywhere\apps\scoop\apps\php\current\cli\conf.d
                install: {}
                update: {}

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.
