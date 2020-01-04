.. _module_javascript:

==========
Javascript
==========

.. image:: https://upload.wikimedia.org/wikipedia/commons/9/99/Unofficial_JavaScript_logo_2.svg
    :alt: Javascript
    :height: 250px

About
#####

`Javascript <https://www.oracle.com/java/>`_ (JS) is a lightweight, interpreted,
or just-in-time compiled programming language with first-class functions.

While it is most well-known as the scripting language for Web pages, many
non-browser environments also use it, such as Node.js, Apache CouchDB and
Adobe Acrobat.

JavaScript is a prototype-based, multi-paradigm,
single-threaded, dynamic language, supporting object-oriented, imperative, and
declarative (e.g. functional programming) styles.

Prerequisites
#############

This module doesn't work out of the box. You must configure it for each project
for it works properly.

To work, the `dbaeumer.vscode-eslint`_ extension must to be configured.

VSCode extensions
#################

For more details read the `official documentation <https://code.visualstudio.com/docs/languages/javascript>`_.

VisualStudioExptTeam.vscodeintellicode
**************************************
This `extension <https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode>`__
provides AI-assisted development features for JavaScript/TypeScript.

.. image:: https://docs.microsoft.com/en-us/visualstudio/intellicode/media/python-intellicode.gif
    :alt: Python IntelliSense

dbaeumer.vscode-eslint
**********************

This `extension <https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack>`__
`ESLint <http://eslint.org>`__ into VS Code.

.. note::

    This extension doesn't work out of the box. You must configure it for each
    project for this extension works properly.

    Please read the `documentation <https://eslint.org/docs/user-guide/configuring>`_.

    .. container:: youtube

        .. raw:: html

            <iframe src="https://www.youtube.com/embed/cMrDePs86Uo" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>

esbenp.prettier-vscode
**********************

`Prettier <https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode>`_
is an opinionated code formatter. It enforces a consistent style by parsing
your code and re-printing it with its own rules that take the maximum line
length into account, wrapping code when necessary.

eg2.vscode-npm-script
*********************

This `extension <https://marketplace.visualstudio.com/items?itemName=eg2.vscode-npm-script>`__
running npm scripts defined in the `package.json` file and validating the
installed modules against the dependencies defined in the `package.json`.

.. image:: https://github.com/Microsoft/vscode-npm-scripts/raw/master/images/validation.png
    :alt: npm

xabikos.JavaScriptSnippets
**************************

This `extension <https://marketplace.visualstudio.com/items?itemName=xabikos.JavaScriptSnippets>`__
contains code snippets for JavaScript in ES6 syntax for Vs Code editor.

leizongmin.node-module-intellisense
***********************************

This `extension <https://marketplace.visualstudio.com/items?itemName=leizongmin.node-module-intellisense>`__
autocompletes JavaScript / TypeScript modules in import statements.

.. image:: https://github.com/leizongmin/vscode-node-module-intellisense/raw/master/images/auto_complete.gif
    :alt: Modules Intellisense

christian-kohler.npm-intellisense
*********************************

This `extension <https://marketplace.visualstudio.com/items?itemName=christian-kohler.npm-intellisense>`__
autocompletes filenames.

.. image:: https://github.com/ChristianKohler/NpmIntellisense/raw/master/images/auto_complete.gif
    :alt: npm Intellisense


christian-kohler.path-intellisense
**********************************

This `extension <https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense>`__
autocompletes npm modules in import statements.

.. image:: http://i.giphy.com/iaHeUiDeTUZuo.gif
    :alt: npm Intellisense

msjsdiag.debugger-for-chrome
****************************

This `extension <https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome>`__
allow to debug your JavaScript code in the Chrome browser, or any other target
that supports the Chrome Debugger protocol.

.. image:: https://github.com/Microsoft/vscode-chrome-debug/blob/master/images/demo.gif?raw=true
    :alt: Debugger for Chrome

wix.vscode-import-cost
**********************

This `extension <https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost>`__
allow to debug your JavaScript code in the Chrome browser, or any other target
that supports the Chrome Debugger protocol.

.. image:: https://file-wkbcnlcvbn.now.sh/import-cost.gif
    :alt: npm import cost

VSCode settings
###############

VSCode settings configuration for ``javascript``.

Global settings
***************

.. code-block:: json

    {
        "eslint.alwaysShowStatus": true,
        "[javascript]": {
            "editor.defaultFormatter": "esbenp.prettier-vscode"
        },
        "[javascriptreact]": {
            "editor.defaultFormatter": "esbenp.prettier-vscode"
        },
        "[typescript]": {
            "editor.defaultFormatter": "esbenp.prettier-vscode"
        },
        "[typescriptreact]": {
            "editor.defaultFormatter": "esbenp.prettier-vscode"
        },
        "[vue]": {
            "editor.defaultFormatter": "esbenp.prettier-vscode"
        }
    }

Software
########

Windows software
****************

scoop
=====

- `nodejs <https://github.com/ScoopInstaller/Main/blob/master/bucket/nodejs.json>`__

Docsets
#######

2 docsets will be installed:

- `NodeJS <https://github.com/Kapeli/feeds/blob/master/NodeJS.xml>`__
- `JavaScript <https://github.com/Kapeli/feeds/blob/master/JavaScript.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    javascript:
        enabled: True

Environment
***********

Windows environment
===================

.. code-block:: yaml

    PATH: C:\VSCode-Anywhere\apps\scoop\apps\nodejs\current;C:\VSCode-Anywhere\apps\scoop\apps\nodejs\current\bin

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Specific module settings
************************

npm
===

``npm`` is used to install `npm modules <https://www.npmjs.com>`_.

The following python packages will be installed:

- `eslint <https://www.npmjs.com/package/eslint>`__


VSCode-Anywhere installs for you the ``eslint`` module but you can add more.

.. code-block:: yaml

    javascript:
        enabled: True
        npm:
            pkgs:
                eslint:
                    enabled: True

You can choose a specific version:

.. code-block:: yaml

You can also specify a specific version :

.. code-block:: yaml

    npm:
        pkgs:
            eslint:
                enabled: True
                version: '6.7.2'

You can use advanced npm options:

.. code-block:: yaml+jinja

    javascript:
        enabled: True
        npm:
            opts:
                global: {}
                install: {}
                update: {}
                uninstall: {}
            pkgs:
                eslint:
                    enabled: True
                    version: null
                    opts:
                        install: {}
                        update: {}
                        uninstall: {}

npm options:

- ``npm.opts.global``: `npm options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.npm.html>`__
    used to install, update and delete a npm module
- ``npm.opts.install``: `npm.installed options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.npm.html#salt.states.npm.installed>`__
    used to install a npm module
- ``npm.opts.update``: `npm.installed options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.npm.html#salt.states.npm.installed>`__
    is used to update a npm module
- ``npm.opts.uninstall``: `npm.removed options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.npm.html#salt.states.npm.removed>`__
    used to delete a npm module
- ``npm.pkgs.<module_name>.opts.install``: same thing as ``npm.opts.install``
  but only apply for the target module
- ``npm.pkgs.<module_name>.opts.update``: same thing as ``npm.opts.update``
  but only apply for the target module
- ``npm.pkgs.<module_name>.opts.uninstall``: same thing as
  ``npm.opts.uninstall`` but only apply for the target module
- ``npm.pkgs.<module_name>.version``: specify the version to install
- ``npm.pkgs.<module_name>.enabled``: specify if the target module must be
  installed

.. note::

    Don't add the ``name`` option because it is already set!
