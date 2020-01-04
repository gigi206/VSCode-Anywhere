.. _conf_saltstack_conf:

==============================
Saltstack minion configuration
==============================

minion / miniond.d
##################

The minion ``file`` is the main configuration file. VSCode-Anywhere does not
configure anything in this file but in the ``minion.d`` directory.

The ``minion.d`` directory contains the
`the Saltstack minion configuration <https://docs.saltstack.com/en/latest/ref/configuration/minion.html>`_.

The file ``minion.d\VSCode-Anywhere.conf`` is managed by VSCode-Anywhere.
You you don't have to modify manually this file.


.. warning::

    This is not recommended to edit manually ``minion`` or
    ``miniond\VSCode-Anywhere.conf`` files.

    But if you still want to change the minion configuration, you can:

    - override settings within the pillar configuration file
      :ref:`pillar <conf_saltstack_pillar>` in the
      ``vscode-anywhere:saltstack_core`` section
    - add a file with the ``conf`` extension in the ``minion.d`` directory

grains
######

The ``grains`` file manage the `Saltstack grains <https://docs.saltstack.com/en/latest/topics/grains/>`_.

.. warning::

    This is not recommended to edit manually the ``grains`` file.
