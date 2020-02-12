.. _conf_saltstack_pillar:

================
Saltstack pillar
================

This directory manage the `Saltstack pillar <https://docs.saltstack.com/en/latest/topics/pillar/>`_ files.

top.sls
#######

This is the `Salstack top file <https://docs.saltstack.com/en/latest/ref/states/top.html>`_.

.. warning::

    This is not recommended to edit manually this file

saltstack.sls
#############

This file is for internal use.

.. warning::

    This is not recommended to edit manually this file

vscode-anywhere.sls
###################

This is the file where you can interact with VSCode-Anywhere for activate a
module for installation and configuration. Please read the documentation
:ref:`modules <modules>` for know how to configure your module.

.. note::

    All modules can be overrided by a specific configuration.
