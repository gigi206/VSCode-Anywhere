.. _module_csharp:

====
C#
====

.. image:: https://upload.wikimedia.org/wikipedia/commons/8/82/C_Sharp_logo.png
    :alt: C#
    :height: 250px

About
#####

`C# <https://docs.microsoft.com/en-us/dotnet/csharp/index>`_ is a general-purpose,
multi-paradigm programming language encompassing strong typing, lexically
scoped, imperative, declarative, functional, generic, object-oriented
(class-based), and component-oriented programming disciplines.

Prerequisites
#############

This module doesn't work out of the box. You must configure it for each project
for this module works properly.

Please read `dotnet documentation <https://code.visualstudio.com/docs/languages/dotnet>`_
and take a look at the extension `ms-vscode.csharp`__.

VSCode extensions
#################

For more details read the `official documentation <https://code.visualstudio.com/docs/languages/csharp>`_.

ms-vscode.csharp
****************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp>`__
provides the following features inside VS Code:

- Lightweight development tools for `.NET Core <https://dotnet.github.io>`_.
- Great C# editing support, including Syntax Highlighting, IntelliSense,
  Go to Definition, Find All References, etc.
- Debugging support for .NET Core (CoreCLR)
- The C# extension is powered by `OmniSharp <https://github.com/OmniSharp/omnisharp-roslyn>`_.

.. image:: https://code.visualstudio.com/assets/docs/languages/csharp/intellisense.png
    :alt: IntelliSense

Following your OS, please read (note that all requirements are already
installed by VSCode-Anywhere):

- `Windows <https://channel9.msdn.com/Blogs/dotnet/Get-started-VSCode-Csharp-NET-Core-Windows>`_
- `Linux <https://channel9.msdn.com/Blogs/dotnet/Get-started-with-VS-Code-Csharp-dotnet-Core-Ubuntu>`_
- `MacOS <https://channel9.msdn.com/Blogs/dotnet/Get-started-VSCode-NET-Core-Mac>`_

.. note::

    The first time you open a ``cs`` file, this extension will download its
    prerequisites.

wghats.vscode-nxunit-test-adapter
*********************************

This `extension <https://marketplace.visualstudio.com/items?itemName=wghats.vscode-nxunit-test-adapter>`_
allow to run your Nunit or Xunit test for Desktop .NET Framework or Mono

.. note::

    VSCode-Anywhere install for you Nunit console.

VSCode settings
###############

No settings.

Software
########

Windows software
****************

scoop
=====

- `dotnet-sdk <https://github.com/ScoopInstaller/Main/blob/master/bucket/dotnet-sdk.json>`_
- `scriptcs <https://github.com/ScoopInstaller/Main/blob/master/bucket/scriptcs.json>`_
- `nunit-console <https://github.com/ScoopInstaller/Main/blob/master/bucket/nunit-console.json>`_

Docsets
#######

1 docset will be installed:

- `NET_Framework <https://github.com/Kapeli/feeds/blob/master/NET_Framework.xml>`_

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    csharp:
        enabled: True

Environment
***********

Windows environment
*******************

.. code-block:: yaml

    DOTNET_ROOT: C:\VSCode-Anywhere\apps\scoop\apps\dotnet-sdk\current
    MSBuildSDKsPath: C:\VSCode-Anywhere\apps\scoop\apps\dotnet-sdk\current\sdk\<version>\Sdks

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

    ``version`` is the current cersion of the dotnet sdk.

Specific module settings
************************

No specific setting.
