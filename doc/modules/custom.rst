.. _module_custom:

======
Custom
======

About
#####

This is not a real module, it allows you to customize your installation with
custom:

- :ref:`extensions <module_conf_vscode_extensions>`
- :ref:`settings <module_conf_vscode_settings>`
- :ref:`keybindings <module_conf_vscode_keybindings>`
- packages (:ref:`msys2 <module_conf_msys2>`, :ref:`scoop <module_conf_scoop>`,
  :ref:`chocolatey <module_conf_chocolatey>`)
- :ref:`docsets <module_conf_docsets>`
- :ref:`env <module_conf_env>`

Prerequisites
#############

No prerequisites.

VSCode extensions
#################

You can add your custom extensions here:

.. code-block:: yaml

    custom:
        enabled: True
        vscode:
            extensions:
                extension_id:
                    enabled: True
                    version: null
                settings:
                    custom_settings_key1: custom_settings_value2
                    custom_settings_key2: custom_settings_value2

.. note::

    Replace `extension_id` by the id of your custom extension to install.

    Replace `custom_settings_key*` by your custom VSCode key setting required
    by your extension and `custom_settings_value*` by the adequate value.


VSCode settings
###############

You can add your custom gobal settings here:

.. code-block:: yaml

    custom:
        enabled: True
        vscode:
            settings:
                custom_settings_key1: custom_settings_value2
                custom_settings_key2: custom_settings_value2

.. note::

    Replace `extension_id` by the id of your custom extension to install.

    Replace `custom_settings_key*` by your custom VSCode key setting and
    `custom_settings_value*` by the adequate value.

VSCode keybindings
##################

Add your custom keybindings.

Below, a simple example:

.. code-block:: yaml

    - key: shift+home
    command: cursorHomeSelect
    when: editorTextFocus

Software
########

Windows software
****************

scoop
=====

Install your custom scoop software.

.. code-block:: yaml

    custom:
        enabled: True
        scoop:
            pkgs:
                pkg_name:
                    enabled: True
                    version: null

.. note::

    Type `scoop search` to see all software.

    Replace `pkg_name` by the package name.

chocolatey
==========

Install your custom chocolatey software.

.. code-block:: yaml

    custom:
        enabled: True
        chocolatey:
            pkgs:
                pkg_name:
                    enabled: True
                    version: null

.. note::

    Type `choco list` to see all software.

    Replace `pkg_name` by the package name.

msys2
=====

Install your custom msys2 software.

.. code-block:: yaml

    custom:
        enabled: True
        msys2:
            pkgs:
                pkg_name:
                    enabled: True
                    version: null

.. note::

    Type `pacman -Ss` from the terminal install the installation directory
    to see all software. You can also view all packages at
    https://packages.msys2.org/base.

    Replace `pkg_name` by the package name.

Docsets
#######

Install custom Zeal docsets.

    You can view all docsets at:

    - https://github.com/Kapeli/feeds
    - https://github.com/Kapeli/Dash-User-Contributions/tree/master/docsets

.. code-block:: yaml

    zeal:
        docsets:
            docsets_id:
                version: null
                enabled: True

.. note::

    Replace `docsets_id` by your docset.

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    custom:
        enabled: True

Environment
***********

.. code-block:: yaml

    custom:
        enabled: True
        env:
            my_var: my_value

.. note::

    Replace `my_var` and `my_value` by your variable name and its value.

Specific module settings
************************

No settings.
