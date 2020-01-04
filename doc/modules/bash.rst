.. _module_bash:

=========
Bash / SH
=========

.. image:: https://upload.wikimedia.org/wikipedia/commons/8/82/Gnu-bash-logo.svg
    :alt: Bash

About
#####

`Bash <https://www.gnu.org/software/bash/>`__ is the Bourne Again SHell. Bash
is an sh-compatible shell that incorporates useful features from the Korn shell
(ksh) and C shell (csh).

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

timonwong.shellcheck
********************

This `extension <https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck>`__
is a linter for sh / bash.

rogalmic.bash-debug
*******************

This `extension <https://marketplace.visualstudio.com/items?itemName=rogalmic.bash-debug>`__
is a bash debugger GUI frontend based on bashdb scripts.

VSCode settings
###############

VSCode settings configuration for shell.

Windows settings
****************

.. code-block:: yaml

    {
        "shellcheck.executablePath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\shellcheck\\current\\shellcheck.exe"
    }

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Software
########

Windows software
****************

scoop
=====

- `shellcheck <https://github.com/ScoopInstaller/Main/blob/master/bucket/shellcheck.json>`_

Docsets
#######

2 docsets will be installed:

- `Bash <https://github.com/Kapeli/feeds/blob/master/Bash.xml>`_
- `Linux_Man_Pages <https://github.com/hashhar/dash-contrib-docset-feeds/blob/master/Linux_Man_Pages.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    saltstack:
        enabled: True

Environment
***********

No environment.

Specific module settings
************************

No specific module settings.
