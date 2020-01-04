.. _modulec_cpp:

=======
C / C++
=======

.. image:: https://ms-vscode.gallerycdn.vsassets.io/extensions/ms-vscode/cpptools/0.26.1/1572295904182/Microsoft.VisualStudio.Services.Icons.Default
    :alt: C/C++
    :height: 250px

About
#####

This module contains 2 languages:

- `C <https://en.cppreference.com/w/c>`__ is a general-purpose, procedural computer programming language
  supporting structured programming, lexical variable scope, and recursion,
  while a static type system prevents unintended operations.

- `C++ <https://en.cppreference.com/w/cpp>`__ is a general-purpose programming language created by
  Bjarne Stroustrup as an extension of the C programming
  language, or "C with Classes".

VSCode extensions
#################

ms-vscode.cpptools
******************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools>`__
adds language support for C/C++ to Visual Studio Code, including features such
as `IntelliSense <https://code.visualstudio.com/docs/editor/intellisense>`_ and
`debugging <https://code.visualstudio.com/docs/editor/debugging>`__.

.. image:: https://code.visualstudio.com/assets/docs/languages/cpp/cpp-hero.png
    :alt: C++ completion

jbenden.c-cpp-flylint
*********************

This `extension <https://marketplace.visualstudio.com/items?itemName=jbenden.c-cpp-flylint>`__
is an advanced, modern, static analysis extension for C/C++ that supports a
number of back-end analyzer programs.

matepek.vscode-catch2-test-adapter
**********************************

This `extension <https://marketplace.visualstudio.com/items?itemName=matepek.vscode-catch2-test-adapter>`__
allows you to run your `Catch2 <https://github.com/catchorg/Catch2>`_,
`Google Test <https://github.com/google/googletest>`_ and
`doctest <https://github.com/onqtam/doctest>`_ (experimental) tests for Visual Studio Code.

.. image:: https://github.com/matepek/vscode-catch2-test-adapter/raw/master/resources/Screenshot_2019-05-28.png
    :alt: Cpp tests

.. note::

    VSCode-Anywhere does not install Catch2, Google Test or doctest.
    You have to install them by yourself.

Configuration
=============

After installing the `ms-vscode.cpptools`_ extension, you must configure it.

For more details read `the official configuration <https://code.visualstudio.com/docs/languages/cpp>`_
and how to configure it with:

- `Mingw-w64 <https://code.visualstudio.com/docs/cpp/config-mingw>`_ on Windows

You could also read:

- `Debugging <https://code.visualstudio.com/docs/cpp/cpp-debug>`__
- `Editing <https://code.visualstudio.com/docs/cpp/cpp-ide>`_
- `Settings <https://code.visualstudio.com/docs/cpp/customize-default-settings-cpp>`_
- `c_cpp_properties.json <https://code.visualstudio.com/docs/cpp/c-cpp-properties-schema-reference>`_

You can create the task file ``.vscode/tasks.json`` to compile your program:

.. code-block:: json
    :name: tasks

    {
        "version": "2.0.0",
        "tasks": [
            {
                "type": "shell",
                "label": "clang build active file",
                "command": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang.exe",
                "args": [
                    "-std=c11",
                    "-Wall",
                    "-Wextra",
                    "-g",
                    "${file}",
                    "-o",
                    "${fileDirname}\\${fileBasenameNoExtension}.exe"
                ],
                "options": {
                    "cwd": "${workspaceFolder}"
                }
            },
            {
                "type": "shell",
                "label": "clang++ build active file",
                "command": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang++.exe",
                "args": [
                    "-std=c++17",
                    "-Wall",
                    "-Wextra",
                    "-g",
                    "${file}",
                    "-o",
                    "${fileDirname}\\${fileBasenameNoExtension}.exe"
                ],
                "options": {
                    "cwd": "${workspaceFolder}"
                }
            }
        ]
    }

Now, you can create the ``.vscode/launch.json`` to run the debugger:

.. code-block:: json
    :name: launch

    {
        "version": "0.2.0",
        "configurations": [
            {
                "name": "(gdb) clang",
                "type": "cppdbg",
                "request": "launch",
                "program": "${workspaceFolder}\\${fileBasenameNoExtension}.exe",
                "args": [],
                "stopAtEntry": true,
                "cwd": "${workspaceFolder}",
                "environment": [],
                "externalConsole": false,
                "MIMode": "gdb",
                "miDebuggerPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\gdb.exe",
                "setupCommands": [
                    {
                        "description": "Activer l'impression en mode Pretty pour gdb",
                        "text": "-enable-pretty-printing",
                        "ignoreFailures": true
                    }
                ],
                "preLaunchTask": "clang build active file"
            },
            {
                "name": "(gdb) clang++",
                "type": "cppdbg",
                "request": "launch",
                "program": "${workspaceFolder}\\${fileBasenameNoExtension}.exe",
                "args": [],
                "stopAtEntry": true,
                "cwd": "${workspaceFolder}",
                "environment": [],
                "externalConsole": false,
                "MIMode": "gdb",
                "miDebuggerPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\gdb.exe",
                "setupCommands": [
                    {
                        "description": "Activer l'impression en mode Pretty pour gdb",
                        "text": "-enable-pretty-printing",
                        "ignoreFailures": true
                    }
                ],
                "preLaunchTask": "clang++ build active file"
            }
        ]
    }

VSCode settings
###############

VSCode settings configuration for ``C`` and ``C++``.

Global settings
***************

.. code-block:: json

    {
        "dash.languageIdToDocsetMap.c": [
            "c"
        ],
        "C_Cpp.default.cStandard": "c11",
        "C_Cpp.default.cppStandard": "c++17",
        "c-cpp-flylint.flexelint.enable": false,
        "c-cpp-flylint.cppcheck.enable": false,
        "c-cpp-flylint.clang.enable": true
    }

Windows settings
****************

.. code-block:: json

    {
        "C_Cpp.default.compilerPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang.exe",
        "c-cpp-flylint.clang.executable": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang.exe",
        "code-runner.executorMap.c": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang.exe $fileName -o $fileNameWithoutExt.exe && $fileNameWithoutExt.exe",
        "code-runner.executorMap.cpp": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang++.exe $fileName -o $fileNameWithoutExt.exe && $fileNameWithoutExt.exe"
    }

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Software
########

Windows software
****************

msys2
=====

- `mingw-w64-x86_64-clang <https://packages.msys2.org/package/mingw-w64-x86_64-clang>`_
- `mingw-w64-x86_64-gdb <https://packages.msys2.org/package/mingw-w64-x86_64-gdb>`_

Docsets
#######

2 docsets will be installed:

- `C <https://github.com/Kapeli/feeds/blob/master/C.xml>`__
- `C++ <https://github.com/Kapeli/feeds/blob/master/C%2B%2B.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    c_cpp:
        enabled: True

Environment
***********

Windows environment
*******************

.. code-block:: yaml

    PATH: C:\VSCode-Anywhere\apps\scoop\apps\gdb\current\bin

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Specific module settings
************************

No specific Configuration but you can change the default compiler by another
one:

.. code-block:: yaml

    msys2:
        pkgs:
            mingw-w64-x86_64-gcc:
                enabled: True
