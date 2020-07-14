# vscode settings

Allow managing [vscode](https://code.visualstudio.com/).

## extensions

`extensions` allow to manage the [VSCode extensions](https://marketplace.visualstudio.com/vscode).

![](https://code.visualstudio.com/assets/docs/editor/extension-gallery/extensions-popular.png)

You need to specify the name of the extensions to install.

For each extension you can specify the following arguments:

* `enabled`: `True` to install or `False` to ignore \(default to `False`\)
* `version`: specify the version to install \(default to `null`\). If `null` the latest version will be installed
* `settings`: set [VSCode settings](https://code.visualstudio.com/docs/getstarted/settings) only if this extension is enabled
* `keybindings`: set [VSCode keybindings](https://code.visualstudio.com/docs/getstarted/keybindings) only if this extension is enabled

Simple example, in the [vscode-anywhere.sls](../../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file to ask to install `settings` in the `python3` module  with the `extensions` `ms-pyright.pyrighr` and `keybindings` with the extension `alefragnani.Bookmarks`:

```yaml
vscode-anywhere:
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
```

{% hint style="warning" %}
If the 2 extensions `ms-pyright.pyrighr` and `alefragnani.Bookmarks` are set to `enabled: False` then no keybindings or settings will be applied. But reverts the value from `True` to `False` will not remove the settings or keybindings already applied.
{% endhint %}

## settings

Manage [VSCode settings](https://code.visualstudio.com/docs/getstarted/settings) in VSCode.

![](https://code.visualstudio.com/assets/docs/getstarted/settings/settings.png)

You need to specify the name of the settings and their values.

A simple example to set `settings` globally for the `python3` module:

```yaml
vscode-anywhere:
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
```

{% hint style="info" %}
In this example, jinja is used for `python.workspaceSymbols.ctagsPath`.

Custom grains are set inside the [grains](../../../structure/conf/saltstack/conf.md#grains) file.
{% endhint %}

## keybindings

Manage [VSCode keybindings](https://code.visualstudio.com/docs/getstarted/keybindings) in VSCode.

![](https://code.visualstudio.com/assets/docs/getstarted/keybinding/keyboard-shortcuts.gif)

Keybinds is an array with the followings values:

* **key**: a key that describes the pressed keys
* **command** a command containing the identifier of the command to execute
* **when**: an optional when clause containing a boolean expression that will be evaluated depending on the current context

A simple example to set `keybindings` globally for the `python3` module:

```yaml
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
```

{% hint style="info" %}
This is just an illustrative example and no keybindings are set inside the `python3` module.
{% endhint %}

