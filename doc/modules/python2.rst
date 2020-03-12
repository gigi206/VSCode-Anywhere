.. _module_python2:

========
Python 2
========

.. image:: https://www.python.org/static/img/python-logo@2x.png
    :alt: Python
    :height: 250px

About
#####

`Python <https://www.python.org>`__ is a programming language that lets you
work more quickly and integrate your systems more effectively.

Use case
########

Open a shell (powershell for Windows or bash for Linux and MacOS).

Note that after executing the precedure below, the VSCode terminal will also
have good environment.

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

    Note that in the following examples ``VSCode-Anywhere`` can also be replaced
    by ``<installation_directory>\tools\vscode.ps1``.

Use case VSCode settings
************************

Please read the `environment documentation <https://code.visualstudio.com/docs/python/environments>`_.

By default, the Python extension looks for and loads a file named ``.env`` in
the current workspace folder, then applies those definitions.
The file is identified by the default entry
``"python.envFile": "${workspaceFolder}/.env``.

And you can also interact with your environment with the VSCode settings
``.vscode/settings.json``:

- ``python.envFile``: Absolute path to a file containing environment variable
  definitions
- ``python.venvPath``: Path to folder with a list of Virtual Environments
- ``python.venvFolders``: Folders in your home directory to look into for
  virtual environments (supports pyenv, direnv and virtualenvwrapper by
  default)

