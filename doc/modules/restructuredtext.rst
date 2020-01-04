.. _module_restructuredtext:

================
reStructuredText
================

About
#####

`reStructuredText <https://docutils.readthedocs.io/en/sphinx-docs/user/rst/quickstart.html>`_
is a file format for textual data used primarily in the Python programming
language community for technical documentation.

Prerequisites
#############

This module requires that the module :ref:`python3 <module_python3>` be
enabled.

VSCode extensions
#################

lextudio.restructuredtext
*************************

This `extension <https://marketplace.visualstudio.com/items?itemName=lextudio.restructuredtext>`_
provides rich reStructuredText language support for Visual Studio Code.
Now you write reStructuredText scripts using the excellent IDE-like interface
that VS Code provides.

.. image:: https://github.com/vscode-restructuredtext/vscode-restructuredtext/raw/master/images/main.gif
    :alt: RST

VSCode settings
###############

No settings.

Software
########

No software.

Docsets
#######

No docsets.

Environment
***********

No environment.

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    restructuredtext:
        enabled: True
    python3:
        enabled: True

Specific module settings
************************

pip
===

`pip <https://pypi.org>`_ is used to install some Python packages.

The following python packages will be installed:

- `docutils <https://pypi.org/project/docutils/>`_
- `sphinx <https://pypi.org/project/sphinx/>`_
- `sphinx-autobuild <https://pypi.org/project/sphinx-autobuild/>`_
- `doc8 <https://pypi.org/project/doc8/>`_

.. note::

    Same usage as :ref:`python3 <module_python3>`.
