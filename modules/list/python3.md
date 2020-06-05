# Python3



![](https://www.python.org/static/img/python-logo@2x.png)

## About

[Python](https://www.python.org/) is a programming language that lets you work more quickly and integrate your systems more effectively.

## Installation

Change `enable` from `False` to `True` in the `python3` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    python3:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere python3 module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/python3/defaults.yaml).
{% endhint %}

For more details read the [official documentation](https://code.visualstudio.com/docs/languages/python).

## Requirements

No requirements.

## VSCode

### Additionnal informations

Please read the [environment documentation](https://code.visualstudio.com/docs/python/environments).

By default, the Python extension looks for and loads a file named `.env` in the current workspace folder, then applies those definitions. The file is identified by the default entry `"python.envFile": "${workspaceFolder}/.env`.

And you can also interact with your environment with the VSCode settings `.vscode/settings.json`:

* `python.envFile`: Absolute path to a file containing environment variable definitions
* `python.venvPath`: Path to folder with a list of Virtual Environments
* `python.venvFolders`: Folders in your home directory to look into for virtual environments \(supports pyenv, direnv and virtualenvwrapper by default\)

And also use environment variable \(you can set these variables directly in your `python.envFile`:

* `WORKON_HOME`: used by `virtualenvwrapper` and `pipenv`
* `PYTHONPATH`: specifies additional locations where the Python interpreter should look for modules

#### virtualenv

If you want to test directly your `virtualenv` without configure your settings:

```text
cd <path_to_your_project>
. <installation_directory>\tools\env.ps1
.\<env>\bin\activate
VSCode-Anywhere .
```

After that you must select the good python interpreter. Press F1 and type:

```text
> Python Select Interpreter
```

![](https://code.visualstudio.com/assets/docs/python/environments/select-interpreters-command.png)

And select the right interpreter \(virtualenv\) from the list provided.

#### pipenv

If you want to test directly your `pipenv` without configure your settings:

```text
cd <path_to_your_project>
. C:\VSCode-Anywhere\tools\env.ps1
pipenv shell
VSCode-Anywhere .
```

After that you must select the good python interpreter. Press F1 and type:

```text
> Python Select Interpreter
```

And select the right interpreter from the list provided.

#### poetry

If you want to test directly your `poetry` without configure your settings:

```text
cd <path_to_your_project>
. C:\VSCode-Anywhere\tools\env.ps1
poetry shell
VSCode-Anywhere .
```

After that you must select the good python interpreter. Press F1 and type:

```text
> Python Select Interpreter
```

And select the right interpreter from the list provided.

#### anaconda

Please read the specific settings at the bottom of the page.

### VSCode extensions

#### ms-python.python

This [extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) provides a rich support for the [Python language](https://www.python.org/) \(for all [actively supported versions](https://devguide.python.org/#status-of-python-branches) of the language: 2.7, &gt;=3.5\), including features such as IntelliSense, linting, debugging, code navigation, code formatting, Jupyter notebook support, refactoring, variable explorer, test explorer, snippets, and more!

![](https://raw.githubusercontent.com/microsoft/vscode-python/master/images/ConfigureTests.gif)

#### VisualStudioExptTeam.vscodeintellicode

This [extension](https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode) provides AI-assisted development features for Python.

![](https://docs.microsoft.com/en-us/visualstudio/intellicode/media/python-intellicode.gif)

{% hint style="info" %}
With the `windows_portable` [profile](../../install/advanced/windows-installation.md#profiles) this extension will not be installed.
{% endhint %}

#### ms-pyright.pyright

This [extension](https://marketplace.visualstudio.com/items?itemName=ms-pyright.pyright) is a fast type checker meant for large Python source bases. It can run in a _watch_ mode and performs fast incremental updates when files are modified.

#### kevinrose.vsc-python-indent

This [extension](https://marketplace.visualstudio.com/items?itemName=kevinrose.vsc-python-indent) corrects Python indentation in Visual Studio Code.

![](https://github.com/kbrose/vsc-python-indent/raw/master/static/demo.gif)

#### littlefoxteam.vscode-python-test-adapter

This [extension](https://vscode-anywhere.readthedocs.io/en/dev/modules/littlefoxteam.vscode-python-test-adapter) allows you to run your Python [Unittest](https://docs.python.org/3/library/unittest.html#module-unittest) or [Pytest](https://docs.pytest.org/en/latest/).

![](https://github.com/kondratyev-nv/vscode-python-test-adapter/raw/master/img/screenshot.png)

{% hint style="info" %}
VSCode-Anywhere installs python modules `nose`, `pytest` and configure `pytest` to the default test adapter. `unittest` is a builtin python module.
{% endhint %}

### VSCode settings

#### Global settings

```javascript
{
  "pyright.disableLanguageServices": True,
  "python.testing.pytestEnabled": True,
  "code-runner.executorMap.python": "$pythonPath -u $fullFileName",
  "python.linting.pylintEnabled": False,
  "python.linting.flake8Enabled": True,
  "python.linting.flake8Args": [
    "--max-line-length=88"
  ],
  "python.linting.enabled": True,
  "python.jediEnabled": False,
  "python.autoComplete.addBrackets": True,
  "python.formatting.provider": "black",
  "dash.languageIdToDocsetMap.python": [
    "python3",
    "django",
    "twisted",
    "sphinx",
    "flask",
    "tornado",
    "sqlalchemy",
    "numpy",
    "scipy",
    "salt",
    "pandas",
    "matplotlib",
    "cvp"
  ]
}
```

#### Windows settings

```javascript
{
    "python.workspaceSymbols.ctagsPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\scoop\\apps\\ctags\\current\\ctags.exe"
}
```

If `anaconda` is set to `True`:

```javascript
{
    "python.condaPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\conda.exe",
    "python.pythonPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\python.exe",
    "python.formatting.blackPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\black.exe",
    "python.poetryPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\poetry.exe",
    "python.linting.flake8Path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\flake8.exe",
    "python.testing.nosetestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\nosetests.exe",
    "python.testing.pytestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\pytest.exe",
    "python.pipenvPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\anaconda3\\current\\Scripts\\pipenv.exe"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

If `anaconda` is set to `False`:

```javascript
{
    "python.pythonPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python\\current\\python.exe",,
    "python.formatting.blackPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python\\current\\Scripts\\black.exe",
    "python.poetryPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python\\current\\Scripts\\poetry.exe",
    "python.linting.flake8Path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python\\current\\Scripts\\flake8.exe",
    "python.testing.nosetestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python\\current\\Scripts\\nosetests.exe",
    "python.testing.pytestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python\\current\\Scripts\\pytest.exe",
    "python.pipenvPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\python\\current\\Scripts\\pipenv.exe"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

If [profile](../../install/advanced/windows-installation.md#profiles) is set to `windows_portable`:

```javascript
{
      "python.jediEnabled": true,
      "python.pythonPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\python3",
      "python.formatting.blackPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\black",
      "python.poetryPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\poetry",
      "python.pipenvPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\pipenv",
      "python.linting.flake8Path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\flake8",
      "python.testing.nosetestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\nose",
      "python.testing.pytestPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\usr\\bin\\pytest"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

### Linux Settings

```javascript
{
    "python.workspaceSymbols.ctagsPath": "/home/linuxbrew/.linuxbrew/bin/ctags"
}
```

If `anaconda` is set to `True`:

```javascript
{
    'pythonPath': '/home/linuxbrew/.linuxbrew/opt/anaconda3/bin/python3',
    'autopep8Path': '/home/linuxbrew/.linuxbrew/opt/anaconda3/bin/autopep8',
    'poetryPath': '/home/linuxbrew/.linuxbrew/opt/anaconda3/bin/poetry',
    'flake8Path': '/home/linuxbrew/.linuxbrew/opt/anaconda3/bin/flake8',
    'nosetestPath': '/home/linuxbrew/.linuxbrew/opt/anaconda3/bin/nosetests',
    'pytestPath': '/home/linuxbrew/.linuxbrew/opt/anaconda3/bin/pytest',
    'pipenvPath': '/home/linuxbrew/.linuxbrew/opt/anaconda3/bin/pipenv',
    'python.condaPath': '/home/linuxbrew/.linuxbrew/opt/anaconda3/conda'
}
```

If `anaconda` is set to `False`:

```javascript
{
    'pythonPath': '/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.nix-profile/bin/python3',
    'autopep8Path': '/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.nix-profile/bin/autopep8',
    'poetryPath': '/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.nix-profile/bin/poetry',
    'flake8Path': '/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.nix-profile/bin/flake8',
    'nosetestPath': '/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.nix-profile/bin/nosetests',
    'pytestPath': '/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.local/bin/pytest',
    'pipenvPath': '/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.local/bin/pipenv'
}
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

#### scoop

* [python](https://github.com/ScoopInstaller/Main/blob/master/bucket/python.json) \(will not be installed with the `windows_portable`  [profile](../../install/advanced/windows-installation.md#profiles)\)
* [ctags](https://github.com/lukesampson/scoop-extras/blob/master/bucket/anaconda3.json)
* [anaconda3](https://github.com/lukesampson/scoop-extras/blob/master/bucket/anaconda3.json) \(will be installed if `anaconda` is set to `true`\)

#### msys2

The following packages will be installed only if the profile is set to `windows_portable`  [profile](../../install/advanced/windows-installation.md#profiles):

* [python3](https://packages.msys2.org/package/python3?repo=msys&variant=x86_64)
* [python3-pip](https://packages.msys2.org/package/python3-pip?repo=msys&variant=x86_64)
* [gcc](https://packages.msys2.org/package/gcc?repo=msys&variant=x86_64)
* [libcrypt-devel](https://packages.msys2.org/package/libcrypt-devel?repo=msys&variant=x86_64)

### Linux software

#### brew

* [python](https://formulae.brew.sh/formula/python)
* [ctags](https://formulae.brew.sh/formula/ctags)
* anaconda3 \(custom formulae + only if `anaconda` is set to `True`\)

## Documentation

* [Python\_3](https://github.com/Kapeli/feeds/blob/master/Python_3.xml)
* [PEPs](https://github.com/hashhar/dash-contrib-docset-feeds/blob/master/PEPs.xml)

### Environment

#### Windows environment

```yaml
PATH: C:\VSCode-Anywhere\apps\scoop\apps\python\current\Scripts
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

If `anaconda` is set to `True`:

```yaml
PATH: C:\VSCode-Anywhere\apps\scoop\apps\python\current\Scripts;C:\VSCode-Anywhere\apps\anaconda3\current:C:\VSCode-Anywhere\apps\anaconda3\current\Library\mingw-64\bin:C:\VSCode-Anywhere\apps\anaconda3\current\Library\usr\bin::C:\VSCode-Anywhere\apps\anaconda3\current\Library\bin::C:\VSCode-Anywhere\apps\anaconda3\current\Library\Scripts
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux environment

```yaml
PATH: /home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.local/bin
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

If `anaconda` is set to `True`:

```yaml
PATH: /home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.local/bin:/home/linuxbrew/.linuxbrew/opt/anaconda3/bin
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

### Specific settings

#### anaconda

Allow to install [anaconda](http://anaconda.com):

```yaml
vscode-anywhere:
  python3:
    enabled: True
    enaconda: True
```

Please read:

* the [VSCode documentation for anaconda](https://code.visualstudio.com/docs/python/environments#_conda-environments)
* the [VSCode documentation for Jupyter Notebook](https://code.visualstudio.com/docs/python/jupyter-support)
* the [VSCode documentation for Interactive Python \(IPython\)](https://code.visualstudio.com/docs/python/jupyter-support-py)

This is recommended method for the data sciences and with the use of [Jupyter](https://jupyter.org).

![](https://code.visualstudio.com/assets/docs/python/jupyter/plot-viewer.gif)

#### anaconda\_update

Update all [anaconda](http://anaconda.com) modules:

```yaml
vscode-anywhere:
  python3:
    enabled: True
    enaconda: True
    enaconda_update: True
```

{% hint style="info" %}
Requires that `anaconda` be set to `True`.
{% endhint %}

#### pip

Allow to install packages with [pip](https://pypi.org).



* **`pkgs`**: name of the packages to install
  * `enabled`: `True` to `enable`, `False` to skip \(default to `False`\)
  * `version`: version of the pip package



* **`opts`**

`opts` is not mandatory but allows to pass additional arguments.

Extra args can be arguments described in the [saltstack pip states](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html) or can be [global saltstack arguments](https://docs.saltstack.com/en/latest/ref/states/requisites.html).



Global `opts` packages settings:

* `pip:pkgs:opts:global`: allow to pass arguments **to all pip packages** when **installing**, **updating**, or **uninstalling** a package
*  `pm:pkgs:opts:install`: allow to pass arguments **to all pip packages** when **installing** a package \(cf [states.pip.installed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.installed)\)
* `pip:pkgs:opts:update`: allow to pass arguments **to all pip packages** when **updating** a package \(cf [states.pip.installed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.installed)\)
* `pip:pkgs:opts:uninstall`: allow to pass arguments **to all pip packages** when **uninstatalling** a package \(cf [states.pip.removed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.removed)\)



Specific `opts` packages settings:

* `pip:<mypkg>:opts:global`: allow to pass arguments **to** `<mypkg>` **pip package** when **installing**, **updating**, or **uninstalling** the package
*  `pip:pkgs:<mypkg>:opts:install`: allow to pass arguments **to** `<mypkg>` **pip packages** when **installing** the package \(cf [states.pip.installed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.installed)\)
* `pip:pkgs:<mypkg>:opts:update`: allow to pass arguments **to** `<mypkg>` **pip packages** when **updating** the package \(cf [states.pip.installed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.installed)\)
* `pip:pkgs:<mypkg>:opts:uninstall`: allow to pass arguments **to all pip packages** when **uninstatalling** a package \(cf [states.pip.removed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.pip_state.html#salt.states.pip_state.removed)\)

{% hint style="info" %}
Replace `<mypkg>` by the name of the package to install.
{% endhint %}



* global:

```yaml
vscode-anywhere:
  python3:
    enabled: True
      pip:
        opts:
          install:
            upgrade: False
          update:
            upgrade: True
          uninstall: {}
        pkgs:
          rope:
            enabled: True
            version: null
            opts:
              install: {}
              update: {}
              uninstall: {}
          flake8:
            enabled: True
            version: null
            opts:
              install: {}
              update: {}
              uninstall: {}
          black:
            enabled: True
            version: '>= 19.10b0'
            opts:
              install: {}
              update: {}
              uninstall: {}
          ptvsd:
            enabled: True
            version: null
            opts:
              install: {}
              update: {}
              uninstall: {}
          nose:
            enabled: True
            version: null
            opts:
              install: {}
              update: {}
              uninstall: {}
          pytest:
            enabled: True
            version: null
            opts:
              install: {}
              update: {}
              uninstall: {}
          pytest-xdist:
            enabled: True
            version: null
            opts:
              install: {}
              update: {}
              uninstall: {}
          poetry:
            enabled: True
            version: null
            opts:
              install: {}
              update: {}
              uninstall: {}
          pipenv:
            enabled: True
            version: null
            opts:
              install: {}
              update: {}
              uninstall: {}
    
```

* Windows:

If `anaconda` is set to `True`:

```yaml
vscode-anywhere:
  python3:
    enabled: True
    pip:
      opts:
        global:
          bin_env: C:\VSCode-Anywhere\apps\scoop\apps\python\current\Scripts\pip.exe
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

If `anaconda` is set to `False`:

```yaml
vscode-anywhere:
  python3:
    enabled: True
    pip:
      opts:
        global:
          bin_env: C:\VSCode-Anywhere\apps\scoop\apps\anaconda3\current\Scripts\pip.exe
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

If [profile](../../install/advanced/windows-installation.md#profiles) is set to `windows_portable`:

```yaml
vscode-anywhere:
  python3:
    enabled: True
    pip:
      opts:
        global:
          bin_env: C:\VSCode-Anywhere\apps\scoop\apps\msys2\current\usr\bin\pip3
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

* Linux:

```yaml
vscode-anywhere:
  python3:
    enabled: True
    pip:
      pkgs:
        setuptools:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
        rope:
          enabled: False
        flake8:
          enabled: False
        autopep8:
          enabled: False
        nose:
          enabled: False
        peotry:
          enabled: False
```

If `anaconda` is set to `True`:

```yaml
vscode-anywhere:
  python3:
    enabled: True
    pip:
      opts:
        global:
          bin_env: /home/myuser/VSCode-Anywhere/apps/vscode-anywhere/home/.nix-profile/bin/pip2
          env_vars:
            PYTHONPATH: ''
          target: /home/myuser/VSCode-Anywhere/apps/vscode-anywhere/python3
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

If `anaconda` is set to `False`:

```yaml
vscode-anywhere:
  python3:
    enabled: True
    pip:
      opts:
        global:
          bin_env: /home/linuxbrew/.linuxbrew/opt/anaconda3/bin/pip
```