And also use environment variable (you can set these variables directly in your
``python.envFile``:

- ``WORKON_HOME``: used by ``virtualenvwrapper`` and ``pipenv``
- ``PYTHONPATH``: specifies additional locations where the Python interpreter
  should look for modules

Use case with virtualenv
*************************

If you want to test directly your ``virtualenv`` without configure your
settings:

.. code-block:: powershell

    cd <path_to_your_project>
    . <installation_directory>\tools\env.ps1
    .\<env>\bin\activate
    VSCode-Anywhere .

.. note::

    After that you must select the good python interpreter. Press F1 and type:

    .. code-block::

        > Python Select Interpreter

    .. image:: https://code.visualstudio.com/assets/docs/python/environments/select-interpreters-command.png
        :alt: Python Select Interpreter

    And select the right interpreter (virtualenv) from the list provided.

Use case with pipenv
********************

If you want to test directly your ``pipenv`` without configure your
settings:

.. code-block:: powershell

    cd <path_to_your_project>
    . C:\VSCode-Anywhere\tools\env.ps1
    pipenv shell
    VSCode-Anywhere .

.. note::

    After that you must select the good python interpreter. Press F1 and type:

    .. code-block::

        > Python Select Interpreter

    .. image:: https://code.visualstudio.com/assets/docs/python/environments/select-interpreters-command.png
        :alt: Python Select Interpreter

    And select the right interpreter (virtualenv) from the list provided.

Use case with poetry
********************

If you want to test directly your ``poetry`` without configure your
settings:

.. code-block:: powershell

    cd <path_to_your_project>
    . C:\VSCode-Anywhere\tools\env.ps1
    poetry shell
    VSCode-Anywhere .

.. note::

    After that you must select the good python interpreter. Press F1 and type:

    .. code-block::

        > Python Select Interpreter

    .. image:: https://code.visualstudio.com/assets/docs/python/environments/select-interpreters-command.png
        :alt: Python Select Interpreter

    And select the right interpreter (virtualenv) from the list provided.

Use case with anaconda
**********************

Please read:

- the `VSCode documentation for anaconda <https://code.visualstudio.com/docs/python/environments#_conda-environments>`_
- the `VSCode documentation for Jupyter Notebook <https://code.visualstudio.com/docs/python/jupyter-support>`_
- the `VSCode documentation for Interactive Python (IPython) <https://code.visualstudio.com/docs/python/jupyter-support-py>`_

To enable conda, just set ``anaconda`` to ``True`` in the VSCode-Anywhere
settings:

.. code-block:: yaml

    python2:
        enabled: True
        anaconda: True

.. note::

    This is recommended method for the data sciences and with the use of
    Jupyter.

    .. image:: https://code.visualstudio.com/assets/docs/python/jupyter/plot-viewer.gif
        :alt: Jupyter

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

For more details read the `official documentation <https://code.visualstudio.com/docs/languages/python>`_.

ms-python.python
****************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-python.python>`__
provides a rich support for the Python language (2.7 only), including features
such as IntelliSense, linting, debugging, code navigation, code formatting,
Jupyter notebook support, refactoring, variable explorer, test explorer,
snippets, and more!

.. image:: https://raw.githubusercontent.com/microsoft/vscode-python/master/images/ConfigureTests.gif
    :alt: Python debugger

VisualStudioExptTeam.vscodeintellicode
**************************************

This `extension <https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode>`__
provides AI-assisted development features for Python.

.. image:: https://docs.microsoft.com/en-us/visualstudio/intellicode/media/python-intellicode.gif
    :alt: Python IntelliSense

.. note::

    With the ``windows_portable`` profile this extension will not be installed.

ms-pyright.pyright
******************

This `extension <https://marketplace.visualstudio.com/items?itemName=ms-pyright.pyright>`__
is a fast type checker meant for large Python source bases. It can run in a
*watch* mode and performs fast incremental updates when files are modified.

kevinrose.vsc-python-indent
***************************

This `extension <https://marketplace.visualstudio.com/items?itemName=kevinrose.vsc-python-indent>`__
corrects Python indentation in Visual Studio Code.

.. image:: https://github.com/kbrose/vsc-python-indent/raw/master/static/demo.gif
    :alt: Python indent

tushortz.python-extended-snippets
*********************************

`Python Extended <https://marketplace.visualstudio.com/items?itemName=tushortz.python-extended-snippets>`_
is a vscode snippet that makes it easy to write codes in python by providing
completion options along with all arguments.

.. image:: https://raw.githubusercontent.com/tushortz/vscode-Python-Extended/master/images/preview.gif
    :alt: Python Extended snippets

littlefoxteam.vscode-python-test-adapter
****************************************

This `extension <littlefoxteam.vscode-python-test-adapter>`__ allows you to run
your Python `Unittest <https://docs.python.org/3/library/unittest.html#module-unittest>`_
or `Pytest <https://docs.pytest.org/en/latest/>`__.

.. image:: https://github.com/kondratyev-nv/vscode-python-test-adapter/raw/master/img/screenshot.png
    :alt: Python tests

.. note::

    VSCode-Anywhere installs python modules ``nose``, ``pytest`` and configure
    ``pytest`` to the default test adapter. ``unittest`` is a builtin python
    module.

VSCode settings
###############

VSCode settings configuration for Python 2.

Global settings
***************

.. code-block:: json

    {
        "code-runner.executorMap.python": "$pythonPath -u $fullFileName",
        "python.linting.pylintEnabled": false,
        "python.linting.flake8Enabled": true,
        "python.linting.enabled": true,
        "python.jediEnabled": false,
        "python.autoComplete.addBrackets": true,
        "python.testing.pytestEnabled": true,
        "pyright.disableLanguageServices": true
    }

Windows settings
****************

If the profile is set to ``windows_admin`` or ``windows_user``:

.. code-block:: json

    {
        "pyright.disableLanguageServices": true,
        "python.autoComplete.addBrackets": true,
        "python.formatting.autopep8Path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python27\\current\\Scripts\\autopep8.exe",
        "python.formatting.provider": "autopep8",
        "python.jediEnabled": false,
        "python.linting.enabled": true,
        "python.linting.flake8Args": [
            "--max-line-length=88"
        ],
        "python.linting.flake8Enabled": true,
        "python.linting.flake8Path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python27\\current\\Scripts\\flake8.exe",
        "python.linting.pylintEnabled": false,
        "python.pipenvPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python27\\current\\Scripts\\pipenv.exe",
        "python.poetryPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python27\\current\\Scripts\\poetry.exe",
        "python.pythonPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python27\\current\\python.exe",
        "python.testing.nosetestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python27\\current\\Scripts\\nosetests.exe",
        "python.testing.pytestEnabled": true,
        "python.testing.pytestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python27\\current\\Scripts\\pytest.exe",
        "python.workspaceSymbols.ctagsPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\ctags\\current\\ctags.exe",
        "code-runner.executorMap.python": "$pythonPath -u $fullFileName"
    }

If ``anaconda`` is set to ``True``, the followings settings will change:

.. code-block:: json

    {
        "python.condaPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\conda.exe",
        "python.formatting.blackPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\black.exe",
        "python.linting.flake8Path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\flake8.exe",
        "python.pipenvPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\pipenv.exe",
        "python.poetryPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\poetry.exe",
        "python.pythonPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\python.exe",
        "python.testing.nosetestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\nosetests.exe",
        "python.testing.pytestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\pytest.exe",
    }

If the profile is set to ``windows_portable``:

.. code-block:: json

    {
        "pyright.disableLanguageServices": true,
        "python.autoComplete.addBrackets": true,
        "python.formatting.autopep8Path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\autopep8",
        "python.formatting.provider": "black",
        "python.jediEnabled": false,
        "python.linting.enabled": true,
        "python.linting.flake8Args": [
            "--max-line-length=88"
        ],
        "python.linting.flake8Enabled": true,
        "python.linting.flake8Path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\flake8",
        "python.linting.pylintEnabled": false,
        "python.pipenvPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\pipenv",
        "python.poetryPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\poetry",
        "python.pythonPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\python",
        "python.testing.nosetestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\nosetests",
        "python.testing.pytestEnabled": true,
        "python.testing.pytestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\pytest",
        "python.workspaceSymbols.ctagsPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\ctags",
        "code-runner.executorMap.python": "$pythonPath -u $fullFileName"
    }

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

    All settings will be replaced by those of ``python3`` if it is enabled in
    the settings because they share the same parameters.

Software
########

Windows software
****************

scoop
=====

- `python27 <https://github.com/ScoopInstaller/Versions/blob/master/bucket/python27.json>`_
- `ctags <https://github.com/ScoopInstaller/Main/blob/master/bucket/ctags.json>`_
- `anaconda2 <https://github.com/ScoopInstaller/Versions/blob/master/bucket/anaconda2.json>`_

msys2
=====

The following packages will be installed only if the profile is set to
``windows_portable``:

- `python2 <https://packages.msys2.org/package/python2?repo=msys&variant=x86_64>`_
- `python2-pip <https://packages.msys2.org/package/python2-pip?repo=msys&variant=x86_64>`_
- `gcc <https://packages.msys2.org/package/gcc?repo=msys&variant=x86_64>`_
- `libcrypt-devel <https://packages.msys2.org/package/libcrypt-devel?repo=msys&variant=x86_64>`_

Docsets
#######

2 docsets will be installed:

- `Python_2 <https://github.com/Kapeli/feeds/blob/master/Python_2.xml>`__
- `PEPs <https://github.com/hashhar/dash-contrib-docset-feeds/blob/master/PEPs.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    python2:
        enabled: True

Environment
***********

Windows environment
*******************

- Default environment:

.. code-block:: yaml

    python2:
        env:
            PATH: C:\VSCode-Anywhere\apps\scoop\apps\python27\current\Scripts

- The following environment will be overriden if ``anaconda`` in set to
  ``True`` in the settings:

.. code-block:: yaml

    python2:
        env:
            PATH: C:\VSCode-Anywhere\apps\scoop\apps\python27\current\Scripts;C:\VSCode-Anywhere\apps\scoop\apps\anaconda2\current;C:\VSCode-Anywhere\apps\scoop\apps\anaconda2\current\Library\mingw-w64\bin;C:\VSCode-Anywhere\apps\scoop\apps\anaconda2\current\Library\usr\bin;C:\VSCode-Anywhere\apps\scoop\apps\anaconda2\current\Library\bin;C:\VSCode-Anywhere\apps\scoop\apps\anaconda3\current\Library\Scripts

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Specific module settings
************************

anaconda
========

If set to ``True``, it will install additional components for
`anaconda <https://www.anaconda.com>`_:

.. code-block:: yaml

    python2:
        enabled: True
        anaconda: True

pip
===

`pip <https://pypi.org>`_ is used to install some Python packages.

The following python packages will be installed:

- `rope <https://pypi.org/project/rope/>`_
- `flake8 <https://pypi.org/project/flake8/>`_
- `autopep8 <https://pypi.org/project/autopep8/>`_
- `ptvsd <https://pypi.org/project/ptvsd/>`_
- `nose <https://pypi.org/project/nose/>`_
- `pytest <https://pypi.org/project/pytest/>`__
- `pytest-xdist <https://pypi.org/project/pytest-xdist/>`_
- `poetry <https://pypi.org/project/poetry/>`_
- `pytest-xdist <https://pypi.org/project/pytest-xdist/>`_
- `jupyterlab <https://pypi.org/project/pipenv/>`_

.. note::

    ``jupyterlab`` will not be installed if ``anaconda`` is set to ``True``
    (because this package is already included in ``anaconda3``) or if the
    installation profile is defined to ``windows_portable``.

.. code-block:: yaml

    python2:
        enabled: True
        pip:
            pkgs:
                rope:
                    enabled: True
                flake8:
                    enabled: True
                autopep8:
                    enabled: True
                ptvsd:
                    enabled: True
                nose:
                    enabled: True
                pytest:
                    enabled: True


You can also specify a specific version :

.. code-block:: yaml

    pip:
        pkgs:
            nose:
                enabled: True
                version: '== 1.3.7'
            django:
                enabled: True
                version: '>= 2.1, <= 2.2, != 2.1.10'

You can use advanced pip options:

.. code-block:: yaml+jinja

    python2:
        enabled: True
        pip:
            opts:
                global:
                    bin_env: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'python27', 'current', 'Scripts', 'pip.exe') }}
                install:
                    upgrade: False
                update:
                    upgrade: True
                uninstall: {}
            pkgs:
                django:
                    enabled: True
                    version: '>= 2.1, <= 2.2, != 2.1.10'
                    opts:
                        install: {}
                        update: {}
                        uninstall: {}

pip options:

- ``pip.opts.global``: `pip options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html>`__
    used to install, update and delete a pip module
- ``pip.opts.install``: `pip.installed options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.installed>`__
    used to install a pip module
- ``pip.opts.update``: `pip.installed options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.installed>`__
    is used to update a pip module
- ``pip.opts.uninstall``: `pip.removed options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.removed>`__
    used to delete a pip module
- ``pip.pkgs.<module_name>.opts.install``: same thing as ``pip.opts.install``
  but only apply for the target module
- ``pip.pkgs.<module_name>.opts.update``: same thing as ``pip.opts.update``
  but only apply for the target module
- ``pip.pkgs.<module_name>.opts.uninstall``: same thing as
  ``pip.opts.uninstall`` but only apply for the target module
- ``pip.pkgs.<module_name>.version``: specify the version to install
- ``pip.pkgs.<module_name>.enabled``: specify if the target module must be
  installed

.. note::

    When you specify a package version, you must respect the
    `pip syntax <https://docs.python.org/2/installing/index.html>`_.

    Also, don't add the ``name`` option because it is already set!
