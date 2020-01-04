.. _module_powershell:

==========
Powershell
==========

.. image:: https://upload.wikimedia.org/wikipedia/commons/a/af/PowerShell_Core_6.0_icon.png
    :alt: Powershell
    :height: 250px

About
#####

`PowerShell <https://docs.microsoft.com/en-us/powershell/>`_ is a task
automation and configuration management framework from Microsoft, consisting of
a command-line shell and associated scripting language.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

ms-vscode.PowerShell
********************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell>`__
provides rich PowerShell language support for Visual Studio Code.

Now you can write and debug PowerShell scripts using the excellent IDE-like
interface that Visual Studio Code provides.

VSCode settings
###############

VSCode settings configuration for ``powershell``.

Global settings
***************

.. code-block:: json

    {
        "dash.languageIdToDocsetMap.powershell": [
            "posh"
        ]
    }

Software
########

Windows software
****************

Use the installed Powershell version on your system.

.. note::

    You can also use `powershell-core <https://github.com/PowerShell/PowerShell>`_
    instead of the native powershell.

Docsets
#######

1 docsets will be installed:

- `Powershell <https://github.com/Kapeli/feeds/blob/master/Powershell.xml>`__

Environment
***********

No environment.

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    powershell:
        enabled: True

Specific module settings
************************

No Specific settings.
