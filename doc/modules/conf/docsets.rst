.. _module_conf_docsets:

=======
docsets
=======

Install docsets:

- **Windows / Linux**: `Zeal <https://zealdocs.org>`_
- **MacOS**: `Dash <https://kapeli.com/dash>`_

You can view all docsets at:

- https://github.com/Kapeli/feeds
- https://github.com/Kapeli/Dash-User-Contributions/tree/master/docsets


Example to add the docset ``python3``:

.. code-block:: yaml

    python3:
        enabled: True
        zeal:
            docsets:
                Python_3:
                    version: null
                    enabled: True

.. note::

    Only for Windows.
