.. _module_conf_vscode:

======
vscode
======

Allow to manage `vscode <https://code.visualstudio.com>`_.

extensions
##########

``extensions`` allow to install some `VSCode extensions <https://marketplace.visualstudio.com/vscode>`_.

You need to specify the name of the extensions to install.

For each extensions you can specify the following arguments:

- ``enabled``: ``True`` to install or ``False`` to ignore
  (default to ``False``)
- ``version``: specify the version to install (default to ``null``). If
  ``null`` the latest version will be installed
- ``settings``: set `VSCode settings <https://code.visualstudio.com/docs/getstarted/settings>`_ only if this extension is enabled
- ``keybindings``: set `VSCode keybindings <https://code.visualstudio.com/docs/getstarted/keybindings>`_ only if this extension is enabled

Example to install ``python3`` extensions:

.. code-block:: yaml

    python3:
        enabled: True
        vscode:
            extensions:
                ms-python.python:
                    enabled: True
                    version: null
                VisualStudioExptTeam.vscodeintellicode:
                    enabled: True
                    version: null
                ms-pyright.pyright:
                    enabled: True
                    version: null
                    settings:
                    pyright.disableLanguageServices: True
                alefragnani.Bookmarks:
                    enabled: True
                    version: null
                    keybindings:
                       - key: alt+l
                        command: bookmarks.toggle
                        when: editorTextFocus

.. note::

    This is just an example and the extension ``alefragnani.Bookmarks`` is not
    set in the ``python3`` module.

settings
########

Add `VSCode settings <https://code.visualstudio.com/docs/getstarted/settings>`_
to VSCode.

.. image:: https://code.visualstudio.com/assets/docs/getstarted/settings/settings.png
    :alt: setting

You need to specify the name of the settings and their values:

Simple example with ``python3``:

.. code-block:: yaml+jinja

    python3:
        enabled: True
        vscode:
            settings:
                code-runner.executorMap.python: $pythonPath -u $fullFileName
                python.linting.pylintEnabled: False
                python.linting.flake8Enabled: True
                python.linting.flake8Args:
                    - --max-line-length=88
                python.linting.enabled: True
                python.jediEnabled: False
                python.autoComplete.addBrackets: True
                python.formatting.provider: black
                python.workspaceSymbols.ctagsPath: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'ctags', 'current', 'ctags.exe') }}

.. note::

    You can also interact directly with saltstack like it is the case with the
    ``python.workspaceSymbols.ctagsPath`` setting.

    Note that custom grains are set in the
    ``<install_dir>/conf/saltstack/conf/grains`` file.

keybindings
###########

Add `VSCode keybindings <https://code.visualstudio.com/docs/getstarted/keybindings>`_
to VSCode.

.. image:: https://code.visualstudio.com/assets/docs/getstarted/keybinding/keyboard-shortcuts.gif
    :alt: keybindings

Keybinds is an array with the followings values:

- **key**: a key that describes the pressed keys
- **command** a command containing the identifier of the command to execute
- **when**: an optional when clause containing a boolean expression that will
  be evaluated depending on the current context

Simple example with ``python3``:

.. code-block:: yaml

    python3:
        enabled: True
        vscode:
            keybindings:
                alefragnani.Bookmarks:
                    enabled: True
                    version: null
                    keybindings:
                      - key: alt+l
                        command: bookmarks.toggle
                        when: editorTextFocus

.. note::

    This is just an example and no keybindings are set inside the ``python3``
    module.
