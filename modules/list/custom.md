# Custom

## About

By default custom do nothing...

_**custom**_ is a particular module. It allows you to install custom extensions, settings, keybindings, documentations, packages...

## Installation

Change `enable` from `False` to `True` in the `custom` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    custom:
        enabled: True
```

{% hint style="info" %}
Read [global settings](../settings/global/) to know what you can add in this section.
{% endhint %}

A simple example to disable the extension [axosoft.gitkraken-glo](https://marketplace.visualstudio.com/items?itemName=axosoft.gitkraken-glo) in the `vscode` module section and replace it by the extension [mkloubert.vscode-kanban](https://marketplace.visualstudio.com/items?itemName=mkloubert.vscode-kanban) inside the `custom` section:

```yaml
vscode-anywhere:
  custom:
    enabled: True
    vscode:
      extensions:
        mkloubert.vscode-kanban:
          enabled: True
  vscode:
    enabled: True
    vscode:
      extensions:
        axosoft.gitkraken-glo:
          enabled: False
```

