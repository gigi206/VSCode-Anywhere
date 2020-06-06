---
description: RST
---

# ReStructuredText

## About

[reStructuredText](https://docutils.readthedocs.io/en/sphinx-docs/user/rst/quickstart.html) is a file format for textual data used primarily in the Python programming language community for technical documentation.

## Installation

Change `enable` from `False` to `True` in the `restructuredtext` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    restructuredtext:
        enabled: True
    python3:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere restructuredtext module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/restructuredtext/defaults.yaml).
{% endhint %}

## Requirements

This module requires to have the [p](python2.md#installation)[ython3](python3.md#installation) module enabled.

## VSCode

### VSCode extensions

#### lextudio.restructuredtext

This [extension](https://marketplace.visualstudio.com/items?itemName=lextudio.restructuredtext) provides rich reStructuredText language support for Visual Studio Code. Now you write reStructuredText scripts using the excellent IDE-like interface that VS Code provides.

![](https://github.com/vscode-restructuredtext/vscode-restructuredtext/raw/master/images/main.gif)

### VSCode settings

No [settings](https://code.visualstudio.com/docs/getstarted/settings).

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

No software.

## Documentation

No documentation.

## VSCode-Anywhere

### Environment

No environment.

### Specific settings

#### pip

Same pip settings usage as [python3](python3.md#pip).

* Global:

```yaml
vscode-anywhere:
  restructuredtext:
    enabled: True
    pip:
      opts:
        global: {}
        install:
          upgrade: False
        update:
          upgrade: True
        uninstall: {}
      pkgs:
        docutils:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
        sphinx:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
        sphinx-autobuild:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
        doc8:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
```

* Windows:

```yaml
vscode-anywhere:
  restructuredtext:
    enabled: True
    pip:
      opts:
        global:
          bin_env: C:\VSCode-Anywhere\apps\scoop\apps\python\current\Scripts\pip.exe
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

* Linux:

```yaml
vscode-anywhere:
  restructuredtext:
    enabled: True
    pip:
      opts:
        global:
          bin_env: /home/linuxbrew/.linuxbrew/bin/pip3
```

