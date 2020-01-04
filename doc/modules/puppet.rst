.. _module_puppet:

======
Puppet
======

.. image:: https://upload.wikimedia.org/wikipedia/commons/b/be/Puppet_Logo.svg
    :alt: Puppet
    :height: 250px

About
#####

`Puppet <https://puppet.com/>`_ is an open-core software configuration
management tool.

Prerequisites
#############

This module requires that the module :ref:`ruby <module_ruby>` be enabled.

VSCode extensions
#################

jpogran.puppet-vscode
*********************

This `extension <https://marketplace.visualstudio.com/items?itemName=jpogran.puppet-vscode>`__
provides rich support for the Puppet language, including features such as
syntax highlighting, linting, debugging, IntelliSense and more.

.. image:: https://raw.githubusercontent.com/lingua-pupuli/puppet-vscode/master/docs/assets/auto_complete.gif
    :alt: Puppet IntelliSense

.. note::

    This extension will be installed only if you have the ``windows_admin`` profile.

bitzl.vscode-puppet
*******************

This `extension <https://marketplace.visualstudio.com/items?itemName=bitzl.vscode-puppet>`__
offers rich language support for Puppet DSL, snippets, and linter for Visual
Studio Code.

.. note::

    This extension will be installed only if you have the ``windows_user`` or ``windows_portable`` profile.

VSCode settings
###############

No settings configured.

Software
########

Windows software
****************

chocolatey
==========

- `pdk <https://chocolatey.org/packages/pdk>`_ (only with the ``windows_admin``
  profile)

.. note::

    This package is required by the `jpogran.puppet-vscode`_ extension.

Docsets
#######

1 docsets will be installed:

- `Puppet <https://github.com/Kapeli/feeds/blob/master/Puppet.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    puppet:
        enabled: True

Environment
***********

No environment.

Specific module settings
************************

gem
===

`gem <https://rubygems.org>`_ is used to install some Ruby packages:

The following gem packages will be installed:

- `puppet-lint <http://puppet-lint.com>`_ ruby module.

.. note::

    Same usage as :ref:`ruby <module_ruby>`.
