.. _module_ansible:

=======
Ansible
=======

.. image:: https://upload.wikimedia.org/wikipedia/commons/2/24/Ansible_logo.svg
    :alt: Ansible
    :height: 250px

About
#####

`Ansible <https://www.ansible.com>`__ is an IT automation tool.  It can configure systems, deploy software,
and orchestrate more advanced IT tasks such as continuous deployments or zero
downtime rolling updates.

Prerequisites
#############

This module requires that the module :ref:`python3 <module_python3>` be
enabled.

VSCode extensions
#################

vscoss.vscode-ansible
*********************

This `extension <https://marketplace.visualstudio.com/items?itemName=vscoss.vscode-ansible>`_
is designed to increase developer productivity authoring, testing and using
Ansible with Azure. The extension provides cool features around playbook
authoring and execution. It supports running playbook from various places
e.g. Docker, local installation, remote machines via ssh and Cloud Shell.

.. image:: https://github.com/VSChina/vscode-ansible/raw/master/images/authoring.gif
    :alt: Code snippets

.. image:: https://github.com/VSChina/vscode-ansible/raw/master/images/menu.png
    :alt: Run Ansible playbook

VSCode settings
###############

No settings.

VSCode keybindings
##################

No keybindings.

Software
########

Windows software
****************

scoop
=====

- `python <https://github.com/ScoopInstaller/Main/blob/master/bucket/python.json>`__

Docsets
#######

2 docsets will be installed:

- `Ansible <https://github.com/Kapeli/feeds/blob/master/Ansible.xml>`__
- `Jinja <https://github.com/Kapeli/feeds/blob/master/Jinja.xml>`_

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    ansible:
        enabled: True
    python3:
        enabled: True

Environment
***********

No environment.

Specific module settings
************************

pip
===

`pip <https://pypi.org>`_ is used to install some Python packages.

The following python packages will be installed:

Pip modules:

- `ansible <https://pypi.org/project/ansible/>`_

.. note::

    The ansible module pip will not be installed under Windows because it is
    incompatible with this one!

    Same usage as :ref:`python3 <module_python3>`.
