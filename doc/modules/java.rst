.. _module_java:

====
Java
====

.. image:: https://upload.wikimedia.org/wikipedia/fr/2/2e/Java_Logo.svg
    :alt: Java
    :height: 250px

About
#####

`Java <https://www.oracle.com/java/>`_ Java is a general-purpose programming
language that is class-based, object-oriented, and designed to have as few
implementation dependencies as possible.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

For more details read the `official documentation <https://code.visualstudio.com/docs/languages/java>`_.

.. vscjava.vscode-java-pack
.. ************************

.. This `extension <https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack>`__
.. is a collection of popular extensions that can help write, test and debug Java
.. applications in Visual Studio Code. Check out Java in VS Code to get started.

redhat.java
***********

This `extension <https://marketplace.visualstudio.com/items?itemName=redhat.java>`__
provides Java language support.

.. image:: https://raw.githubusercontent.com/redhat-developer/vscode-java/master/images/vscode-java.0.0.1.gif
    :alt: Language Support for Java(TM) by Red Hat

vscjava.vscode-java-debug
*************************

This `extension <https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug>`__
provides a lightweight Java debugger for Visual Studio Code.

.. image:: https://github.com/VSChina/vscode-ansible/raw/master/images/menu.png
    :alt: Debugger for Java

vscjava.vscode-java-test
************************

This `extension <https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug>`__
allow to run and debug Java test cases in Visual Studio Code.

.. image:: https://github.com/Microsoft/vscode-java-test/raw/master/demo/demo.gif
    :alt: Java Test Runner

vscjava.vscode-maven
********************

This `extension <https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-maven>`__
allow to manage Maven projects, execute goals, generate project from archetype,
improve user experience for Java developers.

.. image:: https://github.com/Microsoft/vscode-maven/raw/master/images/explorer.png
    :alt: Maven for Java

vscjava.vscode-java-dependency
******************************

This `extension <https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-dependency>`__
manages Java Dependencies in VSCode.

.. image:: https://raw.githubusercontent.com/Microsoft/vscode-java-dependency/master/images/project-dependency.gif
    :alt: Java Dependency Viewer

VisualStudioExptTeam.vscodeintellicode
**************************************

This `extension <https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode>`__
provides AI-assisted development features for Java.

.. image:: https://go.microsoft.com/fwlink/?linkid=2006041
    :alt: Visual Studio IntelliCode

shengchen.vscode-checkstyle
***************************

This `extension <https://marketplace.visualstudio.com/items?itemName=shengchen.vscode-checkstyle>`__
provides real-time feedback about Checkstyle violations and quick fix actions.

.. image:: https://raw.githubusercontent.com/jdneo/vscode-checkstyle/master/docs/gifs/demo.gif
    :alt: Checkstyle for Java

redhat.vscode-xml
*****************

This `extension <https://marketplace.visualstudio.com/items?itemName=shengchen.vscode-checkstyle>`__
provides support for creating and editing XML documents, based on the LSP4XML
Language Server, running with Java.

.. image:: https://user-images.githubusercontent.com/148698/45977901-df208a80-c018-11e8-85ec-71c70ba8a5ca.gif
    :alt: XML for Java

pivotal.vscode-spring-boot
**************************

This `extension <https://marketplace.visualstudio.com/items?itemName=pivotal.vscode-spring-boot>`__
provides validation and content assist for Spring Boot
``application.properties``, ``application.yml`` properties files. As well as
Boot-specific support for ``.java`` files.

.. image:: https://github.com/spring-projects/sts4/raw/facac2003191bc29bf79049aa02a091457ffbe47/vscode-extensions/vscode-spring-boot/readme-imgs/java-code-completion.png
    :alt: Spring boot

.. note::

    This extension will be installed only if you had set ``spring_boot`` to
    ``True`` in your VSCode-Anywhere settings:

    .. code-block:: yaml

        java:
            enabled: True
            spring_boot: True

vscjava.vscode-spring-initializr
********************************

This `extension <https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-spring-initializr>`__
quickly generate a Spring Boot project in Visual Studio Code (VS Code). It
helps you to customize your projects with configurations and manage Spring Boot
dependencies.

.. image:: https://github.com/Microsoft/vscode-spring-initializr/raw/master/images/spring-initializr-vsc.gif
    :alt: Spring initializr

.. note::

    This extension will be installed only if you had set ``spring_boot`` to
    ``True`` in your VSCode-Anywhere settings:

    .. code-block:: yaml

        java:
            enabled: True
            spring_boot: True

vscjava.vscode-spring-boot-dashboard
************************************

`Spring Boot Dashboard <https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-spring-boot-dashboard>`__
is an explorer in the side bar, you can view and manage all available Spring
Boot projects in your workspace. It also supports the features to quickly
start, stop or debug a Spring Boot project.

.. image:: https://github.com/Microsoft/vscode-spring-boot-dashboard/raw/master/images/boot-dashboard-vsc.gif
    :alt: Spring boot dashboard

.. note::

    This extension will be installed only if you had set ``spring_boot`` to
    ``True`` in your VSCode-Anywhere settings:

    .. code-block:: yaml

        java:
            enabled: True
            spring_boot: True

redhat.vscode-quarkus
*********************

This `extension <https://marketplace.visualstudio.com/items?itemName=redhat.vscode-quarkus>`__
provides support for Quarkus development.

