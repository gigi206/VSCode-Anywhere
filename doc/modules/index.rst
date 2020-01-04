.. _modules:

#######
Modules
#######

In VSCode-Anywhere, a lot of modules are available. These modules allow you to:

- install some VSCode extensions
- install some requirements for your VSCode extensions
  (librairies, compilers, programming languages, etc...)
- configure some settings for the VSCode extensions
- configure environment variables
- configure VSCode keyboard shortcuts in VSCode
- install documentations to your programming language

List
####

Below is the list of all available modules:

.. toctree::
    :glob:
    :maxdepth: 1

    *

Install
#######

To installed a VSCode-Anywhere module, you must edit the file
:file:`conf/saltstack/pillar/vscode-anywhere.sls` in your installation
directory and change the value of the target module from ``False`` to ``True``.

After that, you must run the :ref:`installation script <tool_install>`.

VSCode-Anywhere uses `Saltstack <https://www.saltstack.com>`_ which will
compute the differences to apply to your installation for all modules that you
have activated.

Update
######

To update all VSCode-Anywhere module, you must run the
:ref:`update script <tool_update>`.

Configure
#########

All VSCode-Anywhere modules can be configured to override the default
instalation behaviour, add settings, etc...

To configure a module, you need to edit inside the installation directory the
file :ref:`conf/saltstack/pillar/vscode-anywhere.sls <conf_saltstack_pillar>`

Main settings are listed :ref:`here <module_conf>`.

Create
######

Need to be documented.

.. TODO: explain how to create a module
