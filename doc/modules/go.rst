.. _module_go:

====
Go
====

.. image:: https://golang.org/lib/godoc/images/go-logo-blue.svg
    :alt: Go
    :height: 250px

About
#####

`Go <https://golang.org/>`__ Go is an open source programming language that
makes it easy to build simple, reliable, and efficient software.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

For more details read the the `official documentation <https://code.visualstudio.com/docs/languages/go>`_.

ms-vscode.go
************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-vscode.go>`_
adds rich language support for the Go language to VS Code.

.. image:: https://code.visualstudio.com/assets/docs/languages/go/hover.png
    :alt: Go hover

VSCode settings
###############

VSCode settings configuration for ``go``.

Global settings
***************

.. code-block:: json

    {
        "go.lintTool": "gometalinter"
    }

Windows settings
****************

.. code-block:: json

    {
        "go.goroot": "C:\VSCode-Anywhere\apps\scoop\apps\go\current",
        "go.gopath": "C:\VSCode-Anywhere\apps\scoop\persist\go"
    }

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Software
########

Windows software
****************

scoop
=====

- `go <https://github.com/ScoopInstaller/Main/blob/master/bucket/go.json>`__

msys2
=====

- `mingw-w64-x86_64-gcc <https://packages.msys2.org/package/mingw-w64-x86_64-gcc>`_

Docsets
#######

1 docset will be installed:

- `Go <https://github.com/Kapeli/feeds/blob/master/Go.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    go:
        enabled: True

Environment
***********

Windows environment
===================

.. code-block:: yaml

    GOROOT: C:\VSCode-Anywhere\apps\scoop\apps\go\current
    GOPATH: C:\VSCode-Anywhere\apps\scoop\persist\go
    PATH: C:\VSCode-Anywhere\apps\scoop\persist\go\bin

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Specific module settings
************************

modules
=======

``modules`` allow to install `go modules <https://blog.golang.org/using-go-modules>`_.

This is an example:

.. code-block:: yaml

    enabled: True
        modules:
            github.com/ramya-rao-a/go-outline:
                enabled: True
            github.com/acroca/go-symbols:
                enabled: True
            github.com/stamblerre/gocode:
                enabled: True
            github.com/mdempsky/gocode:
                enabled: True
            github.com/rogpeppe/godef:
                enabled: True
            golang.org/x/tools/cmd/godoc:
                enabled: True
            github.com/zmb3/gogetdoc:
                enabled: True
            golang.org/x/lint/golint:
                enabled: True
            github.com/fatih/gomodifytags:
                enabled: True
            github.com/uudashr/gopkgs/cmd/gopkgs:
                enabled: True
            golang.org/x/tools/cmd/gorename:
                enabled: True
            github.com/sqs/goreturns:
                enabled: True
            golang.org/x/tools/cmd/goimports:
                enabled: True
            github.com/cweill/gotests:
                enabled: True
            golang.org/x/tools/cmd/guru:
                enabled: True
            github.com/josharian/impl:
                enabled: True
            github.com/haya14busa/goplay/cmd/goplay:
                enabled: True
            github.com/alecthomas/gometalinter:
                enabled: True
            github.com/tylerb/gotype-live:
                enabled: True
            github.com/go-delve/delve/cmd/dlv:
                enabled: True
            github.com/golangci/golangci-lint/cmd/golangci-lint:
                enabled: True
            github.com/mgechev/revive:
                enabled: True
            honnef.co/go/tools/cmd/staticcheck:
                enabled: True
            github.com/davidrjenni/reftools/cmd/fillstruct:
                enabled: True
            github.com/godoctor/godoctor:
                enabled: True
