.. _module_conf_env:

===
env
===

Append environment to VSCode-Anywhere :ref:`env file <tool_env>`:

- **Windows**: ``<install_dir>/tools/env.ps1``
- **Linux / MacOS**: ``<install_dir>/tools/env.sh``

Unlike the other variables ``PATH`` is special, it does not override the value
put append a value.

Example to add environment to ``python3``:

.. code-block:: yaml

    python3:
        enabled: True
        env:
            PATH: C:\VSCode-Anywhere\apps\scoop\apps\python\current\Scripts
            VAR1: value1
            VAR2: value2

.. note::

    Only for Windows.
