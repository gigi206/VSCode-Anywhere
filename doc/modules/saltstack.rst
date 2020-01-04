.. _module_saltstack:

=========
Saltstack
=========

.. image:: https://upload.wikimedia.org/wikipedia/commons/6/64/SaltStack_logo_blk_2k.png
    :alt: Saltstack
    :height: 250px

About
#####

`Salt <https://www.saltstack.com>`__ (sometimes referred to as SaltStack) is
Python-based, open-source software for event-driven IT automation, remote task
execution, and configuration management. Supporting the
`Infrastructure as Code <https://en.wikipedia.org/wiki/Infrastructure_as_Code>`_
approach to data center system and network deployment and management,
configuration automation, SecOps orchestration, vulnerability remediation, and
hybrid cloud control. Salt is most often compared to tools from
:ref:`Puppet <module_puppet>`, :ref:`Chef <module_chef>`, and
:ref:`Ansible <module_ansible>`.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

korekontrol.saltstack
*********************

This `extension <https://marketplace.visualstudio.com/items?itemName=korekontrol.saltstack>`__
adds language colorization support for the SaltStack template language to VS
Code. The language is a yaml with Jinja2 templating.

.. image:: https://raw.githubusercontent.com/korekontrol/vscode-saltstack/master/example.png
    :alt: Saltstack

VSCode settings
###############

VSCode settings configuration for SaltStack:

.. code-block:: yaml+jinja

    dash.languageIdToDocsetMap.sls:
        - salt

Software
########

No software.

Docsets
#######

2 docsets will be installed:

- `SaltStack <https://github.com/Kapeli/feeds/blob/master/SaltStack.xml>`_
- `Jinja <https://github.com/Kapeli/feeds/blob/master/Jinja.xml>`_

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    saltstack:
        enabled: True

Environment
***********

No environment.

Specific module settings
************************

No specific module settings.