.. image:: https://github.com/redhat-developer/vscode-quarkus/raw/master/images/propertiesSupport.png
    :alt: Quarkus

.. note::

    This extension will be installed only if you had set ``quarkus`` to
    ``True`` in your VSCode-Anywhere settings:

    .. code-block:: yaml

        java:
            enabled: True
            quarkus: True

SummerSun.vscode-jetty
**********************

This `extension <https://marketplace.visualstudio.com/items?itemName=SummerSun.vscode-jetty>`__
allow to start and run or debug your war package on Jetty.

.. image:: https://github.com/summersun/vscode-jetty/raw/master/resources/Jetty.gif
    :alt: Jetty

.. note::

    This extension will be installed only if you had set ``jetty`` to
    ``True`` in your VSCode-Anywhere settings:

    .. code-block:: yaml

        java:
            enabled: True
            jetty: True

adashen.vscode-tomcat
*********************

This `extension <https://marketplace.visualstudio.com/items?itemName=adashen.vscode-tomcat>`__
allow to debug or run your java war package in Apache Tomcat.

.. image:: https://github.com/adashen/vscode-tomcat/raw/master/resources/Tomcat.gif
    :alt: Tomcat

.. note::

    This extension will be installed only if you had set ``tomcat`` to
    ``True`` in your VSCode-Anywhere settings:

    .. code-block:: yaml

        java:
            enabled: True
            tomcat: True

VSCode settings
###############

VSCode settings configuration for ``java``.

Global settings
***************

No global settings.

Windows settings
****************

.. code-block:: json

    {
        "java.home": "C:\VSCode-Anywhere\apps\scoop\apps\openjdk\current",
        "xml.java.home": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\openjdk\\current"
    }

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Software
########

Windows software
****************

scoop
=====

- `openjdk <https://github.com/ScoopInstaller/Java/blob/master/bucket/openjdk.json>`__
- `maven <https://github.com/ScoopInstaller/Main/blob/master/bucket/maven.json>`_
- `gradle <https://github.com/ScoopInstaller/Main/blob/master/bucket/gradle.json>`_

If ``quarkus`` is set to ``True``:
- `graalvm <https://github.com/ScoopInstaller/Java/blob/master/bucket/graalvm.json>`_

If ``tomcat`` is set to ``True``:
- `tomcat <https://github.com/lukesampson/scoop-extras/blob/master/bucket/tomcat.json>`__

chocolatey
==========

If ``jetty`` is set to ``True``:
- `jetty <https://chocolatey.org/packages/jetty>`__

Docsets
#######

2 docsets will be installed:

- `Java_SE12 <https://github.com/Kapeli/feeds/blob/master/Java_SE12.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    java:
        enabled: True

Environment
***********

Windows environment
===================

- Default settings:

.. code-block:: yaml

    PATH: C:\VSCode-Anywhere\apps\scoop\persist\openjdk\bin
    JAVA_HOME: C:\VSCode-Anywhere\apps\scoop\apps\openjdk\current
    JDK_HOME: C:\VSCode-Anywhere\apps\scoop\apps\openjdk\current

- Following settins will be added only if ``quarkus`` is set to ``True`` in
  your VSCode-Anywhere settings:

.. code-block:: yaml

    PATH: C:\VSCode-Anywhere\apps\scoop\apps\graalvm\current\bin

    .. note::

        This path will be added to the default path ``C:\VSCode-Anywhere\apps\scoop\persist\openjdk\bin``.

- Following settins will be added only if ``tomcat`` is set to ``True`` in your
  VSCode-Anywhere settings:

.. code-block:: yaml

    CATALINA_BASE: C:\VSCode-Anywhere\apps\scoop\apps\tomcat\current
    CATALINA_HOME: C:\VSCode-Anywhere\apps\scoop\apps\tomcat\current

.. code-block:: yaml

    java:
        enabled: True
        tomcat: True

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

    ``JETTY_HOME`` must be set and it is set in Windows environment during the
    installation process and not directly in VSCode-Anywhere (need to detec
    correctly the installation path for that). This can lead to some issues if
    you install multiple environment.

     If you encounter some issues, you can fix manually with adding the
     variable in your VSCode-Anywhere environment:

    .. code-block:: yaml+jinja

        java:
            env:
                JETTY_HOME: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('Chocolatey', 'lib', 'jetty', 'tools', 'jetty-distribution-<version>') }}

    Juste replace ``<version>`` by the Jetty installed version.

Specific module settings
************************

spring_boot
===========

If set to ``True``, it will install additional components for
`Spring Boot <https://spring.io/projects/spring-boot>`_:

.. code-block:: yaml

    java:
        enabled: True
        spring_boot: True

quarkus
=======

If set to ``True``, it will install additional components for
`Quarkus <https://quarkus.io>`_:

.. code-block:: yaml

    java:
        enabled: True
        quarkus: True

tomcat
======

If set to ``True``, it will install additional components for
`Tomcat <https://tomcat.apache.org>`__:

.. code-block:: yaml

    java:
        enabled: True
        tomcat: True

jetty
=====

If set to ``True``, it will install additional components for
`Jetty <https://www.eclipse.org/jetty/>`__:

.. code-block:: yaml

    java:
        enabled: True
        jetty: True
