.. _module_conf_msys2:

=====
msys2
=====

Allow to manage `msys2 <https://www.msys2.org>`_.

pkgs
####

``pkgs`` allow to install some `msys2 packages <https://packages.msys2.org>`_.

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
        msys2:
            pkgs:
                python3:
                    enabled: True
                    version: null
                python3-pip:
                    enabled: True
                    version: null

.. note::

    Only for Windows.
