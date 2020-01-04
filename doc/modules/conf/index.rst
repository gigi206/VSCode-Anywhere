.. _module_conf:

====================
Module configuration
====================

You can interact with the configuration settings in the
``<install_dir>/conf/saltstack/pillar/vscode-anywhere.sls`` file.

Each module is disabled by default and support additional global and specific
settings.

To enable a module, please edit the configuration file and for the module
concerned change the value ``enabled`` from ``False`` to ``True``.

Example for the ``python3`` module:

.. code-block:: yaml

    python3:
        enabled: True

Please read the documentation of the :ref:`module <modules>` concerned in
order to know if it supports specific settings like ``python3`` for example:

.. code-block:: yaml

    python3:
        enabled: True
        anaconda: True
        pip:
            pkgs:
                autopep8:
                    enabled: True
                    version: '1.4.3'

After editing the configuration file, don't forget to
:ref:`apply the new settings <tool_install>`. You need to run the install file:

-  Windows: ``<install_dir>/tools/install.ps1``
-  Linux / MacOS: ``<install_dir>/tools/install.sh``

Below, the global settings that you can add for each module:

.. toctree::
    :glob:
    :maxdepth: 1

    *
