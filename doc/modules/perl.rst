.. _module_perl:

====
Perl
====

.. image:: https://upload.wikimedia.org/wikipedia/commons/1/15/Logo_De_Perl.png
    :alt: Perl
    :height: 250px

About
#####

`Perl <https://www.perl.org>`__ is a highly capable, feature-rich programming
language with over 30 years of development.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

cfgweb.vscode-perl
******************

This `extension <https://marketplace.visualstudio.com/items?itemName=cfgweb.vscode-perl>`__
aims to bring code intelligence for the Perl language to Visual Studio Code,
mainly through the use of Exuberant Ctags.

d9705996.perl-toolbox
*********************

This `extension <https://marketplace.visualstudio.com/items?itemName=d9705996.perl-toolbox>`__
provides support for linting and syntax checking for Perl.

mortenhenriksen.perl-debug
**************************

This `extension <https://marketplace.visualstudio.com/items?itemName=mortenhenriksen.perl-debug>`__
provides a debugger for Perl in Visual Studio Code.

.. image:: https://github.com/raix/vscode-perl-debug/raw/master/images/vscode-perl-debugger.gif
    :alt: Perl debugger

VSCode settings
###############

VSCode settings configuration for ``perl``.

Global settings
***************

No global settings.

Windows settings
****************

.. code-block:: json

    {
        "perl.ctagsPath": "C:\VSCode-Anywhere\\apps\\scoop\\apps\\ctags\\current\\ctags.exe",
        "perl-toolbox.syntax.path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\perl\\current\\perl\\bin",
        "perl-toolbox.lint.exec": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\perl\\current\\perl\\site\\bin\\perlcritic.bat",
        "perl.perltidy": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\perl\\current\\perl\\bin\\perltidy.bat"
    }

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Software
########

Windows software
****************

scoop
=====

- `perl <https://github.com/ScoopInstaller/Main/blob/master/bucket/perl.json>`__
- `ctags <https://github.com/ScoopInstaller/Main/blob/master/bucket/ctags.json>`__

Docsets
#######

1 docsets will be installed:

- `Perl <https://github.com/Kapeli/feeds/blob/master/Perl.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    perl:
        enabled: True

Environment
***********

Windows environment
===================

.. code-block:: yaml

    PATH: C:\VSCode-Anywhere\apps\scoop\apps\perl\current\c\bin;C:\VSCode-Anywhere\apps\scoop\apps\perl\current\perl\bin;C:\VSCode-Anywhere\apps\scoop\apps\perl\current\perl\site\bin

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Specific module settings
************************

cpan
====

``cpan`` is used to install `perl modules <https://www.cpan.org>`_.

The following perl modules will be installed:

- `Perl::Tidy <https://metacpan.org/pod/Perl::Tidy>`_
- `Perl::Critic <https://metacpan.org/pod/Perl::Critic>`_

.. code-block:: yaml

    perl:
        enabled: True
        cpan:
            pkgs:
                Perl::Tidy:
                    enabled: True
                Perl::Critic:
                    enabled: True

You can use advanced cpan options:

.. code-block:: yaml+jinja

    perl:
        enabled: True
        cpan:
            opts:
                global:
                    bin_env: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'perl', 'current', 'perl', 'bin', 'cpan.bat') }}
                install: {}
                update: {}
            pkgs:
                Perl::Tidy:
                    enabled: True
                    version: SHANCOCK/Perl-Tidy-20190915
                    opts:
                        install: {}
                        update: {}
                Perl::Critic:
                    enabled: True
                    version: null
                    opts:
                        install: {}
                        update: {}

CPAN options:

- ``cpan.opts.global``: `cpan options <https://docs.saltstack.com/en/develop/ref/states/all/salt.states.cpan.html>`__
    used to install, update and delete a cpan module
- ``cpan.opts.install``: `cpan.installed options <https://docs.saltstack.com/en/develop/ref/states/all/salt.states.cpan.htmll#salt.states.cpan.installed>`__
    used to install a cpan module
- ``cpan.opts.update``: `cpan.uptodate options <https://docs.saltstack.com/en/develop/ref/states/all/salt.states.cpan.htmll#salt.states.cpan.uptodate>`__
    is used to update a cpan module
- ``cpan.pkgs.<module_name>.opts.install``: same thing as ``cpan.opts.install``
  but only apply for the target module
- ``cpan.pkgs.<module_name>.opts.update``: same thing as ``cpan.opts.update``
  but only apply for the target module
- ``cpan.pkgs.<module_name>.version``: specify the version to install
- ``cpan.pkgs.<module_name>.enabled``: specify if the target module must be
  installed

.. note::

    The **cpan** state is not published officially (saltstack ``master``
    branch) and is only available on the ``develop`` branch. This module has
    been modified because the original is buggy.

    When you specify a module version, you must respect the following syntax
    ``<AUTHOR>/<module>-<version>``.

    You can find these informations from the site https://metacpan.org.

    Also, don't add the ``name`` option because it is already set!
