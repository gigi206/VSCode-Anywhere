.. _module_conf_zeal:

====
zeal
====

Allow to manage `zeal <https://zealdocs.org>`_.

.. image:: https://i.imgur.com/qBkZduS.png
    :alt: Zeal

docsets
#######

Install zeal docsets.

You need to specify the name of the docsets to install.

For each packages you can specify the following arguments:

- ``enabled``: ``True`` to install or ``False`` to ignore
  (default to ``False``)
- ``version``: specify the docset version to install (default to ``null``). If
  ``null`` the latest version will be installed

Example to install ``python3``:


Example with ``python3``:

.. code-block:: yaml

    python3:
        enabled: True
        docsets:
            Python_3:
                version: null
                enabled: True
            PEPs:
                enabled: True
                version: null
