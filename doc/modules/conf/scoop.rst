.. _module_conf_scoop:

=====
scoop
=====

Allow to manage `scoop <https://scoop.sh>`_.

pkgs
####

``pkgs`` allow to install some scoop packages.

You need to specify the name of the packages to install.

For each packages you can specify the following arguments:

- ``enabled``: ``True`` to install or ``False`` to ignore
  (default to ``False``)
- ``version``: specify the version to install (default to ``null``). If
  ``null`` the latest version will be installed

Example to install ``python3``:

.. code-block:: yaml

    python3:
        enabled: True
        scoop:
            pkgs:
                python:
                    enabled: True
                    version: null

.. note::

    Only for Windows.
