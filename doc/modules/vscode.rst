.. _module_vscode:

======
VSCode
======

.. image:: https://upload.wikimedia.org/wikipedia/commons/9/9a/Visual_Studio_Code_1.35_icon.svg
    :alt: VSCode
    :height: 250px

About
#####

This module installs additional extensions.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

xaver.theme-ysgrifennwr
***********************

`Ysgrifennwr <https://marketplace.visualstudio.com/items?itemName=xaver.theme-ysgrifennwr>`_
is a light color theme.

.. image:: https://github.com/xaverh/theme-ysgrifennwr/raw/master/screenshot.png
    :alt: Ysgrifennwr

.. note::

  This extension is installed but not set as the default theme.

yogipatel.solarized-light-no-bold
*********************************

`Solarized Light <https://marketplace.visualstudio.com/items?itemName=yogipatel.solarized-light-no-bold>`_
is a light color theme.

.. image:: https://github.com/yogipatel/vscode-solarized-light-no-bold/raw/master/screenshot.png
    :alt: Solarized Light

.. note::

  This extension is installed but not set as the default theme.

zhuangtongfa.Material-theme
***************************

`One Dark Pro <https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.Material-theme>`_
is a dark color theme.

.. image:: https://raw.githubusercontent.com/Binaryify/OneDark-Pro/master/static/screenshot2.png
    :alt: One Dark Pro

.. note::

  This extension is set as the default theme.

vscode-icons-team.vscode-icons
******************************

`vscode-icons <https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons>`_
brings icons to your Visual Studio Code.

.. image:: https://raw.githubusercontent.com/vscode-icons/vscode-icons/master/images/screenshot.gif
    :alt: One Dark Pro

alefragnani.Bookmarks
*********************

`Bookmarks <https://marketplace.visualstudio.com/items?itemName=alefragnani.Bookmarks>`_
is an extension created for Visual Studio Code. If you find it useful, please
consider supporting it.

.. image:: https://github.com/alefragnani/vscode-bookmarks/raw/master/images/bookmarks-toggle-labeled.gif
    :alt: Bookmarks

alefragnani.project-manager
***************************

`Project Manager <https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager>`_
helps you to easily access your projects, no matter where they are located.

.. image:: https://github.com/alefragnani/vscode-project-manager/raw/master/images/vscode-project-manager-side-bar.gif
    :alt: Project Manager

christian-kohler.path-intellisense
**********************************

`Path Intellisense <https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense>`_
is a plugin that autocompletes filenames.

.. image:: https://github.com/alefragnani/vscode-project-manager/raw/master/images/vscode-project-manager-side-bar.gif
    :alt: Path Intellisense

CoenraadS.bracket-pair-colorizer
********************************

`Bracket Pair Colorizer <https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer>`_
allows matching brackets to be identified with colours. The user can define
which characters to match, and which colours to use.

.. image:: https://github.com/CoenraadS/BracketPair/raw/master/images/activeScopeBackground.png
    :alt: Bracket Pair Colorizer

formulahendry.code-runner
*************************

`Code Runner <https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner>`_
can run code snippet or code file for multiple languages.

.. image:: https://github.com/formulahendry/vscode-code-runner/raw/master/images/usage.gif
    :alt: Code Runner

spmeesseman.vscode-taskexplorer
*******************************

`Task Explorer <https://marketplace.visualstudio.com/items?itemName=spmeesseman.vscode-taskexplorer>`_
allow to manage tasks for npm, vscode, ant, gradle, grunt, gulp, batch, bash,
make, python, perl, powershell, ruby, and nsis.

For more information about tasks,
`please read the documentation <https://code.visualstudio.com/docs/editor/tasks>`_.

.. image:: https://github.com/spmeesseman/vscode-taskexplorer/raw/master/res/taskview5.png?raw=true
    :alt: Code Runner

spywhere.guides
***************

`Guides <https://marketplace.visualstudio.com/items?itemName=spywhere.guides>`_
is simply an extension that add various indentation guide lines.

.. image:: https://github.com/spywhere/vscode-guides/raw/master/images/screenshot.png
    :alt: Guides

ybaumes.highlight-trailing-white-spaces
***************************************

`Highlight Trailing White Spaces <https://marketplace.visualstudio.com/items?itemName=ybaumes.highlight-trailing-white-spaces>`_
highlight in red color trailing white spaces.

.. image:: https://github.com/yifu/highlight-trailing-whitespaces/raw/master/illustration.gif
    :alt: Highlight Trailing White Spaces

Rubymaniac.vscode-paste-and-indent
**********************************

`Paste and Indent <https://marketplace.visualstudio.com/items?itemName=Rubymaniac.vscode-paste-and-indent>`_
adds limited support for pasting and indenting code.

Gruntfuggly.todo-tree
*********************

`Todo Tree <https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree>`_
quickly searches your workspace for comment tags like **TODO** and **FIXME**,
and displays them in a tree view in the explorer pane.

.. image:: https://raw.githubusercontent.com/Gruntfuggly/todo-tree/master/resources/screenshot.png
    :alt: Todo Tree

axosoft.gitkraken-glo
*********************

`GitKraken Glo <https://marketplace.visualstudio.com/items?itemName=axosoft.gitkraken-glo>`_
is an issue board for tracking issues and tasks.

.. image:: https://user-images.githubusercontent.com/899916/37066976-01877280-2165-11e8-87ff-d6b04e1d9ca5.png
    :alt: GitKraken Glo

VSCode settings
###############

VSCode settings configuration:

.. code-block:: yaml

    workbench.colorTheme: One Dark Pro
    workbench.iconTheme: vscode-icons
    vsicons.dontShowNewVersionMessage: True
    code-runner.respectShebang: False
    editor.renderIndentGuides: False
    window.titleBarStyle: custom
    window.menuBarVisibility: toggle
    workbench.colorCustomizations:
    '[Ysgrifennwr]':
        statusBar.background: '#edece8'
        statusBar.foreground: '#42424280'
    '[One Dark Pro]':
        editor.selectionHighlightBackground: '#ffffff10'
        editor.selectionHighlightBorder: '#ffffff10'
    todo-tree.customHighlight:
        TODO:
            icon: check
            fontWeight: 90
            foreground: white
            background: magenta
            opacity: 5
            iconColour: pink
        FIXME:
            icon: alert
            fontWeight: 900
            foreground: white
            background: yellow
            opacity: 50
            iconColour: yellow

VSCode keybindings
##################

VSCode keybindings configuration:

.. code-block:: yaml

    - key: alt+l
    command: bookmarks.toggle
    when: editorTextFocus

Software
########

No software.

Docsets
#######

No docsets.

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    vscode:
        enabled: True

Environment
***********

No environment.

Specific module settings
************************

No specific module settings.
