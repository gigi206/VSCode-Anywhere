.. _module_docker:

======
Docker
======

.. image:: https://www.docker.com/sites/default/files/d8/2019-07/Moby-logo.png
    :alt: Docker
    :height: 250px

About
#####

`Docker <https://www.docker.com>`_ is a set of platform as a service (PaaS)
products that use OS-level virtualization to deliver software in packages
called containers.

Prerequisites
#############

Windows prerequisites
*********************

VSCode-Anywhere will install Docker only if you have the
:ref:`profile <profile_windows>` ``windows_admin`` set because it requires
administrator rights.

Note that without this profile, you will not be able to use all the
features of the `ms-azuretools.vscode-docker`_ extension.

.. note::

    In addition to the ``windows_admin`` profile, Docker requires
    Windows 10 64-bit: Pro, Enterprise, or Education (Build 15063 or later) and
    Hyper-V and Containers Windows features must be enabled.

    Also BIOS-level hardware virtualization support must be enabled in the BIOS
    settings.

.. note::

    If you haven't set the ``windows_admin`` profile, you can manually install
    Docker. Please take a look at the
    `documentation <https://docs.docker.com/docker-for-windows/install/>`_.

VSCode extensions
#################

For more details, please visit the `official documentation <https://code.visualstudio.com/docs/azure/docker>`_.

ms-azuretools.vscode-docker
***************************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker>`_
makes it easy to build, manage and deploy containerized applications from
Visual Studio Code.

.. image:: https://github.com/microsoft/vscode-docker/raw/master/resources/readme/generateFiles.gif
    :alt: Generate Dockerfile

.. image:: https://github.com/microsoft/vscode-docker/raw/master/resources/readme/intelliSense.gif
    :alt: IntelliSense

.. image:: https://github.com/microsoft/vscode-docker/raw/master/resources/readme/explorers.png
    :alt: View


.. container:: youtube

    .. raw:: html

            <iframe src="https://www.youtube.com/embed/vQxSOL9kE-s" frameborder="0" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>

VSCode settings
###############

No settings.

Software
########

Windows software
*****************

Chocolatey
==========

- `docker-desktop <https://chocolatey.org/packages/docker-desktop>`_

Docsets
#######

1 docset will be installed:

- `Docker <https://github.com/Kapeli/feeds/blob/master/Docker.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    docker:
        enabled: True

Environment
***********

No environment.

Specific module settings
************************

No Specific settings.
