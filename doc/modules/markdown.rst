.. _module_markdown:

========
Markdown
========

.. image:: https://upload.wikimedia.org/wikipedia/commons/4/48/Markdown-mark.svg
    :alt: Markdown
    :height: 250px

About
#####

`Markdown <https://daringfireball.net/projects/markdown/>`_ is a lightweight
markup language with plain text formatting syntax.

Its design allows it to be converted to many output formats, but the original
tool by the same name only supports HTML. Markdown is often used to format
readme files, for writing messages in online discussion forums, and to create
rich text using a plain text editor.

VSCode support natively markdown. For more information read the `documentation <https://code.visualstudio.com/docs/languages/markdown>`_.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

yzhang.markdown-all-in-one
**************************

This `extension <https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one>`_
is all you need for Markdown (keyboard shortcuts, table of contents, auto
preview and more).

.. image:: https://github.com/yzhang-gh/vscode-markdown/raw/master/images/toc.png
    :alt: TOC

.. image:: https://github.com/yzhang-gh/vscode-markdown/raw/master/images/gifs/table-formatter.gif
    :alt: table

esbenp.prettier-vscode
**********************

`Prettier <https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode>`_
is an opinionated code formatter. It enforces a consistent style by parsing
your code and re-printing it with its own rules that take the maximum line
length into account, wrapping code when necessary.

VSCode settings
###############

VSCode settings configuration for ``markdown``.

Global settings
***************

.. code-block:: json

    {
        "[markdown]": {
            "editor.defaultFormatter": "esbenp.prettier-vscode"
        }
    }

Software
########

No software required

Docsets
#######

1 docsets will be installed:

- `Markdown <https://github.com/Kapeli/feeds/blob/master/Markdown.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    markdown:
        enabled: True

Environment
***********

No environment

Specific module settings
************************

No Specific settings.
