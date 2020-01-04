.. _module_remote:

======
Remote
======

.. image:: https://code.visualstudio.com/assets/docs/remote/remote-overview/architecture.png
    :alt: Remote
    :height: 250px

About
#####

The Visual Studio Code Remote Development extension pack allows you to open any
folder in a container, on a remote machine (via SSH), or in the
`Windows Subsystem for Linux <https://docs.microsoft.com/windows/wsl>`_
(WSL) and take advantage of VS Code's full feature set.

This means that VS Code can provide a local-quality development experience —
including full IntelliSense (completions), debugging, and more — regardless
of where your code is located or hosted.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

For more details read the `official documentation <https://code.visualstudio.com/docs/remote/remote-overview>`_.

ms-vscode-remote.remote-ssh
***************************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh>`__
lets you use any remote machine with a SSH server as your development
environment.

Read the `documentation <https://code.visualstudio.com/remote-tutorials/ssh/getting-started>`__,
the `tutorial <https://code.visualstudio.com/remote-tutorials/ssh/getting-started>`__
and `tips <https://code.visualstudio.com/docs/remote/troubleshooting#_ssh-tips>`__
for more details.

.. image:: https://microsoft.github.io/vscode-remote-release/images/ssh-readme.gif
    :alt: SSH remote

ms-vscode-remote.remote-wsl
***************************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl>`__
lets you use the Windows Subsystem for Linux (WSL) as your full-time
development environment right from VS Code.

Read the `documentation <https://code.visualstudio.com/docs/remote/wsl>`__,
the `tutorial <https://code.visualstudio.com/remote-tutorials/wsl/getting-started>`__
and `tips <https://code.visualstudio.com/docs/remote/troubleshooting#_container-tips>`__
for more details.

.. note::

    This extension is not installed by default, but if you want to install it:

    .. code-block:: yaml

        remote:
            enabled: True
            vscode:
                extensions:
                    ms-vscode-remote.remote-wsl:
                        enabled: True
                        version: null

.. image:: https://microsoft.github.io/vscode-remote-release/images/wsl-readme.gif
    :alt: WSL remote

ms-vscode-remote.remote-containers
**********************************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers>`__
lets you use a Docker container as a full-featured development environment.

Read the `documentation <https://code.visualstudio.com/docs/remote/containers>`__,
the `tutorial <https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers>`__,
`tips <https://code.visualstudio.com/docs/remote/troubleshooting#_container-tips>`__
and `advanced use <https://code.visualstudio.com/docs/remote/containers-advanced>`_
for more details.

.. note::

    This extension is not installed by default, but if you want to install it:

    .. code-block:: yaml

        remote:
            enabled: True
            vscode:
                extensions:
                    ms-vscode-remote.remote-containers:
                        enabled: True
                        version: null

.. image:: https://microsoft.github.io/vscode-remote-release/images/remote-containers-readme.gif
    :alt: Docker remote

ms-vsonline.vsonline
********************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-vsonline.vsonline>`__
provides cloud-powered development environments for any activity.

Read the `documentation <https://code.visualstudio.com/docs/remote/vsonline>`__,
the `tutorial <https://docs.microsoft.com/fr-fr/visualstudio/online/how-to/vscode>`__
and `tips <https://code.visualstudio.com/docs/remote/troubleshooting#_ssh-tips>`__.
for more details.

.. note::

    This extension is not installed by default, but if you want to install it:

    .. code-block:: yaml

        remote:
            enabled: True
            vscode:
                extensions:
                    ms-vsonline.vsonline:
                        enabled: True
                        version: null

VSCode settings
###############

VSCode settings configuration for ``remote``.

Global settings
***************

No global settings.

Windows settings
****************

.. code-block:: json

    {
        "remote.SSH.path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\git\\usr\\bin\\ssh.exe"
    }

Software
########

No software.

Docsets
#######

No docset.

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    remote:
        enabled: True

Environment
***********

No environment.

Specific module settings
************************

No Specific settings.
